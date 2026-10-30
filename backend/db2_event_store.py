"""
DB2 Event Store for BedTrust+
=============================

IBM DB2 backed implementation of the EventStore interface.
Provides thread-safe event storage, deduplication, auditing, and replay
capabilities backed directly by IBM DB2 database tables (events and audit_log).
"""

from __future__ import annotations

import logging
import threading
from typing import List, Dict, Optional
from models import Event, now_ts, new_id
from db2_repository import DB2Repository

logger = logging.getLogger(__name__)


class DB2EventStore:
    """
    EventStore implementation backed by an IBM DB2 Repository.
    Replaces or synchronizes with the JSONL file-based event store.
    """

    def __init__(self, repo: DB2Repository):
        self.repo = repo
        self._lock = threading.RLock()

    def has_event(self, event_id: str) -> bool:
        """Check whether an event with the given ID exists in DB2."""
        with self._lock:
            return self.repo.has_event(event_id)

    def store(self, ev: Event) -> bool:
        """
        Store event into DB2 events table.
        Returns False if event is a duplicate (already exists).
        """
        with self._lock:
            event_dict = ev.to_dict()
            success = self.repo.insert_event(event_dict)
            if not success:
                ev.isDuplicate = True
                self.audit({
                    "ts": now_ts(),
                    "type": "DUPLICATE_DETECTED",
                    "eventId": ev.eventId,
                    "bedId": ev.bedId,
                    "source": ev.source
                })
                return False
            return True

    def audit(self, entry: Dict) -> None:
        """Append an audit entry into DB2 audit_log table."""
        with self._lock:
            entry_copy = dict(entry)
            entry_copy.setdefault("ts", now_ts())
            entry_copy.setdefault("id", new_id())
            entry_type = entry_copy.get("type", "UNKNOWN")
            
            # The DB2 table stores (id, ts, type, data)
            audit_record = {
                "id": entry_copy["id"],
                "ts": entry_copy["ts"],
                "type": entry_type,
                "data": entry_copy
            }
            try:
                self.repo.insert_audit(audit_record)
            except Exception as e:
                logger.error(f"Failed to record audit entry in DB2: {e}")

    def get_events_for_bed(self, bed_id: str, limit: int = 100) -> List[Dict]:
        """Fetch chronological events for a specific bed from DB2."""
        with self._lock:
            return self.repo.get_events_for_bed(bed_id, limit)

    def get_all_events(self, limit: int = 500) -> List[Dict]:
        """Fetch most recent events from DB2."""
        with self._lock:
            return self.repo.get_all_events(limit)

    def get_audit(self, limit: int = 200) -> List[Dict]:
        """Fetch most recent audit log entries from DB2."""
        with self._lock:
            rows = self.repo.get_audit(limit)
            result = []
            for r in rows:
                data = r.get("data")
                if isinstance(data, dict):
                    result.append(data)
                else:
                    result.append(r)
            return result

    def replay_all(self) -> List[Event]:
        """Replay all historical events from DB2."""
        with self._lock:
            rows = self.repo.get_all_events(limit=10000)
            events = []
            for d in reversed(rows):
                try:
                    ev = Event(**{k: d[k] for k in Event.__dataclass_fields__ if k in d})
                    events.append(ev)
                except Exception as e:
                    logger.warning(f"Skipping malformed event during replay: {e}")
            return events

