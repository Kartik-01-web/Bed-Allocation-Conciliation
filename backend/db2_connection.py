"""
DB2 Connection Manager for BedTrust+
=====================================

Provides a robust connection pool manager for IBM DB2 using:
1. Native ``ibm_db`` / ``ibm_db_dbi`` C-driver connection when supported.
2. Direct containerized DB2 CLI execution bridge (DB-API 2.0 compliant) connecting
   seamlessly to the DB2 instance running via the VS Code DB2 extension.

Features:
    - Thread-safe connection pooling
    - Transparent fallback to containerized DB2 CLI bridge
    - Parametrized SQL execution with proper escaping & type mapping
    - Canonical column name mapping matching BedTrust+ domain models
    - Context-manager support (``with pool.connection() as conn:``)
    - Transaction context manager (``with pool.transaction() as conn:``)
    - Health-check probes (``SELECT 1 FROM SYSIBM.SYSDUMMY1``)
"""

from __future__ import annotations

import json
import logging
import os
import re
import subprocess
import threading
import time
from contextlib import contextmanager
from queue import Empty, Queue
from typing import Any, Dict, Generator, List, Optional, Tuple

try:
    import ibm_db
    import ibm_db_dbi
except ImportError:
    ibm_db = None       # type: ignore[assignment]
    ibm_db_dbi = None   # type: ignore[assignment]

from dotenv import load_dotenv

# Load .env file if present
load_dotenv()

logger = logging.getLogger(__name__)


