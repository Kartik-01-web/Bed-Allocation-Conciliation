# Safety Rules (Non-Negotiable)

These rules are enforced by the code and cannot be overridden by configuration.

1. **A bed may be assigned only when its reconciled state is `CONFIRMED_AVAILABLE`.**
2. **`UNKNOWN` = NOT ALLOCATABLE.** Never treat UNKNOWN as available.
3. On any disagreement, missing evidence, or staleness → immediately set `UNKNOWN` and remove from usable capacity.
4. A confirmed AVAILABLE state is protected by a time-bounded **availability lease**. After expiry the bed returns to UNKNOWN until fresh confirmation arrives.
5. The system must **never guess**. If evidence is insufficient or conflicting, stay in UNKNOWN.
6. Out-of-order events are detected via `eventTime` / `sequenceNumber` and must not overwrite newer knowledge.
7. Duplicate events (same `eventId`) are processed at most once.
8. Dependent reports that share the same `sourceLineageId` must not be counted as independent confirmations.
9. When the declared reconciliation bound expires without a safe conclusion → escalate to human review (`MANUAL_REVIEW_REQUIRED`).  
   **Do not** automatically mark the bed available on timeout.
10. Human actions create a new `HUMAN_CONFIRMATION` event; they do not silently erase previous evidence.
11. Human may choose **Keep Blocked**. The system must never force Available or Occupied.
12. Reservation is atomic: CHECK → LOCK → RESERVE → COMMIT. Two patients can never reserve the same bed.
13. All decisions are written to the immutable audit log.

## Human Review Contract

Required fields:
- Authorized user
- Explicit action (Confirm Available / Confirm Occupied / Keep Blocked)
- Free-text reason
- Timestamp
- Audit record

Human overrides carry an expiry and should be revalidated later.
