"""
High-Demand Demonstration Scenario
Implements the exact 14-step visible demo required by the prompt.
"""

from __future__ import annotations
import sys
import os
import time
import threading

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "backend"))
from models import now_ts, Source
from engines import state, config, tick_reconciliation, check_leases, detect_anomalies
from simulation import seed_beds, seed_waiting, make_event, emit  # re-use core helpers

# Prefer local simulators when run standalone
try:
    from admin_simulator import emit_admin_state
    from source_a_simulator import emit_source_a, emit_stale_out_of_order
    from source_b_simulator import emit_source_b
    from workflow_simulator import emit_workflow
except ImportError:
    pass

def run():
    """
    Visible demonstration of:
    1. high demand occurs
    2. admin says a bed is available (incorrectly)
    3. confirmation information disagrees
    4. system immediately marks bed UNKNOWN
    5. incorrect assignment is blocked
    6. fresh confirmations are requested
    7. out-of-order event is correctly recognized
    8. stale event does not overwrite newer state
    9. reconciliation succeeds or escalates
    10. correct final state is reached
    11. if AVAILABLE → atomically reserved
    12. if OCCUPIED → admin record corrected
    13. if unresolved → human review triggered
    14. human can Confirm Available / Occupied / Keep Blocked
    """
    print("=" * 60)
    print("BedTrust+ High-Demand Scenario")
    print("=" * 60)

    config.high_demand = True
    config.reconciliation_bound_sec = 5.0
    state.sim_running = True

    with state.lock:
        state.twins.clear()
        state.waiting.clear()
        state.review_queue.clear()
        state.anomaly_flags.clear()
        from models import Metrics
        state.metrics = Metrics()

    seed_beds(10)
    seed_waiting(4)

    # Force most beds occupied
    with state.lock:
        for i, twin in enumerate(state.twins.values()):
            if i < 8:
                twin.reconciledState = "OCCUPIED"
                twin.adminState = "OCCUPIED"
                twin.sourceAState = "OCCUPIED"
                twin.sourceBState = "OCCUPIED"
                twin.activePatientId = f"P{i+1:03d}"
            else:
                twin.reconciledState = "CONFIRMED_AVAILABLE"
                twin.adminState = "AVAILABLE"
                twin.sourceAState = "AVAILABLE"
                twin.sourceBState = "AVAILABLE"
                from engines import ensure_lease
                ensure_lease(twin)

    target = "B09"
    t0 = now_ts()
    print(f"\n[1] High demand active. Waiting patients: {len(state.waiting)}")
    print(f"[2] Admin incorrectly marks {target} AVAILABLE")
    emit(make_event(target, Source.ADMIN.value, "AVAILABLE", event_time=t0,
                    lineage="ADMIN-ROOT-1", metadata={"ward": "GENERAL"}))

    time.sleep(0.3)
    print(f"[3] Source A reports OCCUPIED (true physical)")
    emit(make_event(target, Source.SOURCE_A.value, "OCCUPIED", event_time=t0 + 0.5,
                    lineage="PHYS-A-1"))

    time.sleep(0.2)
    print(f"[3b] Source B initially conflicts (AVAILABLE)")
    emit(make_event(target, Source.SOURCE_B.value, "AVAILABLE", event_time=t0 + 0.6,
                    lineage="PHYS-B-1"))

    time.sleep(0.3)
    print("[7/8] Injecting out-of-order stale event (should be ignored)")
    ooo = make_event(target, Source.SOURCE_A.value, "OCCUPIED",
                     event_time=t0 - 10, lineage="PHYS-A-OLD")
    ooo.sequenceNumber = 1
    emit(ooo)

    print("[Duplicate] Sending near-duplicate confirmation")
    emit(make_event(target, Source.SOURCE_A.value, "OCCUPIED",
                    event_time=t0 + 0.5, lineage="PHYS-A-1"))

    time.sleep(1.0)
    print("[6] Delayed correction from Source B → OCCUPIED")
    emit(make_event(target, Source.SOURCE_B.value, "OCCUPIED",
                    event_time=now_ts(), lineage="PHYS-B-2", delay=0.4))

    print("[Workflow] Active patient still assigned")
    emit(make_event(target, Source.WORKFLOW.value, "OCCUPIED",
                    event_time=now_ts(),
                    metadata={"workflowType": "PATIENT_ASSIGNED", "patientId": "P009"}))

    def _bg():
        for i in range(16):
            time.sleep(0.5)
            tick_reconciliation()
            check_leases()
            detect_anomalies()
            if i == 4:
                twin = state.get_twin(target)
                if twin:
                    print(f"\n[4/5] Current state of {target}: {twin.reconciledState} "
                          f"({twin.unknownReason}) — allocation blocked while UNKNOWN")
        state.sim_running = False
        twin = state.get_twin(target)
        if twin:
            print(f"\n[9-13] Final state of {target}: {twin.reconciledState} "
                  f"| needsHumanReview={twin.needsHumanReview}")
            if twin.needsHumanReview:
                print("[14] Human review queue now contains this bed.")
        print("\nScenario finished.")

    threading.Thread(target=_bg, daemon=True).start()
    return {"status": "HIGH_DEMAND_DEMO_STARTED", "targetBed": target}

if __name__ == "__main__":
    # When run directly, need the server engines already loaded
    print("Run via the dashboard button or: python -c \"from high_demand_scenario import run; run()\"")
    print("after the BedTrust+ server is up.")
