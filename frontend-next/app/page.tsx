"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { api } from "@/lib/api";
import type { CapacitySummary, DigitalTwin, WaitingPatient, Metrics, BedEvent } from "@/lib/types";
import { CapacityCards } from "@/components/CapacityCards";
import { BedsTable } from "@/components/BedsTable";
import { ReviewQueue } from "@/components/ReviewQueue";
import { MetricsPanel } from "@/components/MetricsPanel";
import { BedDetail } from "@/components/BedDetail";
import { ReviewModal } from "@/components/ReviewModal";
import { ActivityLog, type LogEntry } from "@/components/ActivityLog";
import { GuidedDemo } from "@/components/GuidedDemo";
import { Bed, User, AlertTriangle, Lock, Ban } from "lucide-react";

function sleep(ms: number) {
  return new Promise((r) => setTimeout(r, ms));
}

const WardMap = ({ beds, onBedClick }: { beds: DigitalTwin[], onBedClick: (id: string) => void }) => {
  const wards = Array.from(new Set(beds.map(b => b.ward))).sort();
  const getIcon = (state: string) => {
    switch(state) {
      case 'CONFIRMED_AVAILABLE': return <Bed size={22} strokeWidth={2.5} />;
      case 'OCCUPIED': return <User size={22} strokeWidth={2.5} />;
      case 'UNKNOWN': return <AlertTriangle size={22} strokeWidth={2.5} />;
      case 'RESERVED': return <Lock size={22} strokeWidth={2.5} />;
      case 'BLOCKED': return <Ban size={22} strokeWidth={2.5} />;
      default: return <Bed size={22} />;
    }
  };
  return (
    <div className="ward-map-container">
      {wards.map(w => {
        const wardBeds = beds.filter(b => b.ward === w).sort((a,b) => a.bedId.localeCompare(b.bedId));
        const total = wardBeds.length;
        const occupied = wardBeds.filter(b => b.reconciledState === 'OCCUPIED').length;
        const occPct = total > 0 ? Math.round((occupied / total) * 100) : 0;
        return (
          <div key={w} className="ward-section">
            <div className="ward-section-header">
              <span>{w} Ward</span>
              <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                <div style={{ fontSize: '0.75rem', color: 'var(--muted)', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em' }}>
                  {occPct}% Occupied
                </div>
                <div style={{ width: '80px', height: '6px', background: 'var(--border)', borderRadius: '3px', overflow: 'hidden' }}>
                  <div style={{ width: `${occPct}%`, height: '100%', background: occPct > 85 ? 'var(--red)' : occPct > 70 ? 'var(--amber)' : 'var(--green)' }}></div>
                </div>
                <div style={{ fontSize: '0.8rem', color: 'var(--faint)', fontWeight: 500 }}>
                  {total} Beds
                </div>
              </div>
            </div>
            <div className="ward-grid">
              {wardBeds.map(bed => (
                <div key={bed.bedId} className={`bed-seat ${bed.reconciledState}`} onClick={() => onBedClick(bed.bedId)} title={`Bed ${bed.bedId} - ${bed.reconciledState}`}>
                  <div className="bed-seat-icon" style={{ display: 'flex', marginBottom: '4px' }}>{getIcon(bed.reconciledState)}</div>
                  <div className="bed-seat-id">{bed.bedId}</div>
                </div>
              ))}
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default function DashboardPage() {
  const [capacity, setCapacity] = useState<CapacitySummary | null>(null);
  const [beds, setBeds] = useState<DigitalTwin[]>([]);
  const [waiting, setWaiting] = useState<WaitingPatient[]>([]);
  const [reviewCases, setReviewCases] = useState<DigitalTwin[]>([]);
  const [metrics, setMetrics] = useState<Metrics | null>(null);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [detailBed, setDetailBed] = useState<DigitalTwin | null>(null);
  const [detailEvents, setDetailEvents] = useState<BedEvent[]>([]);
  const [reviewTarget, setReviewTarget] = useState<DigitalTwin | null>(null);
  const [online, setOnline] = useState(true);
  const [busy, setBusy] = useState(false);
  const [demoStep, setDemoStep] = useState(0);
  const [demoRunning, setDemoRunning] = useState(false);
  const [logs, setLogs] = useState<LogEntry[]>([]);
  const logsRef = useRef<LogEntry[]>([]);
  const [section, setSection] = useState<"overview" | "map" | "beds" | "patients" | "reviews" | "demo" | "metrics" | "processes">("overview");
  const [addBedModal, setAddBedModal] = useState(false);
  const [addPatientModal, setAddPatientModal] = useState(false);
  const [editPatientTarget, setEditPatientTarget] = useState<WaitingPatient | null>(null);

  const pushLog = useCallback((level: LogEntry["level"], message: string) => {
    const entry: LogEntry = { ts: Date.now() / 1000, level, message };
    logsRef.current = [...logsRef.current.slice(-80), entry];
    setLogs([...logsRef.current]);
  }, []);

  const refresh = useCallback(async () => {
    try {
      const [cap, bedsRes, waitRes, revRes, met] = await Promise.all([
        api.capacity(), api.beds(), api.waiting(), api.review(), api.metrics(),
      ]);
      setCapacity(cap); setBeds(bedsRes.beds); setWaiting(waitRes.patients);
      setReviewCases(revRes.cases); setMetrics(met); setOnline(true);
      if (selectedId) {
        const d = await api.bed(selectedId);
        setDetailBed(d.bed); setDetailEvents(d.events);
      }
    } catch { setOnline(false); }
  }, [selectedId]);

  useEffect(() => {
    refresh();
    const t = setInterval(refresh, 1200);
    return () => clearInterval(t);
  }, [refresh]);

  const openDetail = async (id: string) => {
    setSelectedId(id);
    const d = await api.bed(id);
    setDetailBed(d.bed); setDetailEvents(d.events);
  };
  const closeDetail = () => { setSelectedId(null); setDetailBed(null); setDetailEvents([]); };
  const openReview = async (id: string) => {
    const d = await api.bed(id);
    setReviewTarget(d.bed);
  };
  const submitReview = async (payload: {
    action: "CONFIRM_AVAILABLE" | "CONFIRM_OCCUPIED" | "KEEP_BLOCKED";
    user: string; reason: string;
  }) => {
    if (!reviewTarget) return;
    await api.reviewAction({ bedId: reviewTarget.bedId, ...payload });
    pushLog("success", `Human ${payload.action} on ${reviewTarget.bedId} by ${payload.user}`);
    setReviewTarget(null); refresh();
  };

  const tryAllocate = async (patientId: string) => {
    const free = beds.find((b) => b.reconciledState === "CONFIRMED_AVAILABLE" && b.leaseValid);
    if (!free) {
      pushLog("error", `Allocation blocked for ${patientId}: no CONFIRMED_AVAILABLE + valid lease`);
      alert("Allocation BLOCKED.\nUNKNOWN is never treated as available.");
      return;
    }
    try {
      const res = await api.allocate(free.bedId, patientId);
      if (res.success) {
        pushLog("success", `Reserved ${free.bedId} → ${patientId}`);
        alert(`Reserved ${free.bedId} for ${patientId}`);
      } else {
        pushLog("error", `Blocked: ${res.reason}`);
        alert("Blocked: " + res.reason);
      }
    } catch (e: unknown) {
      pushLog("error", String(e));
    }
    refresh();
  };

  const handleAddBed = () => setAddBedModal(true);

  const handleRemoveBed = async (bedId: string) => {
    if (!confirm(`Are you sure you want to remove bed ${bedId}?`)) return;
    try {
      await api.removeBed(bedId);
      pushLog("success", `Removed bed ${bedId}`);
      if (selectedId === bedId) closeDetail();
      refresh();
    } catch (e: any) {
      alert("Failed to remove bed: " + e.message);
    }
  };

  const handleAddPatient = () => setAddPatientModal(true);
  const handleEditPatient = (p: WaitingPatient) => setEditPatientTarget(p);

  const handleRemovePatient = async (pId: string) => {
    if (!confirm(`Remove patient ${pId} from waiting list?`)) return;
    try {
      await api.removePatient(pId);
      pushLog("success", `Removed patient ${pId}`);
      refresh();
    } catch (e: any) {
      alert("Failed to remove patient: " + e.message);
    }
  };

  const runGuidedDemo = async () => {
    if (demoRunning) return;
    setDemoRunning(true); setBusy(true); setSection("demo");
    logsRef.current = []; setLogs([]); setDemoStep(0);
    try {
      pushLog("system", "═══ Guided pipeline started ═══");
      pushLog("info", "Rule: NEVER guess. UNKNOWN = NOT ALLOCATABLE.");
      setDemoStep(1);
      pushLog("system", "Step 1 — High-demand seed");
      await api.seed(10, 4); await api.highDemand(); await refresh(); await sleep(1400);
      setDemoStep(2); pushLog("warn", "Step 2 — Admin drift: bed reported AVAILABLE"); await sleep(1100);
      setDemoStep(3); pushLog("warn", "Step 3 — Source conflict (A OCCUPIED / B AVAILABLE)"); await sleep(1100);
      setDemoStep(4); pushLog("error", "Step 4 — Reconciled → UNKNOWN; removed from capacity"); await openDetail("B09"); await refresh(); await sleep(1400);
      setDemoStep(5); pushLog("error", "Step 5 — Allocate attempt on UNKNOWN…");
      try {
        const res = await api.allocate("B09", "WP001");
        pushLog(res.success ? "error" : "success", res.success ? "Unexpected success" : `✓ Gate blocked: ${res.reason}`);
      } catch (e: unknown) { pushLog("success", `✓ Gate blocked: ${String(e)}`); }
      await sleep(1200);
      setDemoStep(6); pushLog("info", "Step 6 — Fresh confirmations"); try { await api.fresh("B09"); } catch {} await sleep(900);
      setDemoStep(7); pushLog("system", "Step 7 — Out-of-order event via eventTime"); await sleep(900);
      setDemoStep(8); pushLog("success", "Step 8 — Stale ignored; newer state kept"); await openDetail("B09"); await sleep(1000);
      setDemoStep(9); pushLog("info", "Step 9 — Reconciliation inside 5s bound"); await sleep(1800); await refresh();
      setDemoStep(10);
      const bed = (await api.bed("B09")).bed;
      pushLog("info", `Step 10 — B09 = ${bed.reconciledState} (${bed.unknownReason})`);
      await sleep(1000);
      setDemoStep(11); pushLog("info", "Step 11 — Only CONFIRMED_AVAILABLE + lease reserves"); await sleep(700);
      setDemoStep(12); pushLog("info", "Step 12 — Admin corrected when evidence is OCCUPIED"); await sleep(700);
      setDemoStep(13); await refresh();
      const rev = await api.review();
      pushLog(rev.cases.length ? "warn" : "success",
        rev.cases.length ? `Step 13 — ${rev.cases.length} in Human Review` : "Step 13 — Auto-resolved within bound");
      await sleep(900);
      setDemoStep(14); pushLog("system", "Step 14 — Human Confirm Available / Occupied / Keep Blocked");
      pushLog("success", "═══ Pipeline complete ═══");
      setDemoStep(15); await refresh();
    } catch (e: unknown) { pushLog("error", `Walkthrough error: ${String(e)}`); }
    finally { setDemoRunning(false); setBusy(false); }
  };

  const resetWorld = async () => {
    setBusy(true);
    try {
      await api.seed(10, 4); setDemoStep(0); logsRef.current = []; setLogs([]);
      pushLog("system", "World reset"); await refresh();
    } finally { setBusy(false); }
  };

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="brand">
          <div className="brand-mark">BT</div>
          <div>
            <h1>BedTrust<span>+</span></h1>
            <small>Command Center</small>
          </div>
        </div>
        <button className={`nav-item ${section === "overview" ? "active" : ""}`} onClick={() => setSection("overview")}>
          Dashboard Overview
        </button>
        <button className={`nav-item ${section === "map" ? "active" : ""}`} onClick={() => setSection("map")}>
          Live Ward Map
        </button>
        <button className={`nav-item ${section === "beds" ? "active" : ""}`} onClick={() => setSection("beds")}>
          Bed Management
        </button>
        <button className={`nav-item ${section === "patients" ? "active" : ""}`} onClick={() => setSection("patients")}>
          Patient Management
        </button>
        <button className={`nav-item ${section === "reviews" ? "active" : ""}`} onClick={() => setSection("reviews")}>
          Human Review Queue
        </button>
        <button className={`nav-item ${section === "demo" ? "active" : ""}`} onClick={() => setSection("demo")}>
          Automated Walkthrough
        </button>
        <button className={`nav-item ${section === "processes" ? "active" : ""}`} onClick={() => setSection("processes")}>
          Safety Processes
        </button>
        <button className={`nav-item ${section === "metrics" ? "active" : ""}`} onClick={() => setSection("metrics")}>
          Safety Metrics
        </button>
        <div className="sidebar-footer">
          Operator dashboard<br />
          UNKNOWN is not available
        </div>
      </aside>

      <div className="main-area">
        <header className="topbar">
          <div className="topbar-title">
            {section === "overview" && "Dashboard Overview"}
            {section === "map" && "Live Ward Map"}
            {section === "beds" && "Bed Management"}
            {section === "patients" && "Patient Management"}
            {section === "reviews" && "Human Review Queue"}
            {section === "demo" && "Automated Walkthrough"}
            {section === "processes" && "Individual Safety Processes"}
            {section === "metrics" && "Safety metrics"}
            <span>bed-state reconciliation</span>
          </div>
          <div className="topbar-actions">
            <span className={`badge ${online ? "badge-live" : "badge-offline"}`}>
              {online ? "● LIVE" : "● OFFLINE"}
            </span>
            {capacity?.capacityCrunch && (
              <span className="badge badge-crunch">⚠ CAPACITY CRUNCH</span>
            )}
          </div>
        </header>

        <div className="content">
          <div className="info-banner">
            <strong>How the gate works</strong>
            <ol>
              <li>Events are ordered by <code>eventTime</code> — never by network arrival.</li>
              <li>Sources disagree → bed becomes <strong>UNKNOWN</strong> and leaves usable capacity.</li>
              <li><strong>UNKNOWN = NOT ALLOCATABLE.</strong> Only <code>CONFIRMED_AVAILABLE</code> + valid lease passes.</li>
              <li>Lease expiry returns the bed to UNKNOWN until re-confirmed.</li>
              <li>Unresolved inside the 5s bound → Human Review (never auto-available on timeout).</li>
            </ol>
          </div>

          {capacity?.capacityCrunch && (
            <div className="warn-banner">
              High demand — only CONFIRMED_AVAILABLE beds are usable. UNKNOWN stays blocked.
            </div>
          )}

          {section === "demo" && (
            <div className="grid-2">
              <GuidedDemo currentStep={demoStep} running={demoRunning} onStart={runGuidedDemo} onReset={resetWorld} />
              <ActivityLog entries={logs} />
            </div>
          )}

          {section === "processes" && (
            <div style={{ display: "flex", flexDirection: "column", gap: "16px" }}>
              <div className="card">
                <div className="card-header">
                  <div className="card-title accent">Safety Processes</div>
                  <span className="sub">Trigger and observe core system behaviors</span>
                </div>
                <div style={{ display: "flex", flexDirection: "column", gap: "16px", marginTop: "16px" }}>
                  <div style={{ paddingBottom: "16px", borderBottom: "1px solid var(--border)" }}>
                    <div className="step-body" style={{ width: "100%" }}>
                      <h4 style={{ marginBottom: "6px" }}>1. Level 1 - Touchless</h4>
                      <p style={{ marginBottom: "12px" }}>All sources agree and are fresh. Normal bed-state transitions happen automatically.</p>
                      <button disabled={busy} onClick={async () => {
                        pushLog("system", "Triggering Level 1 on B05...");
                        try {
                          await api.level1("B05");
                          pushLog("info", "B05 should transition normally.");
                        } catch(e: any) {
                          pushLog("error", `Failed: ${e.message}`);
                        }
                        await refresh();
                        openDetail("B05");
                      }}>Trigger Level 1</button>
                    </div>
                  </div>
                  
                  <div style={{ paddingBottom: "16px", borderBottom: "1px solid var(--border)" }}>
                    <div className="step-body" style={{ width: "100%" }}>
                      <h4 style={{ marginBottom: "6px" }}>2. Level 2 - Auto-Recovery</h4>
                      <p style={{ marginBottom: "12px" }}>Temporary mismatch. The system places the bed in UNKNOWN, waits for the settling window, and auto-recovers when a delayed workflow event arrives.</p>
                      <button disabled={busy} onClick={async () => {
                        pushLog("system", "Triggering Level 2 on B05...");
                        try {
                          await api.level2("B05");
                          pushLog("info", "Mismatch injected. Wait a few seconds for Auto-Recovery.");
                        } catch(e: any) {
                          pushLog("error", `Failed: ${e.message}`);
                        }
                        await refresh();
                        openDetail("B05");
                      }}>Trigger Level 2</button>
                    </div>
                  </div>

                  <div style={{ paddingBottom: "16px", borderBottom: "1px solid var(--border)" }}>
                    <div className="step-body" style={{ width: "100%" }}>
                      <h4 style={{ marginBottom: "6px" }}>3. Level 3 - Human Exception</h4>
                      <p style={{ marginBottom: "12px" }}>Automation fails. Unresolved conflict exceeds the settling window and requires human review.</p>
                      <button disabled={busy} onClick={async () => {
                        pushLog("system", "Triggering Level 3 on B05...");
                        try {
                          await api.level3("B05");
                          pushLog("warn", "Bed is now UNKNOWN and will escalate to manual review queue.");
                        } catch(e: any) {
                          pushLog("error", `Failed: ${e.message}`);
                        }
                        await refresh();
                        openDetail("B05");
                      }}>Trigger Level 3</button>
                    </div>
                  </div>

                  <div style={{ paddingBottom: "16px", borderBottom: "1px solid var(--border)" }}>
                    <div className="step-body" style={{ width: "100%" }}>
                      <h4 style={{ marginBottom: "6px" }}>4. Grouped Source Outage</h4>
                      <p style={{ marginBottom: "12px" }}>A source goes offline. The Exception Manager groups the affected beds into a single incident to prevent notification fatigue.</p>
                      <button disabled={busy} onClick={async () => {
                        pushLog("system", "Simulating EVS feed delay...");
                        try {
                          await api.groupedOutage();
                          pushLog("warn", "Grouped outage detected. Check the human review queue for grouped items (or lack thereof!).");
                        } catch(e: any) {
                          pushLog("error", `Failed: ${e.message}`);
                        }
                        await refresh();
                      }}>Trigger Source Outage</button>
                    </div>
                  </div>

                  <div style={{ paddingBottom: "16px" }}>
                    <div className="step-body" style={{ width: "100%" }}>
                      <h4 style={{ marginBottom: "6px" }}>4. Double-Booking Prevention</h4>
                      <p style={{ marginBottom: "12px" }}>Attempt to allocate a patient to a bed that is not CONFIRMED_AVAILABLE.</p>
                      <button disabled={busy} onClick={async () => {
                        pushLog("system", "Attempting unsafe allocation on B05...");
                        try {
                           const res = await api.allocate("B05", "WP-TEST");
                           pushLog(res.success ? "error" : "success", res.success ? "Failed: Allocated unsafe bed!" : `Blocked: ${res.reason}`);
                        } catch(e: any) {
                           pushLog("success", `Blocked by Safe Allocation Gate: ${e.message}`);
                        }
                        await refresh();
                      }}>Trigger Allocation Block</button>
                    </div>
                  </div>
                </div>
              </div>
              <ActivityLog entries={logs} />
            </div>
          )}

          {/* MAP SECTION */}
          {section === "map" && (
            <WardMap beds={beds} onBedClick={openDetail} />
          )}

          {/* OVERVIEW SECTION */}
          {section === "overview" && (
            <div className="grid-2">
              <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
                <CapacityCards data={capacity} />
                <div className="card">
                  <div className="card-header"><div className="card-title">Quick actions</div></div>
                  <div className="btn-row">
                    <button className="warn" disabled={busy || demoRunning}
                      onClick={async () => {
                        pushLog("warn", "Inject SOURCE_CONFLICT on B05");
                        await api.conflict("B05"); refresh();
                      }}>Inject conflict</button>
                    <button className="secondary" disabled={busy || demoRunning}
                      onClick={async () => { await api.reconcile(); pushLog("info", "Forced reconcile"); refresh(); }}>
                      Force reconcile
                    </button>
                    <button className="secondary" disabled={busy || demoRunning} onClick={resetWorld}>
                      Reset / seed
                    </button>
                  </div>
                </div>
              </div>
              <ActivityLog entries={logs} />
            </div>
          )}

          {/* BEDS SECTION */}
          {section === "beds" && (
            <div className="grid-2">
              <div>
                <div className="card" style={{ marginBottom: 16 }}>
                  <div className="card-header">
                    <div className="card-title">Bed Management</div>
                    <span className="sub">{capacity?.totalBeds ?? 0} beds total</span>
                  </div>
                  <div className="btn-row" style={{ padding: '0 16px 16px 16px' }}>
                    <button className="success" onClick={handleAddBed}>+ Add Bed</button>
                  </div>
                  <BedsTable beds={beds} onSelect={openDetail} />
                </div>
              </div>
              <div>
                {detailBed ? (
                  <BedDetail
                    bed={detailBed}
                    events={detailEvents}
                    onClose={closeDetail}
                    onFresh={async (id) => { await api.fresh(id); pushLog("info", `Fresh request ${id}`); refresh(); }}
                    onReview={openReview}
                  />
                ) : (
                  <div className="card">
                    <div className="card-header"><div className="card-title">Bed Details</div></div>
                    <div style={{ padding: '16px', color: 'var(--text-muted)' }}>Select a bed to view details or remove it.</div>
                  </div>
                )}
                {detailBed && (
                  <div className="card" style={{ marginTop: 16 }}>
                    <div className="card-header"><div className="card-title warn-text">Danger Zone</div></div>
                    <div style={{ padding: 16 }}>
                      <button className="warn" onClick={() => handleRemoveBed(detailBed.bedId)}>Remove Bed {detailBed.bedId}</button>
                    </div>
                  </div>
                )}
              </div>
            </div>
          )}

          {/* PATIENTS SECTION */}
          {section === "patients" && (
            <div className="card" style={{ marginBottom: 16 }}>
              <div className="card-header">
                <div className="card-title">Patient Management</div>
              </div>
              <div className="btn-row" style={{ padding: '0 16px 16px 16px' }}>
                <button className="success" onClick={handleAddPatient}>+ Add Patient</button>
              </div>
              <p className="sub" style={{ padding: '0 16px', marginBottom: 8 }}>
                Assign only when a bed is CONFIRMED_AVAILABLE with a valid lease.
              </p>
              <table>
                <thead>
                  <tr><th>ID</th><th>Name</th><th>Priority</th><th>Ward</th><th>Actions</th></tr>
                </thead>
                <tbody>
                  {waiting.filter((p) => !p.assignedBed).map((p) => (
                    <tr key={p.patientId}>
                      <td>{p.patientId}</td>
                      <td>{p.name}</td>
                      <td>
                        <span className={`badge ${
                          p.priority === "ICU" || p.priority === "EMERGENCY" ? "badge-p1" : "badge-p3"
                        }`}>{p.priority}</span>
                      </td>
                      <td>{p.requestedWard}</td>
                      <td>
                        <div style={{ display: 'flex', gap: '8px' }}>
                          <button style={{ padding: "4px 10px", fontSize: "0.75rem" }} className="success"
                            onClick={() => tryAllocate(p.patientId)} disabled={busy || demoRunning}>
                            Assign Bed
                          </button>
                          <button style={{ padding: "4px 10px", fontSize: "0.75rem" }} className="secondary"
                            onClick={() => handleEditPatient(p)} disabled={busy || demoRunning}>
                            Edit
                          </button>
                          <button style={{ padding: "4px 10px", fontSize: "0.75rem" }} className="warn"
                            onClick={() => handleRemovePatient(p.patientId)} disabled={busy || demoRunning}>
                            Remove
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                  {waiting.filter((p) => !p.assignedBed).length === 0 && (
                    <tr><td colSpan={5} className="sub">No waiting patients</td></tr>
                  )}
                </tbody>
              </table>
            </div>
          )}

          {/* REVIEWS SECTION */}
          {section === "reviews" && (
            <div className="grid-2">
              <ReviewQueue cases={reviewCases} onReview={openReview} />
              <ActivityLog entries={logs} />
            </div>
          )}

          {section === "metrics" && (
            <div className="grid-2">
              <MetricsPanel metrics={metrics} />
              <ActivityLog entries={logs} />
            </div>
          )}
        </div>
      </div>

      {reviewTarget && (
        <ReviewModal bed={reviewTarget} onClose={() => setReviewTarget(null)} onSubmit={submitReview} />
      )}

      {addBedModal && (
        <div className="modal-bg">
          <div className="modal">
            <h3>Add New Bed</h3>
            <form onSubmit={async (e) => {
              e.preventDefault();
              const fd = new FormData(e.currentTarget);
              const bedId = (fd.get("bedId") as string).toUpperCase();
              const ward = (fd.get("ward") as string).toUpperCase();
              if (!bedId) return;
              try {
                await api.addBed(bedId, ward);
                pushLog("success", `Added bed ${bedId} in ${ward}`);
                refresh();
                setAddBedModal(false);
              } catch (err: any) { alert("Failed to add bed: " + err.message); }
            }}>
              <label>Bed ID (e.g., NEW-B01)</label>
              <input name="bedId" required autoFocus />
              <label>Ward</label>
              <select name="ward">
                <option value="GENERAL">GENERAL</option>
                <option value="ICU">ICU</option>
                <option value="EMERGENCY">EMERGENCY</option>
                <option value="PEDIATRICS">PEDIATRICS</option>
              </select>
              <div className="btn-row" style={{ marginTop: 16, justifyContent: "flex-end" }}>
                <button type="button" className="ghost" onClick={() => setAddBedModal(false)}>Cancel</button>
                <button type="submit" className="success">Save Bed</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {(addPatientModal || editPatientTarget) && (
        <div className="modal-bg">
          <div className="modal">
            <h3>{editPatientTarget ? "Edit Patient" : "Add Patient"}</h3>
            <form onSubmit={async (e) => {
              e.preventDefault();
              const fd = new FormData(e.currentTarget);
              const patientId = (fd.get("patientId") as string);
              const name = (fd.get("name") as string);
              const priority = (fd.get("priority") as string);
              const ward = (fd.get("ward") as string);
              try {
                await api.updatePatient(patientId, name, priority, ward);
                pushLog("success", `${editPatientTarget ? "Updated" : "Added"} patient ${patientId}`);
                refresh();
                setAddPatientModal(false);
                setEditPatientTarget(null);
              } catch (err: any) { alert("Failed: " + err.message); }
            }}>
              <label>Patient ID</label>
              <input name="patientId" required defaultValue={editPatientTarget?.patientId || ""} readOnly={!!editPatientTarget} autoFocus={!editPatientTarget} />
              <label>Name</label>
              <input name="name" required defaultValue={editPatientTarget?.name || ""} autoFocus={!!editPatientTarget} />
              <label>Priority</label>
              <select name="priority" defaultValue={editPatientTarget?.priority || "NORMAL"}>
                <option value="NORMAL">NORMAL</option>
                <option value="EMERGENCY">EMERGENCY</option>
                <option value="ICU">ICU</option>
              </select>
              <label>Requested Ward</label>
              <select name="ward" defaultValue={editPatientTarget?.requestedWard || "GENERAL"}>
                <option value="GENERAL">GENERAL</option>
                <option value="ICU">ICU</option>
                <option value="EMERGENCY">EMERGENCY</option>
                <option value="PEDIATRICS">PEDIATRICS</option>
              </select>
              <div className="btn-row" style={{ marginTop: 16, justifyContent: "flex-end" }}>
                <button type="button" className="ghost" onClick={() => { setAddPatientModal(false); setEditPatientTarget(null); }}>Cancel</button>
                <button type="submit" className="success">Save Patient</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
