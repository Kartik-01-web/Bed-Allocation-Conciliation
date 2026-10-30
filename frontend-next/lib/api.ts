const BASE = typeof window !== "undefined" ? "" : "http://localhost:8080";

async function request<T>(path: string, opts?: RequestInit): Promise<T> {
  const res = await fetch(`${BASE}${path}`, {
    headers: { "Content-Type": "application/json", ...(opts?.headers || {}) },
    ...opts,
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ error: res.statusText }));
    throw new Error(err.error || err.reason || res.statusText);
  }
  return res.json();
}

export const api = {
  capacity: () => request<import("./types").CapacitySummary>("/api/capacity"),
  beds: () => request<{ beds: import("./types").DigitalTwin[] }>("/api/beds"),
  bed: (id: string) =>
    request<{ bed: import("./types").DigitalTwin; events: import("./types").BedEvent[] }>(
      `/api/beds/${id}`
    ),
  waiting: () =>
    request<{ patients: import("./types").WaitingPatient[] }>("/api/waiting"),
  review: () =>
    request<{ cases: import("./types").DigitalTwin[] }>("/api/review"),
  metrics: () => request<import("./types").Metrics>("/api/metrics"),
  addBed: (bedId: string, ward: string) =>
    request<{ success: boolean; bedId: string }>("/api/beds/add", {
      method: "POST",
      body: JSON.stringify({ bedId, ward }),
    }),
  removeBed: (bedId: string) =>
    request<{ success: boolean; bedId: string }>("/api/beds/remove", {
      method: "POST",
      body: JSON.stringify({ bedId }),
    }),
  updatePatient: (patientId: string, name: string, priority: string, requestedWard: string) =>
    request<{ success: boolean; patientId: string }>("/api/patients/update", {
      method: "POST",
      body: JSON.stringify({ patientId, name, priority, requestedWard }),
    }),
  removePatient: (patientId: string) =>
    request<{ success: boolean; patientId: string }>("/api/patients/remove", {
      method: "POST",
      body: JSON.stringify({ patientId }),
    }),
  allocate: (bedId: string, patientId: string) =>
    request<{ success: boolean; reason?: string; reservationId?: string }>("/api/allocate", {
      method: "POST",
      body: JSON.stringify({ bedId, patientId }),
    }),
  reviewAction: (payload: {
    bedId: string;
    action: "CONFIRM_AVAILABLE" | "CONFIRM_OCCUPIED" | "KEEP_BLOCKED";
    user: string;
    reason: string;
  }) =>
    request("/api/review/action", {
      method: "POST",
      body: JSON.stringify(payload),
    }),
  highDemand: () =>
    request("/api/sim/high-demand", { method: "POST", body: "{}" }),
  seed: (beds = 10, waiting = 4) =>
    request("/api/sim/seed", {
      method: "POST",
      body: JSON.stringify({ beds, waiting }),
    }),
  conflict: (bedId = "B05") =>
    request("/api/sim/conflict", {
      method: "POST",
      body: JSON.stringify({ bedId }),
    }),
  level1: (bedId = "B05") =>
    request("/api/sim/level1", {
      method: "POST",
      body: JSON.stringify({ bedId }),
    }),
  level2: (bedId = "B05") =>
    request("/api/sim/level2", {
      method: "POST",
      body: JSON.stringify({ bedId }),
    }),
  level3: (bedId = "B05") =>
    request("/api/sim/level3", {
      method: "POST",
      body: JSON.stringify({ bedId }),
    }),
  groupedOutage: () =>
    request("/api/sim/grouped-outage", {
      method: "POST",
      body: "{}",
    }),
  fresh: (bedId: string) =>
    request("/api/sim/fresh", {
      method: "POST",
      body: JSON.stringify({ bedId }),
    }),
  reconcile: () =>
    request("/api/reconcile", { method: "POST", body: "{}" }),
};
