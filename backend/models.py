"""
BedTrust+ Core Models & Constants
Software-only hospital bed reconciliation prototype.
"""

from __future__ import annotations
import uuid
import time
from dataclasses import dataclass, field, asdict
from typing import Optional, List, Dict, Any
from enum import Enum
from datetime import datetime, timezone

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def now_ts() -> float:
    return time.time()

def iso_now() -> str:
    return datetime.now(timezone.utc).isoformat()

def new_id() -> str:
    return str(uuid.uuid4())

# ---------------------------------------------------------------------------
# External states (what the UI shows)
# ---------------------------------------------------------------------------
class BedState(str, Enum):
    CONFIRMED_AVAILABLE = "CONFIRMED_AVAILABLE"
    OCCUPIED = "OCCUPIED"
    UNKNOWN = "UNKNOWN"
    RESERVED = "RESERVED"
    BLOCKED = "BLOCKED"

# Internal UNKNOWN reasons
class UnknownReason(str, Enum):
    ADMIN_PHYSICAL_MISMATCH = "ADMIN_PHYSICAL_MISMATCH"
    SOURCE_CONFLICT = "SOURCE_CONFLICT"
    STALE_CONFIRMATION = "STALE_CONFIRMATION"
    MISSING_CONFIRMATION = "MISSING_CONFIRMATION"
    OUT_OF_ORDER_AMBIGUITY = "OUT_OF_ORDER_AMBIGUITY"
    LEASE_EXPIRED = "LEASE_EXPIRED"
    RECONCILIATION_TIMEOUT = "RECONCILIATION_TIMEOUT"
    SOURCE_FAILURE = "SOURCE_FAILURE"
    INVALID_EVENT = "INVALID_EVENT"
    MANUAL_REVIEW_REQUIRED = "MANUAL_REVIEW_REQUIRED"
    ADMIN_DRIFT_DETECTED = "ADMIN_DRIFT_DETECTED"
    TEMPORARY_SETTLING = "TEMPORARY_SETTLING"
    NONE = "NONE"

class Confidence(str, Enum):
    HIGH = "HIGH"
    MEDIUM = "MEDIUM"
    LOW = "LOW"

class Source(str, Enum):
    ADMIN = "ADMIN"
    SOURCE_A = "SOURCE_A"
    SOURCE_B = "SOURCE_B"
    WORKFLOW = "WORKFLOW"
    HUMAN = "HUMAN"
    SYSTEM = "SYSTEM"

class WorkflowEventType(str, Enum):
    ADMISSION_STARTED = "ADMISSION_STARTED"
    PATIENT_ASSIGNED = "PATIENT_ASSIGNED"
    PATIENT_TRANSFERRED = "PATIENT_TRANSFERRED"
    DISCHARGE_INITIATED = "DISCHARGE_INITIATED"
    DISCHARGE_COMPLETED = "DISCHARGE_COMPLETED"
    CLEANING_REQUIRED = "CLEANING_REQUIRED"
    CLEANING_STARTED = "CLEANING_STARTED"
    CLEANING_DELAYED = "CLEANING_DELAYED"
    CLEANING_COMPLETED = "CLEANING_COMPLETED"
    CLEANING_CANCELLED = "CLEANING_CANCELLED"
    ROOM_READY = "ROOM_READY"
    NURSE_ENCOUNTER_STARTED = "NURSE_ENCOUNTER_STARTED"
    NURSE_ENCOUNTER_CLOSED = "NURSE_ENCOUNTER_CLOSED"
    PATIENT_ARRIVAL_RECORDED = "PATIENT_ARRIVAL_RECORDED"

class SourceHealthStatus(str, Enum):
    HEALTHY = "HEALTHY"
    DEGRADED = "DEGRADED"
    OFFLINE = "OFFLINE"

@dataclass
class SourceHealth:
    sourceId: str
    status: str = SourceHealthStatus.HEALTHY.value
    lastSuccessfulEventTime: float = 0.0
    errorCount: int = 0
    latencySum: float = 0.0
    eventCount: int = 0
    lastErrorTime: float = 0.0

@dataclass
class Incident:
    incidentId: str
    category: str
    description: str
    affectedBeds: List[str] = field(default_factory=list)
    autoResolvedBeds: List[str] = field(default_factory=list)
    createdAt: float = field(default_factory=now_ts)
    resolvedAt: float = 0.0
    status: str = "OPEN"

# Configurable reconciliation SLA (simulated seconds)
DEFAULT_RECONCILIATION_BOUND_SEC = 5.0
DEFAULT_LEASE_DURATION_SEC = 30.0
DEFAULT_FRESHNESS_THRESHOLD_SEC = 60.0
HIGH_DEMAND_LEASE_SEC = 15.0



