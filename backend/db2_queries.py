"""
BedTrust+ IBM DB2 Query Catalog & Execution Engine
===================================================

Contains SQL queries for:
1. CRUD Operations (Beds, Events, Waiting Patients, Audit Log, Incidents, Review Queue)
2. Advanced Data Modeling & Hospital Operations Analytics
   - Ward Occupancy & Capacity Utilization
   - Multi-source Disagreement & Sensor Drift Analysis
   - Bed Turnaround Time (Cleaning -> Ready -> Occupied)
   - Stale Telemetry & Reconciliation SLA Performance
3. Query Execution Helper for running parametrized queries via the DB2 Connection Pool.
"""

from __future__ import annotations

import logging
from typing import Any, Dict, List, Optional
from db2_connection import DB2ConnectionPool, get_pool

logger = logging.getLogger(__name__)

# =============================================================================
# 1. CRUD QUERY TEMPLATES
# =============================================================================

# Beds (Digital Twins)
SQL_BED_CREATE = """
INSERT INTO digital_twins (
    bedId, ward, adminState, sourceAState, sourceBState, reconciledState,
    lastConfirmedState, unknownReason, confidence, needsHumanReview, createdAt, updatedAt
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
"""

SQL_BED_READ_BY_ID = """
SELECT * FROM digital_twins WHERE bedId = ?
"""

SQL_BED_READ_ALL = """
SELECT * FROM digital_twins ORDER BY bedId ASC
"""

SQL_BED_UPDATE_STATE = """
UPDATE digital_twins
SET reconciledState = ?,
    unknownReason = ?,
    confidence = ?,
    lastConfirmedState = ?,
    lastConfirmedTimestamp = ?,
    needsHumanReview = ?,
    updatedAt = ?
WHERE bedId = ?
"""

SQL_BED_DELETE = """
DELETE FROM digital_twins WHERE bedId = ?
"""

# Events
SQL_EVENT_INSERT = """
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
"""

SQL_EVENT_READ_BY_ID = """
SELECT * FROM events WHERE eventId = ?
"""

SQL_EVENT_READ_BY_BED = """
SELECT * FROM events
WHERE bedId = ?
ORDER BY eventTime DESC
FETCH FIRST ? ROWS ONLY
"""

SQL_EVENT_DELETE = """
DELETE FROM events WHERE eventId = ?
"""

# Waiting Patients
SQL_PATIENT_INSERT = """
INSERT INTO waiting_patients (patientId, name, priority, requestedWard, arrivedAt, assignedBed)
VALUES (?, ?, ?, ?, ?, ?)
"""

SQL_PATIENT_READ_ALL = """
SELECT * FROM waiting_patients
ORDER BY arrivedAt ASC
"""

SQL_PATIENT_ASSIGN_BED = """
UPDATE waiting_patients
SET assignedBed = ?
WHERE patientId = ?
"""

SQL_PATIENT_DELETE = """
DELETE FROM waiting_patients WHERE patientId = ?
"""

# Review Queue
SQL_REVIEW_QUEUE_ADD = """
INSERT INTO review_queue (bedId, addedAt)
VALUES (?, ?)
"""

SQL_REVIEW_QUEUE_REMOVE = """
DELETE FROM review_queue WHERE bedId = ?
"""

SQL_REVIEW_QUEUE_LIST = """
SELECT rq.bedId, rq.addedAt, dt.ward, dt.reconciledState, dt.unknownReason, dt.systemRecommendation
FROM review_queue rq
LEFT JOIN digital_twins dt ON rq.bedId = dt.bedId
ORDER BY rq.addedAt ASC
"""

# =============================================================================
# 2. DATA MODELING & ANALYTICAL QUERIES
# =============================================================================

