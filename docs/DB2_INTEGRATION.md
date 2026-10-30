# IBM DB2 Database Integration & Data Modeling Guide

This document describes the enterprise **IBM DB2 database integration**, relational data modeling, query catalog, and migration system built for **BedTrust+**.

---

## 1. Architectural Overview

The database layer replaces ephemeral flat files with an enterprise-grade **IBM DB2** relational schema featuring connection pooling, atomic transactions, parameterized CRUD operations, and analytical modeling views.

```
┌─────────────────────────────────────────────────────────────────┐
│                    BedTrust+ Web & API Server                   │
│                         (server.py)                             │
└────────────────────────────────┬────────────────────────────────┘
                                 │
     ┌───────────────────────────┴───────────────────────────┐
     ▼                                                       ▼
┌───────────────────────────────┐       ┌───────────────────────────────┐
│        Engine Pipeline        │       │       DB2 Query Runner        │
│         (engines.py)          │       │       (db2_queries.py)        │
└───────────────┬───────────────┘       └───────────────┬───────────────┘
                │                                       │
                ▼                                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                   DB2 Repository (db2_repository.py)            │
│               CRUD · Dynamic Queries · MERGE Upserts            │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│              DB2 Connection Pool (db2_connection.py)            │
│         ibm_db / ibm_db_dbi · Health Probes · Auto-Retry        │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                       IBM DB2 Database                          │
│   events │ digital_twins │ audit_log │ waiting_patients │ ...   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. IBM DB2 Data Modeling & Schema (`db2_schema.sql`)

The schema supports high concurrency, deduplication, and full audit traceability:

| Table | Purpose | Primary Key | Key Indexes |
|---|---|---|---|
| `events` | Raw, immutable telemetry event stream | `eventId` (VARCHAR 36) | `bedId`, `source`, `eventTime`, `processed` |
| `digital_twins` | Reconciled digital twin state per physical bed | `bedId` (VARCHAR 10) | `reconciledState`, `ward`, `needsHumanReview` |
| `audit_log` | Immutable compliance and safety audit log | `id` (VARCHAR 36) | `ts DESC`, `type` |
| `waiting_patients` | Patient queue prioritized for allocation | `patientId` (VARCHAR 36) | `assignedBed`, `requestedWard`, `priority` |
| `metrics` | Real-time aggregate telemetry KPIs (singleton) | `id` (INTEGER, CHECK id=1) | Primary Key |
| `incidents` | Clustered outage / telemetry delay incidents | `incidentId` (VARCHAR 36) | `status`, `createdAt DESC` |
| `source_health` | Heartbeat & reliability stats per source | `sourceId` (VARCHAR 20) | Primary Key |
| `review_queue` | Exception queue for human clinical review | `id` (IDENTITY) | `bedId` (UNIQUE), `addedAt` |

### Key DB2 Data Types
- **CLOB(1M / 2M)**: Used for flexible JSON payloads (`metadata`, `workflowEvidence`, `sourceLineage`, `conflictHistory`, `auditHistory`, `data`).
- **SMALLINT (0 / 1)**: Native DB2 boolean representation (`processed`, `isDuplicate`, `isOutOfOrder`, `isStale`, `needsHumanReview`).
- **DOUBLE**: High-precision Unix epoch timestamps (`eventTime`, `receivedTime`, `availabilityLeaseExpiry`, `ts`).
- **MERGE INTO**: Atomic upsert operations without race conditions or locks.

---

## 3. Pre-built Query Catalog (`db2_queries.py`)

A set of analytical and operational data modeling queries is cataloged and callable via API or Python:

### 1. Ward Occupancy & Capacity Utilization (`ward_capacity_distribution`)
```sql
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
ORDER BY ward ASC;
```

### 2. Multi-Source Sensor Disagreement & Drift (`source_disagreement_analysis`)
```sql
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
ORDER BY bedId ASC;
```

### 3. Source Ingestion Quality & Deduplication (`event_quality_report`)
```sql
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
ORDER BY total_events_received DESC;
```

### 4. Admin Ghost Bed Drift Trail (`admin_ghost_bed_audit`)
```sql
SELECT id, ts, type, data
FROM audit_log
WHERE type = 'ADMIN_DRIFT_CORRECTED'
   OR type LIKE '%ADMIN_DRIFT%'
ORDER BY ts DESC
FETCH FIRST 100 ROWS ONLY;
```

### 5. Patient-Bed Triage Matching (`patient_bed_matching`)
```sql
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
    wp.arrivedAt ASC;
```

---

## 4. REST API Endpoints for DB2 & CRUD

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/db/health` | IBM DB2 connectivity, pool health, database name, and current schema |
| `GET` | `/api/db/catalog` | Lists all cataloged analytical queries |
| `POST` | `/api/db/query` | Run a named catalog query or dynamic SQL (`{"query_key": "ward_capacity_distribution"}`) |
| `POST` | `/api/db/migrate` | Triggers data migration (`{"dry_run": false}`) |
| `GET` | `/api/db/crud/beds` | Retrieve all bed twins directly from DB2 |
| `POST` | `/api/db/crud/beds/create` | Insert / update bed digital twin |
| `POST` | `/api/db/crud/beds/delete` | Delete bed by ID |
| `GET` | `/api/db/crud/patients` | Retrieve all waiting patients from DB2 |
| `POST` | `/api/db/crud/patients/create`| Insert waiting patient into DB2 |
| `POST` | `/api/db/crud/patients/delete`| Delete waiting patient |
| `GET` | `/api/db/crud/events` | Fetch events stream from DB2 |
| `GET` | `/api/db/crud/audit` | Fetch audit logs from DB2 |
| `GET` | `/api/db/crud/metrics` | Fetch real-time system metrics from DB2 |
| `GET` | `/api/db/crud/review` | Fetch review queue from DB2 |

---

## 5. Migration Execution

The tool `backend/migrate_to_db2.py` transfers existing file-based data (`data/events.jsonl` and `data/audit.jsonl`) into IBM DB2:

```bash
# 1. Test data integrity and schema validation (no database changes)
python backend/migrate_to_db2.py --dry-run

# 2. Run full migration into IBM DB2
python backend/migrate_to_db2.py

# 3. Skip DDL creation if tables already exist
python backend/migrate_to_db2.py --skip-schema
```

### Verification Results
```
[DRY RUN] 127/127 events match DB2 schema constraints.
[DRY RUN] 307/307 audit records match DB2 schema constraints.
[DRY RUN] 12 beds, 5 waiting patients, and 6 source health records initialized.
```