# ---------------------------------------------------------------------------
# Event model
# ---------------------------------------------------------------------------
@dataclass
class Event:
    eventId: str
    bedId: str
    source: str
    state: str                     # AVAILABLE / OCCUPIED / etc. for sources
    eventTime: float               # true occurrence time
    receivedTime: float            # network arrival time
    sequenceNumber: int
    sourceLineageId: str
    metadata: Dict[str, Any] = field(default_factory=dict)
    processed: bool = False
    isDuplicate: bool = False
    isOutOfOrder: bool = False
    isStale: bool = False
    validationStatus: str = "PENDING"   # VALID / REJECTED / QUARANTINED
    validationNotes: str = ""

    def to_dict(self) -> Dict:
        return asdict(self)

# ---------------------------------------------------------------------------
# Digital Twin
# ---------------------------------------------------------------------------
@dataclass
class DigitalTwin:
    bedId: str
    ward: str
    # Admin
    adminState: str = "UNKNOWN"
    adminUpdateTime: float = 0.0
    # Source A
    sourceAState: str = "UNKNOWN"
    sourceAEventTime: float = 0.0
    sourceAReceivedTime: float = 0.0
    sourceASequence: int = 0
    # Source B
    sourceBState: str = "UNKNOWN"
    sourceBEventTime: float = 0.0
    sourceBReceivedTime: float = 0.0
    sourceBSequence: int = 0
    # Workflow evidence
    workflowEvidence: List[Dict] = field(default_factory=list)
    activePatientId: Optional[str] = None
    # Reconciled
    reconciledState: str = BedState.UNKNOWN.value
    lastConfirmedState: str = BedState.UNKNOWN.value
    lastConfirmedTimestamp: float = 0.0
    unknownReason: str = UnknownReason.NONE.value
    # Lease & reservation
    availabilityLeaseExpiry: float = 0.0
    reservationStatus: str = "NONE"          # NONE / RESERVED
    currentAssignedPatient: Optional[str] = None
    reservationId: Optional[str] = None
    # Meta
    reconciliationDeadline: float = 0.0
    confidence: str = Confidence.LOW.value
    sourceLineage: List[str] = field(default_factory=list)
    conflictHistory: List[Dict] = field(default_factory=list)
    auditHistory: List[Dict] = field(default_factory=list)
    lastReconciliationAttempt: float = 0.0
    autoRetries: int = 0
    needsHumanReview: bool = False
    systemRecommendation: Optional[str] = None
    recommendationReason: Optional[str] = None
    humanOverrideExpiry: float = 0.0
    humanOverrideBy: Optional[str] = None
    humanOverrideReason: Optional[str] = None
    createdAt: float = field(default_factory=now_ts)
    updatedAt: float = field(default_factory=now_ts)

    def to_dict(self) -> Dict:
        d = asdict(self)
        # add computed helpers for UI
        d["leaseValid"] = self.availabilityLeaseExpiry > now_ts()
        d["leaseRemainingSec"] = max(0, self.availabilityLeaseExpiry - now_ts())
        d["reconRemainingSec"] = max(0, self.reconciliationDeadline - now_ts()) if self.reconciliationDeadline else 0
        return d

# ---------------------------------------------------------------------------
# Metrics
# ---------------------------------------------------------------------------
@dataclass
class Metrics:
    incorrect_allocations_prevented: int = 0
    source_conflicts_detected: int = 0
    admin_drift_detected: int = 0
    reconciliation_success: int = 0
    reconciliation_timeout: int = 0
    total_reconciliation_time: float = 0.0
    max_reconciliation_time: float = 0.0
    unknown_state_duration_sum: float = 0.0
    out_of_order_events_handled: int = 0
    duplicate_events_ignored: int = 0
    stale_confirmations_detected: int = 0
    manual_review_count: int = 0
    auto_resolved_count: int = 0
    double_booking_attempts_prevented: int = 0
    total_events_processed: int = 0
    invalid_events_rejected: int = 0

    def to_dict(self) -> Dict:
        d = asdict(self)
        total_recon = self.reconciliation_success + self.reconciliation_timeout
        d["avg_reconciliation_time"] = (
            self.total_reconciliation_time / total_recon if total_recon else 0.0
        )
        total_cases = self.auto_resolved_count + self.manual_review_count
        d["percentage_resolved_automatically"] = (
            (self.auto_resolved_count / total_cases * 100) if total_cases else 100.0
        )
        d["human_intervention_rate"] = (
            (self.manual_review_count / total_cases * 100) if total_cases else 0.0
        )
        return d

# ---------------------------------------------------------------------------
# Waiting patient
# ---------------------------------------------------------------------------
@dataclass
class WaitingPatient:
    patientId: str
    name: str
    priority: str          # ICU / EMERGENCY / NORMAL
    requestedWard: str
    arrivedAt: float = field(default_factory=now_ts)
    assignedBed: Optional[str] = None

    def to_dict(self) -> Dict:
        return asdict(self)
