"""
BedTrust+ Engines:
- Event Validation
- Ordering & Deduplication
- Source Lineage / Independence
- Reconciliation
- Consensus
- Freshness / Confidence
- Workflow Evidence
- Availability Lease
- Safe Allocation Gate
- Atomic Reservation
- Exception / Human Review
- Anomaly Detection
"""

from __future__ import annotations
import logging
import os
import threading
from typing import Dict, List, Optional, Tuple, Any
from models import (
    Event, DigitalTwin, BedState, UnknownReason, Confidence, Source,
    now_ts, new_id, DEFAULT_RECONCILIATION_BOUND_SEC, DEFAULT_LEASE_DURATION_SEC,
    DEFAULT_FRESHNESS_THRESHOLD_SEC, HIGH_DEMAND_LEASE_SEC, Metrics, WaitingPatient
)
from event_store import EventStore

class Config:
    reconciliation_bound_sec: float = DEFAULT_RECONCILIATION_BOUND_SEC
    lease_duration_sec: float = DEFAULT_LEASE_DURATION_SEC
    freshness_threshold_sec: float = DEFAULT_FRESHNESS_THRESHOLD_SEC
    high_demand: bool = False
    source_a_enabled: bool = True
    source_b_enabled: bool = True
    auto_reconcile: bool = True

logger = logging.getLogger(__name__)

config = Config()

class SystemState:
    def __init__(self, use_db2: bool = False):
        self.lock = threading.RLock()
        self.twins: Dict[str, DigitalTwin] = {}
        self.waiting: List[WaitingPatient] = []
        self.metrics = Metrics()
        self.store = EventStore()
        self.high_demand_mode = False
        self.sim_running = False
        self.anomaly_flags: List[Dict] = []
        self.incidents: List[Any] = []
        self.source_health: Dict[str, Any] = {
            s.value: {"sourceId": s.value, "status": "HEALTHY", "errorCount": 0}
            for s in Source
        }
        self.review_queue: List[str] = []
        self.priority_queue: List[str] = []
        self.db2_repo: Optional[Any] = None
        self.db2_enabled: bool = False
        if use_db2 or os.getenv("USE_DB2", "").lower() in ("true", "1", "yes"):
            self.init_db2()

    def init_db2(self) -> bool:
        """Connect to IBM DB2 and initialize DB2 repository and DB2 event store."""
        try:
            from db2_connection import get_pool
            from db2_repository import DB2Repository
            from db2_event_store import DB2EventStore
            pool = get_pool()
            pool.initialize()
            self.db2_repo = DB2Repository(pool)
            self.store = DB2EventStore(self.db2_repo)
            self.db2_enabled = True
            logger.info("IBM DB2 persistence layer successfully initialized in SystemState.")
            return True
        except Exception as e:
            logger.warning(f"DB2 initialization bypassed (fallback to JSONL store): {e}")
            self.db2_enabled = False
            return False

    def sync_twin_to_db2(self, bed_id: str):
        """Synchronize bed digital twin record into IBM DB2."""
        if self.db2_repo and bed_id in self.twins:
            try:
                self.db2_repo.upsert_twin(self.twins[bed_id].to_dict())
            except Exception as e:
                logger.debug(f"DB2 twin sync notice: {e}")

    def sync_metrics_to_db2(self):
        """Synchronize system metrics singleton to IBM DB2."""
        if self.db2_repo:
            try:
                self.db2_repo.update_metrics(self.metrics.to_dict())
            except Exception as e:
                logger.debug(f"DB2 metrics sync notice: {e}")

    def get_twin(self, bed_id: str) -> Optional[DigitalTwin]:
        return self.twins.get(bed_id)

    def all_twins(self) -> List[DigitalTwin]:
        return list(self.twins.values())

    def add_bed(self, bed_id: str, ward: str) -> bool:
        with self.lock:
            if bed_id in self.twins:
                return False
            twin = DigitalTwin(bedId=bed_id, ward=ward)
            self.twins[bed_id] = twin
            if self.db2_repo:
                try:
                    self.db2_repo.upsert_twin(twin.to_dict())
                except Exception as e:
                    logger.warning(f"Error syncing bed to DB2: {e}")
            return True
            
    def remove_bed(self, bed_id: str) -> bool:
        with self.lock:
            if bed_id in self.twins:
                del self.twins[bed_id]
                if self.db2_repo:
                    try:
                        self.db2_repo.delete_twin(bed_id)
                    except Exception as e:
                        logger.warning(f"Error removing bed in DB2: {e}")
                return True
            return False
            
    def update_patient(self, patient_id: str, name: str, priority: str, requested_ward: str) -> bool:
        with self.lock:
            pat = None
            for p in self.waiting:
                if p.patientId == patient_id:
                    p.name = name
                    p.priority = priority
                    p.requestedWard = requested_ward
                    pat = p
                    break
            if not pat:
                pat = WaitingPatient(patientId=patient_id, name=name, priority=priority, requestedWard=requested_ward)
                self.waiting.append(pat)
            if self.db2_repo:
                try:
                    self.db2_repo.upsert_patient(pat.to_dict())
                except Exception as e:
                    logger.warning(f"Error syncing patient to DB2: {e}")
            return True
            
    def remove_patient(self, patient_id: str) -> bool:
        with self.lock:
            initial_len = len(self.waiting)
            self.waiting = [p for p in self.waiting if p.patientId != patient_id]
            if len(self.waiting) < initial_len:
                if self.db2_repo:
                    try:
                        self.db2_repo.remove_patient(patient_id)
                    except Exception as e:
                        logger.warning(f"Error removing patient in DB2: {e}")
                return True
            return False

