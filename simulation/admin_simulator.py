"""
Administrative Bed System Simulator
Emits administrative bed-state events (can be late, wrong, or drifted).
"""

from __future__ import annotations
import sys
import os
import time
import random

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "backend"))
from models import Event, Source, now_ts, new_id
from engines import process_event

_seq = 0

def next_seq() -> int:
    global _seq
    _seq += 1
    return _seq

def emit_admin_state(bed_id: str, state: str, event_time: float = None,
                     ward: str = "GENERAL", lineage: str = None) -> dict:
    """Simulate an administrative record update for a bed."""
    et = event_time if event_time is not None else now_ts()
    ev = Event(
        eventId=new_id(),
        bedId=bed_id,
        source=Source.ADMIN.value,
        state=state,
        eventTime=et,
        receivedTime=now_ts(),
        sequenceNumber=next_seq(),
        sourceLineageId=lineage or f"ADMIN-{bed_id}-{int(et)}",
        metadata={"ward": ward, "origin": "admin_simulator"}
    )
    return process_event(ev)

def simulate_admin_drift(bed_id: str, wrong_state: str = "AVAILABLE"):
    """Intentionally emit an incorrect admin state (common failure mode)."""
    return emit_admin_state(bed_id, wrong_state, lineage=f"ADMIN-DRIFT-{bed_id}")

if __name__ == "__main__":
    print("Admin simulator ready. Import and call emit_admin_state(...)")
