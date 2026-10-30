"""
Simulated sources + High-demand demonstration scenario.
All confirmation sources are pure software event generators.
"""

from __future__ import annotations
import threading
import time
import random
from typing import List
from models import Event, DigitalTwin, WaitingPatient, Source, now_ts, new_id, BedState, UnknownReason
from engines import state, process_event, config, reconcile_bed

_seq = {"ADMIN": 0, "SOURCE_A": 0, "SOURCE_B": 0, "WORKFLOW": 0}

def next_seq(src: str) -> int:
    _seq[src] = _seq.get(src, 0) + 1
    return _seq[src]

def make_event(bed_id: str, source: str, state_val: str, event_time: float = None,
               lineage: str = None, metadata: dict = None, delay: float = 0.0) -> Event:
    et = event_time if event_time is not None else now_ts()
    # simulate network delay / out-of-order by controlling receivedTime
    rt = now_ts() + delay
    return Event(
        eventId=new_id(),
        bedId=bed_id,
        source=source,
        state=state_val,
        eventTime=et,
        receivedTime=rt if delay >= 0 else now_ts(),
        sequenceNumber=next_seq(source),
        sourceLineageId=lineage or f"{source}-{bed_id}-{int(et)}",
        metadata=metadata or {}
    )

def seed_beds(n: int = 12):
    """Create initial bed twins across wards."""
    wards = ["ICU", "EMERGENCY", "GENERAL", "PEDIATRICS"]
    with state.lock:
        for i in range(1, n + 1):
            bed_id = f"B{i:02d}"
            ward = wards[(i - 1) % len(wards)]
            twin = DigitalTwin(bedId=bed_id, ward=ward)
            # most beds start occupied
            if i <= n - 3:
                twin.adminState = "OCCUPIED"
                twin.sourceAState = "OCCUPIED"
                twin.sourceBState = "OCCUPIED"
                twin.reconciledState = BedState.OCCUPIED.value
                twin.adminUpdateTime = now_ts() - 10
                twin.sourceAEventTime = now_ts() - 8
                twin.sourceBEventTime = now_ts() - 7
                twin.activePatientId = f"P{i:03d}"
            else:
                twin.adminState = "AVAILABLE"
                twin.sourceAState = "AVAILABLE"
                twin.sourceBState = "AVAILABLE"
                twin.reconciledState = BedState.CONFIRMED_AVAILABLE.value
                twin.adminUpdateTime = now_ts() - 5
                twin.sourceAEventTime = now_ts() - 4
                twin.sourceBEventTime = now_ts() - 3
                from engines import ensure_lease
                ensure_lease(twin)
            state.twins[bed_id] = twin

def seed_waiting(n: int = 5):
    names = ["Alex Rivera", "Sam Patel", "Jordan Lee", "Taylor Kim", "Casey Morgan",
             "Riley Quinn", "Avery Brooks", "Jamie Santos"]
    priorities = ["ICU", "EMERGENCY", "NORMAL", "NORMAL", "EMERGENCY"]
    with state.lock:
        state.waiting.clear()
        for i in range(n):
            p = WaitingPatient(
                patientId=f"WP{i+1:03d}",
                name=names[i % len(names)],
                priority=priorities[i % len(priorities)],
                requestedWard="ICU" if priorities[i % len(priorities)] == "ICU" else "GENERAL"
            )
            state.waiting.append(p)

def emit(ev: Event):
    """Push event into the system (respects simulated receivedTime via delay)."""
    if ev.receivedTime > now_ts():
        # schedule delayed delivery
        delay = ev.receivedTime - now_ts()
        def _delayed():
            time.sleep(max(0, delay))
            process_event(ev)
        threading.Thread(target=_delayed, daemon=True).start()
    else:
        process_event(ev)

