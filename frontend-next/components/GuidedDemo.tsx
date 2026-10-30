"use client";
import { DEMO_STEPS } from "@/lib/demoSteps";

export function GuidedDemo({
  currentStep, running, onStart, onReset,
}: {
  currentStep: number; running: boolean; onStart: () => void; onReset: () => void;
}) {
  return (
    <div className="card" style={{ marginBottom: 16 }}>
      <div className="card-header">
        <div className="card-title accent">Automated Walkthrough</div>
        <span className="sub">
          {currentStep === 0 ? "Idle" : currentStep > 14 ? "Complete" : `Step ${currentStep} / 14`}
        </span>
      </div>
      <p className="sub" style={{ marginBottom: 12 }}>
        Operator walkthrough of conflict → UNKNOWN → blocked allocation → reconcile / escalate —
        same command-center pattern as a POLARIS dispatch pipeline.
      </p>
      <div className="btn-row" style={{ marginBottom: 16 }}>
        <button disabled={running} onClick={onStart}>
          {running ? "Running pipeline…" : "▶ Run automated walkthrough"}
        </button>
        <button className="secondary" disabled={running} onClick={onReset}>Reset world</button>
      </div>
      <div className="step-chain" style={{ maxHeight: 340, overflowY: "auto" }}>
        {DEMO_STEPS.map((s) => {
          const active = currentStep === s.id;
          const done = currentStep > s.id;
          return (
            <div className="step-item" key={s.id}>
              <div className={`step-dot ${done ? "done" : active ? "active" : ""}`}>
                {done ? "✓" : s.id}
              </div>
              <div className="step-body">
                <h4 style={{ color: active ? "var(--accent)" : done ? "var(--green)" : undefined }}>{s.title}</h4>
                <p>{s.description}</p>
                {(active || done) && s.expect && (
                  <p style={{ color: active ? "var(--accent)" : "var(--green)", marginTop: 2 }}>
                    Look for: {s.expect}
                  </p>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
