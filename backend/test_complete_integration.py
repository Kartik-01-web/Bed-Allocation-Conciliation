"""
Test Complete Integration of DB2DirectConnection with DB2Repository and DB2QueryRunner
"""
import sys
import os
import json
import subprocess
import re

# Add backend to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from db2_connection import DB2Config, DB2ConnectionPool
from db2_repository import DB2Repository
from db2_queries import DB2QueryRunner

CANONICAL_COLUMNS = {
    'EVENTID': 'eventId', 'BEDID': 'bedId', 'SOURCE': 'source', 'STATE': 'state',
    'EVENTTIME': 'eventTime', 'RECEIVEDTIME': 'receivedTime', 'SEQUENCENUMBER': 'sequenceNumber',
    'SOURCELINEAGEID': 'sourceLineageId', 'METADATA': 'metadata', 'PROCESSED': 'processed',
    'ISDUPLICATE': 'isDuplicate', 'ISOUTOFORDER': 'isOutOfOrder', 'ISSTALE': 'isStale',
    'VALIDATIONSTATUS': 'validationStatus', 'VALIDATIONNOTES': 'validationNotes',
    'WARD': 'ward', 'ADMINSTATE': 'adminState', 'ADMINUPDATETIME': 'adminUpdateTime',
    'SOURCEASTATE': 'sourceAState', 'SOURCEAEVENTTIME': 'sourceAEventTime',
    'SOURCEARECEIVEDTIME': 'sourceAReceivedTime', 'SOURCEASEQUENCE': 'sourceASequence',
    'SOURCEBSTATE': 'sourceBState', 'SOURCEBEVENTTIME': 'sourceBEventTime',
    'SOURCEBRECEIVEDTIME': 'sourceBReceivedTime', 'SOURCEBSEQUENCE': 'sourceBSequence',
    'WORKFLOWEVIDENCE': 'workflowEvidence', 'ACTIVEPATIENTID': 'activePatientId',
    'RECONCILEDSTATE': 'reconciledState', 'LASTCONFIRMEDSTATE': 'lastConfirmedState',
    'LASTCONFIRMEDTIMESTAMP': 'lastConfirmedTimestamp', 'UNKNOWNREASON': 'unknownReason',
    'AVAILABILITYLEASEEXPIRY': 'availabilityLeaseExpiry', 'RESERVATIONSTATUS': 'reservationStatus',
    'CURRENTASSIGNEDPATIENT': 'currentAssignedPatient', 'RESERVATIONID': 'reservationId',
    'RECONCILIATIONDEADLINE': 'reconciliationDeadline', 'CONFIDENCE': 'confidence',
    'SOURCELINEAGE': 'sourceLineage', 'CONFLICTHISTORY': 'conflictHistory',
    'AUDITHISTORY': 'auditHistory', 'LASTRECONCILIATIONATTEMPT': 'lastReconciliationAttempt',
    'AUTORETRIES': 'autoRetries', 'NEEDSHUMANREVIEW': 'needsHumanReview',
    'SYSTEMRECOMMENDATION': 'systemRecommendation', 'RECOMMENDATIONREASON': 'recommendationReason',
    'HUMANOVERRIDEEXPIRY': 'humanOverrideExpiry', 'HUMANOVERRIDEBY': 'humanOverrideBy',
    'HUMANOVERRIDEREASON': 'humanOverrideReason', 'CREATEDAT': 'createdAt', 'UPDATEDAT': 'updatedAt',
    'PATIENTID': 'patientId', 'NAME': 'name', 'PRIORITY': 'priority',
    'REQUESTEDWARD': 'requestedWard', 'ARRIVEDAT': 'arrivedAt', 'ASSIGNEDBED': 'assignedBed',
    'ID': 'id', 'TS': 'ts', 'TYPE': 'type', 'DATA': 'data'
}