class DB2SystemState(SystemState):
    """Explicit DB2-backed SystemState variant."""
    def __init__(self):
        super().__init__(use_db2=True)

def create_system_state(use_db2: bool = False) -> SystemState:
    """Factory creating either DB2-backed or in-memory SystemState."""
    return DB2SystemState() if use_db2 else SystemState()

state = SystemState()

VALID_STATES = {"AVAILABLE", "OCCUPIED", "CLEANING", "RESERVED", "UNKNOWN"}
AUTHORIZED_SOURCES = {s.value for s in Source}

def validate_event(ev: Event) -> Tuple[bool, str]:
    if not ev.eventId or not ev.bedId:
        return False, "Missing eventId or bedId"
    if ev.source not in AUTHORIZED_SOURCES:
        return False, f"Unauthorized source: {ev.source}"
    if ev.state not in VALID_STATES and ev.source != Source.WORKFLOW.value:
        return False, f"Invalid state: {ev.state}"
    if ev.eventTime <= 0 or ev.receivedTime <= 0:
        return False, "Invalid timestamps"
    if ev.eventTime > now_ts() + 120:
        return False, "Event time too far in future"
    if state.store.has_event(ev.eventId):
        return False, "Duplicate eventId"
    return True, "OK"

def is_stale_for_twin(ev: Event, twin: DigitalTwin) -> bool:
    if ev.source == Source.SOURCE_A.value:
        if twin.sourceAEventTime > 0 and ev.eventTime < twin.sourceAEventTime:
            return True
        if twin.sourceASequence > 0 and ev.sequenceNumber < twin.sourceASequence:
            return True
    if ev.source == Source.SOURCE_B.value:
        if twin.sourceBEventTime > 0 and ev.eventTime < twin.sourceBEventTime:
            return True
        if twin.sourceBSequence > 0 and ev.sequenceNumber < twin.sourceBSequence:
            return True
    if ev.source == Source.ADMIN.value:
        if twin.adminUpdateTime > 0 and ev.eventTime < twin.adminUpdateTime:
            return True
    return False

def independent_sources(twin: DigitalTwin) -> set:
    inds = set()
    now = now_ts()
    thresh = config.freshness_threshold_sec
    if twin.adminState != "UNKNOWN" and twin.adminUpdateTime and (now - twin.adminUpdateTime) < thresh:
        inds.add("ADMIN")
    if twin.sourceAState != "UNKNOWN" and twin.sourceAEventTime and (now - twin.sourceAEventTime) < thresh:
        inds.add("SOURCE_A")
    if twin.sourceBState != "UNKNOWN" and twin.sourceBEventTime and (now - twin.sourceBEventTime) < thresh:
        inds.add("SOURCE_B")
    return inds