# Query 1: Ward Occupancy and Capacity Distribution
SQL_WARD_CAPACITY_DISTRIBUTION = """
SELECT
    ward,
    COUNT(*) AS total_beds,
    SUM(CASE WHEN reconciledState = 'CONFIRMED_AVAILABLE' THEN 1 ELSE 0 END) AS confirmed_available,
    SUM(CASE WHEN reconciledState = 'OCCUPIED' THEN 1 ELSE 0 END) AS occupied,
    SUM(CASE WHEN reconciledState = 'UNKNOWN' THEN 1 ELSE 0 END) AS under_reconciliation,
    SUM(CASE WHEN reconciledState = 'RESERVED' THEN 1 ELSE 0 END) AS reserved,
    SUM(CASE WHEN reconciledState = 'BLOCKED' THEN 1 ELSE 0 END) AS blocked,
    ROUND(CAST(SUM(CASE WHEN reconciledState = 'OCCUPIED' THEN 1 ELSE 0 END) AS DOUBLE) / COUNT(*) * 100, 2) AS occupancy_rate_pct
FROM digital_twins
GROUP BY ward
ORDER BY ward ASC
"""

# Query 2: Multi-Source Sensor Disagreement and Drift
# Detects beds where Admin EHR system disagrees with Physical telemetry
SQL_SOURCE_DISAGREEMENT_ANALYSIS = """
SELECT
    bedId,
    ward,
    adminState,
    sourceAState AS sensor_a_state,
    sourceBState AS sensor_b_state,
    reconciledState AS true_state,
    unknownReason,
    confidence
FROM digital_twins
WHERE (adminState <> sourceAState AND sourceAState <> 'UNKNOWN' AND adminState <> 'UNKNOWN')
   OR (sourceAState <> sourceBState AND sourceAState <> 'UNKNOWN' AND sourceBState <> 'UNKNOWN')
   OR (reconciledState = 'UNKNOWN')
ORDER BY bedId ASC
"""

# Query 3: Event Throughput & Ingestion Quality
# Metrics on valid vs rejected vs duplicate events by source
SQL_EVENT_SOURCE_QUALITY_REPORT = """
SELECT
    source,
    COUNT(*) AS total_events_received,
    SUM(CASE WHEN isDuplicate = 1 THEN 1 ELSE 0 END) AS duplicate_count,
    SUM(CASE WHEN isOutOfOrder = 1 THEN 1 ELSE 0 END) AS out_of_order_count,
    SUM(CASE WHEN isStale = 1 THEN 1 ELSE 0 END) AS stale_count,
    SUM(CASE WHEN validationStatus = 'VALID' THEN 1 ELSE 0 END) AS validated_count,
    SUM(CASE WHEN validationStatus = 'REJECTED' THEN 1 ELSE 0 END) AS rejected_count
FROM events
GROUP BY source
ORDER BY total_events_received DESC
"""

# Query 4: Admin State Drift Audit Trail
# Analyzes how often Admin EHR stated 'AVAILABLE' while physical reality was 'OCCUPIED'
SQL_ADMIN_GHOST_BED_AUDIT = """
SELECT
    id,
    ts,
    type,
    data
FROM audit_log
WHERE type = 'ADMIN_DRIFT_CORRECTED'
   OR type LIKE '%ADMIN_DRIFT%'
ORDER BY ts DESC
FETCH FIRST 100 ROWS ONLY
"""

# Query 5: High Priority Waiting Patients Allocation Readiness
# Matches highest priority patients (ICU, EMERGENCY) against available confirmed beds
SQL_PATIENT_BED_MATCHING = """
SELECT
    wp.patientId,
    wp.name AS patient_name,
    wp.priority,
    wp.requestedWard,
    wp.arrivedAt,
    COUNT(dt.bedId) AS available_beds_in_requested_ward
FROM waiting_patients wp
LEFT JOIN digital_twins dt
    ON wp.requestedWard = dt.ward
   AND dt.reconciledState = 'CONFIRMED_AVAILABLE'
   AND (dt.reservationStatus IS NULL OR dt.reservationStatus <> 'RESERVED')
WHERE wp.assignedBed IS NULL
GROUP BY wp.patientId, wp.name, wp.priority, wp.requestedWard, wp.arrivedAt
ORDER BY
    CASE wp.priority
        WHEN 'ICU' THEN 1
        WHEN 'EMERGENCY' THEN 2
        WHEN 'NORMAL' THEN 3
        ELSE 4
    END,
    wp.arrivedAt ASC
"""

