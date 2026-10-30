"""
DB2 Repository Layer for BedTrust+
====================================

Full CRUD repository backed by IBM DB2, providing data-access methods for
every entity in the BedTrust+ domain model:

    - Events
    - DigitalTwins (Beds)
    - AuditLog
    - WaitingPatients
    - Metrics
    - Incidents
    - SourceHealth
    - ReviewQueue

All queries use **parameterized placeholders** (``?``) to prevent SQL
injection.  CLOB/JSON columns are transparently serialized (``json.dumps``)
on write and deserialized (``json.loads``) on read.

Usage::

    from db2_connection import init_pool
    from db2_repository import DB2Repository

    pool = init_pool()
    repo = DB2Repository(pool)

    repo.insert_event(event)
    twin = repo.get_twin("BED-001")
"""

from __future__ import annotations

import json
import logging
import time
import uuid
from typing import Any, Dict, List, Optional

from db2_connection import DB2ConnectionPool

logger = logging.getLogger(__name__)


# ========================================================================= #
# Helper utilities
# ========================================================================= #

def _json_dumps(obj: Any) -> Optional[str]:
    """Serialize *obj* to a JSON string, returning ``None`` for ``None``."""
    if obj is None:
        return None
    return json.dumps(obj)


def _json_loads(raw: Any) -> Any:
    """Deserialize a JSON string, returning ``None`` for ``None`` / empty."""
    if raw is None or raw == "":
        return None
    if isinstance(raw, str):
        return json.loads(raw)
    return raw


def _bool_to_int(val: Any) -> int:
    """Convert a Python boolean (or truthy value) to DB2 SMALLINT (0/1)."""
    return 1 if val else 0


def _int_to_bool(val: Any) -> bool:
    """Convert a DB2 SMALLINT (0/1) to a Python bool."""
    return bool(val)


# ========================================================================= #
# DB2Repository
# ========================================================================= #

