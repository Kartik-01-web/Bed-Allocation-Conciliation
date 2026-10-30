"use client";

import type { DigitalTwin } from "@/lib/types";
import { StateBadge } from "./StateBadge";

export function BedsTable({
  beds,
  onSelect,
}: {
  beds: DigitalTwin[];
  onSelect: (id: string) => void;
}) {
  return (
    <div style={{ overflowX: "auto" }}>
      <table>
        <thead>
          <tr>
            <th>Bed</th>
            <th>Ward</th>
            <th>Reconciled</th>
            <th>Admissions (EHR)</th>
            <th>EVS</th>
            <th>Nurse</th>
            <th>Reason</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {beds.map((b) => (
            <tr key={b.bedId}>
              <td>
                <strong>{b.bedId}</strong>
              </td>
              <td>{b.ward}</td>
              <td>
                <StateBadge state={b.reconciledState} />
              </td>
              <td>{b.adminState}</td>
              <td>{b.sourceAState}</td>
              <td>{b.sourceBState}</td>
              <td style={{ fontSize: "0.75rem", color: "var(--muted)" }}>
                {b.unknownReason !== "NONE" ? b.unknownReason : "–"}
              </td>
              <td>
                <button
                  className="secondary"
                  style={{ padding: "4px 8px", fontSize: "0.75rem" }}
                  onClick={() => onSelect(b.bedId)}
                >
                  View
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
