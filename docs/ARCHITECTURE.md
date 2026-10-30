# BedTrust+ Architecture

## Design Principle

> Automate normal cases. Detect uncertainty early. **Never guess availability.**  
> Block unsafe allocation. Reconcile automatically whenever possible.  
> Escalate only unresolved cases to humans. Keep every decision traceable.

**A bed may be assigned only when its reconciled state is `CONFIRMED_AVAILABLE`.**  
`UNKNOWN = NOT ALLOCATABLE`

## Component Map

```
┌─────────────────────────────────────────────────────────────┐
│                    Simulation Control Panel                  │
│  Admin Sim │ Source A Sim │ Source B Sim │ Workflow Sim     │
└────────────┬──────────────┬──────────────┬──────────────────┘
             │              │              │
             ▼              ▼              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Event Ingestion API                      │
└────────────────────────────┬────────────────────────────────┘
                             ▼
┌─────────────────────────────────────────────────────────────┐
│  Event Validation Layer                                      │
│  • bed exists  • authorized source  • valid state            │
│  • timestamps  • sequence  • not malformed  • unique eventId │
└────────────────────────────┬────────────────────────────────┘
                             ▼
┌─────────────────────────────────────────────────────────────┐
│  Event Store (immutable JSONL) + Deduplication               │
└────────────────────────────┬────────────────────────────────┘
                             ▼
┌─────────────────────────────────────────────────────────────┐
│  Ordering Layer (eventTime + sequenceNumber)                 │
│  Out-of-order / stale events → OUT_OF_ORDER_STALE_EVENT      │
└────────────────────────────┬────────────────────────────────┘
                             ▼
┌─────────────────────────────────────────────────────────────┐
│  Digital Twin (one per bed)                                  │
│  Admin │ Source A │ Source B │ Workflow │ Lease │ Reservation│
└────────────────────────────┬────────────────────────────────┘
                             ▼
┌──────────────┬─────────────────┬────────────────────────────┐
│ Freshness /  │ Source Lineage  │ Workflow Evidence Engine   │
│ Confidence   │ Independence    │                            │
└──────┬───────┴────────┬────────┴─────────────┬──────────────┘
       │                │                      │
       └────────────────┼──────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────────┐
│  Reconciliation + Consensus Engine                           │
│  Agree AVAILABLE → candidate CONFIRMED_AVAILABLE             │
│  Agree OCCUPIED  → OCCUPIED                                  │
│  Disagree / stale / missing → UNKNOWN + deadline             │
└────────────────────────────┬────────────────────────────────┘
                             ▼
┌─────────────────────────────────────────────────────────────┐
│  Availability Lease Manager                                  │
│  CONFIRMED_AVAILABLE is time-bounded; expiry → UNKNOWN       │
└────────────────────────────┬────────────────────────────────┘
                             ▼
┌─────────────────────────────────────────────────────────────┐
│  Safe Allocation Gate                                        │
│  1. CONFIRMED_AVAILABLE  2. lease valid  3. no conflict      │
│  4. not reserved  5. fresh  6. no newer conflict  7. final   │
└────────────────────────────┬────────────────────────────────┘
                             ▼
┌─────────────────────────────────────────────────────────────┐
│  Atomic Reservation Manager (CHECK → LOCK → RESERVE → COMMIT)│
└────────────────────────────┬────────────────────────────────┘
                             ▼
┌─────────────────────────────────────────────────────────────┐
│  Exception / Human Review Manager                            │
│  Bound expires → MANUAL_REVIEW_REQUIRED                      │
│  Actions: Confirm Available | Confirm Occupied | Keep Blocked│
└─────────────────────────────────────────────────────────────┘
```

## External States

- `CONFIRMED_AVAILABLE`
- `OCCUPIED`
- `UNKNOWN` (with reason)
- `RESERVED`
- `BLOCKED`

## UNKNOWN Reasons

ADMIN_PHYSICAL_MISMATCH · SOURCE_CONFLICT · STALE_CONFIRMATION ·  
MISSING_CONFIRMATION · OUT_OF_ORDER_AMBIGUITY · LEASE_EXPIRED ·  
RECONCILIATION_TIMEOUT · SOURCE_FAILURE · INVALID_EVENT ·  
MANUAL_REVIEW_REQUIRED · ADMIN_DRIFT_DETECTED

## Data Flow Rule

Events are **never** applied directly to the reconciled state.  
They are stored, validated, ordered, used to update the twin’s source views, then the reconciliation engine decides the new reconciled state.