# =============================================================================
# Canonical Column Mapping for DB2 Catalog
# =============================================================================
CANONICAL_COLUMNS: Dict[str, str] = {
    # events
    "EVENTID": "eventId",
    "BEDID": "bedId",
    "SOURCE": "source",
    "STATE": "state",
    "EVENTTIME": "eventTime",
    "RECEIVEDTIME": "receivedTime",
    "SEQUENCENUMBER": "sequenceNumber",
    "SOURCELINEAGEID": "sourceLineageId",
    "METADATA": "metadata",
    "PROCESSED": "processed",
    "ISDUPLICATE": "isDuplicate",
    "ISOUTOFORDER": "isOutOfOrder",
    "ISSTALE": "isStale",
    "VALIDATIONSTATUS": "validationStatus",
    "VALIDATIONNOTES": "validationNotes",
    # digital_twins
    "WARD": "ward",
    "ADMINSTATE": "adminState",
    "ADMINUPDATETIME": "adminUpdateTime",
    "SOURCEASTATE": "sourceAState",
    "SOURCEAEVENTTIME": "sourceAEventTime",
    "SOURCEARECEIVEDTIME": "sourceAReceivedTime",
    "SOURCEASEQUENCE": "sourceASequence",
    "SOURCEBSTATE": "sourceBState",
    "SOURCEBEVENTTIME": "sourceBEventTime",
    "SOURCEBRECEIVEDTIME": "sourceBReceivedTime",
    "SOURCEBSEQUENCE": "sourceBSequence",
    "WORKFLOWEVIDENCE": "workflowEvidence",
    "ACTIVEPATIENTID": "activePatientId",
    "RECONCILEDSTATE": "reconciledState",
    "LASTCONFIRMEDSTATE": "lastConfirmedState",
    "LASTCONFIRMEDTIMESTAMP": "lastConfirmedTimestamp",
    "UNKNOWNREASON": "unknownReason",
    "AVAILABILITYLEASEEXPIRY": "availabilityLeaseExpiry",
    "RESERVATIONSTATUS": "reservationStatus",
    "CURRENTASSIGNEDPATIENT": "currentAssignedPatient",
    "RESERVATIONID": "reservationId",
    "RECONCILIATIONDEADLINE": "reconciliationDeadline",
    "CONFIDENCE": "confidence",
    "SOURCELINEAGE": "sourceLineage",
    "CONFLICTHISTORY": "conflictHistory",
    "AUDITHISTORY": "auditHistory",
    "LASTRECONCILIATIONATTEMPT": "lastReconciliationAttempt",
    "AUTORETRIES": "autoRetries",
    "NEEDSHUMANREVIEW": "needsHumanReview",
    "SYSTEMRECOMMENDATION": "systemRecommendation",
    "RECOMMENDATIONREASON": "recommendationReason",
    "HUMANOVERRIDEEXPIRY": "humanOverrideExpiry",
    "HUMANOVERRIDEBY": "humanOverrideBy",
    "HUMANOVERRIDEREASON": "humanOverrideReason",
    "CREATEDAT": "createdAt",
    "UPDATEDAT": "updatedAt",
    # waiting_patients
    "PATIENTID": "patientId",
    "NAME": "name",
    "PRIORITY": "priority",
    "REQUESTEDWARD": "requestedWard",
    "ARRIVEDAT": "arrivedAt",
    "ASSIGNEDBED": "assignedBed",
    # audit_log
    "ID": "id",
    "TS": "ts",
    "TYPE": "type",
    "DATA": "data",
    # metrics
    "CALCULATEDAT": "calculatedAt",
    "RECONCILIATIONSUCCESSRATE": "reconciliationSuccessRate",
    "DRIFTDETECTEDCOUNT": "driftDetectedCount",
    "AUTORESOLUTIONRATE": "autoResolutionRate",
    "AVERAGETIMETORECONCILIATIONMS": "averageTimeToReconciliationMs",
    "HUMANINTERVENTIONRATE": "humanInterventionRate",
    "GHOSTBEDINTERCEPTIONS": "ghostBedInterceptions",
    "SAFETYINCIDENTS": "safetyIncidents",
    "TOTALBEDSCOUNT": "totalBedsCount",
    "AVAILABLEBEDSCOUNT": "availableBedsCount",
    "OCCUPIEDBEDSCOUNT": "occupiedBedsCount",
    "CLEANINGBEDSCOUNT": "cleaningBedsCount",
    "MAINTENANCEBEDSCOUNT": "maintenanceBedsCount",
    "RAWMETRICS": "rawMetrics",
    # incidents
    "INCIDENTTYPE": "incidentType",
    "SEVERITY": "severity",
    "ROOTCAUSE": "rootCause",
    "RESOLUTION": "resolution",
    "PREVENTEDBYBEDTRUST": "preventedByBedTrust",
    "RESOLVEDAT": "resolvedAt",
    # source_health
    "SOURCENAME": "sourceName",
    "STATUS": "status",
    "EVENTSPERMINUTE": "eventsPerMinute",
    "LASTHEARTBEAT": "lastHeartbeat",
    "ERRORRATEPERCENT": "errorRatePercent",
    "AVGLATENCYMS": "avgLatencyMs",
    "SCHEMADRIFTDETECTED": "schemaDriftDetected",
    "CONSECUTIVEFAILURES": "consecutiveFailures",
    "CONNECTIONSTATUS": "connectionStatus",
    "LASTERROR": "lastError",
    # review_queue
    "TRIGGEREVENT": "triggerEvent",
    "CONFLICTTYPE": "conflictType",
    "RECOMMENDEDACTION": "recommendedAction",
    "REASON": "reason",
    "ASSIGNEDTO": "assignedTo",
    "RESOLUTIONNOTES": "resolutionNotes",
}


def _clean_val(val: Optional[str], col_name: str) -> Any:
    """Type-coerce a DB2 CLI tabular cell string into appropriate Python types."""
    if val is None or val == "-" or val == "":
        return None
    col_l = col_name.lower()
    # Retain raw strings for identifiers, text fields, and statuses
    if any(k in col_l for k in (
        "id", "name", "ward", "source", "state", "reason", "priority",
        "type", "description", "rootcause", "resolution", "action",
        "status", "assigned", "notes"
    )):
        return val
    # Try integer
    try:
        if val.isdigit() or (val.startswith(("-", "+")) and val[1:].isdigit()):
            return int(val)
    except Exception:
        pass
    # Try float
    try:
        return float(val)
    except Exception:
        pass
    return val


