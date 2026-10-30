"""
Hospital Workflow Evidence Simulator
Simulates existing hospital software events:
  admission started, patient assigned, transferred,
  discharge initiated/completed, cleaning required/completed.
"""

from __future__ import annotations
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "backend"))
from models import Event, Source, now_ts, new_id
from engines import process_event

_seq = 0

WORKFLOW_TYPES = [
    "ADMISSION_STARTED",
    "PATIENT_ASSIGNED",
    "PATIENT_TRANSFERRED",
    "DISCHARGE_INITIATED",
    "DISCHARGE_COMPLETED",
    "CLEANING_REQUIRED",
    "CLEANING_COMPLETED",
]

def next_seq() -> int:
    global _seq
    _seq += 1
    return _seq

def emit_workflow(bed_id: str, workflow_type: str, patient_id: str = None,
                  event_time: float = None) -> dict:
    if workflow_type not in WORKFLOW_TYPES:
        return {"error": f"Unknown workflow type: {workflow_type}"}
    et = event_time if event_time is not None else now_ts()
    # Map workflow to a coarse state for the event model
    state = "OCCUPIED"
    if workflow_type in ("DISCHARGE_COMPLETED", "CLEANING_COMPLETED"):
        state = "AVAILABLE"
    elif workflow_type == "CLEANING_REQUIRED":
        state = "CLEANING"

    ev = Event(
        eventId=new_id(),
        bedId=bed_id,
        source=Source.WORKFLOW.value,
        state=state,
        eventTime=et,
        receivedTime=now_ts(),
        sequenceNumber=next_seq(),
        sourceLineageId=f"WF-{bed_id}-{workflow_type}-{int(et)}",
        metadata={
            "workflowType": workflow_type,
            "patientId": patient_id,
            "origin": "workflow_simulator"
        }
    )
    return process_event(ev)

def simulate_full_discharge_cycle(bed_id: str, patient_id: str):
    """Emit a realistic discharge + cleaning sequence."""
    results = []
    results.append(emit_workflow(bed_id, "DISCHARGE_INITIATED", patient_id))
    results.append(emit_workflow(bed_id, "DISCHARGE_COMPLETED", patient_id))
    results.append(emit_workflow(bed_id, "CLEANING_REQUIRED", patient_id))
    results.append(emit_workflow(bed_id, "CLEANING_COMPLETED", patient_id))
    return results

if __name__ == "__main__":
    print("Workflow simulator ready. Types:", WORKFLOW_TYPES)
