/** Guided high-demand demonstration steps (matches prompt requirements) */
export type DemoStep = {
  id: number;
  title: string;
  description: string;
  expect?: string; // what UI should show
};

export const DEMO_STEPS: DemoStep[] = [
  {
    id: 1,
    title: "High demand starts",
    description: "Most beds occupied. Several patients waiting. Capacity pressure rises.",
    expect: "Waiting patients > 0, few CONFIRMED_AVAILABLE",
  },
  {
    id: 2,
    title: "Admin says a bed is AVAILABLE (incorrectly)",
    description: "Administrative record drifts — shows AVAILABLE while bed is actually occupied.",
    expect: "Admin column shows AVAILABLE for target bed",
  },
  {
    id: 3,
    title: "Confirmation sources disagree",
    description: "Source A reports OCCUPIED. Source B initially reports AVAILABLE → conflict.",
    expect: "Source A ≠ Source B",
  },
  {
    id: 4,
    title: "System marks bed UNKNOWN immediately",
    description: "Reconciliation engine refuses to guess. Bed is removed from usable capacity.",
    expect: "Reconciled state = UNKNOWN, reason = SOURCE_CONFLICT",
  },
  {
    id: 5,
    title: "Incorrect assignment is blocked",
    description: "Safe Allocation Gate rejects any attempt to assign a patient to UNKNOWN.",
    expect: "Allocate fails with 'need CONFIRMED_AVAILABLE'",
  },
  {
    id: 6,
    title: "Fresh confirmations requested",
    description: "System asks Source A/B for new readings. Workflow evidence is re-checked.",
    expect: "New events appear in timeline",
  },
  {
    id: 7,
    title: "Out-of-order event recognized",
    description: "An older OCCUPIED event arrives late. Ordering layer uses eventTime, not arrival order.",
    expect: "Event tagged STALE / OUT_OF_ORDER in timeline",
  },
  {
    id: 8,
    title: "Stale event does not overwrite newer state",
    description: "Digital Twin keeps the newer knowledge. Stale event is audited only.",
    expect: "Reconciled state unchanged by stale event",
  },
  {
    id: 9,
    title: "Reconciliation runs inside the bound",
    description: "Within the declared 5s SLA the engine retries with new evidence.",
    expect: "Recon deadline countdown visible",
  },
  {
    id: 10,
    title: "Correct final state reached — or escalate",
    description: "If sources agree → CONFIRMED_AVAILABLE or OCCUPIED. If not → MANUAL_REVIEW.",
    expect: "Either resolved state or Human Review queue entry",
  },
  {
    id: 11,
    title: "If AVAILABLE → atomic reservation",
    description: "CHECK → LOCK → RESERVE → COMMIT. Double-booking prevented under lock.",
    expect: "State becomes RESERVED, patient assigned",
  },
  {
    id: 12,
    title: "If OCCUPIED → admin record corrected",
    description: "Admin drift is detected and corrected after independent confirmation.",
    expect: "Admin state updated to OCCUPIED, drift metric +1",
  },
  {
    id: 13,
    title: "If unresolved → human review triggered",
    description: "Bound expired without safe consensus. Case appears in Human Review Queue.",
    expect: "needsHumanReview = true",
  },
  {
    id: 14,
    title: "Human can Confirm Available / Occupied / Keep Blocked",
    description: "Requires user + reason. Creates HUMAN_CONFIRMATION event. Never erases history.",
    expect: "Review modal with three actions",
  },
];