class DB2Repository:
    """
    Central data-access object for all BedTrust+ entities.

    Each public method obtains a connection from the pool, executes the
    query, and releases the connection back.  For multi-statement
    operations the pool's ``transaction()`` context manager is used.
    """

    def __init__(self, pool: DB2ConnectionPool) -> None:
        self.pool = pool

    # ===================================================================== #
    #  EVENTS
    # ===================================================================== #

    def insert_event(self, event: dict) -> bool:
        """
        Insert a new event row.

        Args:
            event: Dict-like object with event fields.

        Returns:
            ``True`` on success, ``False`` if a duplicate ``eventId`` exists.
        """
        sql = """
            INSERT INTO events (
                eventId, bedId, source, state, eventTime, receivedTime,
                sequenceNumber, sourceLineageId, metadata,
                processed, isDuplicate, isOutOfOrder, isStale,
                validationStatus, validationNotes
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """
        try:
            with self.pool.connection() as conn:
                cursor = conn.cursor()
                cursor.execute(sql, (
                    event.get("eventId"),
                    event.get("bedId"),
                    event.get("source"),
                    event.get("state"),
                    event.get("eventTime"),
                    event.get("receivedTime"),
                    event.get("sequenceNumber", 0),
                    event.get("sourceLineageId"),
                    _json_dumps(event.get("metadata")),
                    _bool_to_int(event.get("processed", False)),
                    _bool_to_int(event.get("isDuplicate", False)),
                    _bool_to_int(event.get("isOutOfOrder", False)),
                    _bool_to_int(event.get("isStale", False)),
                    event.get("validationStatus", "pending"),
                    event.get("validationNotes"),
                ))
                cursor.close()
            return True
        except Exception as exc:
            # DB2 duplicate-key SQLSTATE is 23505
            if "23505" in str(exc) or "SQLSTATE=23505" in str(exc):
                logger.debug("Duplicate event ignored: %s", event.get("eventId"))
                return False
            logger.exception("Failed to insert event %s", event.get("eventId"))
            raise

    def get_event_by_id(self, event_id: str) -> Optional[dict]:
        """Retrieve a single event by its ``eventId``."""
        sql = "SELECT * FROM events WHERE eventId = ?"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (event_id,))
            row = cursor.fetchone()
            if row is None:
                return None
            columns = [desc[0] for desc in cursor.description]
            cursor.close()
            return self._row_to_event(dict(zip(columns, row)))

    def get_events_for_bed(self, bed_id: str, limit: int = 100) -> List[dict]:
        """Return events for a specific bed, newest first."""
        sql = """
            SELECT * FROM events
            WHERE bedId = ?
            ORDER BY eventTime DESC
            FETCH FIRST ? ROWS ONLY
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (bed_id, limit))
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            return [self._row_to_event(dict(zip(columns, r))) for r in rows]

    def get_all_events(self, limit: int = 500) -> List[dict]:
        """Return all events, newest first."""
        sql = """
            SELECT * FROM events
            ORDER BY eventTime DESC
            FETCH FIRST ? ROWS ONLY
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (limit,))
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            return [self._row_to_event(dict(zip(columns, r))) for r in rows]

    def has_event(self, event_id: str) -> bool:
        """Check whether an event with the given ID exists."""
        sql = "SELECT 1 FROM events WHERE eventId = ? FETCH FIRST 1 ROWS ONLY"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (event_id,))
            result = cursor.fetchone()
            cursor.close()
            return result is not None

    def update_event(self, event: dict) -> None:
        """Update mutable fields of an existing event (e.g., validation)."""
        sql = """
            UPDATE events SET
                processed = ?,
                isDuplicate = ?,
                isOutOfOrder = ?,
                isStale = ?,
                validationStatus = ?,
                validationNotes = ?
            WHERE eventId = ?
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (
                _bool_to_int(event.get("processed", False)),
                _bool_to_int(event.get("isDuplicate", False)),
                _bool_to_int(event.get("isOutOfOrder", False)),
                _bool_to_int(event.get("isStale", False)),
                event.get("validationStatus", "pending"),
                event.get("validationNotes"),
                event.get("eventId"),
            ))
            cursor.close()

    def delete_event(self, event_id: str) -> bool:
        """Delete an event by ID.  Returns ``True`` if a row was removed."""
        sql = "DELETE FROM events WHERE eventId = ?"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (event_id,))
            deleted = cursor.rowcount > 0
            cursor.close()
            return deleted

    @staticmethod
    def _row_to_event(row: dict) -> dict:
        """Normalize a raw DB row into a Python-friendly event dict."""
        row["metadata"] = _json_loads(row.get("metadata"))
        for flag in ("processed", "isDuplicate", "isOutOfOrder", "isStale"):
            if flag in row:
                row[flag] = _int_to_bool(row[flag])
        return row

    # ===================================================================== #
    #  DIGITAL TWINS (Beds)
    # ===================================================================== #

    def upsert_twin(self, twin: dict) -> None:
        """
        Insert or update a digital-twin (bed) record.

        Uses DB2's ``MERGE`` statement for atomic upsert.
        """
        sql = """
            MERGE INTO digital_twins AS tgt
            USING (VALUES (
                ?, ?, ?, ?,
                ?, ?, ?, ?,
                ?, ?, ?, ?,
                ?, ?, ?, ?, ?, ?,
                ?, ?, ?, ?, ?,
                ?, ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?, ?, ?,
                ?, ?
            )) AS src (
                bedId, ward, adminState, adminUpdateTime,
                sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
                sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
                workflowEvidence, activePatientId, reconciledState,
                lastConfirmedState, lastConfirmedTimestamp, unknownReason,
                availabilityLeaseExpiry, reservationStatus,
                currentAssignedPatient, reservationId, reconciliationDeadline,
                confidence, sourceLineage, conflictHistory, auditHistory,
                lastReconciliationAttempt, autoRetries, needsHumanReview,
                systemRecommendation, recommendationReason,
                humanOverrideExpiry, humanOverrideBy, humanOverrideReason,
                createdAt, updatedAt
            )
            ON tgt.bedId = src.bedId
            WHEN MATCHED THEN UPDATE SET
                ward = src.ward,
                adminState = src.adminState,
                adminUpdateTime = src.adminUpdateTime,
                sourceAState = src.sourceAState,
                sourceAEventTime = src.sourceAEventTime,
                sourceAReceivedTime = src.sourceAReceivedTime,
                sourceASequence = src.sourceASequence,
                sourceBState = src.sourceBState,
                sourceBEventTime = src.sourceBEventTime,
                sourceBReceivedTime = src.sourceBReceivedTime,
                sourceBSequence = src.sourceBSequence,
                workflowEvidence = src.workflowEvidence,
                activePatientId = src.activePatientId,
                reconciledState = src.reconciledState,
                lastConfirmedState = src.lastConfirmedState,
                lastConfirmedTimestamp = src.lastConfirmedTimestamp,
                unknownReason = src.unknownReason,
                availabilityLeaseExpiry = src.availabilityLeaseExpiry,
                reservationStatus = src.reservationStatus,
                currentAssignedPatient = src.currentAssignedPatient,
                reservationId = src.reservationId,
                reconciliationDeadline = src.reconciliationDeadline,
                confidence = src.confidence,
                sourceLineage = src.sourceLineage,
                conflictHistory = src.conflictHistory,
                auditHistory = src.auditHistory,
                lastReconciliationAttempt = src.lastReconciliationAttempt,
                autoRetries = src.autoRetries,
                needsHumanReview = src.needsHumanReview,
                systemRecommendation = src.systemRecommendation,
                recommendationReason = src.recommendationReason,
                humanOverrideExpiry = src.humanOverrideExpiry,
                humanOverrideBy = src.humanOverrideBy,
                humanOverrideReason = src.humanOverrideReason,
                updatedAt = src.updatedAt
            WHEN NOT MATCHED THEN INSERT (
                bedId, ward, adminState, adminUpdateTime,
                sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
                sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
                workflowEvidence, activePatientId, reconciledState,
                lastConfirmedState, lastConfirmedTimestamp, unknownReason,
                availabilityLeaseExpiry, reservationStatus,
                currentAssignedPatient, reservationId, reconciliationDeadline,
                confidence, sourceLineage, conflictHistory, auditHistory,
                lastReconciliationAttempt, autoRetries, needsHumanReview,
                systemRecommendation, recommendationReason,
                humanOverrideExpiry, humanOverrideBy, humanOverrideReason,
                createdAt, updatedAt
            ) VALUES (
                src.bedId, src.ward, src.adminState, src.adminUpdateTime,
                src.sourceAState, src.sourceAEventTime, src.sourceAReceivedTime,
                src.sourceASequence,
                src.sourceBState, src.sourceBEventTime, src.sourceBReceivedTime,
                src.sourceBSequence,
                src.workflowEvidence, src.activePatientId, src.reconciledState,
                src.lastConfirmedState, src.lastConfirmedTimestamp, src.unknownReason,
                src.availabilityLeaseExpiry, src.reservationStatus,
                src.currentAssignedPatient, src.reservationId,
                src.reconciliationDeadline,
                src.confidence, src.sourceLineage, src.conflictHistory,
                src.auditHistory,
                src.lastReconciliationAttempt, src.autoRetries, src.needsHumanReview,
                src.systemRecommendation, src.recommendationReason,
                src.humanOverrideExpiry, src.humanOverrideBy, src.humanOverrideReason,
                src.createdAt, src.updatedAt
            )
        """
        now = time.time()
        params = (
            twin.get("bedId"),
            twin.get("ward", ""),
            twin.get("adminState"),
            twin.get("adminUpdateTime"),
            twin.get("sourceAState"),
            twin.get("sourceAEventTime"),
            twin.get("sourceAReceivedTime"),
            twin.get("sourceASequence", 0),
            twin.get("sourceBState"),
            twin.get("sourceBEventTime"),
            twin.get("sourceBReceivedTime"),
            twin.get("sourceBSequence", 0),
            _json_dumps(twin.get("workflowEvidence")),
            twin.get("activePatientId"),
            twin.get("reconciledState"),
            twin.get("lastConfirmedState"),
            twin.get("lastConfirmedTimestamp"),
            twin.get("unknownReason"),
            twin.get("availabilityLeaseExpiry"),
            twin.get("reservationStatus"),
            twin.get("currentAssignedPatient"),
            twin.get("reservationId"),
            twin.get("reconciliationDeadline"),
            twin.get("confidence"),
            _json_dumps(twin.get("sourceLineage")),
            _json_dumps(twin.get("conflictHistory")),
            _json_dumps(twin.get("auditHistory")),
            twin.get("lastReconciliationAttempt"),
            twin.get("autoRetries", 0),
            _bool_to_int(twin.get("needsHumanReview", False)),
            twin.get("systemRecommendation"),
            twin.get("recommendationReason"),
            twin.get("humanOverrideExpiry"),
            twin.get("humanOverrideBy"),
            twin.get("humanOverrideReason"),
            twin.get("createdAt", now),
            twin.get("updatedAt", now),
        )
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, params)
            cursor.close()

    def get_twin(self, bed_id: str) -> Optional[dict]:
        """Fetch a single digital twin by ``bedId``."""
        sql = "SELECT * FROM digital_twins WHERE bedId = ?"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (bed_id,))
            row = cursor.fetchone()
            if row is None:
                return None
            columns = [desc[0] for desc in cursor.description]
            cursor.close()
            return self._row_to_twin(dict(zip(columns, row)))

    def get_all_twins(self) -> List[dict]:
        """Return every digital-twin record."""
        sql = "SELECT * FROM digital_twins ORDER BY bedId"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            return [self._row_to_twin(dict(zip(columns, r))) for r in rows]

    def delete_twin(self, bed_id: str) -> bool:
        """Delete a digital twin.  Returns ``True`` if removed."""
        sql = "DELETE FROM digital_twins WHERE bedId = ?"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (bed_id,))
            deleted = cursor.rowcount > 0
            cursor.close()
            return deleted

    def get_twins_by_state(self, state: str) -> List[dict]:
        """Return all twins with a given ``reconciledState``."""
        sql = "SELECT * FROM digital_twins WHERE reconciledState = ? ORDER BY bedId"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (state,))
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            return [self._row_to_twin(dict(zip(columns, r))) for r in rows]

    def get_twins_by_ward(self, ward: str) -> List[dict]:
        """Return all twins in a given ward."""
        sql = "SELECT * FROM digital_twins WHERE ward = ? ORDER BY bedId"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (ward,))
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            return [self._row_to_twin(dict(zip(columns, r))) for r in rows]

    def count_by_state(self) -> Dict[str, int]:
        """Return a mapping of ``reconciledState`` → count for capacity views."""
        sql = """
            SELECT reconciledState, COUNT(*) AS cnt
            FROM digital_twins
            GROUP BY reconciledState
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            result = {}
            for row in cursor.fetchall():
                state = row[0] if row[0] else "unknown"
                result[state] = row[1]
            cursor.close()
            return result

    @staticmethod
    def _row_to_twin(row: dict) -> dict:
        """Normalize a raw DB row into a Python-friendly twin dict."""
        for field in ("workflowEvidence", "sourceLineage",
                      "conflictHistory", "auditHistory"):
            row[field] = _json_loads(row.get(field))
        if "needsHumanReview" in row:
            row["needsHumanReview"] = _int_to_bool(row["needsHumanReview"])
        return row

    # ===================================================================== #
    #  AUDIT LOG
    # ===================================================================== #

    def insert_audit(self, entry: dict) -> None:
        """
        Insert an audit-log record.

        If the entry has no ``id`` a UUID is generated automatically.
        """
        sql = "INSERT INTO audit_log (id, ts, type, data) VALUES (?, ?, ?, ?)"
        audit_id = entry.get("id", str(uuid.uuid4()))
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (
                audit_id,
                entry.get("ts", time.time()),
                entry.get("type", "unknown"),
                _json_dumps(entry.get("data")),
            ))
            cursor.close()

    def get_audit(self, limit: int = 200) -> List[dict]:
        """Return recent audit entries, newest first."""
        sql = """
            SELECT * FROM audit_log
            ORDER BY ts DESC
            FETCH FIRST ? ROWS ONLY
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (limit,))
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            return [self._row_to_audit(dict(zip(columns, r))) for r in rows]

    def get_audit_by_bed(self, bed_id: str, limit: int = 50) -> List[dict]:
        """
        Return audit entries whose JSON ``data`` references *bed_id*.

        Uses DB2 string matching on the CLOB column.
        """
        sql = """
            SELECT * FROM audit_log
            WHERE data LIKE ?
            ORDER BY ts DESC
            FETCH FIRST ? ROWS ONLY
        """
        pattern = f"%{bed_id}%"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (pattern, limit))
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            return [self._row_to_audit(dict(zip(columns, r))) for r in rows]

    def delete_audit_before(self, timestamp: float) -> int:
        """Delete audit entries older than *timestamp*.  Returns count deleted."""
        sql = "DELETE FROM audit_log WHERE ts < ?"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (timestamp,))
            count = cursor.rowcount
            cursor.close()
            return count

    @staticmethod
    def _row_to_audit(row: dict) -> dict:
        row["data"] = _json_loads(row.get("data"))
        return row

    # ===================================================================== #
    #  WAITING PATIENTS
    # ===================================================================== #

    def upsert_patient(self, patient: dict) -> None:
        """Insert or update a waiting-patient record."""
        sql = """
            MERGE INTO waiting_patients AS tgt
            USING (VALUES (?, ?, ?, ?, ?, ?)) AS src (
                patientId, name, priority, requestedWard, arrivedAt, assignedBed
            )
            ON tgt.patientId = src.patientId
            WHEN MATCHED THEN UPDATE SET
                name = src.name,
                priority = src.priority,
                requestedWard = src.requestedWard,
                arrivedAt = src.arrivedAt,
                assignedBed = src.assignedBed
            WHEN NOT MATCHED THEN INSERT (
                patientId, name, priority, requestedWard, arrivedAt, assignedBed
            ) VALUES (
                src.patientId, src.name, src.priority,
                src.requestedWard, src.arrivedAt, src.assignedBed
            )
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (
                patient.get("patientId"),
                patient.get("name", ""),
                patient.get("priority", "normal"),
                patient.get("requestedWard"),
                patient.get("arrivedAt", time.time()),
                patient.get("assignedBed"),
            ))
            cursor.close()

    def get_patient(self, patient_id: str) -> Optional[dict]:
        """Fetch a single waiting patient by ID."""
        sql = "SELECT * FROM waiting_patients WHERE patientId = ?"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (patient_id,))
            row = cursor.fetchone()
            if row is None:
                return None
            columns = [desc[0] for desc in cursor.description]
            cursor.close()
            return dict(zip(columns, row))

    def get_all_waiting(self) -> List[dict]:
        """Return all waiting patients (unassigned first, ordered by arrival)."""
        sql = """
            SELECT * FROM waiting_patients
            ORDER BY assignedBed NULLS FIRST, arrivedAt ASC
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            return [dict(zip(columns, r)) for r in rows]

    def remove_patient(self, patient_id: str) -> bool:
        """Remove a patient from the waiting list."""
        sql = "DELETE FROM waiting_patients WHERE patientId = ?"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (patient_id,))
            deleted = cursor.rowcount > 0
            cursor.close()
            return deleted

    def assign_bed(self, patient_id: str, bed_id: str) -> None:
        """Assign a bed to a waiting patient."""
        sql = "UPDATE waiting_patients SET assignedBed = ? WHERE patientId = ?"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (bed_id, patient_id))
            cursor.close()

    # ===================================================================== #
    #  METRICS (singleton row)
    # ===================================================================== #

    def get_metrics(self) -> dict:
        """Return the singleton metrics row."""
        sql = "SELECT * FROM metrics WHERE id = 1"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            row = cursor.fetchone()
            if row is None:
                return {}
            columns = [desc[0] for desc in cursor.description]
            cursor.close()
            return dict(zip(columns, row))

    def update_metrics(self, metrics: dict) -> None:
        """Replace all metric values with those in *metrics*."""
        sql = """
            UPDATE metrics SET
                incorrect_allocations_prevented = ?,
                source_conflicts_detected = ?,
                admin_drift_detected = ?,
                reconciliation_success = ?,
                reconciliation_timeout = ?,
                total_reconciliation_time = ?,
                max_reconciliation_time = ?,
                unknown_state_duration_sum = ?,
                out_of_order_events_handled = ?,
                duplicate_events_ignored = ?,
                stale_confirmations_detected = ?,
                manual_review_count = ?,
                auto_resolved_count = ?,
                double_booking_attempts_prevented = ?,
                total_events_processed = ?,
                invalid_events_rejected = ?
            WHERE id = 1
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (
                metrics.get("incorrect_allocations_prevented", 0),
                metrics.get("source_conflicts_detected", 0),
                metrics.get("admin_drift_detected", 0),
                metrics.get("reconciliation_success", 0),
                metrics.get("reconciliation_timeout", 0),
                metrics.get("total_reconciliation_time", 0.0),
                metrics.get("max_reconciliation_time", 0.0),
                metrics.get("unknown_state_duration_sum", 0.0),
                metrics.get("out_of_order_events_handled", 0),
                metrics.get("duplicate_events_ignored", 0),
                metrics.get("stale_confirmations_detected", 0),
                metrics.get("manual_review_count", 0),
                metrics.get("auto_resolved_count", 0),
                metrics.get("double_booking_attempts_prevented", 0),
                metrics.get("total_events_processed", 0),
                metrics.get("invalid_events_rejected", 0),
            ))
            cursor.close()

    def increment_metric(self, field: str, amount: int = 1) -> None:
        """
        Atomically increment a single metric field.

        Args:
            field:  Column name (must be a valid metrics column).
            amount: Increment value (default 1).

        Raises:
            ValueError: If *field* is not a known metric column.
        """
        _VALID_METRICS = {
            "incorrect_allocations_prevented",
            "source_conflicts_detected",
            "admin_drift_detected",
            "reconciliation_success",
            "reconciliation_timeout",
            "total_reconciliation_time",
            "max_reconciliation_time",
            "unknown_state_duration_sum",
            "out_of_order_events_handled",
            "duplicate_events_ignored",
            "stale_confirmations_detected",
            "manual_review_count",
            "auto_resolved_count",
            "double_booking_attempts_prevented",
            "total_events_processed",
            "invalid_events_rejected",
        }
        if field not in _VALID_METRICS:
            raise ValueError(f"Unknown metric field: {field!r}")

        # Column names cannot be parameterized, but we've validated against
        # the allow-list above so this is safe from injection.
        sql = f"UPDATE metrics SET {field} = {field} + ? WHERE id = 1"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (amount,))
            cursor.close()

    def reset_metrics(self) -> None:
        """Reset every metric counter back to zero."""
        sql = """
            UPDATE metrics SET
                incorrect_allocations_prevented = 0,
                source_conflicts_detected = 0,
                admin_drift_detected = 0,
                reconciliation_success = 0,
                reconciliation_timeout = 0,
                total_reconciliation_time = 0.0,
                max_reconciliation_time = 0.0,
                unknown_state_duration_sum = 0.0,
                out_of_order_events_handled = 0,
                duplicate_events_ignored = 0,
                stale_confirmations_detected = 0,
                manual_review_count = 0,
                auto_resolved_count = 0,
                double_booking_attempts_prevented = 0,
                total_events_processed = 0,
                invalid_events_rejected = 0
            WHERE id = 1
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            cursor.close()

    # ===================================================================== #
    #  INCIDENTS
    # ===================================================================== #

    def insert_incident(self, incident: dict) -> None:
        """Insert a new incident record."""
        sql = """
            INSERT INTO incidents (
                incidentId, category, description,
                affectedBeds, autoResolvedBeds,
                createdAt, resolvedAt, status
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (
                incident.get("incidentId", str(uuid.uuid4())),
                incident.get("category", "unknown"),
                incident.get("description"),
                _json_dumps(incident.get("affectedBeds")),
                _json_dumps(incident.get("autoResolvedBeds")),
                incident.get("createdAt", time.time()),
                incident.get("resolvedAt"),
                incident.get("status", "open"),
            ))
            cursor.close()

    def get_open_incidents(self) -> List[dict]:
        """Return all incidents with ``status = 'open'``."""
        sql = "SELECT * FROM incidents WHERE status = 'open' ORDER BY createdAt DESC"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            return [self._row_to_incident(dict(zip(columns, r))) for r in rows]

    def update_incident(self, incident: dict) -> None:
        """Update an existing incident."""
        sql = """
            UPDATE incidents SET
                category = ?,
                description = ?,
                affectedBeds = ?,
                autoResolvedBeds = ?,
                resolvedAt = ?,
                status = ?
            WHERE incidentId = ?
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (
                incident.get("category"),
                incident.get("description"),
                _json_dumps(incident.get("affectedBeds")),
                _json_dumps(incident.get("autoResolvedBeds")),
                incident.get("resolvedAt"),
                incident.get("status"),
                incident.get("incidentId"),
            ))
            cursor.close()

    def resolve_incident(self, incident_id: str, resolved_at: float) -> None:
        """Mark an incident as resolved."""
        sql = """
            UPDATE incidents
            SET status = 'resolved', resolvedAt = ?
            WHERE incidentId = ?
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (resolved_at, incident_id))
            cursor.close()

    @staticmethod
    def _row_to_incident(row: dict) -> dict:
        row["affectedBeds"] = _json_loads(row.get("affectedBeds"))
        row["autoResolvedBeds"] = _json_loads(row.get("autoResolvedBeds"))
        return row

    # ===================================================================== #
    #  SOURCE HEALTH
    # ===================================================================== #

    def upsert_source_health(self, health: dict) -> None:
        """Insert or update a source-health record."""
        sql = """
            MERGE INTO source_health AS tgt
            USING (VALUES (?, ?, ?, ?, ?, ?, ?)) AS src (
                sourceId, status, lastSuccessfulEventTime,
                errorCount, latencySum, eventCount, lastErrorTime
            )
            ON tgt.sourceId = src.sourceId
            WHEN MATCHED THEN UPDATE SET
                status = src.status,
                lastSuccessfulEventTime = src.lastSuccessfulEventTime,
                errorCount = src.errorCount,
                latencySum = src.latencySum,
                eventCount = src.eventCount,
                lastErrorTime = src.lastErrorTime
            WHEN NOT MATCHED THEN INSERT (
                sourceId, status, lastSuccessfulEventTime,
                errorCount, latencySum, eventCount, lastErrorTime
            ) VALUES (
                src.sourceId, src.status, src.lastSuccessfulEventTime,
                src.errorCount, src.latencySum, src.eventCount, src.lastErrorTime
            )
        """
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (
                health.get("sourceId"),
                health.get("status", "unknown"),
                health.get("lastSuccessfulEventTime"),
                health.get("errorCount", 0),
                health.get("latencySum", 0.0),
                health.get("eventCount", 0),
                health.get("lastErrorTime"),
            ))
            cursor.close()

    def get_source_health(self, source_id: str) -> Optional[dict]:
        """Fetch health data for a specific source."""
        sql = "SELECT * FROM source_health WHERE sourceId = ?"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (source_id,))
            row = cursor.fetchone()
            if row is None:
                return None
            columns = [desc[0] for desc in cursor.description]
            cursor.close()
            return dict(zip(columns, row))

    def get_all_source_health(self) -> Dict[str, dict]:
        """Return a mapping of ``sourceId`` → health-data dict."""
        sql = "SELECT * FROM source_health"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            cursor.close()
            result = {}
            for r in rows:
                entry = dict(zip(columns, r))
                result[entry["sourceId"]] = entry
            return result

    # ===================================================================== #
    #  REVIEW QUEUE
    # ===================================================================== #

    def add_to_review(self, bed_id: str) -> None:
        """
        Add a bed to the human-review queue.

        Silently ignores duplicates (unique index on ``bedId``).
        """
        sql = "INSERT INTO review_queue (bedId, addedAt) VALUES (?, ?)"
        try:
            with self.pool.connection() as conn:
                cursor = conn.cursor()
                cursor.execute(sql, (bed_id, time.time()))
                cursor.close()
        except Exception as exc:
            if "23505" in str(exc):
                logger.debug("Bed %s already in review queue.", bed_id)
            else:
                raise

    def remove_from_review(self, bed_id: str) -> None:
        """Remove a bed from the review queue."""
        sql = "DELETE FROM review_queue WHERE bedId = ?"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (bed_id,))
            cursor.close()

    def get_review_queue(self) -> List[str]:
        """Return a list of bed IDs currently in the review queue."""
        sql = "SELECT bedId FROM review_queue ORDER BY addedAt ASC"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            beds = [row[0] for row in cursor.fetchall()]
            cursor.close()
            return beds

    def is_in_review(self, bed_id: str) -> bool:
        """Check whether a bed is currently in the review queue."""
        sql = "SELECT 1 FROM review_queue WHERE bedId = ? FETCH FIRST 1 ROWS ONLY"
        with self.pool.connection() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, (bed_id,))
            result = cursor.fetchone()
            cursor.close()
            return result is not None

    # ===================================================================== #
    #  SCHEMA INITIALIZATION
    # ===================================================================== #

    def execute_ddl(self, ddl_path: str) -> None:
        """
        Execute a DDL script to create/initialize all tables.

        Statements are split on ``;`` and executed individually.  Errors on
        individual statements (e.g., "table already exists") are logged but
        do not abort the remaining statements, making this idempotent.

        Args:
            ddl_path: Filesystem path to the ``.sql`` file.
        """
        with open(ddl_path, "r", encoding="utf-8") as fh:
            ddl_script = fh.read()

        statements = [
            s.strip() for s in ddl_script.split(";") if s.strip()
        ]

        with self.pool.connection() as conn:
            cursor = conn.cursor()
            for stmt in statements:
                # Skip pure comments
                if stmt.startswith("--"):
                    continue
                try:
                    cursor.execute(stmt)
                    logger.debug("DDL OK: %.60s…", stmt)
                except Exception as exc:
                    # Tolerate "already exists" errors for idempotency
                    logger.warning("DDL statement skipped: %s — %s",
                                   stmt[:80], exc)
            cursor.close()
        logger.info("DDL execution complete (%d statements).", len(statements))
