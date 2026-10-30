"use client";

import type { DigitalTwin, BedEvent } from "@/lib/types";
import { StateBadge } from "./StateBadge";

function fmtTime(ts: number) {
  if (!ts) return "–";
  return new Date(ts * 1000).toLocaleTimeString();
}

export function BedDetail({
  bed,
  events,
  onClose,
  onFresh,
  onReview,
}: {
  bed: DigitalTwin;
  events: BedEvent[];
  onClose: () => void;
  onFresh: (id: string) => void;
  onReview: (id: string) => void;
}) {
  const leaseRem = bed.leaseRemainingSec
    ? `${bed.leaseRemainingSec.toFixed(1)}s`
    : "–";
  const reconRem = bed.reconRemainingSec
    ? `${bed.reconRemainingSec.toFixed(1)}s`
    : "–";

  return (
    <div className="card" style={{ marginTop: 16 }}>
      <div className="panel-title">
        <h2 style={{ margin: 0 }}>
          Bed {bed.bedId} · {bed.ward}
        </h2>
        <button className="secondary" onClick={onClose}>
          Close
        </button>
      </div>
      <div className="detail-grid">
        <div>
          <div className="label">Reconciled State</div>
          <StateBadge state={bed.reconciledState} />
        </div>
        <div>
          <div className="label">Unknown Reason</div>
          {bed.unknownReason}
        </div>
        <div>
          <div className="label">Admissions Desk (EHR)</div>
          {bed.adminState}{" "}
          <span className="sub">@ {fmtTime(bed.adminUpdateTime)}</span>
        </div>
        <div>
          <div className="label">EVS (Cleaning Team)</div>
          {bed.sourceAState}{" "}
          <span className="sub">@ {fmtTime(bed.sourceAEventTime)}</span>
        </div>
        <div>
          <div className="label">Ward Nurse</div>
          {bed.sourceBState}{" "}
          <span className="sub">@ {fmtTime(bed.sourceBEventTime)}</span>
        </div>
        <div>
          <div className="label">Confidence</div>
          {bed.confidence}
        </div>
        <div>
          <div className="label">Lease remaining</div>
          {leaseRem}
        </div>
        <div>
          <div className="label">Recon deadline</div>
          {reconRem}
        </div>
        <div>
          <div className="label">Active patient</div>
          {bed.activePatientId || "–"}
        </div>
        <div>
          <div className="label">Reservation</div>
          {bed.reservationStatus} {bed.currentAssignedPatient || ""}
        </div>
        <div>
          <div className="label">Needs human review</div>
          {bed.needsHumanReview ? "YES" : "No"}
        </div>
        <div>
          <div className="label">Auto retries</div>
          {bed.autoRetries}
        </div>
      </div>
      <h2 style={{ margin: "14px 0 8px" }}>Event Timeline</h2>
      <div className="timeline">
        {(events || []).slice(0, 30).map((e) => {
          let sourceLabel = e.source;
          if (sourceLabel === "ADMIN") sourceLabel = "Admissions Desk (EHR)";
          if (sourceLabel === "SOURCE_A") sourceLabel = "EVS (Cleaning Team)";
          if (sourceLabel === "SOURCE_B") sourceLabel = "Ward Nurse";
          
          return (
          <div className="item" key={e.eventId}>
            <strong>{sourceLabel}</strong> → {e.state}
            {e.isStale && (
              <span className="state UNKNOWN"> STALE/OUT-OF-ORDER</span>
            )}
            {e.isDuplicate && (
              <span className="state BLOCKED"> DUPLICATE</span>
            )}
            <div className="meta">
              eventTime {fmtTime(e.eventTime)} · received {fmtTime(e.receivedTime)} ·{" "}
              {e.validationStatus}
            </div>
          </div>
        )})}
        {(!events || events.length === 0) && (
          <div className="sub">No events yet</div>
        )}
      </div>
      <div className="btn-row">
        <button className="secondary" onClick={() => onFresh(bed.bedId)}>
          Request Fresh Confirmations
        </button>
        {bed.needsHumanReview && (
          <button onClick={() => onReview(bed.bedId)}>Open Human Review</button>
        )}
      </div>
    </div>
  );
}