def compute_confidence(twin: DigitalTwin) -> str:
    now = now_ts()
    ages = []
    if twin.sourceAEventTime:
        ages.append(now - twin.sourceAEventTime)
    if twin.sourceBEventTime:
        ages.append(now - twin.sourceBEventTime)
    if twin.adminUpdateTime:
        ages.append(now - twin.adminUpdateTime)
    if not ages:
        return Confidence.LOW.value
    max_age = max(ages)
    if max_age < 15:
        return Confidence.HIGH.value
    if max_age < 45:
        return Confidence.MEDIUM.value
    return Confidence.LOW.value

def workflow_supports_available(twin: DigitalTwin) -> Optional[bool]:
    if not twin.workflowEvidence:
        return None
    last = twin.workflowEvidence[-1]
    et = last.get("type", "")
    if et in ("DISCHARGE_COMPLETED", "CLEANING_COMPLETED", "ROOM_READY"):
        return True
    if et in ("PATIENT_ASSIGNED", "ADMISSION_STARTED", "CLEANING_REQUIRED", "CLEANING_STARTED", "CLEANING_DELAYED", "NURSE_ENCOUNTER_STARTED", "PATIENT_ARRIVAL_RECORDED"):
        return False
    if twin.activePatientId:
        return False
    return None

def set_unknown(twin: DigitalTwin, reason: UnknownReason):
    twin.reconciledState = BedState.UNKNOWN.value
    twin.unknownReason = reason.value
    twin.availabilityLeaseExpiry = 0
    if twin.reservationStatus == "RESERVED":
        twin.reservationStatus = "NONE"
        twin.currentAssignedPatient = None
        twin.reservationId = None

def ensure_recon_deadline(twin: DigitalTwin):
    if twin.reconciliationDeadline <= now_ts():
        twin.reconciliationDeadline = now_ts() + config.reconciliation_bound_sec
        twin.lastReconciliationAttempt = now_ts()

def ensure_lease(twin: DigitalTwin):
    duration = HIGH_DEMAND_LEASE_SEC if config.high_demand else config.lease_duration_sec
    twin.availabilityLeaseExpiry = now_ts() + duration

def record_success(twin: DigitalTwin, now: float):
    elapsed = now - (twin.lastReconciliationAttempt or now)
    state.metrics.reconciliation_success += 1
    state.metrics.auto_resolved_count += 1
    state.metrics.total_reconciliation_time += max(0, elapsed)
    state.metrics.max_reconciliation_time = max(state.metrics.max_reconciliation_time, elapsed)