# ---------------------------------------------------------------------------
# High-demand demonstration scenario
# ---------------------------------------------------------------------------
def run_high_demand_demo():
    """
    Visibly demonstrates:
    1. high demand
    2. admin says bed available (incorrectly)
    3. confirmation sources disagree
    4. system marks UNKNOWN immediately
    5. assignment blocked
    6. out-of-order / duplicate / delayed events handled
    7. reconciliation or escalation
    """
    config.high_demand = True
    config.reconciliation_bound_sec = 5.0
    state.sim_running = True

    # Reset to clean high-demand state
    with state.lock:
        state.twins.clear()
        state.waiting.clear()
        state.review_queue.clear()
        state.anomaly_flags.clear()
        state.metrics = type(state.metrics)()  # fresh metrics

    seed_beds(10)
    seed_waiting(4)

    # Force most beds occupied
    with state.lock:
        for i, twin in enumerate(state.twins.values()):
            if i < 8:
                twin.reconciledState = BedState.OCCUPIED.value
                twin.adminState = "OCCUPIED"
                twin.sourceAState = "OCCUPIED"
                twin.sourceBState = "OCCUPIED"
                twin.activePatientId = f"P{i+1:03d}"
            else:
                twin.reconciledState = BedState.CONFIRMED_AVAILABLE.value
                twin.adminState = "AVAILABLE"
                twin.sourceAState = "AVAILABLE"
                twin.sourceBState = "AVAILABLE"
                from engines import ensure_lease
                ensure_lease(twin)

    # The problematic bed: B09
    # Admin incorrectly shows AVAILABLE
    # Source A correctly shows OCCUPIED
    # Source B will conflict / arrive late
    target = "B09"
    t0 = now_ts()

    # 1. Admin says AVAILABLE (wrong)
    emit(make_event(target, Source.ADMIN.value, "AVAILABLE", event_time=t0,
                    lineage="ADMIN-ROOT-1", metadata={"ward": "GENERAL"}))

    time.sleep(0.3)

    # 2. Source A says OCCUPIED (true physical)
    emit(make_event(target, Source.SOURCE_A.value, "OCCUPIED", event_time=t0 + 0.5,
                    lineage="PHYS-A-1"))

    time.sleep(0.2)

    # 3. Source B initially agrees with Admin (conflict) then will correct
    emit(make_event(target, Source.SOURCE_B.value, "AVAILABLE", event_time=t0 + 0.6,
                    lineage="PHYS-B-1"))

    time.sleep(0.4)

    # 4. Duplicate event (same eventId will be ignored – we send a copy)
    dup = make_event(target, Source.SOURCE_A.value, "OCCUPIED", event_time=t0 + 0.5,
                     lineage="PHYS-A-1")
    # force same id to trigger dedup
    # (we already processed the first; this will be detected as new id but we also test real dedup)
    emit(dup)

    # 5. Out-of-order: an older OCCUPIED event arrives late
    # eventTime is older than the AVAILABLE that already arrived
    ooo = make_event(target, Source.SOURCE_A.value, "OCCUPIED",
                     event_time=t0 - 10,   # older
                     lineage="PHYS-A-OLD")
    ooo.sequenceNumber = 1  # lower sequence
    emit(ooo)

    # 6. Delayed correction from Source B (arrives after conflict window starts)
    time.sleep(1.0)
    emit(make_event(target, Source.SOURCE_B.value, "OCCUPIED",
                    event_time=now_ts(),
                    lineage="PHYS-B-2", delay=0.5))

    # 7. Workflow evidence: active patient still assigned
    emit(make_event(target, Source.WORKFLOW.value, "OCCUPIED",
                    event_time=now_ts(),
                    metadata={"workflowType": "PATIENT_ASSIGNED", "patientId": "P009"}))

    # Background tick will drive reconciliation / timeout
    def _bg():
        for _ in range(20):
            time.sleep(0.5)
            from engines import tick_reconciliation, check_leases, detect_anomalies
            tick_reconciliation()
            check_leases()
            detect_anomalies()
        state.sim_running = False

    threading.Thread(target=_bg, daemon=True).start()
    return {"status": "HIGH_DEMAND_DEMO_STARTED", "targetBed": target}