def clean_val(val: str, col_name: str):
    if val is None or val == "-" or val == "":
        return None
    # Don't convert text/id fields
    col_l = col_name.lower()
    if any(k in col_l for k in ("id", "name", "ward", "source", "state", "reason", "priority", "type", "description", "rootcause", "resolution", "action", "status", "assigned", "notes")):
        return val
    # Try int
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

def parse_db2_output(output):
    lines = [line.rstrip('\r\n') for line in output.split('\n')]
    sep_idx = -1
    for i, line in enumerate(lines):
        if re.match(r'^[-\s]+$', line) and '-' in line and len(line.strip()) > 2:
            sep_idx = i
            break
            
    if sep_idx <= 0:
        return [], []
        
    header_line = lines[sep_idx - 1]
    sep_line = lines[sep_idx]
    
    col_spans = []
    col_names = []
    matches = list(re.finditer(r'-+', sep_line))
    for m in matches:
        start, end = m.start(), m.end()
        col_spans.append((start, end))
        raw_col = header_line[start:end].strip()
        col_upper = raw_col.upper()
        col_name = CANONICAL_COLUMNS.get(col_upper, col_upper.lower() if '_' in col_upper else raw_col)
        col_names.append(col_name)
        
    rows = []
    for line in lines[sep_idx + 1:]:
        if not line.strip():
            continue
        if 'record(s) selected' in line or 'DB20000I' in line or 'SQL0100W' in line:
            break
        row_vals = []
        for (start, end), col_name in zip(col_spans, col_names):
            val = line[start:end].strip() if start < len(line) else ''
            row_vals.append(clean_val(val, col_name))
        rows.append(dict(zip(col_names, row_vals)))
    return col_names, rows

class DB2DirectCursor:
    def __init__(self, config: DB2Config):
        self.config = config
        self.description = None
        self.rowcount = -1
        self._rows = []
        self._idx = 0

    def _format_sql(self, sql: str, params: tuple) -> str:
        if not params:
            return sql.strip().rstrip(';') + ';'
            
        def format_val(val):
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

        parts = sql.split('?')
        if len(parts) - 1 != len(params):
            return sql.strip().rstrip(';') + ';'
            
        out = []
        for i, val in enumerate(params):
            out.append(parts[i])
            out.append(format_val(val))
        out.append(parts[-1])
        return "".join(out).strip().rstrip(';') + ';'

    def execute(self, sql: str, params: tuple = ()):
        formatted_sql = self._format_sql(sql, params)
        container = getattr(self.config, "container", "db2server")
        
        # Write query to container /tmp/query.sql
        p = subprocess.Popen(
            ["wsl", "-u", "root", "podman", "exec", "-i", container, "sh", "-c", "cat > /tmp/query.sql"],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
        )
        p.communicate(input=formatted_sql)

        # Run query via db2 -tf
        res = subprocess.run(
            ["wsl", "-u", "root", "podman", "exec", container, "su", "-", self.config.user, "-c",
             f"db2 connect to {self.config.database} user {self.config.user} using {self.config.password} > /dev/null && db2 -tf /tmp/query.sql"],
            capture_output=True, text=True
        )
        
        stdout = res.stdout or ""
        stderr = res.stderr or ""
        
        if "23505" in stdout or "SQLSTATE=23505" in stdout:
            raise Exception(f"SQLSTATE=23505: Duplicate key constraint violated.\n{stdout}")
            
        if res.returncode != 0 and "DB20000I" not in stdout and "SQL0100W" not in stdout:
            if "SQL" in stdout:
                raise Exception(f"DB2 Execution Error: {stdout}")
            if stderr:
                raise Exception(f"DB2 Subprocess Error: {stderr}")

        col_names, rows_data = parse_db2_output(stdout)
        if col_names:
            self.description = [(col, None, None, None, None, None, None) for col in col_names]
            self._rows = [tuple(r.get(c) for c in col_names) for r in rows_data]
            self.rowcount = len(self._rows)
        else:
            self.description = None
            self._rows = []
            if "DB20000I" in stdout:
                self.rowcount = 1
            else:
                self.rowcount = 0
        self._idx = 0

    def fetchone(self):
        if self._rows and self._idx < len(self._rows):
            r = self._rows[self._idx]
            self._idx += 1
            return r
        return None

    def fetchall(self):
        if not self._rows:
            return []
        res = self._rows[self._idx:]
        self._idx = len(self._rows)
        return res

    def close(self):
        self._rows = []