def reconcile_bed(bed_id: str) -> Optional[DigitalTwin]:
    with state.lock:
        twin = state.twins.get(bed_id)
        if not twin:
            return None
        now = now_ts()
        twin.updatedAt = now
        twin.confidence = compute_confidence(twin)
        twin.autoRetries += 1

        if twin.humanOverrideExpiry > now and twin.humanOverrideBy:
            if twin.reconciledState == BedState.CONFIRMED_AVAILABLE.value:
                ensure_lease(twin)
            return twin

        a = twin.sourceAState
        b = twin.sourceBState
        admin = twin.adminState
        wf = workflow_supports_available(twin)

        a_fresh = (now - twin.sourceAEventTime) < config.freshness_threshold_sec if twin.sourceAEventTime else False
        b_fresh = (now - twin.sourceBEventTime) < config.freshness_threshold_sec if twin.sourceBEventTime else False
        admin_fresh = (now - twin.adminUpdateTime) < config.freshness_threshold_sec if twin.adminUpdateTime else False

        independent = independent_sources(twin)

        if not a_fresh and not b_fresh and not admin_fresh:
            set_unknown(twin, UnknownReason.STALE_CONFIRMATION)
            return twin

        if not a_fresh and not b_fresh:
            set_unknown(twin, UnknownReason.MISSING_CONFIRMATION)
            return twin

        occupied_votes = 0
        available_votes = 0
        if a_fresh and a == "OCCUPIED": occupied_votes += 1
        if b_fresh and b == "OCCUPIED": occupied_votes += 1
        if a_fresh and a == "AVAILABLE": available_votes += 1
        if b_fresh and b == "AVAILABLE": available_votes += 1
        if wf is False: occupied_votes += 1
        if wf is True: available_votes += 1

        # Derived State Engine logic
        candidate_state = "UNKNOWN"
        if occupied_votes >= 1 and available_votes == 0:
            candidate_state = "OCCUPIED"
        elif available_votes >= 1 and occupied_votes == 0:
            candidate_state = "AVAILABLE"
        else:
            candidate_state = "CONFLICT"

        # If it's a conflict or we don't have enough information, apply Settling Window
        if candidate_state == "CONFLICT" or candidate_state == "UNKNOWN":
            reason = UnknownReason.SOURCE_CONFLICT if candidate_state == "CONFLICT" else UnknownReason.MISSING_CONFIRMATION
            if twin.unknownReason == UnknownReason.NONE.value or twin.reconciledState != BedState.UNKNOWN.value:
                # Entering settling window
                set_unknown(twin, reason)
                ensure_recon_deadline(twin)
            return twin

        if candidate_state == "OCCUPIED":
            twin.reconciledState = BedState.OCCUPIED.value
            twin.unknownReason = UnknownReason.NONE.value
            twin.lastConfirmedState = BedState.OCCUPIED.value
            twin.lastConfirmedTimestamp = now
            twin.needsHumanReview = False
            twin.reconciliationDeadline = 0
            if admin == "AVAILABLE" and admin_fresh:
                state.metrics.admin_drift_detected += 1
                twin.conflictHistory.append({"ts": now, "type": "ADMIN_DRIFT", "admin": admin, "truth": "OCCUPIED"})
                twin.adminState = "OCCUPIED"
                twin.adminUpdateTime = now
                state.store.audit({"type": "ADMIN_DRIFT_CORRECTED", "bedId": bed_id, "from": "AVAILABLE", "to": "OCCUPIED"})
            record_success(twin, now)
            state.sync_twin_to_db2(bed_id)
            return twin

        if candidate_state == "AVAILABLE":
            if len(independent) >= 1 or (a_fresh or b_fresh):
                twin.reconciledState = BedState.CONFIRMED_AVAILABLE.value
                twin.unknownReason = UnknownReason.NONE.value
                twin.lastConfirmedState = BedState.CONFIRMED_AVAILABLE.value
                twin.lastConfirmedTimestamp = now
                twin.needsHumanReview = False
                twin.reconciliationDeadline = 0
                ensure_lease(twin)
                if admin == "OCCUPIED" and admin_fresh:
                    state.metrics.admin_drift_detected += 1
                    twin.adminState = "AVAILABLE"
                    twin.adminUpdateTime = now
                record_success(twin, now)
                state.sync_twin_to_db2(bed_id)
                return twin

        # Fallback
        if admin_fresh and a_fresh and admin != a and a != "UNKNOWN":
            if twin.unknownReason == UnknownReason.NONE.value:
                set_unknown(twin, UnknownReason.ADMIN_PHYSICAL_MISMATCH)
                ensure_recon_deadline(twin)
            state.sync_twin_to_db2(bed_id)
            return twin

        if twin.unknownReason == UnknownReason.NONE.value:
            set_unknown(twin, UnknownReason.MISSING_CONFIRMATION)
            ensure_recon_deadline(twin)
        state.sync_twin_to_db2(bed_id)
        return twin

