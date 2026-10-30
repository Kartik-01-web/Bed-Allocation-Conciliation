"""
Generates SQL INSERT statements to migrate all data into IBM DB2 (SAMPLE database).
Escapes strings and formats CLOB JSON strings cleanly for DB2 SQL.
"""

import json
import os
import sys

BACKEND_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(BACKEND_DIR, "..", "data")
EVENTS_FILE = os.path.join(DATA_DIR, "events.jsonl")
AUDIT_FILE = os.path.join(DATA_DIR, "audit.jsonl")
OUTPUT_SQL = os.path.join(BACKEND_DIR, "migration_data.sql")

def escape_sql(val):
    if val is None:
        return "NULL"
    if isinstance(val, (int, float)):
        return str(val)
    if isinstance(val, bool):
        return "1" if val else "0"
    if isinstance(val, (dict, list)):
        s = json.dumps(val)
    else:
        s = str(val)
    # DB2 escape single quote by doubling it
    s_clean = s.replace("'", "''")
    return f"'{s_clean}'"

def main():
    lines = []
    lines.append("-- =============================================================================")
    lines.append("-- BedTrust+ IBM DB2 Data Migration Script")
    lines.append("-- =============================================================================")
    lines.append("")

    # 1. Digital Twins (12 beds)
    lines.append("-- 1. SEED DIGITAL TWINS (BEDS)")
    wards = ["ICU", "EMERGENCY", "GENERAL", "PEDIATRICS"]
    for i in range(1, 13):
        bed_id = f"B{i:02d}"
        ward = wards[(i - 1) % len(wards)]
        is_occupied = (i <= 9)
        reconciled = "OCCUPIED" if is_occupied else "CONFIRMED_AVAILABLE"
        admin = "OCCUPIED" if is_occupied else "AVAILABLE"
        patient = f"P{i:03d}" if is_occupied else None
        lease = 0.0 if is_occupied else 1788640000.0
        
        sql = f"""INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    {escape_sql(bed_id)}, {escape_sql(ward)}, {escape_sql(admin)}, 1788629000.0,
    {escape_sql(admin)}, 1788629000.0, 1788629000.0, 1,
    {escape_sql(admin)}, 1788629000.0, 1788629000.0, 1,
    '[]', {escape_sql(patient)}, {escape_sql(reconciled)},
    {escape_sql(reconciled)}, 1788629000.0, 'NONE',
    {lease}, 'NONE', 'HIGH',
    '["INIT-{bed_id}"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);"""
        lines.append(sql)

    lines.append("")
    lines.append("-- 2. SEED WAITING PATIENTS")
    patients = [
        ("WP001", "Alex Rivera", "ICU", "ICU", 1788628000.0),
        ("WP002", "Sam Patel", "EMERGENCY", "EMERGENCY", 1788628100.0),
        ("WP003", "Jordan Lee", "NORMAL", "GENERAL", 1788628200.0),
        ("WP004", "Taylor Kim", "NORMAL", "PEDIATRICS", 1788628300.0),
        ("WP005", "Casey Morgan", "EMERGENCY", "GENERAL", 1788628400.0),
    ]
    for pid, name, prio, ward, arr in patients:
        sql = f"""INSERT INTO waiting_patients (patientId, name, priority, requestedWard, arrivedAt, assignedBed)
VALUES ({escape_sql(pid)}, {escape_sql(name)}, {escape_sql(prio)}, {escape_sql(ward)}, {arr}, NULL);"""
        lines.append(sql)

    lines.append("")
    lines.append("-- 3. SEED SOURCE HEALTH")
    sources = ["ADMIN", "SOURCE_A", "SOURCE_B", "WORKFLOW", "HUMAN", "SYSTEM"]
    for s in sources:
        sql = f"""INSERT INTO source_health (sourceId, status, lastSuccessfulEventTime, errorCount, latencySum, eventCount, lastErrorTime)
VALUES ({escape_sql(s)}, 'HEALTHY', 1788629000.0, 0, 0.0, 0, 0.0);"""
        lines.append(sql)

    lines.append("")
    lines.append("-- 4. MIGRATE EVENTS (127 RECORDS)")
    seen_event_ids = set()
    events_count = 0
    if os.path.exists(EVENTS_FILE):
        with open(EVENTS_FILE, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                d = json.loads(line)
                eid = d.get("eventId")
                if eid in seen_event_ids:
                    continue
                seen_event_ids.add(eid)
                
                sql = f"""INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    {escape_sql(eid)},
    {escape_sql(d.get('bedId'))},
    {escape_sql(d.get('source'))},
    {escape_sql(d.get('state'))},
    {escape_sql(d.get('eventTime', 0.0))},
    {escape_sql(d.get('receivedTime', 0.0))},
    {escape_sql(d.get('sequenceNumber', 0))},
    {escape_sql(d.get('sourceLineageId'))},
    {escape_sql(d.get('metadata', {}))},
    {escape_sql(d.get('processed', False))},
    {escape_sql(d.get('isDuplicate', False))},
    {escape_sql(d.get('isOutOfOrder', False))},
    {escape_sql(d.get('isStale', False))},
    {escape_sql(d.get('validationStatus', 'VALID'))},
    {escape_sql(d.get('validationNotes', ''))}
);"""
                lines.append(sql)
                events_count += 1

    lines.append("")
    lines.append("-- 5. MIGRATE AUDIT LOG (307 RECORDS)")
    seen_audit_ids = set()
    audit_count = 0
    if os.path.exists(AUDIT_FILE):
        with open(AUDIT_FILE, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                d = json.loads(line)
                aid = d.get("id") or f"AUD-{audit_count+1}"
                if aid in seen_audit_ids:
                    continue
                seen_audit_ids.add(aid)
                
                sql = f"""INSERT INTO audit_log (id, ts, type, data)
VALUES (
    {escape_sql(aid)},
    {escape_sql(d.get('ts', 0.0))},
    {escape_sql(d.get('type', 'UNKNOWN'))},
    {escape_sql(d)}
);"""
                lines.append(sql)
                audit_count += 1

    with open(OUTPUT_SQL, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"Generated {OUTPUT_SQL}:")
    print(f"  - 12 Bed Digital Twins")
    print(f"  - 5 Waiting Patients")
    print(f"  - 6 Source Health rows")
    print(f"  - {events_count} Event records")
    print(f"  - {audit_count} Audit records")

if __name__ == "__main__":
    main()
