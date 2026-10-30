"use client";
import type { Metrics } from "@/lib/types";

export function MetricsPanel({ metrics }: { metrics: Metrics | null }) {
  if (!metrics) return null;
  const items: [string, string | number, string][] = [
    ["Incorrect allocations prevented", metrics.incorrect_allocations_prevented, "green"],
    ["Source conflicts detected", metrics.source_conflicts_detected, "amber"],
    ["Admin drift detected", metrics.admin_drift_detected, "amber"],
    ["Auto-resolved", metrics.auto_resolved_count, "green"],
    ["Manual reviews", metrics.manual_review_count, "purple"],
    ["Out-of-order handled", metrics.out_of_order_events_handled, "cyan"],
    ["Duplicates ignored", metrics.duplicate_events_ignored, "cyan"],
    ["Stale confirmations", metrics.stale_confirmations_detected, "cyan"],
    ["Double-booking blocked", metrics.double_booking_attempts_prevented, "green"],
    ["Avg recon time", `${(metrics.avg_reconciliation_time || 0).toFixed(2)}s`, "blue"],
    ["% auto resolved", `${(metrics.percentage_resolved_automatically || 0).toFixed(0)}%`, "green"],
    ["Human intervention rate", `${(metrics.human_intervention_rate || 0).toFixed(1)}%`, "amber"],
  ];
  return (
    <div className="card">
      <div className="card-header">
        <div className="card-title">Safety metrics</div>
      </div>
      <div className="metrics-grid">
        {items.map(([lbl, val, color]) => (
          <div className="metric-box" key={lbl}>
            <div className="val" style={{ color: `var(--${color === "cyan" ? "accent" : color})` }}>{val}</div>
            <div className="lbl">{lbl}</div>
          </div>
        ))}
      </div>
    </div>
  );
}