def process_event(ev: Event) -> Dict:
    with state.lock:
        state.metrics.total_events_processed += 1
        ok, note = validate_event(ev)
        if not ok:
            ev.validationStatus = "REJECTED"
            ev.validationNotes = note
            state.metrics.invalid_events_rejected += 1
            state.store.audit({"type": "EVENT_REJECTED", "eventId": ev.eventId, "reason": note, "source": ev.source, "bedId": ev.bedId})
            state.store.store(ev)
            return {"status": "REJECTED", "reason": note}

        if not state.store.store(ev):
            state.metrics.duplicate_events_ignored += 1
            return {"status": "DUPLICATE", "eventId": ev.eventId}

        ev.validationStatus = "VALID"
        twin = state.twins.get(ev.bedId)
        if not twin:
            twin = DigitalTwin(bedId=ev.bedId, ward=ev.metadata.get("ward", "GENERAL"))
            state.twins[ev.bedId] = twin

        if is_stale_for_twin(ev, twin):
            ev.isOutOfOrder = True
            ev.isStale = True
            state.metrics.out_of_order_events_handled += 1
            state.metrics.stale_confirmations_detected += 1
            state.store.audit({
                "type": "OUT_OF_ORDER_STALE_EVENT",
                "eventId": ev.eventId,
                "bedId": ev.bedId,
                "source": ev.source,
                "eventTime": ev.eventTime,
                "note": "Ignored – older than current knowledge"
            })
            return {"status": "STALE_IGNORED", "eventId": ev.eventId}

        if ev.source == Source.ADMIN.value:
            twin.adminState = ev.state
            twin.adminUpdateTime = ev.eventTime
        elif ev.source == Source.SOURCE_A.value:
            twin.sourceAState = ev.state
            twin.sourceAEventTime = ev.eventTime
            twin.sourceAReceivedTime = ev.receivedTime
            twin.sourceASequence = ev.sequenceNumber
        elif ev.source == Source.SOURCE_B.value:
            twin.sourceBState = ev.state
            twin.sourceBEventTime = ev.eventTime
            twin.sourceBReceivedTime = ev.receivedTime
            twin.sourceBSequence = ev.sequenceNumber
        elif ev.source == Source.WORKFLOW.value:
            twin.workflowEvidence.append({
                "type": ev.metadata.get("workflowType", "UNKNOWN"),
                "ts": ev.eventTime,
                "patientId": ev.metadata.get("patientId"),
                "eventId": ev.eventId
            })
            if ev.metadata.get("workflowType") == "PATIENT_ASSIGNED":
                twin.activePatientId = ev.metadata.get("patientId")
            if ev.metadata.get("workflowType") == "DISCHARGE_COMPLETED":
                twin.activePatientId = None
        elif ev.source == Source.HUMAN.value:
            twin.humanOverrideBy = ev.metadata.get("user", "unknown")
            twin.humanOverrideReason = ev.metadata.get("reason", "")
            twin.humanOverrideExpiry = now_ts() + 300
            if ev.state == "AVAILABLE":
                twin.reconciledState = BedState.CONFIRMED_AVAILABLE.value
                twin.unknownReason = UnknownReason.NONE.value
                ensure_lease(twin)
            elif ev.state == "OCCUPIED":
                twin.reconciledState = BedState.OCCUPIED.value
                twin.unknownReason = UnknownReason.NONE.value
            else:
                twin.reconciledState = BedState.BLOCKED.value
                twin.unknownReason = UnknownReason.MANUAL_REVIEW_REQUIRED.value
            twin.needsHumanReview = False
            if ev.bedId in state.review_queue:
                state.review_queue.remove(ev.bedId)
            state.store.audit({
                "type": "HUMAN_CONFIRMATION",
                "bedId": ev.bedId,
                "user": twin.humanOverrideBy,
                "state": ev.state,
                "reason": twin.humanOverrideReason
            })
            twin.updatedAt = now_ts()
            return {"status": "HUMAN_APPLIED", "bedId": ev.bedId}

        if ev.sourceLineageId and ev.sourceLineageId not in twin.sourceLineage:
            twin.sourceLineage.append(ev.sourceLineageId)

        twin.auditHistory.append({
            "ts": now_ts(),
            "eventId": ev.eventId,
            "source": ev.source,
            "state": ev.state,
            "eventTime": ev.eventTime
        })

        reconcile_bed(ev.bedId)
        state.sync_twin_to_db2(ev.bedId)
        state.sync_metrics_to_db2()
        return {"status": "PROCESSED", "bedId": ev.bedId, "reconciled": twin.reconciledState}

def check_leases():
    with state.lock:
        now = now_ts()
        for twin in state.twins.values():
            if twin.reconciledState == BedState.CONFIRMED_AVAILABLE.value:
                if twin.availabilityLeaseExpiry > 0 and twin.availabilityLeaseExpiry < now:
                    set_unknown(twin, UnknownReason.LEASE_EXPIRED)
                    state.store.audit({"type": "LEASE_EXPIRED", "bedId": twin.bedId})
                    ensure_recon_deadline(twin)

def can_allocate(bed_id: str) -> Tuple[bool, str]:
    twin = state.twins.get(bed_id)
    if not twin:
        return False, "Bed not found"
    if twin.reconciledState != BedState.CONFIRMED_AVAILABLE.value:
        return False, f"State is {twin.reconciledState} (need CONFIRMED_AVAILABLE)"
    if twin.availabilityLeaseExpiry < now_ts():
        return False, "Lease expired"
    if twin.reservationStatus == "RESERVED":
        return False, "Already reserved"
    if twin.needsHumanReview:
        return False, "Pending human review"
    if twin.unknownReason != UnknownReason.NONE.value and twin.reconciledState == BedState.UNKNOWN.value:
        return False, f"Unknown reason: {twin.unknownReason}"
    latest = max(twin.sourceAEventTime or 0, twin.sourceBEventTime or 0, twin.adminUpdateTime or 0)
    if now_ts() - latest > config.freshness_threshold_sec:
        return False, "Confirmation too stale"
    return True, "OK"