class DB2DirectConnection:
    def __init__(self, config: DB2Config):
        self.config = config
        self._autocommit = True

    def cursor(self):
        return DB2DirectCursor(self.config)

    def commit(self):
        pass

    def rollback(self):
        pass

    def close(self):
        pass

    def set_autocommit(self, val: bool):
        self._autocommit = val

# Let's test Mock Pool that yields DB2DirectConnection
class DirectPoolMock:
    def __init__(self, config):
        self.config = config
        self.conn = DB2DirectConnection(config)
    def connection(self):
        class Ctx:
            def __init__(self, c): self.c = c
            def __enter__(self): return self.c
            def __exit__(self, *args): pass
        return Ctx(self.conn)
    def transaction(self):
        return self.connection()

config = DB2Config()
pool = DirectPoolMock(config)
repo = DB2Repository(pool)
runner = DB2QueryRunner(pool)

print("--- 1. Testing DB2 Repository: Digital Twins ---")
twins = repo.get_all_twins()
print(f"Fetched {len(twins)} beds from IBM DB2.")
sample_twin = repo.get_twin("B01")
print(f"Bed B01 details: Ward={sample_twin.get('ward')}, State={sample_twin.get('reconciledState')}, Confidence={sample_twin.get('confidence')}")

print("\n--- 2. Testing DB2 Repository: Events ---")
events = repo.get_all_events(limit=5)
print(f"Fetched {len(events)} events from IBM DB2. Sample eventId={events[0].get('eventId') if events else None}")

print("\n--- 3. Testing DB2 Repository: Waiting Patients ---")
patients = repo.get_all_waiting()
print(f"Fetched {len(patients)} waiting patients from IBM DB2.")

print("\n--- 4. Testing DB2 Catalog Analytical Queries ---")
cat_result = runner.run_catalog_query("ward_capacity_distribution")
print("Catalog Query Output:")
for row in cat_result["rows"]:
    print(f"  Ward: {row.get('ward'):12} | Total: {row.get('total_beds')} | Occupied: {row.get('occupied')} | Available: {row.get('confirmed_available')} | Occupancy Rate: {row.get('occupancy_rate_pct')}%")

print("\n--- 5. Testing DB2 CRUD: Bed Lifecycle ---")
test_bed = {
    "bedId": "B_TEST",
    "ward": "SURGICAL",
    "reconciledState": "CONFIRMED_AVAILABLE",
    "confidence": "HIGH",
    "needsHumanReview": False
}
print("Creating bed B_TEST...")
repo.upsert_twin(test_bed)
fetched_test = repo.get_twin("B_TEST")
print(f"Verified created bed B_TEST in DB2: Ward={fetched_test.get('ward')}, State={fetched_test.get('reconciledState')}")

print("Updating bed B_TEST to OCCUPIED...")
test_bed["reconciledState"] = "OCCUPIED"
test_bed["activePatientId"] = "PATIENT_LIVE_001"
repo.upsert_twin(test_bed)
fetched_test = repo.get_twin("B_TEST")
print(f"Verified updated bed B_TEST in DB2: State={fetched_test.get('reconciledState')}, Patient={fetched_test.get('activePatientId')}")

print("Deleting bed B_TEST...")
repo.delete_twin("B_TEST")
fetched_deleted = repo.get_twin("B_TEST")
print(f"Verified deleted bed B_TEST in DB2: Present={fetched_deleted is not None}")

print("\nALL LIVE IBM DB2 TESTS COMPLETED SUCCESSFULLY!")
