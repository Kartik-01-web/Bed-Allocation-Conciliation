-- =============================================================================
-- BedTrust+ IBM DB2 Database Schema
-- =============================================================================
-- Complete DDL for the hospital bed reconciliation system.
-- Uses DB2-specific data types: CLOB for JSON, SMALLINT for booleans,
-- DOUBLE for Unix epoch timestamps.
--
-- Usage:
--   db2 -tvf db2_schema.sql
--   OR run via the migrate_to_db2.py script
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 1. EVENTS TABLE
-- Stores all incoming bed-state events from various sources (ADT, sensors, etc.)
-- ---------------------------------------------------------------------------
CREATE TABLE events (
    eventId             VARCHAR(36)     NOT NULL,
    bedId               VARCHAR(10)     NOT NULL,
    source              VARCHAR(20)     NOT NULL,
    state               VARCHAR(20)     NOT NULL,
    eventTime           DOUBLE          NOT NULL,
    receivedTime        DOUBLE          NOT NULL,
    sequenceNumber      INTEGER         NOT NULL DEFAULT 0,
    sourceLineageId     VARCHAR(100),
    metadata            CLOB(1M),
    processed           SMALLINT        NOT NULL DEFAULT 0,
    isDuplicate         SMALLINT        NOT NULL DEFAULT 0,
    isOutOfOrder        SMALLINT        NOT NULL DEFAULT 0,
    isStale             SMALLINT        NOT NULL DEFAULT 0,
    validationStatus    VARCHAR(20)     DEFAULT 'pending',
    validationNotes     VARCHAR(500),
    CONSTRAINT pk_events PRIMARY KEY (eventId)
);

-- Index: look up events by bed (most common query)
CREATE INDEX idx_events_bedId ON events (bedId);

-- Index: filter by source system
CREATE INDEX idx_events_source ON events (source);

-- Index: time-range queries and ordering
CREATE INDEX idx_events_eventTime ON events (eventTime DESC);

-- Index: find unprocessed events
CREATE INDEX idx_events_processed ON events (processed);

-- Composite: bed + time for efficient per-bed timeline queries
CREATE INDEX idx_events_bed_time ON events (bedId, eventTime DESC);


-- ---------------------------------------------------------------------------
-- 2. DIGITAL_TWINS TABLE (Beds)
-- The reconciled "digital twin" representation of each physical bed.
-- ---------------------------------------------------------------------------
CREATE TABLE digital_twins (
    bedId                       VARCHAR(10)     NOT NULL,
    ward                        VARCHAR(20)     NOT NULL,
    adminState                  VARCHAR(20),
    adminUpdateTime             DOUBLE,
    sourceAState                VARCHAR(20),
    sourceAEventTime            DOUBLE,
    sourceAReceivedTime         DOUBLE,
    sourceASequence             INTEGER         DEFAULT 0,
    sourceBState                VARCHAR(20),
    sourceBEventTime            DOUBLE,
    sourceBReceivedTime         DOUBLE,
    sourceBSequence             INTEGER         DEFAULT 0,
    workflowEvidence            CLOB(1M),
    activePatientId             VARCHAR(36),
    reconciledState             VARCHAR(30),
    lastConfirmedState          VARCHAR(30),
    lastConfirmedTimestamp      DOUBLE,
    unknownReason               VARCHAR(50),
    availabilityLeaseExpiry     DOUBLE,
    reservationStatus           VARCHAR(20),
    currentAssignedPatient      VARCHAR(36),
    reservationId               VARCHAR(36),
    reconciliationDeadline      DOUBLE,
    confidence                  VARCHAR(10),
    sourceLineage               CLOB(1M),
    conflictHistory             CLOB(1M),
    auditHistory                CLOB(1M),
    lastReconciliationAttempt   DOUBLE,
    autoRetries                 INTEGER         DEFAULT 0,
    needsHumanReview            SMALLINT        DEFAULT 0,
    systemRecommendation        VARCHAR(50),
    recommendationReason        VARCHAR(500),
    humanOverrideExpiry         DOUBLE,
    humanOverrideBy             VARCHAR(50),
    humanOverrideReason         VARCHAR(500),
    createdAt                   DOUBLE,
    updatedAt                   DOUBLE,
    CONSTRAINT pk_digital_twins PRIMARY KEY (bedId)
);

-- Index: filter beds by reconciled state (capacity dashboards)
CREATE INDEX idx_twins_reconciledState ON digital_twins (reconciledState);

-- Index: filter beds by ward
CREATE INDEX idx_twins_ward ON digital_twins (ward);

-- Index: find beds needing human review
CREATE INDEX idx_twins_needsReview ON digital_twins (needsHumanReview);

-- Index: reservation lookups
CREATE INDEX idx_twins_reservationStatus ON digital_twins (reservationStatus);

-- Index: confidence-based queries
CREATE INDEX idx_twins_confidence ON digital_twins (confidence);


-- ---------------------------------------------------------------------------
-- 3. AUDIT_LOG TABLE
-- Immutable audit trail of all system actions and state changes.
-- ---------------------------------------------------------------------------
CREATE TABLE audit_log (
    id      VARCHAR(36)     NOT NULL,
    ts      DOUBLE          NOT NULL,
    type    VARCHAR(50)     NOT NULL,
    data    CLOB(2M),
    CONSTRAINT pk_audit_log PRIMARY KEY (id)
);

