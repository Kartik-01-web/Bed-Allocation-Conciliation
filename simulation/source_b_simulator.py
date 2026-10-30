"""
Simulated Confirmation Source B
Second independent confirmation source. Can disagree with Source A.
"""

from __future__ import annotations
import sys
import os
import time
import threading

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "backend"))
from models import Event, Source, now_ts, new_id
from engines import process_event

_seq = 0

def next_seq() -> int:
    global _seq
    _seq += 1
    return _seq

def emit_source_b(bed_id: str, state: str, event_time: float = None,
                  delay: float = 0.0, sequence: int = None,
                  lineage: str = None) -> dict:
    et = event_time if event_time is not None else now_ts()
    rt = now_ts() + max(0.0, delay)
    ev = Event(
        eventId=new_id(),
        bedId=bed_id,
        source=Source.SOURCE_B.value,
        state=state,
        eventTime=et,
        receivedTime=rt,
        sequenceNumber=sequence if sequence is not None else next_seq(),
        sourceLineageId=lineage or f"PHYS-B-{bed_id}-{int(et)}",
        metadata={"origin": "source_b_simulator"}
    )
    if delay > 0:
        def _late():
            time.sleep(delay)
            process_event(ev)
        threading.Thread(target=_late, daemon=True).start()
        return {"status": "SCHEDULED_DELAYED", "delay": delay, "eventId": ev.eventId}
    return process_event(ev)

def emit_conflict_with_a(bed_id: str, a_state: str = "OCCUPIED", b_state: str = "AVAILABLE"):
    """Force a disagreement between Source A and Source B."""
    from source_a_simulator import emit_source_a
    r1 = emit_source_a(bed_id, a_state)
    r2 = emit_source_b(bed_id, b_state)
    return {"source_a": r1, "source_b": r2}

if __name__ == "__main__":
    print("Source B simulator ready.")