def atomic_reserve(bed_id: str, patient_id: str, patient_name: str = "") -> Dict:
    with state.lock:
        ok, reason = can_allocate(bed_id)
        
        # Automatic Alternative Bed Selection
        selected_bed_id = bed_id
        if not ok:
            twin = state.twins.get(bed_id)
            ward = twin.ward if twin else "GENERAL"
            
            # Find alternative
            alternatives = [t for t in state.twins.values() if t.ward == ward and can_allocate(t.bedId)[0]]
            if not alternatives:
                state.metrics.incorrect_allocations_prevented += 1
                state.store.audit({"type": "ALLOCATION_FAILED_NO_ALTERNATIVES", "bedId": bed_id, "patientId": patient_id, "reason": reason})
                
                # Add to waitlist if not already there
                if not any(p.patientId == patient_id for p in state.waiting):
                    state.waiting.append(WaitingPatient(patientId=patient_id, name=patient_name, priority="NORMAL", requestedWard=ward))
                
                return {"success": False, "reason": f"{reason} and no safe alternatives available in {ward}"}
            
            # Rank and pick the first available
            alternatives.sort(key=lambda t: t.availabilityLeaseExpiry, reverse=True)
            selected_bed_id = alternatives[0].bedId
            state.store.audit({
                "type": "ALTERNATIVE_BED_SELECTED",
                "originalBedId": bed_id,
                "newBedId": selected_bed_id,
                "reason": reason
            })

        twin = state.twins[selected_bed_id]
        if twin.reservationStatus == "RESERVED":
            state.metrics.double_booking_attempts_prevented += 1
            return {"success": False, "reason": "Double-booking prevented"}

        twin.reservationStatus = "RESERVED"
        twin.reconciledState = BedState.RESERVED.value
        twin.currentAssignedPatient = patient_id
        twin.reservationId = new_id()
        twin.availabilityLeaseExpiry = 0

        for p in state.waiting:
            if p.patientId == patient_id:
                p.assignedBed = selected_bed_id
                break

        state.store.audit({
            "type": "RESERVATION_COMMITTED",
            "bedId": selected_bed_id,
            "patientId": patient_id,
            "reservationId": twin.reservationId
        })
        state.sync_twin_to_db2(selected_bed_id)
        if state.db2_repo:
            try:
                state.db2_repo.assign_bed(patient_id, selected_bed_id)
            except Exception as e:
                logger.debug(f"DB2 assign_bed notice: {e}")
        return {"success": True, "bedId": selected_bed_id, "reservationId": twin.reservationId, "patientId": patient_id, "wasAlternative": selected_bed_id != bed_id}

def tick_reconciliation():
    with state.lock:
        now = now_ts()
        for twin in list(state.twins.values()):
            if twin.reconciledState != BedState.UNKNOWN.value:
                continue
            if twin.needsHumanReview:
                continue
            if twin.reconciliationDeadline > 0 and twin.reconciliationDeadline < now:
                twin.needsHumanReview = True
                twin.unknownReason = UnknownReason.RECONCILIATION_TIMEOUT.value
                twin.reconciledState = BedState.UNKNOWN.value
                
                # Compute system recommendation based on derived evidence
                occ_votes = 0
                avail_votes = 0
                if twin.sourceAState == "OCCUPIED": occ_votes += 1
                elif twin.sourceAState == "AVAILABLE": avail_votes += 1
                if twin.sourceBState == "OCCUPIED": occ_votes += 1
                elif twin.sourceBState == "AVAILABLE": avail_votes += 1
                
                wf = workflow_supports_available(twin)
                if wf is False: occ_votes += 2
                elif wf is True: avail_votes += 1
                
                if twin.activePatientId:
                    occ_votes += 3
                
                if occ_votes > avail_votes:
                    twin.systemRecommendation = "LIKELY_OCCUPIED"
                    twin.recommendationReason = f"Likely Occupied because there are {occ_votes} signals for occupancy including workflow/patient context."
                elif avail_votes > occ_votes:
                    twin.systemRecommendation = "LIKELY_AVAILABLE"
                    twin.recommendationReason = f"Likely Available because there are {avail_votes} signals for availability (clean/empty context)."
                else:
                    twin.systemRecommendation = "INSUFFICIENT_EVIDENCE"
                    twin.recommendationReason = "Conflicting or insufficient evidence. Please manually verify."

                state.metrics.reconciliation_timeout += 1
                state.metrics.manual_review_count += 1
                if twin.bedId not in state.review_queue:
                    state.review_queue.append(twin.bedId)
                state.store.audit({
                    "type": "RECONCILIATION_TIMEOUT",
                    "bedId": twin.bedId,
                    "reason": twin.unknownReason,
                    "retries": twin.autoRetries,
                    "recommendation": twin.systemRecommendation
                })
            else:
                if config.auto_reconcile:
                    reconcile_bed(twin.bedId)

