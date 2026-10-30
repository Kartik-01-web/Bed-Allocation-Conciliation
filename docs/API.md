# BedTrust+ HTTP API

Base URL: `http://localhost:8080`

## Health & Capacity

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/health` | Liveness |
| GET | `/api/capacity` | Safe capacity counts, crunch flag, metrics |
| GET | `/api/metrics` | Full metrics object |
| GET | `/api/config` | Current reconciliation bound, lease, etc. |

## Beds & Digital Twins

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/beds` | All digital twins |
| GET | `/api/beds/{bedId}` | Twin + event timeline |

## Waiting Patients

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/waiting` | Patients waiting for a bed |

## Events

```http
POST /api/events
Content-Type: application/json

{
  "bedId": "B09",
  "source": "SOURCE_A",
  "state": "OCCUPIED",
  "eventTime": 1715000000.0,
  "receivedTime": 1715000001.0,
  "sequenceNumber": 42,
  "sourceLineageId": "PHYS-A-B09-1",
  "metadata": {}
}
```

## Safe Allocation

```http
POST /api/allocate
{
  "bedId": "B10",
  "patientId": "WP001",
  "patientName": "Alex Rivera"
}
```

Returns `success: true` only if the Safe Allocation Gate passes.

## Human Review

```http
GET  /api/review
POST /api/review/action
{
  "bedId": "B05",
  "action": "CONFIRM_OCCUPIED",   // or CONFIRM_AVAILABLE | KEEP_BLOCKED
  "user": "dr.chen",
  "reason": "Physically verified occupied by charge nurse"
}
```

## Simulation Controls

| Method | Path | Body | Description |
|--------|------|------|-------------|
| POST | `/api/sim/seed` | `{ "beds": 10, "waiting": 4 }` | Reset world |
| POST | `/api/sim/high-demand` | `{}` | Run 14-step demo |
| POST | `/api/sim/conflict` | `{ "bedId": "B05" }` | Inject source conflict |
| POST | `/api/sim/fresh` | `{ "bedId": "B05" }` | Request fresh confirmations |
| POST | `/api/reconcile` | `{ "bedId": "B05" }` optional | Force reconciliation pass |
| POST | `/api/config` | config fields | Update bound / lease / high-demand flag |

## Audit & Anomalies

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/audit` | Recent immutable audit entries |
| GET | `/api/anomalies` | Rule-based anomaly flags |
