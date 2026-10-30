# BedTrust+ Frontend (Next.js + React)

Real-time operational dashboard built with **Next.js 14 (App Router)** and **React 18**, as specified in the original prompt.

## Features

- Live SAFE CAPACITY cards
- Capacity-crunch banner
- Beds table with Admin / Source A / Source B / reconciled state
- Human Review Queue + modal (Confirm Available / Occupied / Keep Blocked)
- Waiting patients + safe allocation attempts
- Safety metrics panel
- Bed detail + event timeline (marks STALE / DUPLICATE)
- Simulation controls (High-Demand Demo, Inject Conflict, Seed, Force Reconcile)

## Prerequisites

- Node.js 18+
- Backend running at `http://localhost:8080` (`python3 backend/server.py`)

## Setup

```bash
cd frontend-next
npm install
npm run dev
```

Open **http://localhost:3000**

API calls are proxied to the Python backend via `next.config.js` rewrites (`/api/*` → `http://localhost:8080/api/*`).

## Scripts

| Command        | Description                |
|----------------|----------------------------|
| `npm run dev`  | Development server (port 3000) |
| `npm run build`| Production build           |
| `npm start`    | Run production server      |

## Architecture

```
app/
  layout.tsx      # Root layout + global CSS
  page.tsx        # Main dashboard (client component)
  globals.css     # Dark operational theme
components/
  CapacityCards.tsx
  BedsTable.tsx
  ReviewQueue.tsx
  MetricsPanel.tsx
  BedDetail.tsx
  ReviewModal.tsx
  StateBadge.tsx
lib/
  api.ts          # Typed fetch client
  types.ts        # Shared TypeScript types
```

The UI never treats UNKNOWN as available. All allocation paths go through the backend Safe Allocation Gate.