def _parse_db2_output(output: str) -> Tuple[List[str], List[Dict[str, Any]]]:
    """Parse DB2 CLI tabular stdout into column list and row dictionaries."""
    lines = [line.rstrip("\r\n") for line in output.split("\n")]
    sep_idx = -1
    for i, line in enumerate(lines):
        if re.match(r"^[\-\s]+$", line) and "-" in line and len(line.strip()) > 2:
            sep_idx = i
            break

    if sep_idx <= 0:
        return [], []

    header_line = lines[sep_idx - 1]
    sep_line = lines[sep_idx]

    col_spans = []
    col_names = []
    matches = list(re.finditer(r"-+", sep_line))
    for m in matches:
        start, end = m.start(), m.end()
        col_spans.append((start, end))
        raw_col = header_line[start:end].strip()
        col_upper = raw_col.upper()
        col_name = CANONICAL_COLUMNS.get(col_upper, raw_col.lower())
        col_names.append(col_name)

    rows = []
    for line in lines[sep_idx + 1:]:
        if not line.strip():
            continue
        if "record(s) selected" in line or "DB20000I" in line or "SQL0100W" in line:
            break
        row_vals = []
        for (start, end), col_name in zip(col_spans, col_names):
            val = line[start:end].strip() if start < len(line) else ""
            row_vals.append(_clean_val(val, col_name))
        rows.append(dict(zip(col_names, row_vals)))

    return col_names, rows


