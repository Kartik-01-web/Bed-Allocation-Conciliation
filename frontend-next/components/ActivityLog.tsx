"use client";
export type LogEntry = { ts: number; level: "info" | "warn" | "success" | "error" | "system"; message: string };

export function ActivityLog({ entries }: { entries: LogEntry[] }) {
  const color = (l: string) =>
    l === "success" ? "var(--green)" : l === "warn" ? "var(--amber)" : l === "error" ? "var(--red)" : l === "system" ? "var(--accent)" : "var(--text)";
  return (
    <div className="card" style={{ marginBottom: 16 }}>
      <div className="card-header">
        <div className="card-title">Live decision feed</div>
        <span className="sub">How the gate is deciding</span>
      </div>
      <div className="activity-log">
        {entries.length === 0 && <div className="sub">Waiting for events… run the automated walkthrough.</div>}
        {[...entries].reverse().map((e, i) => (
          <div className="line" key={i} style={{ color: color(e.level) }}>
            <span className="ts">[{new Date(e.ts * 1000).toLocaleTimeString()}]</span> {e.message}
          </div>
        ))}
      </div>
    </div>
  );
}
