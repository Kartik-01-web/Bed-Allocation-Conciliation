#!/usr/bin/env python3
"""BedTrust+ HTTP API server (stdlib only)."""

from __future__ import annotations
import json
import os
import sys
import threading
import time
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
from typing import Any

# local imports
sys.path.insert(0, os.path.dirname(__file__))
from models import Event, DigitalTwin, WaitingPatient, Source, now_ts, new_id, BedState, UnknownReason
from engines import (
    state, process_event, reconcile_bed, atomic_reserve, can_allocate,
    capacity_summary, tick_reconciliation, check_leases, detect_anomalies, config
)
from simulation import (
    seed_beds, seed_waiting, run_high_demand_demo,
    request_fresh_confirmations, make_event, emit,
    run_level1_touchless, run_level2_autorecovery, run_level3_human_exception, inject_grouped_source_outage
)
from db2_queries import DB2QueryRunner, QUERY_CATALOG
from db2_connection import get_pool, DB2Config
from migrate_to_db2 import run_migration

HOST = "0.0.0.0"
PORT = 8080
FRONTEND_DIR = os.path.join(os.path.dirname(__file__), "..", "frontend")

# ---------------------------------------------------------------------------
# Background ticker
# ---------------------------------------------------------------------------
def background_loop():
    while True:
        try:
            tick_reconciliation()
            check_leases()
            detect_anomalies()
        except Exception as e:
            print("bg error:", e)
        time.sleep(0.5)