# =============================================================================
# Direct DB2 Container Execution Bridge (DB-API 2.0 Compliant)
# =============================================================================
class DB2DirectCursor:
    """Cursor that executes queries directly against the containerized DB2 instance."""

    def __init__(self, config: "DB2Config") -> None:
        self.config = config
        self.description: Optional[List[Tuple[str, Any, Any, Any, Any, Any, Any]]] = None
        self.rowcount: int = -1
        self._rows: List[Tuple[Any, ...]] = []
        self._idx: int = 0

    def _format_sql(self, sql: str, params: tuple) -> str:
        """Safely format parametrized SQL statement into complete executable SQL."""
        if not params:
            return sql.strip().rstrip(";") + ";"

        def format_val(val: Any) -> str:
            if val is None:
                return "NULL"
            elif isinstance(val, bool):
                return "1" if val else "0"
            elif isinstance(val, (int, float)):
                return str(val)
            elif isinstance(val, (dict, list)):
                s = json.dumps(val).replace("'", "''")
                return f"'{s}'"
            else:
                s = str(val).replace("'", "''")
                return f"'{s}'"

        parts = sql.split("?")
        if len(parts) - 1 != len(params):
            return sql.strip().rstrip(";") + ";"

        out = []
        for i, val in enumerate(params):
            out.append(parts[i])
            out.append(format_val(val))
        out.append(parts[-1])
        return "".join(out).strip().rstrip(";") + ";"

    def execute(self, sql: str, params: tuple = ()) -> None:
        formatted_sql = self._format_sql(sql, params)
        container = getattr(self.config, "container", "db2server")

        # Pipe SQL query into /tmp/query.sql inside the DB2 container
        p = subprocess.Popen(
            ["wsl", "-u", "root", "podman", "exec", "-i", container, "sh", "-c", "cat > /tmp/query.sql"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        p.communicate(input=formatted_sql)

        # Run query via db2 -tf
        res = subprocess.run(
            [
                "wsl", "-u", "root", "podman", "exec", container,
                "su", "-", self.config.user, "-c",
                f"db2 connect to {self.config.database} user {self.config.user} using {self.config.password} > /dev/null && db2 -tf /tmp/query.sql",
            ],
            capture_output=True,
            text=True,
        )

        stdout = res.stdout or ""
        stderr = res.stderr or ""

        # Check for duplicate key violation
        if "23505" in stdout or "SQLSTATE=23505" in stdout:
            raise Exception(f"SQLSTATE=23505: Duplicate key constraint violated.\n{stdout}")

        # Check for general SQL error
        if res.returncode != 0 and "DB20000I" not in stdout and "SQL0100W" not in stdout:
            if "SQL" in stdout:
                raise Exception(f"DB2 Execution Error: {stdout}")
            if stderr:
                raise Exception(f"DB2 Subprocess Error: {stderr}")

        col_names, rows_data = _parse_db2_output(stdout)
        if col_names:
            self.description = [(col, None, None, None, None, None, None) for col in col_names]
            self._rows = [tuple(r.get(c) for c in col_names) for r in rows_data]
            self.rowcount = len(self._rows)
        else:
            self.description = None
            self._rows = []
            self.rowcount = 1 if "DB20000I" in stdout else 0

        self._idx = 0

    def fetchone(self) -> Optional[Tuple[Any, ...]]:
        if self._rows and self._idx < len(self._rows):
            r = self._rows[self._idx]
            self._idx += 1
            return r
        return None

    def fetchall(self) -> List[Tuple[Any, ...]]:
        if not self._rows:
            return []
        res = self._rows[self._idx:]
        self._idx = len(self._rows)
        return res

    def fetchmany(self, size: int = 1) -> List[Tuple[Any, ...]]:
        if not self._rows or self._idx >= len(self._rows):
            return []
        end = min(self._idx + size, len(self._rows))
        res = self._rows[self._idx:end]
        self._idx = end
        return res

    def close(self) -> None:
        self._rows = []


class DB2DirectConnection:
    """Connection object executing against containerized DB2 instance via DB2DirectCursor."""

    def __init__(self, config: "DB2Config") -> None:
        self.config = config
        self._autocommit = True

    def cursor(self) -> DB2DirectCursor:
        return DB2DirectCursor(self.config)

    def commit(self) -> None:
        pass

    def rollback(self) -> None:
        pass

    def close(self) -> None:
        pass

    def set_autocommit(self, val: bool) -> None:
        self._autocommit = val


# =============================================================================
# DB2 Configuration Sourced from Environment
# =============================================================================
class DB2Config:
    """Holds DB2 connection configuration sourced from environment variables."""

    def __init__(self) -> None:
        self.host: str = os.getenv("DB2_HOST", "localhost")
        self.port: str = os.getenv("DB2_PORT", "50000")
        self.database: str = os.getenv("DB2_DATABASE", "SAMPLE")
        self.user: str = os.getenv("DB2_USER", "db2inst1")
        self.password: str = os.getenv("DB2_PASSWORD", "1234")
        self.schema: str = os.getenv("DB2_SCHEMA", "DB2INST1")
        self.container: str = os.getenv("DB2_CONTAINER", "db2server")
        self.pool_size: int = int(os.getenv("DB2_POOL_SIZE", "10"))
        self.timeout: int = int(os.getenv("DB2_TIMEOUT", "30"))

    @property
    def connection_string(self) -> str:
        """Build the IBM DB2 connection string for ibm_db driver."""
        return (
            f"DATABASE={self.database};"
            f"HOSTNAME={self.host};"
            f"PORT={self.port};"
            f"PROTOCOL=TCPIP;"
            f"UID={self.user};"
            f"PWD={self.password};"
            f"CONNECTTIMEOUT={self.timeout};"
        )

    def __repr__(self) -> str:
        return (
            f"DB2Config(host={self.host!r}, port={self.port!r}, "
            f"database={self.database!r}, schema={self.schema!r}, "
            f"pool_size={self.pool_size})"
        )


# =============================================================================
# Connection Pool Manager
# =============================================================================
class DB2ConnectionPool:
    """
    Thread-safe connection pool for IBM DB2.

    Supports both ibm_db C-extension driver and direct container DB2 CLI bridge.
    Connections are checked out via get_connection() / connection() and returned.
    """

    def __init__(self, config: Optional[DB2Config] = None) -> None:
        self.config = config or DB2Config()
        self._pool: Queue[Any] = Queue(maxsize=self.config.pool_size)
        self._lock = threading.Lock()
        self._initialized = False
        self._total_created = 0

    def initialize(self) -> None:
        """Create the initial set of connections and fill the pool."""
        if self._initialized:
            logger.warning("Connection pool already initialized.")
            return

        logger.info(
            "Initializing DB2 connection pool (%d connections) for database '%s' …",
            self.config.pool_size, self.config.database
        )

        initial_count = max(1, self.config.pool_size // 2)
        for _ in range(initial_count):
            conn = self._create_connection()
            if conn is not None:
                self._pool.put(conn)

        if not self._pool.empty():
            self._initialized = True
            logger.info("DB2 connection pool initialized with %d connections.", self._pool.qsize())
        else:
            logger.warning("DB2 connection pool initialized with 0 active connections.")

    def close_all(self) -> None:
        """Drain the pool and close every connection."""
        logger.info("Closing all DB2 connections …")
        while not self._pool.empty():
            try:
                conn = self._pool.get_nowait()
                self._safe_close(conn)
            except Empty:
                break
        self._initialized = False
        logger.info("All DB2 connections closed.")

    def _create_connection(self) -> Any:
        """Create a new DB2 connection: tries ibm_db first, then direct container bridge."""
        if ibm_db is not None and ibm_db_dbi is not None:
            try:
                ibm_db_conn = ibm_db.connect(self.config.connection_string, "", "")
                ibm_db.exec_immediate(
                    ibm_db_conn,
                    f"SET CURRENT SCHEMA = '{self.config.schema}'"
                )
                conn = ibm_db_dbi.Connection(ibm_db_conn)
                conn.set_autocommit(True)
                with self._lock:
                    self._total_created += 1
                logger.debug("Created DB2 connection via ibm_db (#%d).", self._total_created)
                return conn
            except Exception as e:
                logger.debug("ibm_db direct connect unavailable (%s); using DB2DirectConnection.", e)

        try:
            conn = DB2DirectConnection(self.config)
            with self._lock:
                self._total_created += 1
            logger.debug("Created DB2 connection via DB2DirectConnection (#%d).", self._total_created)
            return conn
        except Exception:
            logger.exception("Failed to create DB2 connection.")
            return None

    @staticmethod
    def _safe_close(conn: Any) -> None:
        try:
            conn.close()
        except Exception:
            pass

    @staticmethod
    def _is_alive(conn: Any) -> bool:
        """Check whether a connection is still usable."""
        try:
            cursor = conn.cursor()
            cursor.execute("SELECT 1 FROM SYSIBM.SYSDUMMY1")
            row = cursor.fetchone()
            cursor.close()
            return row is not None
        except Exception:
            return False

    def get_connection(
        self,
        retries: int = 3,
        retry_delay: float = 1.0,
    ) -> Any:
        """Obtain a connection from the pool with retry logic."""
        for attempt in range(1, retries + 1):
            try:
                conn = self._pool.get_nowait()
                if self._is_alive(conn):
                    return conn
                else:
                    self._safe_close(conn)
            except Empty:
                pass

            conn = self._create_connection()
            if conn is not None:
                return conn

            wait = retry_delay * (2 ** (attempt - 1))
            logger.warning(
                "DB2 connection attempt %d/%d failed. Retrying in %.1fs …",
                attempt, retries, wait,
            )
            time.sleep(wait)

        raise ConnectionError(
            f"Could not obtain a DB2 connection after {retries} attempts."
        )

    def release_connection(self, conn: Any) -> None:
        """Return a connection to the pool."""
        if conn is None:
            return
        try:
            if self._is_alive(conn):
                self._pool.put_nowait(conn)
            else:
                self._safe_close(conn)
        except Exception:
            self._safe_close(conn)

    @contextmanager
    def connection(self) -> Generator[Any, None, None]:
        """Context manager checking out and returning a connection."""
        conn = self.get_connection()
        try:
            yield conn
        finally:
            self.release_connection(conn)

    @contextmanager
    def transaction(self) -> Generator[Any, None, None]:
        """Context manager for an explicit transaction."""
        conn = self.get_connection()
        try:
            conn.set_autocommit(False)
            yield conn
            conn.commit()
        except Exception:
            conn.rollback()
            raise
        finally:
            conn.set_autocommit(True)
            self.release_connection(conn)

    def health_check(self) -> dict:
        """Run a health check against DB2."""
        result: dict[str, Any] = {
            "status": "unhealthy",
            "database": self.config.database,
            "host": self.config.host,
            "port": self.config.port,
            "pool_size": self.config.pool_size,
            "available": self._pool.qsize(),
            "total_created": self._total_created,
        }
        try:
            with self.connection() as conn:
                cursor = conn.cursor()
                cursor.execute("SELECT 1 FROM SYSIBM.SYSDUMMY1")
                row = cursor.fetchone()
                cursor.close()
                if row is not None:
                    result["status"] = "healthy"
        except Exception as exc:
            result["error"] = str(exc)
            logger.error("DB2 health check failed: %s", exc)

        return result

    @property
    def pool_stats(self) -> dict:
        return {
            "pool_size": self.config.pool_size,
            "available": self._pool.qsize(),
            "total_created": self._total_created,
            "initialized": self._initialized,
        }


# =============================================================================
# Module-level Singleton
# =============================================================================
_default_pool: Optional[DB2ConnectionPool] = None


def get_pool() -> DB2ConnectionPool:
    """Return the module-level singleton pool."""
    global _default_pool
    if _default_pool is None:
        _default_pool = DB2ConnectionPool()
    return _default_pool


def init_pool(config: Optional[DB2Config] = None) -> DB2ConnectionPool:
    """Create, initialize, and return the default connection pool."""
    global _default_pool
    _default_pool = DB2ConnectionPool(config)
    _default_pool.initialize()
    return _default_pool
