"use client";

import { useState } from "react";
import type { DigitalTwin } from "@/lib/types";

export function ReviewModal({
  bed,
  onClose,
  onSubmit,
}: {
  bed: DigitalTwin;
  onClose: () => void;
  onSubmit: (payload: {
    action: "CONFIRM_AVAILABLE" | "CONFIRM_OCCUPIED" | "KEEP_BLOCKED";
    user: string;
    reason: string;
  }) => void;
}) {
  const [action, setAction] = useState<
    "CONFIRM_AVAILABLE" | "CONFIRM_OCCUPIED" | "KEEP_BLOCKED"
  >("CONFIRM_AVAILABLE");
  const [user, setUser] = useState("dr.chen");
  const [reason, setReason] = useState("");

  return (
    <div className="modal-bg">
      <div className="modal">
        <h3>Manual Review Required</h3>
        <p className="sub">
          System could not safely resolve {bed.bedId} within the reconciliation
          bound.
        </p>
        <div className="detail-grid">
          <div>
            <div className="label">Admissions (EHR)</div>
            {bed.adminState}
          </div>
          <div>
            <div className="label">EVS</div>
            {bed.sourceAState}
          </div>
          <div>
            <div className="label">Nurse</div>
            {bed.sourceBState}
          </div>
          <div>
            <div className="label">Reason</div>
            {bed.unknownReason}
          </div>
          <div>
            <div className="label">Retries</div>
            {bed.autoRetries}
          </div>
          <div>
            <div className="label">Workflow</div>
            {bed.activePatientId
              ? `Active patient ${bed.activePatientId}`
              : "None"}
          </div>
        </div>

        {bed.systemRecommendation && (
          <div style={{ marginTop: "16px", padding: "12px", backgroundColor: "var(--bg-light)", borderRadius: "4px", borderLeft: "4px solid var(--accent)" }}>
            <h4 style={{ margin: "0 0 8px 0" }}>System Recommendation: {bed.systemRecommendation}</h4>
            <p style={{ margin: 0, fontSize: "0.9rem", color: "var(--text-muted)" }}>{bed.recommendationReason}</p>
          </div>
        )}

        <label style={{ marginTop: "16px", display: "block" }}>Action</label>
        <div style={{ display: "flex", gap: "8px", flexWrap: "wrap", marginBottom: "16px" }}>
          <button 
            className="success"
            onClick={() => onSubmit({ action: "CONFIRM_AVAILABLE", user: "auto-reviewer", reason: bed.recommendationReason || "Manual override" })}
          >
            Confirm Available
          </button>
          <button 
            className="secondary"
            onClick={() => onSubmit({ action: "CONFIRM_OCCUPIED", user: "auto-reviewer", reason: bed.recommendationReason || "Manual override" })}
          >
            Confirm Occupied
          </button>
          <button 
            className="warning"
            onClick={() => onSubmit({ action: "KEEP_BLOCKED", user: "auto-reviewer", reason: "Safety hold" })}
          >
            Keep Blocked
          </button>
        </div>

        <details>
          <summary style={{ cursor: "pointer", color: "var(--text-muted)", fontSize: "0.9rem" }}>Technical Details / Advanced Override</summary>
          <div style={{ marginTop: "8px", display: "flex", flexDirection: "column", gap: "8px" }}>
            <label>Action</label>
            <select
              value={action}
              onChange={(e) =>
                setAction(
                  e.target.value as
                    | "CONFIRM_AVAILABLE"
                    | "CONFIRM_OCCUPIED"
                    | "KEEP_BLOCKED"
                )
              }
            >
              <option value="CONFIRM_AVAILABLE">Confirm Available</option>
              <option value="CONFIRM_OCCUPIED">Confirm Occupied</option>
              <option value="KEEP_BLOCKED">Keep Blocked</option>
            </select>
            <label>Authorized User</label>
            <input value={user} onChange={(e) => setUser(e.target.value)} />
            <label>Reason / Comment</label>
            <textarea
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              placeholder="Explain decision…"
            />
            <div className="btn-row">
              <button
                className="success"
                onClick={() => {
                  if (!reason.trim()) {
                    alert("Reason is required");
                    return;
                  }
                  onSubmit({ action, user, reason });
                }}
              >
                Submit Override
              </button>
            </div>
          </div>
        </details>
        
        <div className="btn-row" style={{ marginTop: "16px" }}>
          <button className="secondary" onClick={onClose} style={{ width: "100%" }}>
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
}