# ---------------------------------------------------------------------------
# HTTP Handler
# ---------------------------------------------------------------------------
class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        # quieter logs
        if "/api/" in str(args):
            print(f"[{self.log_date_time_string()}] {args[0]}")

    def _cors(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, Authorization")

    def _json(self, code: int, obj: Any):
        body = json.dumps(obj, default=str).encode("utf-8")
        try:
            self.send_response(code)
            self.send_header("Content-Type", "application/json")
            self._cors()
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        except (BrokenPipeError, ConnectionAbortedError, ConnectionResetError):
            return

    def _html(self, path: str):
        full = os.path.join(FRONTEND_DIR, path)
        if not os.path.isfile(full):
            self.send_error(404)
            return
        with open(full, "rb") as f:
            data = f.read()
        ctype = "text/html"
        if path.endswith(".js"):
            ctype = "application/javascript"
        elif path.endswith(".css"):
            ctype = "text/css"
        try:
            self.send_response(200)
            self.send_header("Content-Type", ctype)
            self._cors()
            self.send_header("Content-Length", str(len(data)))
            self.end_headers()
            self.wfile.write(data)
        except (BrokenPipeError, ConnectionAbortedError, ConnectionResetError):
            return

    def do_OPTIONS(self):
        self.send_response(204)
        self._cors()
        self.end_headers()

    def do_GET(self):
        try:
            parsed = urlparse(self.path)
            path = parsed.path

            if path in ("/", "/index.html"):
                self._json(200, {
                    "status": "ok",
                    "service": "BedTrust+ backend",
                    "health": "/api/health",
                    "api": "/api"
                })
                return
            if path.startswith("/static/"):
                self._html(path[len("/static/"):])
                return

            # --- API ---
            if path == "/api/health":
                self._json(200, {"status": "ok", "service": "BedTrust+", "ts": now_ts()})
                return

            if path == "/api/capacity":
                self._json(200, capacity_summary())
                return

            if path == "/api/beds":
                with state.lock:
                    beds = [t.to_dict() for t in state.twins.values()]
                self._json(200, {"beds": beds})
                return

            if path.startswith("/api/beds/"):
                bed_id = path.split("/")[-1]
                twin = state.get_twin(bed_id)
                if not twin:
                    self._json(404, {"error": "bed not found"})
                    return
                events = state.store.get_events_for_bed(bed_id, 50)
                self._json(200, {"bed": twin.to_dict(), "events": events})
                return

            if path == "/api/waiting":
                with state.lock:
                    self._json(200, {"patients": [p.to_dict() for p in state.waiting]})
                return

            if path == "/api/review":
                with state.lock:
                    cases = []
                    for bid in state.review_queue:
                        t = state.twins.get(bid)
                        if t:
                            cases.append(t.to_dict())
                self._json(200, {"cases": cases})
                return

            if path == "/api/metrics":
                self._json(200, state.metrics.to_dict())
                return

            if path == "/api/audit":
                self._json(200, {"audit": state.store.get_audit(100)})
                return

            if path == "/api/anomalies":
                self._json(200, {"anomalies": state.anomaly_flags[-30:]})
                return

            if path == "/api/config":
                self._json(200, {
                    "reconciliation_bound_sec": config.reconciliation_bound_sec,
                    "lease_duration_sec": config.lease_duration_sec,
                    "freshness_threshold_sec": config.freshness_threshold_sec,
                    "high_demand": config.high_demand,
                    "auto_reconcile": config.auto_reconcile
                })
                return

            # --- DB2 Database & Queries API ---
            if path == "/api/db/health":
                try:
                    pool = get_pool()
                    health = pool.health_check()
                    health["db2_enabled"] = getattr(state, "db2_enabled", False)
                    health["db_host"] = pool.config.host
                    health["db_port"] = pool.config.port
                    health["database"] = pool.config.database
                    health["schema"] = pool.config.schema
                    self._json(200, health)
                except Exception as e:
                    self._json(500, {"status": "unhealthy", "error": str(e), "db2_enabled": False})
                return

            if path == "/api/db/catalog":
                try:
                    runner = DB2QueryRunner()
                    self._json(200, {"queries": runner.list_catalog()})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/beds":
                try:
                    if state.db2_repo:
                        beds = state.db2_repo.get_all_twins()
                    else:
                        with state.lock:
                            beds = [t.to_dict() for t in state.twins.values()]
                    self._json(200, {"source": "db2" if state.db2_repo else "memory", "beds": beds})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/patients":
                try:
                    if state.db2_repo:
                        patients = state.db2_repo.get_all_waiting()
                    else:
                        with state.lock:
                            patients = [p.to_dict() for p in state.waiting]
                    self._json(200, {"source": "db2" if state.db2_repo else "memory", "patients": patients})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/events":
                try:
                    if state.db2_repo:
                        events = state.db2_repo.get_all_events(100)
                    else:
                        events = state.store.get_all_events(100)
                    self._json(200, {"source": "db2" if state.db2_repo else "memory", "events": events})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/audit":
                try:
                    if state.db2_repo:
                        audit_entries = state.db2_repo.get_audit(100)
                    else:
                        audit_entries = state.store.get_audit(100)
                    self._json(200, {"source": "db2" if state.db2_repo else "memory", "audit": audit_entries})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/metrics":
                try:
                    if state.db2_repo:
                        metrics = state.db2_repo.get_metrics()
                    else:
                        metrics = state.metrics.to_dict()
                    self._json(200, {"source": "db2" if state.db2_repo else "memory", "metrics": metrics})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/review":
                try:
                    if state.db2_repo:
                        review_beds = state.db2_repo.get_review_queue()
                    else:
                        with state.lock:
                            review_beds = list(state.review_queue)
                    self._json(200, {"source": "db2" if state.db2_repo else "memory", "review_queue": review_beds})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/incidents":
                try:
                    if state.db2_repo:
                        incidents = state.db2_repo.get_open_incidents()
                    else:
                        with state.lock:
                            incidents = [i.__dict__ if hasattr(i, "__dict__") else i for i in state.incidents]
                    self._json(200, {"source": "db2" if state.db2_repo else "memory", "incidents": incidents})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/sources":
                try:
                    if state.db2_repo:
                        sources = state.db2_repo.get_all_source_health()
                    else:
                        sources = state.source_health
                    self._json(200, {"source": "db2" if state.db2_repo else "memory", "sources": sources})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            self._json(404, {"error": "not found"})
        except (BrokenPipeError, ConnectionAbortedError, ConnectionResetError):
            return
        except Exception as e:
            print(f"Error in do_GET {self.path}: {e}")
            self._json(500, {"error": "Internal Server Error"})

    def do_POST(self):
        try:
            parsed = urlparse(self.path)
            path = parsed.path
            length = int(self.headers.get("Content-Length", 0))
            raw = self.rfile.read(length) if length else b"{}"
            try:
                body = json.loads(raw.decode("utf-8") or "{}")
            except Exception:
                body = {}

            # --- Event ingestion ---
            if path == "/api/events":
                try:
                    ev = Event(
                        eventId=body.get("eventId") or new_id(),
                        bedId=body["bedId"],
                        source=body["source"],
                        state=body["state"],
                        eventTime=float(body.get("eventTime", now_ts())),
                        receivedTime=float(body.get("receivedTime", now_ts())),
                        sequenceNumber=int(body.get("sequenceNumber", 0)),
                        sourceLineageId=body.get("sourceLineageId") or new_id(),
                        metadata=body.get("metadata") or {}
                    )
                    result = process_event(ev)
                    self._json(200, result)
                except Exception as e:
                    self._json(400, {"error": str(e)})
                return

            # --- Allocation ---
            if path == "/api/allocate":
                bed_id = body.get("bedId")
                patient_id = body.get("patientId")
                if not bed_id or not patient_id:
                    self._json(400, {"error": "bedId and patientId required"})
                    return
                result = atomic_reserve(bed_id, patient_id, body.get("patientName", ""))
                self._json(200 if result["success"] else 409, result)
                return

            # --- Human review actions ---
            if path == "/api/review/action":
                bed_id = body.get("bedId")
                action = body.get("action")  # CONFIRM_AVAILABLE / CONFIRM_OCCUPIED / KEEP_BLOCKED
                user = body.get("user", "reviewer")
                reason = body.get("reason", "")
                if not bed_id or not action or not reason:
                    self._json(400, {"error": "bedId, action, reason required"})
                    return
                state_map = {
                    "CONFIRM_AVAILABLE": "AVAILABLE",
                    "CONFIRM_OCCUPIED": "OCCUPIED",
                    "KEEP_BLOCKED": "BLOCKED"
                }
                st = state_map.get(action)
                if not st:
                    self._json(400, {"error": "invalid action"})
                    return
                ev = Event(
                    eventId=new_id(),
                    bedId=bed_id,
                    source=Source.HUMAN.value,
                    state=st,
                    eventTime=now_ts(),
                    receivedTime=now_ts(),
                    sequenceNumber=0,
                    sourceLineageId=f"HUMAN-{user}",
                    metadata={"user": user, "reason": reason, "action": action}
                )
                result = process_event(ev)
                self._json(200, result)
                return

            # --- Bed management ---
            if path == "/api/beds/add":
                bed_id = body.get("bedId")
                ward = body.get("ward", "GENERAL")
                if not bed_id:
                    self._json(400, {"error": "bedId required"})
                    return
                success = state.add_bed(bed_id, ward)
                if success:
                    self._json(200, {"success": True, "bedId": bed_id})
                else:
                    self._json(409, {"error": "Bed already exists"})
                return

            if path == "/api/beds/remove":
                bed_id = body.get("bedId")
                if not bed_id:
                    self._json(400, {"error": "bedId required"})
                    return
                success = state.remove_bed(bed_id)
                if success:
                    self._json(200, {"success": True, "bedId": bed_id})
                else:
                    self._json(404, {"error": "Bed not found"})
                return

            # --- Patient management ---
            if path == "/api/patients/update":
                patient_id = body.get("patientId")
                name = body.get("name", "Unknown")
                priority = body.get("priority", "NORMAL")
                requested_ward = body.get("requestedWard", "GENERAL")
                if not patient_id:
                    self._json(400, {"error": "patientId required"})
                    return
                state.update_patient(patient_id, name, priority, requested_ward)
                self._json(200, {"success": True, "patientId": patient_id})
                return

            if path == "/api/patients/remove":
                patient_id = body.get("patientId")
                if not patient_id:
                    self._json(400, {"error": "patientId required"})
                    return
                success = state.remove_patient(patient_id)
                if success:
                    self._json(200, {"success": True, "patientId": patient_id})
                else:
                    self._json(404, {"error": "Patient not found in waiting list"})
                return

            # --- Simulation controls ---
            if path == "/api/sim/seed":
                n = int(body.get("beds", 12))
                seed_beds(n)
                seed_waiting(int(body.get("waiting", 4)))
                self._json(200, {"status": "SEED_OK", "beds": n})
                return

            if path == "/api/sim/high-demand":
                result = run_high_demand_demo()
                self._json(200, result)
                return

            if path == "/api/sim/conflict":
                bed_id = body.get("bedId", "B05")
                t = now_ts()
                emit(make_event(bed_id, Source.ADMIN.value, "AVAILABLE", event_time=t))
                emit(make_event(bed_id, Source.SOURCE_A.value, "OCCUPIED", event_time=t + 0.1))
                self._json(200, {"status": "CONFLICT_INJECTED", "bedId": bed_id})
                return

            if path == "/api/sim/level1":
                bed_id = body.get("bedId", "B05")
                from simulation import run_level1_touchless
                result = run_level1_touchless(bed_id)
                self._json(200, result)
                return

            if path == "/api/sim/level2":
                bed_id = body.get("bedId", "B05")
                from simulation import run_level2_autorecovery
                result = run_level2_autorecovery(bed_id)
                self._json(200, result)
                return

            if path == "/api/sim/level3":
                bed_id = body.get("bedId", "B05")
                from simulation import run_level3_human_exception
                result = run_level3_human_exception(bed_id)
                self._json(200, result)
                return
                
            if path == "/api/sim/grouped-outage":
                from simulation import inject_grouped_source_outage
                result = inject_grouped_source_outage()
                self._json(200, result)
                return

            if path == "/api/sim/fresh":
                bed_id = body.get("bedId")
                result = request_fresh_confirmations(bed_id)
                self._json(200, result)
                return

            if path == "/api/config":
                if "reconciliation_bound_sec" in body:
                    config.reconciliation_bound_sec = float(body["reconciliation_bound_sec"])
                if "lease_duration_sec" in body:
                    config.lease_duration_sec = float(body["lease_duration_sec"])
                if "high_demand" in body:
                    config.high_demand = bool(body["high_demand"])
                if "auto_reconcile" in body:
                    config.auto_reconcile = bool(body["auto_reconcile"])
                self._json(200, {"status": "CONFIG_UPDATED"})
                return

            if path == "/api/reconcile":
                bed_id = body.get("bedId")
                if bed_id:
                    reconcile_bed(bed_id)
                else:
                    for t in state.all_twins():
                        reconcile_bed(t.bedId)
                self._json(200, {"status": "RECONCILED"})
                return

            # --- DB2 Query Runner & Migration ---
            if path == "/api/db/query":
                query_key = body.get("query_key")
                sql = body.get("sql")
                params = tuple(body.get("params", []))
                try:
                    runner = DB2QueryRunner()
                    if query_key:
                        result = runner.run_catalog_query(query_key, params)
                        self._json(200, result)
                    elif sql:
                        rows = runner.run_query(sql, params)
                        self._json(200, {"row_count": len(rows), "rows": rows})
                    else:
                        self._json(400, {"error": "query_key or sql required"})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/migrate":
                dry_run = body.get("dry_run", False)
                skip_schema = body.get("skip_schema", False)
                try:
                    stats = run_migration(dry_run=dry_run, skip_schema=skip_schema)
                    self._json(200, {"status": "MIGRATION_COMPLETED", "stats": stats, "dry_run": dry_run})
                except Exception as e:
                    self._json(500, {"status": "MIGRATION_FAILED", "error": str(e)})
                return

            # --- DB2 CRUD Operations ---
            if path == "/api/db/crud/beds/create" or path == "/api/db/crud/beds/update":
                bed_id = body.get("bedId")
                if not bed_id:
                    self._json(400, {"error": "bedId required"})
                    return
                try:
                    state.add_bed(bed_id, body.get("ward", "GENERAL"))
                    twin = state.get_twin(bed_id)
                    if twin:
                        if "reconciledState" in body:
                            twin.reconciledState = body["reconciledState"]
                        if "adminState" in body:
                            twin.adminState = body["adminState"]
                        if "sourceAState" in body:
                            twin.sourceAState = body["sourceAState"]
                        if "sourceBState" in body:
                            twin.sourceBState = body["sourceBState"]
                        if "confidence" in body:
                            twin.confidence = body["confidence"]
                        if "unknownReason" in body:
                            twin.unknownReason = body["unknownReason"]
                        state.sync_twin_to_db2(bed_id)
                    self._json(200, {"success": True, "bedId": bed_id})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/beds/delete":
                bed_id = body.get("bedId")
                if not bed_id:
                    self._json(400, {"error": "bedId required"})
                    return
                try:
                    success = state.remove_bed(bed_id)
                    self._json(200 if success else 404, {"success": success, "bedId": bed_id})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/patients/create" or path == "/api/db/crud/patients/update":
                patient_id = body.get("patientId")
                if not patient_id:
                    self._json(400, {"error": "patientId required"})
                    return
                try:
                    state.update_patient(
                        patient_id=patient_id,
                        name=body.get("name", "Unknown"),
                        priority=body.get("priority", "NORMAL"),
                        requested_ward=body.get("requestedWard", "GENERAL")
                    )
                    self._json(200, {"success": True, "patientId": patient_id})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/patients/delete":
                patient_id = body.get("patientId")
                if not patient_id:
                    self._json(400, {"error": "patientId required"})
                    return
                try:
                    success = state.remove_patient(patient_id)
                    self._json(200 if success else 404, {"success": success, "patientId": patient_id})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/events/delete":
                event_id = body.get("eventId")
                if not event_id:
                    self._json(400, {"error": "eventId required"})
                    return
                try:
                    if state.db2_repo:
                        success = state.db2_repo.delete_event(event_id)
                        self._json(200 if success else 404, {"success": success, "eventId": event_id})
                    else:
                        self._json(200, {"success": True, "notice": "In-memory mode; delete not persisted"})
                except Exception as e:
                    self._json(500, {"error": str(e)})
                return

            if path == "/api/db/crud/review/add":
                bed_id = body.get("bedId")
                if not bed_id:
                    self._json(400, {"error": "bedId required"})
                    return
                with state.lock:
                    if bed_id not in state.review_queue:
                        state.review_queue.append(bed_id)
                if state.db2_repo:
                    state.db2_repo.add_to_review(bed_id)
                self._json(200, {"success": True, "bedId": bed_id})
                return

            if path == "/api/db/crud/review/remove":
                bed_id = body.get("bedId")
                if not bed_id:
                    self._json(400, {"error": "bedId required"})
                    return
                with state.lock:
                    if bed_id in state.review_queue:
                        state.review_queue.remove(bed_id)
                if state.db2_repo:
                    state.db2_repo.remove_from_review(bed_id)
                self._json(200, {"success": True, "bedId": bed_id})
                return

            self._json(404, {"error": "not found"})
        except (BrokenPipeError, ConnectionAbortedError, ConnectionResetError):
            return
        except Exception as e:
            print(f"Error in do_POST {self.path}: {e}")
            self._json(500, {"error": "Internal Server Error"})

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    # seed a small default world
    seed_beds(8)
    seed_waiting(3)

    t = threading.Thread(target=background_loop, daemon=True)
    t.start()

    server = ThreadingHTTPServer((HOST, PORT), Handler)
    print(f"BedTrust+ running at http://{HOST}:{PORT}")
    print("Dashboard: http://localhost:8080/")
    print("API health: http://localhost:8080/api/health")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down…")
        server.shutdown()

if __name__ == "__main__":
    main()
