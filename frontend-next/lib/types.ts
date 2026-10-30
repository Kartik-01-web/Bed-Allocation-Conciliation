export type BedState =
  | "CONFIRMED_AVAILABLE"
  | "OCCUPIED"
  | "UNKNOWN"
  | "RESERVED"
  | "BLOCKED";

export interface DigitalTwin {
  bedId: string;
  ward: string;
  adminState: string;
  adminUpdateTime: number;
  sourceAState: string;
  sourceAEventTime: number;
  sourceAReceivedTime: number;
  sourceBState: string;
  sourceBEventTime: number;
  sourceBReceivedTime: number;
  workflowEvidence: Array<Record<string, unknown>>;
  activePatientId: string | null;
  reconciledState: BedState | string;
  lastConfirmedState: string;
  lastConfirmedTimestamp: number;
  unknownReason: string;
  availabilityLeaseExpiry: number;
  reservationStatus: string;
  currentAssignedPatient: string | null;
  reservationId: string | null;
  reconciliationDeadline: number;
  confidence: string;
  sourceLineage: string[];
  conflictHistory: Array<Record<string, unknown>>;
  auditHistory: Array<Record<string, unknown>>;
  lastReconciliationAttempt: number;
  autoRetries: number;
  needsHumanReview: boolean;
  systemRecommendation: string | null;
  recommendationReason: string | null;
  humanOverrideExpiry: number;
  humanOverrideBy: string | null;
  humanOverrideReason: string | null;
  leaseValid?: boolean;
  leaseRemainingSec?: number;
  reconRemainingSec?: number;
  updatedAt: number;
}

export interface WaitingPatient {
  patientId: string;
  name: string;
  priority: string;
  requestedWard: string;
  arrivedAt: number;
  assignedBed: string | null;
}

export interface CapacitySummary {
  counts: {
    CONFIRMED_AVAILABLE: number;
    OCCUPIED: number;
    UNKNOWN: number;
    RESERVED: number;
    BLOCKED: number;
  };
  waitingPatients: number;
  reconciling: number;
  manualReview: number;
  capacityCrunch: boolean;
  totalBeds: number;
  highDemand: boolean;
  metrics: Metrics;
}

export interface Metrics {
  incorrect_allocations_prevented: number;
  source_conflicts_detected: number;
  admin_drift_detected: number;
  reconciliation_success: number;
  reconciliation_timeout: number;
  total_reconciliation_time: number;
  max_reconciliation_time: number;
  out_of_order_events_handled: number;
  duplicate_events_ignored: number;
  stale_confirmations_detected: number;
  manual_review_count: number;
  auto_resolved_count: number;
  double_booking_attempts_prevented: number;
  total_events_processed: number;
  invalid_events_rejected: number;
  avg_reconciliation_time: number;
  percentage_resolved_automatically: number;
  human_intervention_rate: number;
}

export interface BedEvent {
  eventId: string;
  bedId: string;
  source: string;
  state: string;
  eventTime: number;
  receivedTime: number;
  sequenceNumber: number;
  sourceLineageId: string;
  isDuplicate?: boolean;
  isOutOfOrder?: boolean;
  isStale?: boolean;
  validationStatus?: string;
  metadata?: Record<string, unknown>;
}
