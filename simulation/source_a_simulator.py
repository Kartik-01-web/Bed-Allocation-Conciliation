"""
Simulated Confirmation Source A
Independent software endpoint that reports physical-like occupancy.
Can be delayed, out-of-order, or temporarily conflicting.
"""

from __future__ import annotations
import sys
import os
import time

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "backend"))
from models import Event, Source, now_ts, new_id
from engines import process_event

_seq = 0

def next_seq() -> int:
    global _seq
    _seq += 1
    return _seq

def emit_source_a(bed_id: str, state: str, event_time: float = None,
                  delay: float = 0.0, sequence: int = None,
                  lineage: str = None) -> dict:
    """
    Emit a Source A confirmation.
    delay > 0 simulates late network arrival (out-of-order possible).
    """
    et = event_time if event_time is not None else now_ts()
    rt = now_ts() + max(0.0, delay)
    ev = Event(
        eventId=new_id(),
        bedId=bed_id,
        source=Source.SOURCE_A.value,
        state=state,
        eventTime=et,
        receivedTime=rt,
        sequenceNumber=sequence if sequence is not None else next_seq(),
        sourceLineageId=lineage or f"PHYS-A-{bed_id}-{int(et)}",
        metadata={"origin": "source_a_simulator"}
    )
    if delay > 0:
        # schedule delayed delivery
        import threading
        def _late():
            time.sleep(delay)
            process_event(ev)
        threading.Thread(target=_late, daemon=True).start()
        return {"status": "SCHEDULED_DELAYED", "delay": delay, "eventId": ev.eventId}
    return process_event(ev)

def emit_stale_out_of_order(bed_id: str, state: str, older_by_seconds: float = 30.0):
    """Emit an older event that arrives late (should be ignored as stale)."""
    old_time = now_ts() - older_by_seconds
    return emit_source_a(bed_id, state, event_time=old_time, delay=0.1, sequence=1)

if __name__ == "__main__":
    print("Source A simulator ready.")
