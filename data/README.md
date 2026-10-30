# Data Directory

Runtime persistence for BedTrust+.

| File | Purpose |
|------|---------|
| `events.jsonl` | Immutable append-only event log (every accepted / rejected event) |
| `audit.jsonl`  | Decision & anomaly audit trail |

These files are created automatically when the server starts and processes events.

- On restart the event store reloads both files.
- Full Digital-Twin rebuild from the log is a planned enhancement; current version re-seeds a clean world on cold start.
- Safe to delete both files to reset history (server will recreate them).

**Do not edit these files by hand while the server is running.**