def run_level1_touchless(bed_id: str = "B05"):
    """Level 1 - Touchless: All sources agree and are fresh."""
    t = now_ts()
    emit(make_event(bed_id, Source.ADMIN.value, "AVAILABLE", event_time=t))
    emit(make_event(bed_id, Source.SOURCE_A.value, "AVAILABLE", event_time=t + 0.1))
    emit(make_event(bed_id, Source.SOURCE_B.value, "AVAILABLE", event_time=t + 0.2))
    emit(make_event(bed_id, Source.WORKFLOW.value, "AVAILABLE", event_time=t + 0.3, metadata={"workflowType": "ROOM_READY"}))
    return {"status": "LEVEL_1_INJECTED", "bedId": bed_id}

def run_level2_autorecovery(bed_id: str = "B05"):
    """Level 2 - Auto-Recovery: Temporary mismatch resolves within settling window."""
    t = now_ts()
    # Admin says available, but Source A is occupied (creates conflict/UNKNOWN)
    emit(make_event(bed_id, Source.ADMIN.value, "AVAILABLE", event_time=t))
    emit(make_event(bed_id, Source.SOURCE_A.value, "OCCUPIED", event_time=t + 0.1))
    
    # Delayed correction from Nurse workflow 2 seconds later (resolves to OCCUPIED)
    def _delayed_correction():
        time.sleep(2)
        emit(make_event(bed_id, Source.WORKFLOW.value, "OCCUPIED", event_time=now_ts(), metadata={"workflowType": "PATIENT_ARRIVAL_RECORDED", "patientId": "P999"}))
        emit(make_event(bed_id, Source.SOURCE_B.value, "OCCUPIED", event_time=now_ts()))
    threading.Thread(target=_delayed_correction, daemon=True).start()
    
    return {"status": "LEVEL_2_INJECTED", "bedId": bed_id}

def run_level3_human_exception(bed_id: str = "B05"):
    """Level 3 - Human Exception: Automation fails, requires review."""
    t = now_ts()
    emit(make_event(bed_id, Source.ADMIN.value, "AVAILABLE", event_time=t))
    emit(make_event(bed_id, Source.SOURCE_A.value, "OCCUPIED", event_time=t + 0.1))
    emit(make_event(bed_id, Source.SOURCE_B.value, "AVAILABLE", event_time=t + 0.2))
    # It will hit the reconciliation bound and escalate
    return {"status": "LEVEL_3_INJECTED", "bedId": bed_id}

def inject_grouped_source_outage():
    """Simulates an EVS feed delay affecting multiple beds."""
    affected_beds = ["B01", "B02", "B03", "B04", "B05", "B06", "B07"]
    t = now_ts() - 65 # Make them stale
    for b in affected_beds:
        twin = state.get_twin(b)
        if twin:
            twin.reconciledState = BedState.UNKNOWN.value
            twin.unknownReason = UnknownReason.MISSING_CONFIRMATION.value
            twin.sourceAEventTime = t
            twin.sourceBEventTime = t
    from engines import detect_incidents
    detect_incidents(now_ts())
    return {"status": "GROUPED_OUTAGE_INJECTED", "affectedCount": len(affected_beds)}

def request_fresh_confirmations(bed_id: str):
    """Simulate requesting new readings from sources."""
    twin = state.get_twin(bed_id)
    if not twin:
        return {"error": "bed not found"}
    t = now_ts()
    # sources re-report their last known (or random for demo)
    emit(make_event(bed_id, Source.SOURCE_A.value, twin.sourceAState or "OCCUPIED", event_time=t))
    emit(make_event(bed_id, Source.SOURCE_B.value, twin.sourceBState or "OCCUPIED", event_time=t + 0.05))
    return {"status": "FRESH_REQUESTED", "bedId": bed_id}
