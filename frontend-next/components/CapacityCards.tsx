"use client";
import type { CapacitySummary } from "@/lib/types";

export function CapacityCards({ data }: { data: CapacitySummary | null }) {
  const c = data?.counts;
  const items = [
    { label: "Confirmed Available", value: c?.CONFIRMED_AVAILABLE ?? "–", sub: "Safe to allocate", cls: "green" },
    { label: "Occupied", value: c?.OCCUPIED ?? "–", sub: "In use", cls: "red" },
    { label: "Unknown", value: c?.UNKNOWN ?? "–", sub: "Not allocatable", cls: "amber" },
    { label: "Reserved", value: c?.RESERVED ?? "–", sub: "Locked for patient", cls: "blue" },
    { label: "Waiting", value: data?.waitingPatients ?? "–", sub: "Need a safe bed", cls: "purple" },
  ];
  return (
    <section className="kpi-strip">
      {items.map((k) => (
        <div className={`kpi ${k.cls}`} key={k.label}>
          <div className="kpi-label">{k.label}</div>
          <div className="kpi-value" style={{ color: `var(--${k.cls === "blue" ? "blue" : k.cls})` }}>{k.value}</div>
          <div className="kpi-sub">{k.sub}</div>
        </div>
      ))}
    </section>
  );
}
