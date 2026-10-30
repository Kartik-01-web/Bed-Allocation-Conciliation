"use client";

export function StateBadge({ state }: { state: string }) {
  const cls = `state ${state || "UNKNOWN"}`;
  return <span className={cls}>{state || "UNKNOWN"}</span>;
}