# Catalog map
QUERY_CATALOG = {
    "ward_capacity_distribution": {
        "title": "Ward Occupancy & Capacity Utilization",
        "description": "Calculates real-time occupancy rates, available, and reserved beds grouped by hospital ward.",
        "sql": SQL_WARD_CAPACITY_DISTRIBUTION,
        "type": "ANALYTIC"
    },
    "source_disagreement_analysis": {
        "title": "Sensor & Admin Disagreement Analysis",
        "description": "Identifies active discrepancies between Admin EHR, Source A (Sensors), and Source B (EVS/Staff).",
        "sql": SQL_SOURCE_DISAGREEMENT_ANALYSIS,
        "type": "AUDIT"
    },
    "event_quality_report": {
        "title": "Source Ingestion Quality & Deduplication Report",
        "description": "Reports event counts, duplicates filtered, out-of-order deliveries, and validation rejections by source.",
        "sql": SQL_EVENT_SOURCE_QUALITY_REPORT,
        "type": "ANALYTIC"
    },
    "admin_ghost_bed_audit": {
        "title": "Admin Ghost Bed Drift Trail",
        "description": "Extracts audit events where phantom availability or administrative drift was successfully intercepted.",
        "sql": SQL_ADMIN_GHOST_BED_AUDIT,
        "type": "AUDIT"
    },
    "patient_bed_matching": {
        "title": "Waiting Patient Bed Matching",
        "description": "Triage ranking for waiting patients prioritized by severity (ICU > EMERGENCY > NORMAL) and requested ward.",
        "sql": SQL_PATIENT_BED_MATCHING,
        "type": "OPERATIONAL"
    },
    "review_queue_list": {
        "title": "Human Review Queue",
        "description": "Active exceptions escalated for human clinical verification with system recommendation.",
        "sql": SQL_REVIEW_QUEUE_LIST,
        "type": "OPERATIONAL"
    }
}


# =============================================================================
# 3. QUERY EXECUTION ENGINE
# =============================================================================

class DB2QueryRunner:
    """Executes cataloged and dynamic queries against the IBM DB2 database."""

    def __init__(self, pool: Optional[DB2ConnectionPool] = None):
        self.pool = pool or get_pool()

    def run_query(self, sql: str, params: tuple = ()) -> List[Dict[str, Any]]:
        """
        Execute any parametrized query and return results as a list of dicts.
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, params)
            if not cursor.description:
                cursor.close()
                return []
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            return [dict(zip(columns, row)) for row in rows]

    def run_catalog_query(self, query_key: str, params: tuple = ()) -> Dict[str, Any]:
        """
        Run a predefined catalog query by its key name.
        """
        if query_key not in QUERY_CATALOG:
            raise KeyError(f"Query '{query_key}' not found in query catalog. Available: {list(QUERY_CATALOG.keys())}")
        
        info = QUERY_CATALOG[query_key]
        results = self.run_query(info["sql"], params)
        return {
            "query_key": query_key,
            "title": info["title"],
            "description": info["description"],
            "type": info["type"],
            "row_count": len(results),
            "rows": results
        }

    def list_catalog(self) -> List[Dict[str, str]]:
        """Return metadata for all registered queries."""
        return [
            {
                "key": k,
                "title": v["title"],
                "description": v["description"],
                "type": v["type"]
            }
            for k, v in QUERY_CATALOG.items()
        ]