-- Index: time-ordered retrieval
CREATE INDEX idx_audit_ts ON audit_log (ts DESC);

-- Index: filter by audit event type
CREATE INDEX idx_audit_type ON audit_log (type);


-- ---------------------------------------------------------------------------
-- 4. WAITING_PATIENTS TABLE
-- Patients waiting for bed assignment.
-- ---------------------------------------------------------------------------
CREATE TABLE waiting_patients (
    patientId       VARCHAR(36)     NOT NULL,
    name            VARCHAR(100)    NOT NULL,
    priority        VARCHAR(20)     NOT NULL DEFAULT 'normal',
    requestedWard   VARCHAR(20),
    arrivedAt       DOUBLE          NOT NULL,
    assignedBed     VARCHAR(10),
    CONSTRAINT pk_waiting_patients PRIMARY KEY (patientId)
);

-- Index: find unassigned patients (assignedBed IS NULL)
CREATE INDEX idx_waiting_assignedBed ON waiting_patients (assignedBed);

-- Index: filter by requested ward
CREATE INDEX idx_waiting_ward ON waiting_patients (requestedWard);

-- Index: priority ordering
CREATE INDEX idx_waiting_priority ON waiting_patients (priority);


-- ---------------------------------------------------------------------------
-- 5. METRICS TABLE (singleton row)
-- Aggregate system metrics. Only one row (id = 1) should ever exist.
-- ---------------------------------------------------------------------------
CREATE TABLE metrics (
    id                                  INTEGER         NOT NULL DEFAULT 1,
    incorrect_allocations_prevented     INTEGER         DEFAULT 0,
    source_conflicts_detected           INTEGER         DEFAULT 0,
    admin_drift_detected                INTEGER         DEFAULT 0,
    reconciliation_success              INTEGER         DEFAULT 0,
    reconciliation_timeout              INTEGER         DEFAULT 0,
    total_reconciliation_time           DOUBLE          DEFAULT 0.0,
    max_reconciliation_time             DOUBLE          DEFAULT 0.0,
    unknown_state_duration_sum          DOUBLE          DEFAULT 0.0,
    out_of_order_events_handled         INTEGER         DEFAULT 0,
    duplicate_events_ignored            INTEGER         DEFAULT 0,
    stale_confirmations_detected        INTEGER         DEFAULT 0,
    manual_review_count                 INTEGER         DEFAULT 0,
    auto_resolved_count                 INTEGER         DEFAULT 0,
    double_booking_attempts_prevented   INTEGER         DEFAULT 0,
    total_events_processed              INTEGER         DEFAULT 0,
    invalid_events_rejected             INTEGER         DEFAULT 0,
    CONSTRAINT pk_metrics PRIMARY KEY (id),
    CONSTRAINT chk_metrics_singleton CHECK (id = 1)
);

-- Insert the singleton metrics row
INSERT INTO metrics (id) VALUES (1);


-- ---------------------------------------------------------------------------
-- 6. INCIDENTS TABLE
-- Tracks system incidents (e.g., source failures, double-booking attempts).
-- ---------------------------------------------------------------------------
CREATE TABLE incidents (
    incidentId      VARCHAR(36)     NOT NULL,
    category        VARCHAR(50)     NOT NULL,
    description     VARCHAR(500),
    affectedBeds    CLOB(64K),
    autoResolvedBeds CLOB(64K),
    createdAt       DOUBLE          NOT NULL,
    resolvedAt      DOUBLE,
    status          VARCHAR(20)     NOT NULL DEFAULT 'open',
    CONSTRAINT pk_incidents PRIMARY KEY (incidentId)
);

-- Index: find open/active incidents
CREATE INDEX idx_incidents_status ON incidents (status);

-- Index: time-ordered incident retrieval
CREATE INDEX idx_incidents_createdAt ON incidents (createdAt DESC);


-- ---------------------------------------------------------------------------
-- 7. SOURCE_HEALTH TABLE
-- Tracks the health/status of each data source feeding into the system.
-- ---------------------------------------------------------------------------
CREATE TABLE source_health (
    sourceId                VARCHAR(20)     NOT NULL,
    status                  VARCHAR(20)     NOT NULL DEFAULT 'unknown',
    lastSuccessfulEventTime DOUBLE,
    errorCount              INTEGER         DEFAULT 0,
    latencySum              DOUBLE          DEFAULT 0.0,
    eventCount              INTEGER         DEFAULT 0,
    lastErrorTime           DOUBLE,
    CONSTRAINT pk_source_health PRIMARY KEY (sourceId)
);


-- ---------------------------------------------------------------------------
-- 8. REVIEW_QUEUE TABLE
-- Queue of beds requiring manual human review.
-- ---------------------------------------------------------------------------
CREATE TABLE review_queue (
    id      INTEGER         NOT NULL GENERATED ALWAYS AS IDENTITY,
    bedId   VARCHAR(10)     NOT NULL,
    addedAt DOUBLE          NOT NULL,
    CONSTRAINT pk_review_queue PRIMARY KEY (id)
);

-- Index: look up by bed (for deduplication and removal)
CREATE INDEX idx_review_bedId ON review_queue (bedId);

-- Unique constraint: prevent duplicate entries for the same bed
CREATE UNIQUE INDEX idx_review_bedId_unique ON review_queue (bedId);


-- =============================================================================
-- END OF SCHEMA
-- =============================================================================