def detect_anomalies():
    with state.lock:
        now = now_ts()
        for twin in state.twins.values():
            recent = [a for a in twin.auditHistory if now - a["ts"] < 30]
            if len(recent) > 8:
                flag = {"ts": now, "type": "RAPID_STATE_CHANGES", "bedId": twin.bedId, "count": len(recent)}
                if not any(f.get("bedId") == twin.bedId and f.get("type") == "RAPID_STATE_CHANGES" for f in state.anomaly_flags[-10:]):
                    state.anomaly_flags.append(flag)
                    state.store.audit(flag)
        detect_incidents(now)

def detect_incidents(now: float):
    # Group beds with missing or stale confirmations
    stale_beds = [t.bedId for t in state.twins.values() if t.reconciledState == BedState.UNKNOWN.value and t.unknownReason in (UnknownReason.MISSING_CONFIRMATION.value, UnknownReason.STALE_CONFIRMATION.value)]
    
    if len(stale_beds) > 5:
        # Check if we already have an open incident for this
        open_incidents = [i for i in state.incidents if i.status == "OPEN" and i.category == "SOURCE_DELAY"]
        if not open_incidents:
            from models import Incident
            inc = Incident(
                incidentId=new_id(),
                category="SOURCE_DELAY",
                description="EVS or Nurse feed is delayed or offline",
                affectedBeds=stale_beds,
                createdAt=now
            )
            state.incidents.append(inc)
            # Suppress individual alerts by marking them grouped
            for bed_id in stale_beds:
                twin = state.twins.get(bed_id)
                if twin and twin.bedId in state.review_queue:
                    state.review_queue.remove(twin.bedId)
        else:
            inc = open_incidents[0]
            inc.affectedBeds = list(set(inc.affectedBeds + stale_beds))
            
    # Resolve incidents if beds are reconciled
    for inc in state.incidents:
        if inc.status == "OPEN":
            still_affected = [b for b in inc.affectedBeds if state.twins.get(b) and state.twins.get(b).reconciledState == BedState.UNKNOWN.value]
            inc.autoResolvedBeds = [b for b in inc.affectedBeds if b not in still_affected]
            if len(still_affected) == 0:
                inc.status = "RESOLVED"
                inc.resolvedAt = now

def capacity_summary() -> Dict:
    with state.lock:
        counts = {"CONFIRMED_AVAILABLE": 0, "OCCUPIED": 0, "UNKNOWN": 0, "RESERVED": 0, "BLOCKED": 0}
        for t in state.twins.values():
            s = t.reconciledState
            if s in counts:
                counts[s] += 1
            else:
                counts["UNKNOWN"] += 1
        waiting = len([p for p in state.waiting if not p.assignedBed])
        reconciling = len([t for t in state.twins.values() if t.reconciledState == BedState.UNKNOWN.value and not t.needsHumanReview])
        review = len(state.review_queue)
        crunch = waiting > 0 and counts["CONFIRMED_AVAILABLE"] == 0
        return {
            "counts": counts,
            "waitingPatients": waiting,
            "reconciling": reconciling,
            "manualReview": review,
            "capacityCrunch": crunch,
            "totalBeds": len(state.twins),
            "highDemand": config.high_demand,
            "metrics": state.metrics.to_dict()
        }
