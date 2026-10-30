"""
Immutable Event Store + Audit Log
Persistent JSON-backed store. Survives restarts via replay.
"""

from __future__ import annotations
import json
import os
import threading
from typing import List, Dict, Optional, Set
from models import Event, now_ts, new_id

DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "data")
os.makedirs(DATA_DIR, exist_ok=True)

EVENTS_FILE = os.path.join(DATA_DIR, "events.jsonl")
AUDIT_FILE = os.path.join(DATA_DIR, "audit.jsonl")

class EventStore:
    def __init__(self):
        self._lock = threading.RLock()
        self._events: List[Event] = []
        self._seen_ids: Set[str] = set()
        self._audit: List[Dict] = []
        self._load()

    def _load(self):
        if os.path.exists(EVENTS_FILE):
            with open(EVENTS_FILE, "r") as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        d = json.loads(line)
                        ev = Event(**{k: d[k] for k in Event.__dataclass_fields__ if k in d})
                        self._events.append(ev)
                        self._seen_ids.add(ev.eventId)
                    except Exception:
                        pass
        if os.path.exists(AUDIT_FILE):
            with open(AUDIT_FILE, "r") as f:
                for line in f:
                    line = line.strip()
                    if line:
                        try:
                            self._audit.append(json.loads(line))
                        except Exception:
                            pass

    def _append_event(self, ev: Event):
        with open(EVENTS_FILE, "a") as f:
            f.write(json.dumps(ev.to_dict()) + "\n")

    def _append_audit(self, entry: Dict):
        with open(AUDIT_FILE, "a") as f:
            f.write(json.dumps(entry) + "\n")

    def has_event(self, event_id: str) -> bool:
        with self._lock:
            return event_id in self._seen_ids

    def store(self, ev: Event) -> bool:
        """Store event. Returns False if duplicate."""
        with self._lock:
            if ev.eventId in self._seen_ids:
                ev.isDuplicate = True
                self._audit.append({
                    "ts": now_ts(),
                    "type": "DUPLICATE_DETECTED",
                    "eventId": ev.eventId,
                    "bedId": ev.bedId,
                    "source": ev.source
                })
                self._append_audit(self._audit[-1])
                return False
            self._seen_ids.add(ev.eventId)
            self._events.append(ev)
            self._append_event(ev)
            return True

    def audit(self, entry: Dict):
        with self._lock:
            entry.setdefault("ts", now_ts())
            entry.setdefault("id", new_id())
            self._audit.append(entry)
            self._append_audit(entry)

    def get_events_for_bed(self, bed_id: str, limit: int = 100) -> List[Dict]:
        with self._lock:
            return [e.to_dict() for e in reversed(self._events) if e.bedId == bed_id][:limit]

    def get_all_events(self, limit: int = 500) -> List[Dict]:
        with self._lock:
            return [e.to_dict() for e in reversed(self._events)][:limit]

    def get_audit(self, limit: int = 200) -> List[Dict]:
        with self._lock:
            return list(reversed(self._audit))[:limit]

    def replay_all(self) -> List[Event]:
        with self._lock:
            return list(self._events)
