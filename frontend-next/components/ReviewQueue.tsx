"use client";
import type { DigitalTwin } from "@/lib/types";

export function ReviewQueue({ cases, onReview }: { cases: DigitalTwin[]; onReview: (id: string) => void }) {
  return (
    <div className="card" style={{ marginBottom: 16 }}>
      <div className="card-header">
        <div className="card-title">Human review queue</div>
        <span className="badge badge-p2">{cases.length}</span>
      </div>
      {cases.length === 0 ? (
        <p className="sub">No escalations. Auto-reconciliation is handling normal cases.</p>
      ) : (
        [...cases].sort((a, b) => b.autoRetries - a.autoRetries).map((c) => (
          <div key={c.bedId} className="decision-card">
            <div className="decision-label">Escalation · {c.ward}</div>
            <div className="decision-value">{c.bedId}</div>
            <div className="reasoning">
              {c.unknownReason} · retries {c.autoRetries}
              <br />
              {c.systemRecommendation && <strong style={{color: "var(--accent)"}}>{c.systemRecommendation}</strong>}
            </div>
            <button style={{ marginTop: 10, padding: "6px 12px", fontSize: "0.8rem" }} onClick={() => onReview(c.bedId)}>
              Review decision
            </button>
          </div>
        ))
      )}
    </div>
  );
}
