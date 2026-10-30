# Simulation Layer

All confirmation sources are **pure software**. No physical devices.

## Modules

| File | Role |
|------|------|
| `admin_simulator.py` | Administrative bed-management system (can drift / be wrong) |
| `source_a_simulator.py` | Independent confirmation Source A (supports delay & out-of-order) |
| `source_b_simulator.py` | Independent confirmation Source B (can conflict with A) |
| `workflow_simulator.py` | Hospital workflow evidence (admission, discharge, cleaning…) |
| `high_demand_scenario.py` | Full 14-step high-demand demonstration |

## How events flow

```
Simulator  →  Event object  →  process_event()  →  Validation
                                                →  Ordering / Dedup
                                                →  Digital Twin update
                                                →  Reconciliation
```

## Quick examples (with server running)

```python
from admin_simulator import emit_admin_state, simulate_admin_drift
from source_a_simulator import emit_source_a, emit_stale_out_of_order
from source_b_simulator import emit_source_b, emit_conflict_with_a
from workflow_simulator import emit_workflow, simulate_full_discharge_cycle

# Normal update
emit_admin_state("B03", "AVAILABLE")

# Force conflict
emit_conflict_with_a("B05")

# Out-of-order stale event (will be ignored)
emit_stale_out_of_order("B03", "OCCUPIED", older_by_seconds=60)

# Workflow evidence
emit_workflow("B03", "DISCHARGE_COMPLETED", patient_id="P100")
```

The dashboard buttons call the same logic via the HTTP API (`/api/sim/*`).
