-- =============================================================================
-- BedTrust+ IBM DB2 Data Migration Script
-- =============================================================================

-- 1. SEED DIGITAL TWINS (BEDS)
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B01', 'ICU', 'OCCUPIED', 1788629000.0,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    '[]', 'P001', 'OCCUPIED',
    'OCCUPIED', 1788629000.0, 'NONE',
    0.0, 'NONE', 'HIGH',
    '["INIT-B01"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B02', 'EMERGENCY', 'OCCUPIED', 1788629000.0,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    '[]', 'P002', 'OCCUPIED',
    'OCCUPIED', 1788629000.0, 'NONE',
    0.0, 'NONE', 'HIGH',
    '["INIT-B02"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B03', 'GENERAL', 'OCCUPIED', 1788629000.0,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    '[]', 'P003', 'OCCUPIED',
    'OCCUPIED', 1788629000.0, 'NONE',
    0.0, 'NONE', 'HIGH',
    '["INIT-B03"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B04', 'PEDIATRICS', 'OCCUPIED', 1788629000.0,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    '[]', 'P004', 'OCCUPIED',
    'OCCUPIED', 1788629000.0, 'NONE',
    0.0, 'NONE', 'HIGH',
    '["INIT-B04"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B05', 'ICU', 'OCCUPIED', 1788629000.0,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    '[]', 'P005', 'OCCUPIED',
    'OCCUPIED', 1788629000.0, 'NONE',
    0.0, 'NONE', 'HIGH',
    '["INIT-B05"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B06', 'EMERGENCY', 'OCCUPIED', 1788629000.0,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    '[]', 'P006', 'OCCUPIED',
    'OCCUPIED', 1788629000.0, 'NONE',
    0.0, 'NONE', 'HIGH',
    '["INIT-B06"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B07', 'GENERAL', 'OCCUPIED', 1788629000.0,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    '[]', 'P007', 'OCCUPIED',
    'OCCUPIED', 1788629000.0, 'NONE',
    0.0, 'NONE', 'HIGH',
    '["INIT-B07"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B08', 'PEDIATRICS', 'OCCUPIED', 1788629000.0,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    '[]', 'P008', 'OCCUPIED',
    'OCCUPIED', 1788629000.0, 'NONE',
    0.0, 'NONE', 'HIGH',
    '["INIT-B08"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B09', 'ICU', 'OCCUPIED', 1788629000.0,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    'OCCUPIED', 1788629000.0, 1788629000.0, 1,
    '[]', 'P009', 'OCCUPIED',
    'OCCUPIED', 1788629000.0, 'NONE',
    0.0, 'NONE', 'HIGH',
    '["INIT-B09"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B10', 'EMERGENCY', 'AVAILABLE', 1788629000.0,
    'AVAILABLE', 1788629000.0, 1788629000.0, 1,
    'AVAILABLE', 1788629000.0, 1788629000.0, 1,
    '[]', NULL, 'CONFIRMED_AVAILABLE',
    'CONFIRMED_AVAILABLE', 1788629000.0, 'NONE',
    1788640000.0, 'NONE', 'HIGH',
    '["INIT-B10"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B11', 'GENERAL', 'AVAILABLE', 1788629000.0,
    'AVAILABLE', 1788629000.0, 1788629000.0, 1,
    'AVAILABLE', 1788629000.0, 1788629000.0, 1,
    '[]', NULL, 'CONFIRMED_AVAILABLE',
    'CONFIRMED_AVAILABLE', 1788629000.0, 'NONE',
    1788640000.0, 'NONE', 'HIGH',
    '["INIT-B11"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);
INSERT INTO digital_twins (
    bedId, ward, adminState, adminUpdateTime,
    sourceAState, sourceAEventTime, sourceAReceivedTime, sourceASequence,
    sourceBState, sourceBEventTime, sourceBReceivedTime, sourceBSequence,
    workflowEvidence, activePatientId, reconciledState,
    lastConfirmedState, lastConfirmedTimestamp, unknownReason,
    availabilityLeaseExpiry, reservationStatus, confidence,
    sourceLineage, conflictHistory, auditHistory,
    lastReconciliationAttempt, autoRetries, needsHumanReview,
    createdAt, updatedAt
) VALUES (
    'B12', 'PEDIATRICS', 'AVAILABLE', 1788629000.0,
    'AVAILABLE', 1788629000.0, 1788629000.0, 1,
    'AVAILABLE', 1788629000.0, 1788629000.0, 1,
    '[]', NULL, 'CONFIRMED_AVAILABLE',
    'CONFIRMED_AVAILABLE', 1788629000.0, 'NONE',
    1788640000.0, 'NONE', 'HIGH',
    '["INIT-B12"]', '[]', '[]',
    1788629000.0, 0, 0,
    1788629000.0, 1788629000.0
);

-- 2. SEED WAITING PATIENTS
INSERT INTO waiting_patients (patientId, name, priority, requestedWard, arrivedAt, assignedBed)
VALUES ('WP001', 'Alex Rivera', 'ICU', 'ICU', 1788628000.0, NULL);
INSERT INTO waiting_patients (patientId, name, priority, requestedWard, arrivedAt, assignedBed)
VALUES ('WP002', 'Sam Patel', 'EMERGENCY', 'EMERGENCY', 1788628100.0, NULL);
INSERT INTO waiting_patients (patientId, name, priority, requestedWard, arrivedAt, assignedBed)
VALUES ('WP003', 'Jordan Lee', 'NORMAL', 'GENERAL', 1788628200.0, NULL);
INSERT INTO waiting_patients (patientId, name, priority, requestedWard, arrivedAt, assignedBed)
VALUES ('WP004', 'Taylor Kim', 'NORMAL', 'PEDIATRICS', 1788628300.0, NULL);
INSERT INTO waiting_patients (patientId, name, priority, requestedWard, arrivedAt, assignedBed)
VALUES ('WP005', 'Casey Morgan', 'EMERGENCY', 'GENERAL', 1788628400.0, NULL);

-- 3. SEED SOURCE HEALTH
INSERT INTO source_health (sourceId, status, lastSuccessfulEventTime, errorCount, latencySum, eventCount, lastErrorTime)
VALUES ('ADMIN', 'HEALTHY', 1788629000.0, 0, 0.0, 0, 0.0);
INSERT INTO source_health (sourceId, status, lastSuccessfulEventTime, errorCount, latencySum, eventCount, lastErrorTime)
VALUES ('SOURCE_A', 'HEALTHY', 1788629000.0, 0, 0.0, 0, 0.0);
INSERT INTO source_health (sourceId, status, lastSuccessfulEventTime, errorCount, latencySum, eventCount, lastErrorTime)
VALUES ('SOURCE_B', 'HEALTHY', 1788629000.0, 0, 0.0, 0, 0.0);
INSERT INTO source_health (sourceId, status, lastSuccessfulEventTime, errorCount, latencySum, eventCount, lastErrorTime)
VALUES ('WORKFLOW', 'HEALTHY', 1788629000.0, 0, 0.0, 0, 0.0);
INSERT INTO source_health (sourceId, status, lastSuccessfulEventTime, errorCount, latencySum, eventCount, lastErrorTime)
VALUES ('HUMAN', 'HEALTHY', 1788629000.0, 0, 0.0, 0, 0.0);
INSERT INTO source_health (sourceId, status, lastSuccessfulEventTime, errorCount, latencySum, eventCount, lastErrorTime)
VALUES ('SYSTEM', 'HEALTHY', 1788629000.0, 0, 0.0, 0, 0.0);

-- 4. MIGRATE EVENTS (127 RECORDS)
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '433cbeb9-000a-487b-9546-329279dc1d00',
    'B09',
    'ADMIN',
    'AVAILABLE',
    1788629293.9768698,
    1788629293.9768739,
    1,
    'ADMIN-ROOT-1',
    '{"ward": "GENERAL"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '1b15ffbb-8750-415d-bf4f-8cf2fd0d4dc3',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788629294.4768698,
    1788629294.5986733,
    1,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '640abc13-c81b-4019-b037-f9273abff0b8',
    'B09',
    'SOURCE_B',
    'AVAILABLE',
    1788629294.5768697,
    1788629295.0522692,
    1,
    'PHYS-B-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'be90eae7-9c9e-437c-bbc3-5723f224ee88',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788629294.4768698,
    1788629295.6911817,
    2,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '85602311-629f-437e-99fe-b199c5284509',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788629283.9768698,
    1788629295.9246955,
    1,
    'PHYS-A-OLD',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '6bcb76e0-c3b5-4eb1-b670-3edab522e921',
    'B09',
    'WORKFLOW',
    'OCCUPIED',
    1788629297.3600082,
    1788629297.3600101,
    1,
    'WORKFLOW-B09-1788629297',
    '{"workflowType": "PATIENT_ASSIGNED", "patientId": "P009"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '2b799727-f5bb-4951-baa0-75d1ef2ecdd7',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788629297.3595903,
    1788629297.859593,
    2,
    'PHYS-B-2',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '61d8221d-47c4-4555-a45a-705e9b9c5cb6',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1788629308.8348918,
    1788629308.8348963,
    2,
    'ADMIN-B05-1788629308',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '529d923c-734a-425d-87f9-f386e8b3cf1f',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788629308.9348917,
    1788629309.3245223,
    4,
    'SOURCE_A-B05-1788629308',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '24d921c6-a31a-4332-acff-3be64cfc0f2d',
    'B05',
    'SOURCE_B',
    'AVAILABLE',
    1788629309.0348918,
    1788629309.5864048,
    3,
    'SOURCE_B-B05-1788629309',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'edf1522e-26a6-4a34-b298-886333d3b7ba',
    'B09',
    'ADMIN',
    'AVAILABLE',
    1788640233.7906415,
    1788640233.7907553,
    1,
    'ADMIN-ROOT-1',
    '{"ward": "GENERAL"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '76895532-8c48-4896-a771-4c162f42781d',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788640234.2906415,
    1788640234.0928504,
    1,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '71c16241-fbeb-4f0d-ad4f-212c21ad13dc',
    'B09',
    'SOURCE_B',
    'AVAILABLE',
    1788640234.3906415,
    1788640234.294718,
    1,
    'PHYS-B-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'b300ea0d-e372-4e97-ae39-b3dde385ba7f',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788640234.2906415,
    1788640234.6958077,
    2,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'a094de7d-bc86-4a8e-9fbf-cae374efd61d',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788640223.7906415,
    1788640234.6969604,
    1,
    'PHYS-A-OLD',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'e26aa2b0-6597-4863-adcb-dbdb42e93575',
    'B09',
    'WORKFLOW',
    'OCCUPIED',
    1788640235.701542,
    1788640235.7015464,
    1,
    'WORKFLOW-B09-1788640235',
    '{"workflowType": "PATIENT_ASSIGNED", "patientId": "P009"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '366d3233-2700-4049-97a4-816322cae3f5',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788640235.698837,
    1788640236.1988409,
    2,
    'PHYS-B-2',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'ed421a15-2e61-4c17-b8df-ba2a2b0d844b',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788640242.4248466,
    1788640242.4248831,
    4,
    'SOURCE_A-B09-1788640242',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '8ebc42f7-5209-4dd4-a9e9-440b986be336',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788640242.4748466,
    1788640242.4260685,
    3,
    'SOURCE_B-B09-1788640242',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '1ae39df2-1160-4f55-b48e-4a106c7fb727',
    'B10',
    'HUMAN',
    'AVAILABLE',
    1788640896.2315803,
    1788640896.2315807,
    0,
    'HUMAN-dr.chen',
    '{"user": "dr.chen", "reason": "Forget to update accurate\n", "action": "CONFIRM_AVAILABLE"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'e1c4d081-2ae9-489f-8e80-a0eae0552c09',
    'B10',
    'HUMAN',
    'AVAILABLE',
    1788640974.4349546,
    1788640974.4349556,
    0,
    'HUMAN-dr.chen',
    '{"user": "dr.chen", "reason": "Delayed and written mistake found\n", "action": "CONFIRM_AVAILABLE"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '230a8646-6cc4-443a-9ad0-db41bd0bbb32',
    'B10',
    'SOURCE_A',
    'AVAILABLE',
    1788641019.4926007,
    1788641019.4926088,
    5,
    'SOURCE_A-B10-1788641019',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'ce8c5719-54ce-438a-961d-5edc98924531',
    'B10',
    'SOURCE_B',
    'AVAILABLE',
    1788641019.5426006,
    1788641019.4933934,
    4,
    'SOURCE_B-B10-1788641019',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '45aa3b04-acf7-4513-81a0-d314aa4f7d73',
    'B09',
    'ADMIN',
    'AVAILABLE',
    1788641033.967357,
    1788641033.967361,
    2,
    'ADMIN-ROOT-1',
    '{"ward": "GENERAL"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '52b3be8e-9dbe-47e2-a0e9-292106da335b',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788641034.467357,
    1788641034.268342,
    6,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '65e5c5d3-7bb7-4a97-83eb-830bec59f68d',
    'B09',
    'SOURCE_B',
    'AVAILABLE',
    1788641034.5673568,
    1788641034.4700394,
    5,
    'PHYS-B-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'e0a23ce4-5cfc-4fbf-a4f8-a5d7c1852da4',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788641034.467357,
    1788641034.871695,
    7,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'e5d152ed-a538-4456-ad96-7e9b5cfeadcc',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788641023.967357,
    1788641034.8730052,
    1,
    'PHYS-A-OLD',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'd00e9d45-f820-49d8-b595-143c042f3433',
    'B09',
    'WORKFLOW',
    'OCCUPIED',
    1788641035.8764458,
    1788641035.876451,
    2,
    'WORKFLOW-B09-1788641035',
    '{"workflowType": "PATIENT_ASSIGNED", "patientId": "P009"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '38c50f50-3833-42d3-980f-5b91034aab8f',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788641035.875612,
    1788641036.3756156,
    6,
    'PHYS-B-2',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '331e0736-617e-4efd-8575-c888843b202d',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788641042.2271588,
    1788641042.2271676,
    9,
    'SOURCE_A-B09-1788641042',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'dad2259f-9fa1-4a64-b4ab-61b166ba12ee',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788641042.2771587,
    1788641042.2285974,
    7,
    'SOURCE_B-B09-1788641042',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '150b63f3-10f1-4307-961b-492472ef06b7',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644089.0707526,
    1788644089.0707607,
    1,
    'SOURCE_A-B05-1788644089',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '8c6e8683-4632-45b1-a19f-74f93691a632',
    'B05',
    'SOURCE_A',
    'AVAILABLE',
    1788644090.821148,
    1788644090.8211553,
    2,
    'SOURCE_A-B05-1788644090',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '042175be-a38d-4e21-9472-8a48823a149a',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644080.821148,
    1788644090.822129,
    3,
    'SOURCE_A-B05-1788644080',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '09e5edff-77ac-4759-8341-f428b208582d',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1788644100.367975,
    1788644100.367983,
    1,
    'ADMIN-B05-1788644100',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'b569fb7f-b497-45ce-9f74-58ce8e20e792',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644100.467975,
    1788644100.369196,
    4,
    'SOURCE_A-B05-1788644100',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '17e30d5a-ed03-4853-8278-a18b22de1c05',
    'B05',
    'SOURCE_B',
    'OCCUPIED',
    1788644100.567975,
    1788644100.3702438,
    1,
    'SOURCE_B-B05-1788644100',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '40da367d-3350-453e-a0df-775ccda53fce',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1788644101.4802647,
    1788644101.4802709,
    2,
    'ADMIN-B05-1788644101',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '0d66db40-8632-4688-a543-5f0937e1583a',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644101.5802646,
    1788644101.4825234,
    5,
    'SOURCE_A-B05-1788644101',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '700a7bb9-a569-4547-9bc0-2eebf63e5b9b',
    'B05',
    'SOURCE_B',
    'OCCUPIED',
    1788644101.6802647,
    1788644101.4835505,
    2,
    'SOURCE_B-B05-1788644101',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'b8ca0f03-08e1-4163-9d80-ee7871fb9ee3',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644103.5515623,
    1788644103.551569,
    6,
    'SOURCE_A-B05-1788644103',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'a7d704e7-e8d6-4bf3-9198-4d6c065d5475',
    'B05',
    'SOURCE_A',
    'AVAILABLE',
    1788644105.8706226,
    1788644105.8706284,
    7,
    'SOURCE_A-B05-1788644105',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'c85692b5-830c-4626-bd9c-51e5f8418259',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644095.8706226,
    1788644105.8713186,
    8,
    'SOURCE_A-B05-1788644095',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '41dbdd64-5c84-4259-83ad-20faedc33a54',
    'B05',
    'SOURCE_A',
    'AVAILABLE',
    1788644226.162271,
    1788644226.162274,
    9,
    'SOURCE_A-B05-1788644226',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'b64bd1f8-2efa-4acf-ad7c-f8cc382d2dfe',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644216.162271,
    1788644226.1627245,
    10,
    'SOURCE_A-B05-1788644216',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'a97c9790-cf6a-4f68-8f0f-cfa8f9b9423e',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644357.086826,
    1788644357.0868306,
    11,
    'SOURCE_A-B05-1788644357',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'd3c3fabe-117b-4ec1-9edf-cb3537742225',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1788644418.4217064,
    1788644418.4217153,
    3,
    'ADMIN-B05-1788644418',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '9899e0d0-4b11-4f70-8f2c-158f731eb8f3',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644418.5217063,
    1788644418.422811,
    12,
    'SOURCE_A-B05-1788644418',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '1d22b92c-e02a-49f7-9db2-39ae881e9343',
    'B05',
    'SOURCE_B',
    'OCCUPIED',
    1788644418.6217065,
    1788644418.4242072,
    3,
    'SOURCE_B-B05-1788644418',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '6b89566a-e282-47f9-a932-040827d14fde',
    'B05',
    'SOURCE_A',
    'AVAILABLE',
    1788644682.2572203,
    1788644682.257226,
    13,
    'SOURCE_A-B05-1788644682',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'd5d74990-f4d1-4b3c-afe7-96aa15cbe4b5',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644672.2572203,
    1788644682.2579894,
    14,
    'SOURCE_A-B05-1788644672',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '4184b2bf-8205-4a84-a02a-783ede1e7eb9',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644683.8856313,
    1788644683.8856366,
    15,
    'SOURCE_A-B05-1788644683',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '296c917f-1660-4ba0-bdce-3bf0d7c5bad6',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1788644687.5547318,
    1788644687.5547366,
    4,
    'ADMIN-B05-1788644687',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '2c11666e-083f-4a43-accb-5d25ee5dbc49',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644687.6547318,
    1788644687.5566297,
    16,
    'SOURCE_A-B05-1788644687',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '4bc80e34-2e00-4cda-adb5-3b896111163c',
    'B05',
    'SOURCE_B',
    'OCCUPIED',
    1788644687.754732,
    1788644687.5575442,
    4,
    'SOURCE_B-B05-1788644687',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'fb1c140d-01ae-4109-b9c7-5bc9141e7d04',
    'B09',
    'ADMIN',
    'AVAILABLE',
    1788644751.8473542,
    1788644751.8473587,
    5,
    'ADMIN-ROOT-1',
    '{"ward": "GENERAL"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '42415376-25de-4db0-b06e-89c767525505',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788644752.3473542,
    1788644752.1495302,
    17,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'ffaccf00-0e7a-4521-b8d8-e699ffca06c9',
    'B09',
    'SOURCE_B',
    'AVAILABLE',
    1788644752.447354,
    1788644752.3524039,
    5,
    'PHYS-B-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'd783e3a1-c5d6-4950-9b8b-9e4a2b8e6227',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788644752.3473542,
    1788644752.7543235,
    18,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '884728b4-eb81-4e56-901c-956341c22981',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788644741.8473542,
    1788644752.7557583,
    1,
    'PHYS-A-OLD',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '86b9cf26-4447-41e0-9d2a-7eec65f218e2',
    'B09',
    'WORKFLOW',
    'OCCUPIED',
    1788644753.759225,
    1788644753.7592287,
    1,
    'WORKFLOW-B09-1788644753',
    '{"workflowType": "PATIENT_ASSIGNED", "patientId": "P009"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '67541b45-8dcb-49fe-bf12-1cc83f9dda06',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788644753.7581115,
    1788644754.2581146,
    6,
    'PHYS-B-2',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '22c5701b-5684-4179-8a0a-addceefc50fd',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788644760.4199896,
    1788644760.4199996,
    20,
    'SOURCE_A-B09-1788644760',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '873791a3-c28b-4e58-8340-da08b8588bc2',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788644760.4699895,
    1788644760.4214005,
    7,
    'SOURCE_B-B09-1788644760',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '361d3ece-a0d7-457a-96d0-11a37e9219e6',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1788644789.4183977,
    1788644789.4184053,
    6,
    'ADMIN-B05-1788644789',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'f05859f5-b0bd-4944-be6a-b9abfbd17ebd',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644789.5183976,
    1788644789.4204435,
    21,
    'SOURCE_A-B05-1788644789',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'c81df6e8-2b46-4e06-8f87-cc7fd1b2956c',
    'B05',
    'SOURCE_B',
    'AVAILABLE',
    1788644789.6183977,
    1788644789.421411,
    8,
    'SOURCE_B-B05-1788644789',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'a24bdf4a-258a-4144-a35f-85733e9ea151',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1788644840.8810873,
    1788644840.8811002,
    7,
    'ADMIN-B05-1788644840',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '85e2d9d0-786f-40c8-b1f7-2510c6d3ecd3',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788644840.9810872,
    1788644840.8836107,
    22,
    'SOURCE_A-B05-1788644840',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '8c9f56c6-7551-41bc-abb4-e0c5b1ce8b76',
    'B05',
    'SOURCE_B',
    'AVAILABLE',
    1788644841.0810874,
    1788644840.8847115,
    9,
    'SOURCE_B-B05-1788644841',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '06a74bb5-3c83-4796-89bc-dee5693512d2',
    'B02',
    'SOURCE_A',
    'OCCUPIED',
    1788665648.2770429,
    1788665648.2772174,
    23,
    'SOURCE_A-B02-1788665648',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '3f8917f0-6dfc-47b5-9130-69be5db93878',
    'B02',
    'SOURCE_B',
    'OCCUPIED',
    1788665648.3270428,
    1788665648.2815607,
    10,
    'SOURCE_B-B02-1788665648',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '5daaddac-b608-4718-9422-9c068353e6bd',
    'B02',
    'SOURCE_A',
    'OCCUPIED',
    1788665659.9371274,
    1788665659.9371352,
    24,
    'SOURCE_A-B02-1788665659',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'b4718584-3592-4ed0-bbe2-d6f3d0f7f5ac',
    'B02',
    'SOURCE_B',
    'OCCUPIED',
    1788665659.9871273,
    1788665659.938273,
    11,
    'SOURCE_B-B02-1788665659',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '693249a8-7ed2-4792-8316-452d752110cf',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1788666425.892079,
    1788666425.8920906,
    1,
    'ADMIN-B05-1788666425',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '26e898e2-4d06-4016-95b4-dfb5d1fd82f6',
    'B05',
    'SOURCE_A',
    'AVAILABLE',
    1788666425.992079,
    1788666425.8931687,
    1,
    'SOURCE_A-B05-1788666425',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'fc22287c-00d6-4a06-af4b-6395d3c7c6dc',
    'B05',
    'SOURCE_B',
    'AVAILABLE',
    1788666426.0920792,
    1788666425.8939247,
    1,
    'SOURCE_B-B05-1788666426',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '3e126aa2-0be0-497f-a985-3321c2041bef',
    'B05',
    'WORKFLOW',
    'AVAILABLE',
    1788666426.192079,
    1788666425.8945358,
    1,
    'WORKFLOW-B05-1788666426',
    '{"workflowType": "ROOM_READY"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '80038420-56af-4816-b7e5-8a4101a09e1f',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1788666498.432017,
    1788666498.4320278,
    2,
    'ADMIN-B05-1788666498',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '86ecb9f4-4722-4d92-b049-4c68adc624ec',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788666498.532017,
    1788666498.433263,
    2,
    'SOURCE_A-B05-1788666498',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'bc4c83b3-f7ff-4cdd-a6e1-12b8907d9617',
    'B05',
    'WORKFLOW',
    'OCCUPIED',
    1788666500.4352176,
    1788666500.4352224,
    2,
    'WORKFLOW-B05-1788666500',
    '{"workflowType": "PATIENT_ARRIVAL_RECORDED", "patientId": "P999"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '5cb57c2e-c489-4585-95ee-27a583862c85',
    'B05',
    'SOURCE_B',
    'OCCUPIED',
    1788666500.4363987,
    1788666500.4363997,
    2,
    'SOURCE_B-B05-1788666500',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '18ce2d26-64bf-49e4-a223-a679d8675844',
    'B09',
    'ADMIN',
    'AVAILABLE',
    1788667232.7329698,
    1788667232.732975,
    1,
    'ADMIN-ROOT-1',
    '{"ward": "GENERAL"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '6abf15a7-1188-4c2b-a3d3-d1f51eee4383',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788667233.2329698,
    1788667233.0349424,
    1,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'b8f47236-555c-4e66-a4cc-94c73b20e173',
    'B09',
    'SOURCE_B',
    'AVAILABLE',
    1788667233.3329697,
    1788667233.2362518,
    1,
    'PHYS-B-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '7c8c67c3-20cc-4003-b235-7554235b15e7',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788667233.2329698,
    1788667233.6378427,
    2,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '4aec2704-ef6c-4b5a-8a9d-15f4001b89c4',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788667222.7329698,
    1788667233.6392124,
    1,
    'PHYS-A-OLD',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '0430ca07-e87f-4769-b6a6-98c338706460',
    'B09',
    'WORKFLOW',
    'OCCUPIED',
    1788667234.6437705,
    1788667234.6437745,
    1,
    'WORKFLOW-B09-1788667234',
    '{"workflowType": "PATIENT_ASSIGNED", "patientId": "P009"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '7eeda55d-7c00-48c1-ad45-5412823af554',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788667234.642837,
    1788667235.1428404,
    2,
    'PHYS-B-2',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '221091b6-2503-4f97-8e60-887f4c8be8c9',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788667240.994899,
    1788667240.9949064,
    4,
    'SOURCE_A-B09-1788667240',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '8ec3fc9c-1885-47b0-927d-560f63a3dcb6',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788667241.044899,
    1788667240.9960012,
    3,
    'SOURCE_B-B09-1788667241',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'c36d0adf-783e-4cb9-a1de-9f5245a6498e',
    'B10',
    'HUMAN',
    'OCCUPIED',
    1788667701.8849754,
    1788667701.884976,
    0,
    'HUMAN-auto-reviewer',
    '{"user": "auto-reviewer", "reason": "Likely Available because there are 2 signals for availability (clean/empty context).", "action": "CONFIRM_OCCUPIED"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '2682755d-9e44-400f-a289-3bbe1d127778',
    'B09',
    'ADMIN',
    'AVAILABLE',
    1788667767.4613323,
    1788667767.4613369,
    2,
    'ADMIN-ROOT-1',
    '{"ward": "GENERAL"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '9d3e9413-1f6d-4d3b-a6c5-3bea42286f14',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788667767.9613323,
    1788667767.7627566,
    5,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '4129dc83-f52a-4882-a279-9849cdaeb808',
    'B09',
    'SOURCE_B',
    'AVAILABLE',
    1788667768.0613322,
    1788667767.964633,
    4,
    'PHYS-B-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'e5995844-a4ff-49af-8b97-f650010861ed',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788667767.9613323,
    1788667768.3665864,
    6,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '61e366b4-dffa-45e9-ba2d-58dca622c8f3',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788667757.4613323,
    1788667768.3679073,
    1,
    'PHYS-A-OLD',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '6e16075f-1d93-44c0-891a-289189cc17fd',
    'B09',
    'WORKFLOW',
    'OCCUPIED',
    1788667769.370865,
    1788667769.3708673,
    2,
    'WORKFLOW-B09-1788667769',
    '{"workflowType": "PATIENT_ASSIGNED", "patientId": "P009"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'dae2bb85-0f9a-43e6-baab-7983342a4045',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788667769.370478,
    1788667769.8704796,
    5,
    'PHYS-B-2',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '9046d64d-c6bf-4267-9a25-80bfa8b82958',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1788667775.706881,
    1788667775.7068942,
    8,
    'SOURCE_A-B09-1788667775',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '0aa8ab31-eb8a-4904-b23b-dbf7bae1b998',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1788667775.756881,
    1788667775.7084188,
    6,
    'SOURCE_B-B09-1788667775',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '287ccd85-8540-494a-ac41-74022a5b89e6',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1788929880.6864898,
    1788929880.6864996,
    1,
    'ADMIN-B05-1788929880',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '681aa662-9726-4b3f-b520-47ed6b51f5e3',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1788929880.7864897,
    1788929880.6891046,
    1,
    'SOURCE_A-B05-1788929880',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'b1a10012-0ddb-4d02-9020-5b6af09edb00',
    'B09',
    'ADMIN',
    'AVAILABLE',
    1793346402.7085905,
    1793346402.708594,
    1,
    'ADMIN-ROOT-1',
    '{"ward": "GENERAL"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'ca43076b-9369-4f6a-a35e-8bba3aaaf7fb',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1793346403.2085905,
    1793346403.0098968,
    1,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'd33d32ce-1494-40d1-8f68-974c602e9993',
    'B09',
    'SOURCE_B',
    'AVAILABLE',
    1793346403.3085904,
    1793346403.211559,
    1,
    'PHYS-B-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '47882e44-66c0-4660-b8b7-6df3c19b2378',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1793346403.2085905,
    1793346403.6126204,
    2,
    'PHYS-A-1',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'fb3ae3d1-5cb2-45a5-a27d-43b7cfc012c0',
    'B09',
    'SOURCE_A',
    'OCCUPIED',
    1793346392.7085905,
    1793346403.6130092,
    1,
    'PHYS-A-OLD',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'fe47688f-ae86-4972-a668-ef472deaf96f',
    'B09',
    'WORKFLOW',
    'OCCUPIED',
    1793346404.6143773,
    1793346404.6143801,
    1,
    'WORKFLOW-B09-1793346404',
    '{"workflowType": "PATIENT_ASSIGNED", "patientId": "P009"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '71879289-6c3e-4d6f-9bdf-ea79a989e70f',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1793346404.6429682,
    1793346404.6429732,
    2,
    'ADMIN-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '72ab5999-863b-435f-b116-c3f9990d8838',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1793346404.742968,
    1793346404.6436095,
    4,
    'SOURCE_A-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '4f855264-2d61-4f9b-b271-7a8eb165ed0f',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1793346404.6529357,
    1793346404.6529393,
    3,
    'ADMIN-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '7f08bffc-cfd9-4dc9-ac0b-f9ef6ed818ca',
    'B05',
    'SOURCE_A',
    'AVAILABLE',
    1793346404.7529356,
    1793346404.6535392,
    5,
    'SOURCE_A-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '30ea8a4d-4a09-44f7-b8a7-5c96be5eed59',
    'B05',
    'SOURCE_B',
    'AVAILABLE',
    1793346404.8529358,
    1793346404.6537595,
    3,
    'SOURCE_B-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'd63a6038-f8a4-4b77-84fd-49a8ec65b13c',
    'B05',
    'WORKFLOW',
    'AVAILABLE',
    1793346404.9529357,
    1793346404.6540244,
    2,
    'WORKFLOW-B05-1793346404',
    '{"workflowType": "ROOM_READY"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '0e53fe16-a7b2-4070-a473-2506c009b72d',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1793346404.6651106,
    1793346404.6651146,
    4,
    'ADMIN-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '968672bc-8880-47a1-aad5-dc13af8a6282',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1793346404.7651105,
    1793346404.6655266,
    6,
    'SOURCE_A-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'eb4a9ef1-8bd7-43d6-bfe2-a36aeaeaf1a1',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1793346404.6754506,
    1793346404.6754541,
    5,
    'ADMIN-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'b405b3a4-b6cc-4dc6-a62b-080c139a369c',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1793346404.7754505,
    1793346404.6758761,
    7,
    'SOURCE_A-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'b5bb45b0-a1d5-40a7-81c0-1d5c4002ad9c',
    'B05',
    'SOURCE_B',
    'AVAILABLE',
    1793346404.8754506,
    1793346404.6761417,
    4,
    'SOURCE_B-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'd6ac6c75-a0de-44c4-ac02-8c442b8d8c82',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1793346404.7115092,
    1793346404.7115135,
    8,
    'SOURCE_A-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '712f2567-af6c-4ed7-bfbe-6f406454a934',
    'B05',
    'SOURCE_B',
    'AVAILABLE',
    1793346404.7615092,
    1793346404.7121747,
    5,
    'SOURCE_B-B05-1793346404',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '3770cc77-4c72-41e8-8136-70a2f5b02899',
    'B01',
    'HUMAN',
    'AVAILABLE',
    1793346404.7410986,
    1793346404.741099,
    0,
    'HUMAN-tester',
    '{"user": "tester", "reason": "ok", "action": "CONFIRM_AVAILABLE"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '90efa2bc-5b40-46a5-a4a5-a9aeae8e298b',
    'B09',
    'SOURCE_B',
    'OCCUPIED',
    1793346404.613812,
    1793346405.1138148,
    2,
    'PHYS-B-2',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '976c131c-8395-43d4-a062-fb094f0a9639',
    'B05',
    'WORKFLOW',
    'OCCUPIED',
    1793346406.666534,
    1793346406.666539,
    3,
    'WORKFLOW-B05-1793346406',
    '{"workflowType": "PATIENT_ARRIVAL_RECORDED", "patientId": "P999"}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'fe41df07-6d13-4b5b-a7fe-9eacab613e64',
    'B05',
    'SOURCE_B',
    'OCCUPIED',
    1793346406.6676145,
    1793346406.6676157,
    6,
    'SOURCE_B-B05-1793346406',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '1b93d6af-5f91-418e-a968-f67f5faa0ed6',
    'B05',
    'ADMIN',
    'AVAILABLE',
    1793349113.8057146,
    1793349113.805723,
    1,
    'ADMIN-B05-1793349113',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '812780d3-148e-43c9-83e6-e0de0a7bafef',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1793349113.9057145,
    1793349113.8064678,
    1,
    'SOURCE_A-B05-1793349113',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    'b882ea9e-ad34-4740-b5b5-956f7f7eeb3a',
    'B05',
    'SOURCE_A',
    'OCCUPIED',
    1793349113.824634,
    1793349113.82464,
    2,
    'SOURCE_A-B05-1793349113',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);
INSERT INTO events (
    eventId, bedId, source, state, eventTime, receivedTime,
    sequenceNumber, sourceLineageId, metadata, processed,
    isDuplicate, isOutOfOrder, isStale, validationStatus, validationNotes
) VALUES (
    '7769f6a1-7d5d-4c12-a2c0-b28f3354da55',
    'B05',
    'SOURCE_B',
    'OCCUPIED',
    1793349113.874634,
    1793349113.825527,
    1,
    'SOURCE_B-B05-1793349113',
    '{}',
    False,
    False,
    False,
    False,
    'PENDING',
    ''
);

-- 5. MIGRATE AUDIT LOG (307 RECORDS)
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a2203a60-7f85-4f80-8d2a-7bfe1ed65685',
    1788629296.1777394,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "85602311-629f-437e-99fe-b199c5284509", "bedId": "B09", "source": "SOURCE_A", "eventTime": 1788629283.9768698, "note": "Ignored \u2013 older than current knowledge", "ts": 1788629296.1777394, "id": "a2203a60-7f85-4f80-8d2a-7bfe1ed65685"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '368ef3bf-40db-48fb-8860-00a7170747ce',
    1788629298.1105998,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B09", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788629298.1105998, "id": "368ef3bf-40db-48fb-8860-00a7170747ce"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '4f12ddbc-398b-4fba-9eed-a9d00429822f',
    1788629309.0789917,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788629309.0789917, "id": "4f12ddbc-398b-4fba-9eed-a9d00429822f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '87d69bdf-eb8e-419a-b689-c5bcbcad5671',
    1788629309.5865552,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788629309.5865552, "id": "87d69bdf-eb8e-419a-b689-c5bcbcad5671"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '61aa558f-1747-4f52-b750-77079876a7ad',
    1788629311.1834447,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B05", "patientId": "WP001", "reason": "State is UNKNOWN (need CONFIRMED_AVAILABLE)", "ts": 1788629311.1834447, "id": "61aa558f-1747-4f52-b750-77079876a7ad"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '2d9e45e0-2854-49a8-806f-b36c4d663926',
    1788629315.4569235,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B05", "reason": "RECONCILIATION_TIMEOUT", "retries": 13, "ts": 1788629315.4569235, "id": "2d9e45e0-2854-49a8-806f-b36c4d663926"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f2896243-c8a3-4af3-b109-abf2aa6115b6',
    1788629325.7324219,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788629325.7324219, "id": "f2896243-c8a3-4af3-b109-abf2aa6115b6"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'bc3d2509-3854-4634-8633-4ee982ed19d4',
    1788632487.7621307,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788632487.7621307, "id": "bc3d2509-3854-4634-8633-4ee982ed19d4"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '862df9a4-c11b-45e1-9ab6-74ffb656e696',
    1788632487.7632637,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788632487.7632637, "id": "862df9a4-c11b-45e1-9ab6-74ffb656e696"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a325cae2-94fe-4c7d-854a-177291360019',
    1788632487.7640662,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788632487.7640662, "id": "a325cae2-94fe-4c7d-854a-177291360019"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'bff92a59-4c29-4ef4-9b26-4657a39bd4f8',
    1788632518.2961226,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788632518.2961226, "id": "bff92a59-4c29-4ef4-9b26-4657a39bd4f8"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'fcc7a0e3-4030-4dfc-b84c-ddf1d431b159',
    1788632518.2965138,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788632518.2965138, "id": "fcc7a0e3-4030-4dfc-b84c-ddf1d431b159"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '865c5990-e379-4f26-b265-6c5dcbf6ff1e',
    1788632518.2967017,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788632518.2967017, "id": "865c5990-e379-4f26-b265-6c5dcbf6ff1e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '9007eb73-fe72-4502-9479-9b6f4a78b5b9',
    1788632523.3016944,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788632523.3016944, "id": "9007eb73-fe72-4502-9479-9b6f4a78b5b9"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'db45728a-6e1d-4114-9b03-6853d6b414be',
    1788632523.3021555,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788632523.3021555, "id": "db45728a-6e1d-4114-9b03-6853d6b414be"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '56b37298-de30-45e3-8202-3112fc25fb6e',
    1788632523.302409,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788632523.302409, "id": "56b37298-de30-45e3-8202-3112fc25fb6e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1d157630-df73-4854-82cc-0d7888809b8a',
    1788638208.4387817,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788638208.4387817, "id": "1d157630-df73-4854-82cc-0d7888809b8a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '77875ba8-b23b-409e-8330-6ab86ed6530d',
    1788638208.4406428,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788638208.4406428, "id": "77875ba8-b23b-409e-8330-6ab86ed6530d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1c05b8a5-bc33-4298-ab14-ec85a56301d1',
    1788638208.4422615,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788638208.4422615, "id": "1c05b8a5-bc33-4298-ab14-ec85a56301d1"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '0c87f4ed-5561-43ea-ab16-5a12e341cb6e',
    1788638238.974225,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788638238.974225, "id": "0c87f4ed-5561-43ea-ab16-5a12e341cb6e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '5716da4b-325c-4979-a94a-3181734a2ce4',
    1788638238.9748716,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788638238.9748716, "id": "5716da4b-325c-4979-a94a-3181734a2ce4"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '798e42b1-4407-4730-ae9e-d081dcf0826d',
    1788638238.975617,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788638238.975617, "id": "798e42b1-4407-4730-ae9e-d081dcf0826d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '07409f6b-013c-4687-b435-f7275f5264e7',
    1788638243.9807496,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788638243.9807496, "id": "07409f6b-013c-4687-b435-f7275f5264e7"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '395e6de8-2ebc-423b-9137-072d4523fa8a',
    1788638243.981975,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B09", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788638243.981975, "id": "395e6de8-2ebc-423b-9137-072d4523fa8a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8ead079b-30bd-4b5a-b2c8-627968e5ad4d',
    1788638243.982511,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788638243.982511, "id": "8ead079b-30bd-4b5a-b2c8-627968e5ad4d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '452877a7-49dc-417e-811e-5b0f26da1488',
    1788640234.6978734,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "a094de7d-bc86-4a8e-9fbf-cae374efd61d", "bedId": "B09", "source": "SOURCE_A", "eventTime": 1788640223.7906415, "note": "Ignored \u2013 older than current knowledge", "ts": 1788640234.6978734, "id": "452877a7-49dc-417e-811e-5b0f26da1488"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '18260595-218c-44ce-be4b-962d0679adb5',
    1788640236.20225,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B09", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788640236.20225, "id": "18260595-218c-44ce-be4b-962d0679adb5"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'eb4a7e3e-68e9-4be5-bc08-6b44c9bfc455',
    1788640249.139199,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788640249.139199, "id": "eb4a7e3e-68e9-4be5-bc08-6b44c9bfc455"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'bd24dba1-df07-4ad1-8c86-7d11b3197dd7',
    1788640264.658873,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788640264.658873, "id": "bd24dba1-df07-4ad1-8c86-7d11b3197dd7"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f37a744d-b49d-4ed7-ab3b-abd59af14365',
    1788640280.177372,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788640280.177372, "id": "f37a744d-b49d-4ed7-ab3b-abd59af14365"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '20010982-1836-453e-b23f-ff2c213d34b4',
    1788640295.6961398,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788640295.6961398, "id": "20010982-1836-453e-b23f-ff2c213d34b4"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'd5badf86-44c1-4992-9c20-871d3c762aa6',
    1788640300.7023346,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 12, "ts": 1788640300.7023346, "id": "d5badf86-44c1-4992-9c20-871d3c762aa6"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8581f1ff-1fcc-4e46-89ba-f9c4d20a03e3',
    1788640896.232829,
    'HUMAN_CONFIRMATION',
    '{"type": "HUMAN_CONFIRMATION", "bedId": "B10", "user": "dr.chen", "state": "AVAILABLE", "reason": "Forget to update accurate\n", "ts": 1788640896.232829, "id": "8581f1ff-1fcc-4e46-89ba-f9c4d20a03e3"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '18522e75-3e7b-4afd-8dc5-d2d2990d6bd3',
    1788640909.5061579,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B10", "patientId": "WP001", "reason": "Confirmation too stale", "ts": 1788640909.5061579, "id": "18522e75-3e7b-4afd-8dc5-d2d2990d6bd3"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '144267ae-0535-4b1c-ad9b-a873f1fb5a06',
    1788640911.352094,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788640911.352094, "id": "144267ae-0535-4b1c-ad9b-a873f1fb5a06"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '59101c9d-68ea-4b98-a4d6-62b266513d34',
    1788640911.374339,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B10", "patientId": "WP001", "reason": "State is UNKNOWN (need CONFIRMED_AVAILABLE)", "ts": 1788640911.374339, "id": "59101c9d-68ea-4b98-a4d6-62b266513d34"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e87adaa4-6477-4dae-846d-44bf62e473b6',
    1788640916.358571,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 21, "ts": 1788640916.358571, "id": "e87adaa4-6477-4dae-846d-44bf62e473b6"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f05275d8-88cb-4769-9f10-5fcab8521895',
    1788640974.4358034,
    'HUMAN_CONFIRMATION',
    '{"type": "HUMAN_CONFIRMATION", "bedId": "B10", "user": "dr.chen", "state": "AVAILABLE", "reason": "Delayed and written mistake found\n", "ts": 1788640974.4358034, "id": "f05275d8-88cb-4769-9f10-5fcab8521895"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '4ae170ab-44f7-4148-8858-00ea14071ad3',
    1788640985.0372038,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B10", "patientId": "WP002", "reason": "Confirmation too stale", "ts": 1788640985.0372038, "id": "4ae170ab-44f7-4148-8858-00ea14071ad3"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '212edde6-ad11-4b1c-b2ac-8b6d673ecc1b',
    1788640987.3310475,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B10", "patientId": "WP002", "reason": "Confirmation too stale", "ts": 1788640987.3310475, "id": "212edde6-ad11-4b1c-b2ac-8b6d673ecc1b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a1aff9f1-a424-4ee4-a274-6203d05e36a3',
    1788640988.3337383,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B10", "patientId": "WP002", "reason": "Confirmation too stale", "ts": 1788640988.3337383, "id": "a1aff9f1-a424-4ee4-a274-6203d05e36a3"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f4a35152-df08-4a8e-bd9b-6451cbf1c647',
    1788640988.532457,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B10", "patientId": "WP002", "reason": "Confirmation too stale", "ts": 1788640988.532457, "id": "f4a35152-df08-4a8e-bd9b-6451cbf1c647"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '5bb6ed56-dc90-47c6-a43f-276f2d5d954d',
    1788640989.9345527,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788640989.9345527, "id": "5bb6ed56-dc90-47c6-a43f-276f2d5d954d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '6169c490-e0cb-47a3-b2d2-c905c4b120f0',
    1788640994.9454467,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 30, "ts": 1788640994.9454467, "id": "6169c490-e0cb-47a3-b2d2-c905c4b120f0"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'dba0db65-00ba-436f-b592-fa1eef493755',
    1788641034.8739676,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "e5d152ed-a538-4456-ad96-7e9b5cfeadcc", "bedId": "B09", "source": "SOURCE_A", "eventTime": 1788641023.967357, "note": "Ignored \u2013 older than current knowledge", "ts": 1788641034.8739676, "id": "dba0db65-00ba-436f-b592-fa1eef493755"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '2457ac8b-f845-4442-9514-26908a1257b1',
    1788641036.3782008,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B09", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788641036.3782008, "id": "2457ac8b-f845-4442-9514-26908a1257b1"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '66240c31-9070-42b2-91f3-e806e2677748',
    1788641041.011281,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B09", "patientId": "WP001", "reason": "State is OCCUPIED (need CONFIRMED_AVAILABLE)", "ts": 1788641041.011281, "id": "66240c31-9070-42b2-91f3-e806e2677748"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e4cdbbb7-91e6-45db-94f3-891ca929c9cd',
    1788641049.00965,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788641049.00965, "id": "e4cdbbb7-91e6-45db-94f3-891ca929c9cd"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '99da1312-8e4d-4171-8517-42f65c14a50c',
    1788641064.5259428,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788641064.5259428, "id": "99da1312-8e4d-4171-8517-42f65c14a50c"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ef22836c-a545-4147-bde8-00e44a2a35a8',
    1788641080.043585,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788641080.043585, "id": "ef22836c-a545-4147-bde8-00e44a2a35a8"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '339cb92d-cb42-4921-b0a5-2a800bd2ee24',
    1788641095.5624514,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788641095.5624514, "id": "339cb92d-cb42-4921-b0a5-2a800bd2ee24"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1839cd34-83cc-4d89-a89c-7b67393419e6',
    1788641100.5698485,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 12, "ts": 1788641100.5698485, "id": "1839cd34-83cc-4d89-a89c-7b67393419e6"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '998f219e-8904-42b3-9927-65062d085c11',
    1788641164.3082988,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B05", "patientId": "WP-TEST", "reason": "State is OCCUPIED (need CONFIRMED_AVAILABLE)", "ts": 1788641164.3082988, "id": "998f219e-8904-42b3-9927-65062d085c11"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f0e2ef5f-2e64-4baa-bfb6-e16df23ab2db',
    1788641982.6983519,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788641982.6983519, "id": "f0e2ef5f-2e64-4baa-bfb6-e16df23ab2db"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f33e6325-d684-44e1-a98d-4c0a2bacb3bd',
    1788641982.6995327,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788641982.6995327, "id": "f33e6325-d684-44e1-a98d-4c0a2bacb3bd"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '94c1b724-12bc-47b6-897a-775028e85ebc',
    1788641982.7002785,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788641982.7002785, "id": "94c1b724-12bc-47b6-897a-775028e85ebc"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '621d7720-1f43-4d36-892e-8c2c70415537',
    1788642013.2342753,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788642013.2342753, "id": "621d7720-1f43-4d36-892e-8c2c70415537"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '176653ca-4cab-4801-a5df-7d4714c9082b',
    1788642013.2355711,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788642013.2355711, "id": "176653ca-4cab-4801-a5df-7d4714c9082b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'da1730d7-5efe-4aa7-8f3f-22fa25a2b739',
    1788642013.2362778,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788642013.2362778, "id": "da1730d7-5efe-4aa7-8f3f-22fa25a2b739"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '270040f3-9fa7-48e8-a0d2-dfa05f4b1d05',
    1788642018.2425163,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788642018.2425163, "id": "270040f3-9fa7-48e8-a0d2-dfa05f4b1d05"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f7198202-b5b1-4eca-ae6d-c6535f151cb0',
    1788642018.2434719,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788642018.2434719, "id": "f7198202-b5b1-4eca-ae6d-c6535f151cb0"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a4bf416f-719b-46b8-9232-bca236a5d7be',
    1788642018.2440796,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788642018.2440796, "id": "a4bf416f-719b-46b8-9232-bca236a5d7be"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '713f99db-f9da-4d07-8f01-ec22ebbbe783',
    1788642128.3306866,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788642128.3306866, "id": "713f99db-f9da-4d07-8f01-ec22ebbbe783"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'fb76d254-8996-4a89-bd43-0740794d4681',
    1788642128.3319564,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788642128.3319564, "id": "fb76d254-8996-4a89-bd43-0740794d4681"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'bc588829-099f-4288-838a-4a4663dd3537',
    1788642128.3328767,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788642128.3328767, "id": "bc588829-099f-4288-838a-4a4663dd3537"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '0b341f4a-1eb5-4bdd-a76c-0d3f85f075e4',
    1788642158.8658636,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788642158.8658636, "id": "0b341f4a-1eb5-4bdd-a76c-0d3f85f075e4"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '612c5608-6e91-4b23-b23d-694e6678e14a',
    1788642158.8667862,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788642158.8667862, "id": "612c5608-6e91-4b23-b23d-694e6678e14a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c9978721-8311-4b3e-b352-0f8efec8a493',
    1788642158.86736,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788642158.86736, "id": "c9978721-8311-4b3e-b352-0f8efec8a493"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'b60505d9-a31b-4408-8761-080f3723a57c',
    1788642163.8727925,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788642163.8727925, "id": "b60505d9-a31b-4408-8761-080f3723a57c"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c0be04e7-410c-4f81-8b81-7f43bf4296ac',
    1788642163.8739235,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788642163.8739235, "id": "c0be04e7-410c-4f81-8b81-7f43bf4296ac"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a7b85ecf-fe1b-4f03-8d46-dead1c7c78b6',
    1788642163.874531,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788642163.874531, "id": "a7b85ecf-fe1b-4f03-8d46-dead1c7c78b6"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c86c857e-8298-418a-9353-8f2033f10565',
    1788642250.4635549,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788642250.4635549, "id": "c86c857e-8298-418a-9353-8f2033f10565"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '299c53e1-ee9f-47af-a039-94840ad9b8e8',
    1788642250.464208,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788642250.464208, "id": "299c53e1-ee9f-47af-a039-94840ad9b8e8"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '23a45c84-4d8d-4750-8db3-8d8cda0c999c',
    1788642250.4648528,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788642250.4648528, "id": "23a45c84-4d8d-4750-8db3-8d8cda0c999c"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '2a237238-6a83-499e-8852-a784bdbdb39c',
    1788642280.9976368,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788642280.9976368, "id": "2a237238-6a83-499e-8852-a784bdbdb39c"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '37daacd9-e9cc-4fcf-80e1-1be5d9aeaaae',
    1788642280.9985986,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788642280.9985986, "id": "37daacd9-e9cc-4fcf-80e1-1be5d9aeaaae"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'b7d13cb1-98e3-4f73-a9f9-093a69c02c5f',
    1788642280.9991639,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788642280.9991639, "id": "b7d13cb1-98e3-4f73-a9f9-093a69c02c5f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '6969b993-6863-42cd-9b7b-3d86dbe60c12',
    1788642286.005148,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 12, "ts": 1788642286.005148, "id": "6969b993-6863-42cd-9b7b-3d86dbe60c12"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '10685367-05a2-4486-9fa6-f168ac519c0e',
    1788642286.0055742,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B09", "reason": "RECONCILIATION_TIMEOUT", "retries": 12, "ts": 1788642286.0055742, "id": "10685367-05a2-4486-9fa6-f168ac519c0e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '3dc249a9-d2fc-4c71-8cfc-33c9bc64588d',
    1788642286.0059328,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 12, "ts": 1788642286.0059328, "id": "3dc249a9-d2fc-4c71-8cfc-33c9bc64588d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'bd408b16-0531-43a1-b071-d5efb47cc40b',
    1788642470.8411827,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788642470.8411827, "id": "bd408b16-0531-43a1-b071-d5efb47cc40b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '6b69bb90-7d28-49df-8076-3503c0ba96a9',
    1788642470.84216,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788642470.84216, "id": "6b69bb90-7d28-49df-8076-3503c0ba96a9"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1bd90e3f-e275-4307-81a3-4abb190beabb',
    1788642470.8427212,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788642470.8427212, "id": "1bd90e3f-e275-4307-81a3-4abb190beabb"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '3ff0e8a2-3f05-43c8-af64-a666119d3d1e',
    1788642501.375178,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788642501.375178, "id": "3ff0e8a2-3f05-43c8-af64-a666119d3d1e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'af517079-a303-41e4-b092-81f57e1cfc9a',
    1788642501.3758466,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788642501.3758466, "id": "af517079-a303-41e4-b092-81f57e1cfc9a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'cb601792-f765-47e3-8d1b-705cc080f48b',
    1788642501.37628,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788642501.37628, "id": "cb601792-f765-47e3-8d1b-705cc080f48b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '02b0e28e-bed2-46ad-a171-06ea9059870f',
    1788642506.3814046,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788642506.3814046, "id": "02b0e28e-bed2-46ad-a171-06ea9059870f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a4141800-7377-4196-b751-89efcf8370ef',
    1788642506.382367,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788642506.382367, "id": "a4141800-7377-4196-b751-89efcf8370ef"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8c54c527-bf9e-4366-b4cf-ef0cfff62bca',
    1788642506.3830016,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788642506.3830016, "id": "8c54c527-bf9e-4366-b4cf-ef0cfff62bca"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e989ae43-9e3f-4b2e-a1b2-87e200ccde32',
    1788643818.9333556,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B05", "patientId": "WP-TEST", "reason": "State is OCCUPIED (need CONFIRMED_AVAILABLE)", "ts": 1788643818.9333556, "id": "e989ae43-9e3f-4b2e-a1b2-87e200ccde32"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '42c7aad7-a29e-4db9-bb7e-a272a2b32c7f',
    1788644089.071722,
    'EVENT_REJECTED',
    '{"type": "EVENT_REJECTED", "eventId": "150b63f3-10f1-4307-961b-492472ef06b7", "reason": "Duplicate eventId", "source": "SOURCE_A", "bedId": "B05", "ts": 1788644089.071722, "id": "42c7aad7-a29e-4db9-bb7e-a272a2b32c7f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'AUD-92',
    1788644089.0723279,
    'DUPLICATE_DETECTED',
    '{"ts": 1788644089.0723279, "type": "DUPLICATE_DETECTED", "eventId": "150b63f3-10f1-4307-961b-492472ef06b7", "bedId": "B05", "source": "SOURCE_A"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ad29129c-a5c6-454c-9337-33f0a6758ace',
    1788644090.8231525,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "042175be-a38d-4e21-9472-8a48823a149a", "bedId": "B05", "source": "SOURCE_A", "eventTime": 1788644080.821148, "note": "Ignored \u2013 older than current knowledge", "ts": 1788644090.8231525, "id": "ad29129c-a5c6-454c-9337-33f0a6758ace"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '91d4708c-a1dc-4d96-88c8-4acffaa2128f',
    1788644094.2837777,
    'RESERVATION_COMMITTED',
    '{"type": "RESERVATION_COMMITTED", "bedId": "B05", "patientId": "WP-TEST", "reservationId": "2719d4c1-be68-4048-a65c-0ca88ff6aae9", "ts": 1788644094.2837777, "id": "91d4708c-a1dc-4d96-88c8-4acffaa2128f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '5a8e7b1d-1514-4c1e-ab82-b3e0cd3dfc22',
    1788644100.3697667,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788644100.3697667, "id": "5a8e7b1d-1514-4c1e-ab82-b3e0cd3dfc22"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8c183630-a944-4046-86a5-0bca3bdedc3b',
    1788644101.4815283,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788644101.4815283, "id": "8c183630-a944-4046-86a5-0bca3bdedc3b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '9fd0f9e0-2a5d-447a-bf95-343db212d59d',
    1788644103.5524473,
    'EVENT_REJECTED',
    '{"type": "EVENT_REJECTED", "eventId": "b8ca0f03-08e1-4163-9d80-ee7871fb9ee3", "reason": "Duplicate eventId", "source": "SOURCE_A", "bedId": "B05", "ts": 1788644103.5524473, "id": "9fd0f9e0-2a5d-447a-bf95-343db212d59d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'AUD-98',
    1788644103.5529482,
    'DUPLICATE_DETECTED',
    '{"ts": 1788644103.5529482, "type": "DUPLICATE_DETECTED", "eventId": "b8ca0f03-08e1-4163-9d80-ee7871fb9ee3", "bedId": "B05", "source": "SOURCE_A"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e2848b8f-9203-48ab-a1e2-ee3b8768ec50',
    1788644103.5907028,
    'RAPID_STATE_CHANGES',
    '{"ts": 1788644103.5907028, "type": "RAPID_STATE_CHANGES", "bedId": "B05", "count": 9, "id": "e2848b8f-9203-48ab-a1e2-ee3b8768ec50"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'b8b43143-b6da-445c-b40b-aa4d25a5fdc5',
    1788644105.8718128,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "c85692b5-830c-4626-bd9c-51e5f8418259", "bedId": "B05", "source": "SOURCE_A", "eventTime": 1788644095.8706226, "note": "Ignored \u2013 older than current knowledge", "ts": 1788644105.8718128, "id": "b8b43143-b6da-445c-b40b-aa4d25a5fdc5"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ad99b96c-9e27-4816-bd95-e7c14fefb255',
    1788644107.4439204,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B05", "patientId": "WP-TEST", "reason": "State is UNKNOWN (need CONFIRMED_AVAILABLE)", "ts": 1788644107.4439204, "id": "ad99b96c-9e27-4816-bd95-e7c14fefb255"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '584d5a73-39df-4601-bb23-02a159c499fa',
    1788644111.099993,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B05", "reason": "RECONCILIATION_TIMEOUT", "retries": 20, "ts": 1788644111.099993, "id": "584d5a73-39df-4601-bb23-02a159c499fa"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '3c3235b0-4f6b-4c66-a61a-a593612b2336',
    1788644226.1629372,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "b64bd1f8-2efa-4acf-ad7c-f8cc382d2dfe", "bedId": "B05", "source": "SOURCE_A", "eventTime": 1788644216.162271, "note": "Ignored \u2013 older than current knowledge", "ts": 1788644226.1629372, "id": "3c3235b0-4f6b-4c66-a61a-a593612b2336"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c7c63d16-c328-4ad2-a279-d961949de33d',
    1788644235.412168,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788644235.412168, "id": "c7c63d16-c328-4ad2-a279-d961949de33d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '39ba17dd-be9b-43d9-b6ff-b6aea63866fd',
    1788644235.4126947,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788644235.4126947, "id": "39ba17dd-be9b-43d9-b6ff-b6aea63866fd"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '280022ce-22e9-4040-910d-8c6faba33775',
    1788644235.412983,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788644235.412983, "id": "280022ce-22e9-4040-910d-8c6faba33775"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8ed6e8ba-ff25-4d56-90fd-7cc8d41561cb',
    1788644256.253771,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B05", "ts": 1788644256.253771, "id": "8ed6e8ba-ff25-4d56-90fd-7cc8d41561cb"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f3a92b0c-22a5-41ae-89a6-29ba2de59400',
    1788644265.9471843,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788644265.9471843, "id": "f3a92b0c-22a5-41ae-89a6-29ba2de59400"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '55fb4c7a-910d-4f6a-97b6-f81afcb1fcb9',
    1788644265.948117,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788644265.948117, "id": "55fb4c7a-910d-4f6a-97b6-f81afcb1fcb9"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '388a6298-c251-4250-869e-63f56e40e72f',
    1788644265.9488974,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788644265.9488974, "id": "388a6298-c251-4250-869e-63f56e40e72f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '3c30f037-2f04-4516-8759-53c255c2e53a',
    1788644270.9555333,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788644270.9555333, "id": "3c30f037-2f04-4516-8759-53c255c2e53a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '44568594-4aff-4f4f-a85a-dd22fd1d0a5f',
    1788644270.9559178,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788644270.9559178, "id": "44568594-4aff-4f4f-a85a-dd22fd1d0a5f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'b1c11dce-b390-49bf-98ee-6dd71a4da46b',
    1788644270.956105,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "ts": 1788644270.956105, "id": "b1c11dce-b390-49bf-98ee-6dd71a4da46b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'fa95a65b-0a78-4939-9bfa-994c2ac15cd0',
    1788644286.7860334,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B05", "ts": 1788644286.7860334, "id": "fa95a65b-0a78-4939-9bfa-994c2ac15cd0"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '46b6d718-944e-4a72-ad12-e1438ddc90ff',
    1788644291.7933562,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B05", "reason": "RECONCILIATION_TIMEOUT", "retries": 31, "ts": 1788644291.7933562, "id": "46b6d718-944e-4a72-ad12-e1438ddc90ff"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1e77ff68-c5ea-471b-9a76-5b2f43fb106f',
    1788644357.0873797,
    'EVENT_REJECTED',
    '{"type": "EVENT_REJECTED", "eventId": "a97c9790-cf6a-4f68-8f0f-cfa8f9b9423e", "reason": "Duplicate eventId", "source": "SOURCE_A", "bedId": "B05", "ts": 1788644357.0873797, "id": "1e77ff68-c5ea-471b-9a76-5b2f43fb106f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'AUD-117',
    1788644357.0876107,
    'DUPLICATE_DETECTED',
    '{"ts": 1788644357.0876107, "type": "DUPLICATE_DETECTED", "eventId": "a97c9790-cf6a-4f68-8f0f-cfa8f9b9423e", "bedId": "B05", "source": "SOURCE_A"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '456fb5b6-f026-4afb-90d2-ad69dd31e2c4',
    1788644418.4235814,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788644418.4235814, "id": "456fb5b6-f026-4afb-90d2-ad69dd31e2c4"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f9c7a72a-5455-405d-9a95-f29ae019ce94',
    1788644538.420945,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B05", "patientId": "WP-TEST", "reason": "State is OCCUPIED (need CONFIRMED_AVAILABLE)", "ts": 1788644538.420945, "id": "f9c7a72a-5455-405d-9a95-f29ae019ce94"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '11b77450-e801-49d0-9539-1787465f92ab',
    1788644682.2584472,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "d5d74990-f4d1-4b3c-afe7-96aa15cbe4b5", "bedId": "B05", "source": "SOURCE_A", "eventTime": 1788644672.2572203, "note": "Ignored \u2013 older than current knowledge", "ts": 1788644682.2584472, "id": "11b77450-e801-49d0-9539-1787465f92ab"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '51b90267-3ba4-4e5e-9d17-7687c3c39b99',
    1788644683.88633,
    'EVENT_REJECTED',
    '{"type": "EVENT_REJECTED", "eventId": "4184b2bf-8205-4a84-a02a-783ede1e7eb9", "reason": "Duplicate eventId", "source": "SOURCE_A", "bedId": "B05", "ts": 1788644683.88633, "id": "51b90267-3ba4-4e5e-9d17-7687c3c39b99"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'AUD-122',
    1788644683.8867435,
    'DUPLICATE_DETECTED',
    '{"ts": 1788644683.8867435, "type": "DUPLICATE_DETECTED", "eventId": "4184b2bf-8205-4a84-a02a-783ede1e7eb9", "bedId": "B05", "source": "SOURCE_A"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c6354120-90c3-4aa0-9a17-5dbefcb70f15',
    1788644687.5557892,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788644687.5557892, "id": "c6354120-90c3-4aa0-9a17-5dbefcb70f15"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'adb0df10-fea3-45c9-9971-5ff0e5f425bf',
    1788644689.2339394,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B05", "patientId": "WP-TEST", "reason": "State is OCCUPIED (need CONFIRMED_AVAILABLE)", "ts": 1788644689.2339394, "id": "adb0df10-fea3-45c9-9971-5ff0e5f425bf"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '87482280-29db-4222-ba7b-0b7578d617e3',
    1788644752.7568352,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "884728b4-eb81-4e56-901c-956341c22981", "bedId": "B09", "source": "SOURCE_A", "eventTime": 1788644741.8473542, "note": "Ignored \u2013 older than current knowledge", "ts": 1788644752.7568352, "id": "87482280-29db-4222-ba7b-0b7578d617e3"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '2efb51b5-e624-44c2-b0bc-8aea0dbe664f',
    1788644754.2617147,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B09", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788644754.2617147, "id": "2efb51b5-e624-44c2-b0bc-8aea0dbe664f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '67e65c94-a222-446f-a53c-ad209a6230b4',
    1788644758.9043632,
    'ALLOCATION_BLOCKED',
    '{"type": "ALLOCATION_BLOCKED", "bedId": "B09", "patientId": "WP001", "reason": "State is OCCUPIED (need CONFIRMED_AVAILABLE)", "ts": 1788644758.9043632, "id": "67e65c94-a222-446f-a53c-ad209a6230b4"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '2a5f1227-07f1-4982-a76f-da8e862b7a74',
    1788644767.333361,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788644767.333361, "id": "2a5f1227-07f1-4982-a76f-da8e862b7a74"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'd02d64e3-0144-4f57-8b42-4613ea15cf8e',
    1788644789.419602,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788644789.419602, "id": "d02d64e3-0144-4f57-8b42-4613ea15cf8e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'de19f6c1-c767-4997-9f14-2a72eded2210',
    1788644808.3778458,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788644808.3778458, "id": "de19f6c1-c767-4997-9f14-2a72eded2210"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '676e645b-bacd-4de9-a5ce-8d00e94137eb',
    1788644808.3791595,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788644808.3791595, "id": "676e645b-bacd-4de9-a5ce-8d00e94137eb"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '7f6727fe-b5fe-448c-ae02-5daf17063242',
    1788644808.3800735,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788644808.3800735, "id": "7f6727fe-b5fe-448c-ae02-5daf17063242"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ed0159c5-fd77-4193-a390-e3a4fed5204b',
    1788644823.899059,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788644823.899059, "id": "ed0159c5-fd77-4193-a390-e3a4fed5204b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'b69da1e6-5244-4d64-b730-2991a2b661e3',
    1788644823.8997757,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788644823.8997757, "id": "b69da1e6-5244-4d64-b730-2991a2b661e3"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ec4a5251-1034-4933-8983-aa4b8369ccc9',
    1788644823.9001513,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788644823.9001513, "id": "ec4a5251-1034-4933-8983-aa4b8369ccc9"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '50d59731-fc4e-429c-9426-22d1ce324d23',
    1788644840.8825612,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788644840.8825612, "id": "50d59731-fc4e-429c-9426-22d1ce324d23"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '09862e8c-68f0-4ecc-b916-d5d2d5fec2d2',
    1788644845.9221356,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B05", "reason": "RECONCILIATION_TIMEOUT", "retries": 13, "ts": 1788644845.9221356, "id": "09862e8c-68f0-4ecc-b916-d5d2d5fec2d2"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1ca1351e-5e78-4dc1-878d-ea2cb53a9a7c',
    1788644849.427343,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788644849.427343, "id": "1ca1351e-5e78-4dc1-878d-ea2cb53a9a7c"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '94245a21-4c80-4098-9c20-e098e95dab95',
    1788644849.4279904,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788644849.4279904, "id": "94245a21-4c80-4098-9c20-e098e95dab95"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8f87fe70-ec3d-4e7f-a884-7869ff6d5e19',
    1788644849.4284136,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788644849.4284136, "id": "8f87fe70-ec3d-4e7f-a884-7869ff6d5e19"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8837248e-0398-4446-9977-70a9fef69f76',
    1788644864.9424489,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788644864.9424489, "id": "8837248e-0398-4446-9977-70a9fef69f76"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'b2f0dc73-a53e-4db9-9c5d-02c163aedc52',
    1788644864.9446778,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788644864.9446778, "id": "b2f0dc73-a53e-4db9-9c5d-02c163aedc52"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1809a8d5-17bf-4e5d-9cde-7e1e91bc5cfa',
    1788644864.9453306,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788644864.9453306, "id": "1809a8d5-17bf-4e5d-9cde-7e1e91bc5cfa"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '57820973-6e19-4043-ab0f-26dca884e25e',
    1788644880.4634073,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788644880.4634073, "id": "57820973-6e19-4043-ab0f-26dca884e25e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '031f5d42-2eb4-434d-aa83-98cb4dc32a95',
    1788644880.4646065,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788644880.4646065, "id": "031f5d42-2eb4-434d-aa83-98cb4dc32a95"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '0f1cf821-19a1-4fce-acac-f91a49fca4c5',
    1788644880.4657788,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788644880.4657788, "id": "0f1cf821-19a1-4fce-acac-f91a49fca4c5"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f9998d78-4172-402e-a687-f2ab3d64f354',
    1788644895.9835486,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788644895.9835486, "id": "f9998d78-4172-402e-a687-f2ab3d64f354"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ab732921-fea5-4ecc-9fb0-70b388404e8e',
    1788644895.9851363,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788644895.9851363, "id": "ab732921-fea5-4ecc-9fb0-70b388404e8e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '4201f110-3c61-46f6-8058-ae7a1c9329e6',
    1788644895.986185,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788644895.986185, "id": "4201f110-3c61-46f6-8058-ae7a1c9329e6"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '0f72c42c-8b9c-4e31-a5ac-67d1280d1e03',
    1788644900.9926655,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 12, "ts": 1788644900.9926655, "id": "0f72c42c-8b9c-4e31-a5ac-67d1280d1e03"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8ca1e07f-08d2-40e2-b475-b341471e4826',
    1788644900.994379,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B09", "reason": "RECONCILIATION_TIMEOUT", "retries": 12, "ts": 1788644900.994379, "id": "8ca1e07f-08d2-40e2-b475-b341471e4826"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c1f07325-4d40-4541-b77f-34d927c85b9b',
    1788644900.9957056,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 12, "ts": 1788644900.9957056, "id": "c1f07325-4d40-4541-b77f-34d927c85b9b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8a2646ac-6cf1-4f0a-96ef-e88598bf237b',
    1788645773.021195,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788645773.021195, "id": "8a2646ac-6cf1-4f0a-96ef-e88598bf237b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'bd518b6d-a2ff-46ae-9b27-99ea38ab6319',
    1788645773.0226877,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788645773.0226877, "id": "bd518b6d-a2ff-46ae-9b27-99ea38ab6319"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '6e13d6d8-6f6a-4164-9376-4f639e7bdb94',
    1788645773.0240257,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788645773.0240257, "id": "6e13d6d8-6f6a-4164-9376-4f639e7bdb94"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '992c30c3-ae97-4895-83f7-b6477a9b0033',
    1788645803.557494,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788645803.557494, "id": "992c30c3-ae97-4895-83f7-b6477a9b0033"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'cf27248c-5d5e-460b-ae59-6550872bfafb',
    1788645803.55852,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788645803.55852, "id": "cf27248c-5d5e-460b-ae59-6550872bfafb"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ff585d23-c382-4018-b517-300d2dd8ab04',
    1788645803.5592744,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788645803.5592744, "id": "ff585d23-c382-4018-b517-300d2dd8ab04"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ff713742-ceb4-45aa-9622-89d7a634ace1',
    1788645808.5660028,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788645808.5660028, "id": "ff713742-ceb4-45aa-9622-89d7a634ace1"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f61624a2-71f9-45af-a255-19e95636cdb3',
    1788645808.5664058,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788645808.5664058, "id": "f61624a2-71f9-45af-a255-19e95636cdb3"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '3aecd8d4-90e3-43ee-83de-c775a8326916',
    1788645808.566673,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788645808.566673, "id": "3aecd8d4-90e3-43ee-83de-c775a8326916"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'dbcc5a2b-8d44-436f-a67f-fb36625b04ac',
    1788664859.9133365,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788664859.9133365, "id": "dbcc5a2b-8d44-436f-a67f-fb36625b04ac"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ac183986-0bf2-4a32-b49a-eead7535089a',
    1788664859.9137866,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788664859.9137866, "id": "ac183986-0bf2-4a32-b49a-eead7535089a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '315317ac-ac98-4a8b-b943-3c72376294f9',
    1788664859.9139884,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788664859.9139884, "id": "315317ac-ac98-4a8b-b943-3c72376294f9"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e851f64c-2449-415b-a9cc-58500637dadb',
    1788664890.4447625,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788664890.4447625, "id": "e851f64c-2449-415b-a9cc-58500637dadb"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '2d71c1b1-bc55-43b0-a27f-03ce566b55d8',
    1788664890.445753,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788664890.445753, "id": "2d71c1b1-bc55-43b0-a27f-03ce566b55d8"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '689706a0-4eaa-43f7-8e3d-8ae895707e02',
    1788664890.4463406,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788664890.4463406, "id": "689706a0-4eaa-43f7-8e3d-8ae895707e02"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '60084d52-0b71-481a-842e-5c3fcec9534a',
    1788664895.4524653,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788664895.4524653, "id": "60084d52-0b71-481a-842e-5c3fcec9534a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1561dde9-f01a-4592-a3a0-0073e0362974',
    1788664895.452978,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788664895.452978, "id": "1561dde9-f01a-4592-a3a0-0073e0362974"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '29ab4e61-8643-479d-9c03-e5dc7927f9aa',
    1788664895.4532497,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788664895.4532497, "id": "29ab4e61-8643-479d-9c03-e5dc7927f9aa"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ac76c93b-554e-4110-b3dc-a19528bbb6e0',
    1788666228.872394,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788666228.872394, "id": "ac76c93b-554e-4110-b3dc-a19528bbb6e0"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a9ef837d-537e-488f-a859-275ba271d48b',
    1788666228.8736415,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788666228.8736415, "id": "a9ef837d-537e-488f-a859-275ba271d48b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '4a7510fe-a6c9-4e25-ad7a-85c9ff6f773d',
    1788666228.874569,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788666228.874569, "id": "4a7510fe-a6c9-4e25-ad7a-85c9ff6f773d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f4b19cf4-12a6-4f13-895e-5d4d7f19b99f',
    1788666259.410137,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788666259.410137, "id": "f4b19cf4-12a6-4f13-895e-5d4d7f19b99f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'db28f6a8-1d9c-4fa2-a64e-4cec4c7602cb',
    1788666259.411411,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788666259.411411, "id": "db28f6a8-1d9c-4fa2-a64e-4cec4c7602cb"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '571722ec-99bb-413e-ae35-de369317d5b0',
    1788666259.4116871,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788666259.4116871, "id": "571722ec-99bb-413e-ae35-de369317d5b0"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8ed01fea-5498-47b8-b2d9-eb459f7d52bd',
    1788666264.417508,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788666264.417508, "id": "8ed01fea-5498-47b8-b2d9-eb459f7d52bd"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '5bb26b04-cc83-439c-9e2b-86ccb25bd59b',
    1788666264.4178948,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788666264.4178948, "id": "5bb26b04-cc83-439c-9e2b-86ccb25bd59b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e7dc399a-3d92-4eac-9136-ca532f493972',
    1788666264.418087,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788666264.418087, "id": "e7dc399a-3d92-4eac-9136-ca532f493972"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '30dae70d-eb39-4d70-be41-b5e341cf7824',
    1788666347.1996257,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788666347.1996257, "id": "30dae70d-eb39-4d70-be41-b5e341cf7824"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'dc38907c-dc28-4304-9d71-13c29f51584f',
    1788666347.2000074,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788666347.2000074, "id": "dc38907c-dc28-4304-9d71-13c29f51584f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '4b80be68-9571-4213-950a-92eb61ca7a96',
    1788666347.2002048,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788666347.2002048, "id": "4b80be68-9571-4213-950a-92eb61ca7a96"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c3def2b5-4d66-4b5e-b9e4-5c239b042ffd',
    1788666377.73492,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788666377.73492, "id": "c3def2b5-4d66-4b5e-b9e4-5c239b042ffd"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e05ab2c1-ff03-470d-bf36-c8227a4d31e3',
    1788666377.7358027,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788666377.7358027, "id": "e05ab2c1-ff03-470d-bf36-c8227a4d31e3"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '432ba0b1-4b42-402b-83bd-0aaf5cebbcd8',
    1788666377.736559,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788666377.736559, "id": "432ba0b1-4b42-402b-83bd-0aaf5cebbcd8"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '30bb6ed8-2113-461d-85b2-dc0f3a796e0a',
    1788666382.742881,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788666382.742881, "id": "30bb6ed8-2113-461d-85b2-dc0f3a796e0a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '92b555a5-b89c-4fa0-b5b8-0faacbaa6101',
    1788666382.7437901,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788666382.7437901, "id": "92b555a5-b89c-4fa0-b5b8-0faacbaa6101"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'dd4de0af-db08-45e5-8914-35541f5b536e',
    1788666382.7443247,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788666382.7443247, "id": "dd4de0af-db08-45e5-8914-35541f5b536e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8c8735fd-508b-47f7-8db7-a7b5580b2fd2',
    1788666456.3252413,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B05", "ts": 1788666456.3252413, "id": "8c8735fd-508b-47f7-8db7-a7b5580b2fd2"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '66a29c6b-f73b-4ad4-a04c-6ed6d7bd0f7c',
    1788666486.8592603,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B05", "ts": 1788666486.8592603, "id": "66a29c6b-f73b-4ad4-a04c-6ed6d7bd0f7c"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '602594f7-a7f1-4a9c-a944-6d3fbbc84ed4',
    1788666491.8663867,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B05", "reason": "RECONCILIATION_TIMEOUT", "retries": 14, "recommendation": "INSUFFICIENT_EVIDENCE", "ts": 1788666491.8663867, "id": "602594f7-a7f1-4a9c-a944-6d3fbbc84ed4"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '23f7034c-2f4a-49cb-b22e-16d5c16e9aae',
    1788666500.4360647,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788666500.4360647, "id": "23f7034c-2f4a-49cb-b22e-16d5c16e9aae"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8df182a9-9b9e-45be-8f0d-f613e28d6575',
    1788666708.2059922,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788666708.2059922, "id": "8df182a9-9b9e-45be-8f0d-f613e28d6575"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '05aae9d8-7168-40a2-837f-c5ffc0533b54',
    1788666708.207689,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788666708.207689, "id": "05aae9d8-7168-40a2-837f-c5ffc0533b54"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '52cea959-99e7-4051-b6da-78511f385976',
    1788666708.2082415,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788666708.2082415, "id": "52cea959-99e7-4051-b6da-78511f385976"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '70c1409e-4e76-4eb5-af4d-02c16d88664b',
    1788666738.742207,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788666738.742207, "id": "70c1409e-4e76-4eb5-af4d-02c16d88664b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '289bebc5-6e6a-421c-942e-838cba166dea',
    1788666738.7435918,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788666738.7435918, "id": "289bebc5-6e6a-421c-942e-838cba166dea"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '5bfccd3a-5854-4777-92fe-1dd41d8c11ec',
    1788666738.7452407,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788666738.7452407, "id": "5bfccd3a-5854-4777-92fe-1dd41d8c11ec"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '0212b1ac-2c49-4a74-8349-4835ab34a51f',
    1788666743.751304,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788666743.751304, "id": "0212b1ac-2c49-4a74-8349-4835ab34a51f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '69a5ba60-0e00-4262-95a9-48b474cf96ab',
    1788666743.7523909,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788666743.7523909, "id": "69a5ba60-0e00-4262-95a9-48b474cf96ab"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '063d7d78-6b0d-4e57-b6f6-b8f482eaf3ef',
    1788666743.7531707,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788666743.7531707, "id": "063d7d78-6b0d-4e57-b6f6-b8f482eaf3ef"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c8adbd40-b5fc-440b-9c82-b47579350de8',
    1788667220.774852,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788667220.774852, "id": "c8adbd40-b5fc-440b-9c82-b47579350de8"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8a008d06-1fac-46db-9c5e-5a2d32587635',
    1788667220.7764733,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788667220.7764733, "id": "8a008d06-1fac-46db-9c5e-5a2d32587635"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '91741662-a22d-49da-bb6e-c4a548d89f8a',
    1788667220.7778888,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788667220.7778888, "id": "91741662-a22d-49da-bb6e-c4a548d89f8a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ad13fde4-3a07-4ba9-950a-a6d4c60e4c49',
    1788667233.6408596,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "4aec2704-ef6c-4b5a-8a9d-15f4001b89c4", "bedId": "B09", "source": "SOURCE_A", "eventTime": 1788667222.7329698, "note": "Ignored \u2013 older than current knowledge", "ts": 1788667233.6408596, "id": "ad13fde4-3a07-4ba9-950a-a6d4c60e4c49"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '433abcb6-b622-466d-9ec7-23c9fa4e87a2',
    1788667235.1461852,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B09", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788667235.1461852, "id": "433abcb6-b622-466d-9ec7-23c9fa4e87a2"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '9163db03-156f-41d1-b8bf-9e3030256c61',
    1788667239.7800574,
    'ALLOCATION_FAILED_NO_ALTERNATIVES',
    '{"type": "ALLOCATION_FAILED_NO_ALTERNATIVES", "bedId": "B09", "patientId": "WP001", "reason": "State is OCCUPIED (need CONFIRMED_AVAILABLE)", "ts": 1788667239.7800574, "id": "9163db03-156f-41d1-b8bf-9e3030256c61"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '55f44015-a3ae-4cc5-a65f-0a7b20cd3e8e',
    1788667247.8115637,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788667247.8115637, "id": "55f44015-a3ae-4cc5-a65f-0a7b20cd3e8e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '50cc71b8-8d42-4bdd-9764-edc6f5e310f6',
    1788667263.3343065,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788667263.3343065, "id": "50cc71b8-8d42-4bdd-9764-edc6f5e310f6"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '3bd4f070-ab4c-4d92-a955-7275ff0b6752',
    1788667282.3566492,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788667282.3566492, "id": "3bd4f070-ab4c-4d92-a955-7275ff0b6752"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f3f32d56-4cb3-4c79-9013-9834453913d2',
    1788667297.8772068,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788667297.8772068, "id": "f3f32d56-4cb3-4c79-9013-9834453913d2"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '7c742cac-c182-4900-9c9c-06502a94e843',
    1788667302.8841755,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 13, "recommendation": "LIKELY_AVAILABLE", "ts": 1788667302.8841755, "id": "7c742cac-c182-4900-9c9c-06502a94e843"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '009991aa-9ceb-487a-b75c-c0b94a60e037',
    1788667701.8863401,
    'HUMAN_CONFIRMATION',
    '{"type": "HUMAN_CONFIRMATION", "bedId": "B10", "user": "auto-reviewer", "state": "OCCUPIED", "reason": "Likely Available because there are 2 signals for availability (clean/empty context).", "ts": 1788667701.8863401, "id": "009991aa-9ceb-487a-b75c-c0b94a60e037"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '09e9068f-47f3-4018-9e08-0e95d2032516',
    1788667768.3690352,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "61e366b4-dffa-45e9-ba2d-58dca622c8f3", "bedId": "B09", "source": "SOURCE_A", "eventTime": 1788667757.4613323, "note": "Ignored \u2013 older than current knowledge", "ts": 1788667768.3690352, "id": "09e9068f-47f3-4018-9e08-0e95d2032516"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c2a8bfe7-ad07-41e9-9103-e9d49d4328f9',
    1788667769.8733578,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B09", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788667769.8733578, "id": "c2a8bfe7-ad07-41e9-9103-e9d49d4328f9"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a5f226e3-76ec-47c9-a4cc-b1a5b0da8295',
    1788667774.479699,
    'ALLOCATION_FAILED_NO_ALTERNATIVES',
    '{"type": "ALLOCATION_FAILED_NO_ALTERNATIVES", "bedId": "B09", "patientId": "WP001", "reason": "State is OCCUPIED (need CONFIRMED_AVAILABLE)", "ts": 1788667774.479699, "id": "a5f226e3-76ec-47c9-a4cc-b1a5b0da8295"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '945f2bee-f1f2-4885-aa9e-eaa1ae31bea6',
    1788667782.4924667,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788667782.4924667, "id": "945f2bee-f1f2-4885-aa9e-eaa1ae31bea6"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f7b61568-7c9d-46b0-bb65-40dc7b98f738',
    1788667798.0130396,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788667798.0130396, "id": "f7b61568-7c9d-46b0-bb65-40dc7b98f738"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '02111638-63d8-4f5b-b540-f3b58b9e1534',
    1788667813.5327678,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788667813.5327678, "id": "02111638-63d8-4f5b-b540-f3b58b9e1534"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a09c3818-991b-493d-a2f0-a31f07071dde',
    1788667829.0496662,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788667829.0496662, "id": "a09c3818-991b-493d-a2f0-a31f07071dde"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '487cc0e7-4b9e-46b1-adf9-3ca67ed141d9',
    1788667834.0566175,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 12, "recommendation": "LIKELY_AVAILABLE", "ts": 1788667834.0566175, "id": "487cc0e7-4b9e-46b1-adf9-3ca67ed141d9"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'bbc5f091-91ba-43b7-b11d-cb1e1fbda88f',
    1788669893.2056274,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788669893.2056274, "id": "bbc5f091-91ba-43b7-b11d-cb1e1fbda88f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '7864e31c-7fb9-4500-b799-118a924dd852',
    1788669893.2060735,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788669893.2060735, "id": "7864e31c-7fb9-4500-b799-118a924dd852"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '3e4f097b-f9dd-4ba7-9b7c-b1379c4e4a6f',
    1788669893.2062795,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788669893.2062795, "id": "3e4f097b-f9dd-4ba7-9b7c-b1379c4e4a6f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'bb2dc470-8afa-42fe-b921-cbee031f8d0c',
    1788669923.7425168,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788669923.7425168, "id": "bb2dc470-8afa-42fe-b921-cbee031f8d0c"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a1ce6231-a179-4611-938f-711e106a0d21',
    1788669923.7429376,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788669923.7429376, "id": "a1ce6231-a179-4611-938f-711e106a0d21"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a7b01d7e-b8f4-455e-a904-b496b3489b6e',
    1788669923.7432044,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788669923.7432044, "id": "a7b01d7e-b8f4-455e-a904-b496b3489b6e"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '650fc1c9-f11a-43b5-bdf7-13fa4b5611a0',
    1788669928.7484996,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788669928.7484996, "id": "650fc1c9-f11a-43b5-bdf7-13fa4b5611a0"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e36fced3-0a2f-4947-b2ac-312ecd33b44a',
    1788669928.749296,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788669928.749296, "id": "e36fced3-0a2f-4947-b2ac-312ecd33b44a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '5b449ce0-41a3-441b-bb38-bca11c7ce0b0',
    1788669928.7498097,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788669928.7498097, "id": "5b449ce0-41a3-441b-bb38-bca11c7ce0b0"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8e6d27f7-7c44-4eb3-8e26-575326181647',
    1788673233.8387978,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788673233.8387978, "id": "8e6d27f7-7c44-4eb3-8e26-575326181647"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '61b0a665-ec45-4b1e-a29b-c1f7b73bd23d',
    1788673233.8400133,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788673233.8400133, "id": "61b0a665-ec45-4b1e-a29b-c1f7b73bd23d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e6f1b6ad-1d73-430b-a98e-169eea1f60bb',
    1788673233.8404973,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788673233.8404973, "id": "e6f1b6ad-1d73-430b-a98e-169eea1f60bb"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1e0a3f16-d87e-481f-b1f7-b72bb3305c94',
    1788673297.9075825,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788673297.9075825, "id": "1e0a3f16-d87e-481f-b1f7-b72bb3305c94"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a90acfa1-95c1-4720-a568-034bdcd6345a',
    1788673297.9086096,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788673297.9086096, "id": "a90acfa1-95c1-4720-a568-034bdcd6345a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8c5881e7-24ab-4123-80c2-6cad3bd4f148',
    1788673297.9095728,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788673297.9095728, "id": "8c5881e7-24ab-4123-80c2-6cad3bd4f148"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'faef0aa6-f614-4275-8950-4014123b2865',
    1788673328.4371188,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788673328.4371188, "id": "faef0aa6-f614-4275-8950-4014123b2865"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '12525488-26f6-40b5-8d1a-6b646ce33167',
    1788673328.4375663,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788673328.4375663, "id": "12525488-26f6-40b5-8d1a-6b646ce33167"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '52dda7ae-836a-4ec0-8eca-fdacd892385b',
    1788673328.4378107,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788673328.4378107, "id": "52dda7ae-836a-4ec0-8eca-fdacd892385b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '930ee87e-2ba2-4874-9544-ab5e29c9a227',
    1788673333.4425082,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788673333.4425082, "id": "930ee87e-2ba2-4874-9544-ab5e29c9a227"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '84d89bfa-0d7f-402a-964b-6645b5511ac5',
    1788673333.4436033,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B09", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788673333.4436033, "id": "84d89bfa-0d7f-402a-964b-6645b5511ac5"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'd6a798ce-a4e0-4fbc-afb2-ac517880c9c0',
    1788673333.4443297,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788673333.4443297, "id": "d6a798ce-a4e0-4fbc-afb2-ac517880c9c0"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'abb4e0bf-012d-483a-bcc8-3b40fd472db4',
    1788673373.0030558,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788673373.0030558, "id": "abb4e0bf-012d-483a-bcc8-3b40fd472db4"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '9d46cb9e-7fd5-431c-8f4d-d660a13caccc',
    1788673373.0035136,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788673373.0035136, "id": "9d46cb9e-7fd5-431c-8f4d-d660a13caccc"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c1972906-0041-46c3-8841-e1637694b55f',
    1788673373.003787,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788673373.003787, "id": "c1972906-0041-46c3-8841-e1637694b55f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '220c629b-af26-4ddb-9c44-8b1722e4ffe5',
    1788673403.5419023,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788673403.5419023, "id": "220c629b-af26-4ddb-9c44-8b1722e4ffe5"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f219317b-6927-4882-8d3a-2ba0da9f1385',
    1788673403.5433955,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788673403.5433955, "id": "f219317b-6927-4882-8d3a-2ba0da9f1385"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1b37417b-f2f4-436f-a34b-aa1bbdf1d1e1',
    1788673403.5443122,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788673403.5443122, "id": "1b37417b-f2f4-436f-a34b-aa1bbdf1d1e1"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '5ced2840-28f0-4295-8dd5-aa85de75883c',
    1788673408.5520678,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788673408.5520678, "id": "5ced2840-28f0-4295-8dd5-aa85de75883c"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '72ef0c57-3dec-4129-b3cc-f1aee3483e27',
    1788673408.553601,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788673408.553601, "id": "72ef0c57-3dec-4129-b3cc-f1aee3483e27"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '6806b01f-6b6b-4f58-91b4-6bb851932bb2',
    1788673408.5552082,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788673408.5552082, "id": "6806b01f-6b6b-4f58-91b4-6bb851932bb2"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e24ca1db-a50c-4702-ac47-6606b74cfbdc',
    1788673608.2442584,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788673608.2442584, "id": "e24ca1db-a50c-4702-ac47-6606b74cfbdc"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'd358897e-37e7-4f83-ac95-9b54617abdfe',
    1788673608.2455542,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788673608.2455542, "id": "d358897e-37e7-4f83-ac95-9b54617abdfe"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '2ecc165a-8fe0-4183-aea6-e275b15ab1aa',
    1788673608.2469206,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788673608.2469206, "id": "2ecc165a-8fe0-4183-aea6-e275b15ab1aa"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '76cb92ec-f11d-4ae7-b6a2-149cc5084042',
    1788673638.7797484,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788673638.7797484, "id": "76cb92ec-f11d-4ae7-b6a2-149cc5084042"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a961da06-3565-497b-9063-608ec60babde',
    1788673638.7810235,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B09", "ts": 1788673638.7810235, "id": "a961da06-3565-497b-9063-608ec60babde"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '6d76001e-1b13-4853-a52b-61e29d8b88f0',
    1788673638.781887,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1788673638.781887, "id": "6d76001e-1b13-4853-a52b-61e29d8b88f0"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '6ee9c8b1-011e-4cff-963e-d3aa0c1b4615',
    1788673643.7874427,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788673643.7874427, "id": "6ee9c8b1-011e-4cff-963e-d3aa0c1b4615"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a74f5b89-f8a3-4968-b77b-89b993656a2a',
    1788673643.7884567,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B09", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788673643.7884567, "id": "a74f5b89-f8a3-4968-b77b-89b993656a2a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a0ff39c8-4b73-466d-8505-5cae5313421d',
    1788673643.789173,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788673643.789173, "id": "a0ff39c8-4b73-466d-8505-5cae5313421d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c02432a8-4c1f-4c42-bf05-0e88da6bcaca',
    1788929423.7782993,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788929423.7782993, "id": "c02432a8-4c1f-4c42-bf05-0e88da6bcaca"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '4969497e-0b4c-4223-a528-1e05e1edc4c2',
    1788929423.779086,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788929423.779086, "id": "4969497e-0b4c-4223-a528-1e05e1edc4c2"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '4b8350ab-c878-4876-b05e-3c3383f85b8d',
    1788929423.7794135,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788929423.7794135, "id": "4b8350ab-c878-4876-b05e-3c3383f85b8d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f590d4f3-f4d0-4aee-bc97-0e63bf50fe09',
    1788929454.3071425,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788929454.3071425, "id": "f590d4f3-f4d0-4aee-bc97-0e63bf50fe09"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '7ee0d425-fbea-42c2-acfd-94e4ffbeac96',
    1788929454.3074496,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788929454.3074496, "id": "7ee0d425-fbea-42c2-acfd-94e4ffbeac96"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'd006d959-10ba-4ddc-b286-28c330482426',
    1788929454.3076515,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788929454.3076515, "id": "d006d959-10ba-4ddc-b286-28c330482426"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '5b1ee7c1-9226-4b3b-a049-699db837c186',
    1788929459.3140423,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788929459.3140423, "id": "5b1ee7c1-9226-4b3b-a049-699db837c186"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'cadc53fc-43af-4a4f-b029-4421db16b8c1',
    1788929459.3143654,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788929459.3143654, "id": "cadc53fc-43af-4a4f-b029-4421db16b8c1"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '59b052ce-ffbe-43e5-8a62-8601347dbced',
    1788929459.3145888,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788929459.3145888, "id": "59b052ce-ffbe-43e5-8a62-8601347dbced"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'b7a61bad-1405-41b6-860f-3337bc460268',
    1788929880.6881006,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1788929880.6881006, "id": "b7a61bad-1405-41b6-860f-3337bc460268"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '52a6bc9b-0404-4939-b577-6531c711d49f',
    1788929893.9424753,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788929893.9424753, "id": "52a6bc9b-0404-4939-b577-6531c711d49f"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '25b5e405-cb01-4f35-86ea-cf4db7dd4170',
    1788929893.943645,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788929893.943645, "id": "25b5e405-cb01-4f35-86ea-cf4db7dd4170"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e7fb4288-7c18-4db0-a2a9-22c960a63e38',
    1788929893.9446383,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788929893.9446383, "id": "e7fb4288-7c18-4db0-a2a9-22c960a63e38"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '6655ad95-17c3-46d2-84e4-e69e763c47f2',
    1788929924.4845927,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1788929924.4845927, "id": "6655ad95-17c3-46d2-84e4-e69e763c47f2"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e5e80489-da94-4154-8bdd-53a4b425e34b',
    1788929924.486561,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1788929924.486561, "id": "e5e80489-da94-4154-8bdd-53a4b425e34b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ba8171ce-9cf0-4137-8619-f9335ba47ba1',
    1788929924.4875712,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1788929924.4875712, "id": "ba8171ce-9cf0-4137-8619-f9335ba47ba1"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'a44f8e46-de02-4022-8459-e8f2a3b140c2',
    1788929929.4948583,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788929929.4948583, "id": "a44f8e46-de02-4022-8459-e8f2a3b140c2"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '665a7410-bb21-45ae-a43c-df4e433dea07',
    1788929929.4964662,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788929929.4964662, "id": "665a7410-bb21-45ae-a43c-df4e433dea07"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '0c5429e6-f906-4bc6-8310-9e3610182166',
    1788929929.4978178,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1788929929.4978178, "id": "0c5429e6-f906-4bc6-8310-9e3610182166"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '67ba6055-094b-4c86-bb26-95fc242ea895',
    1793345988.4492977,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1793345988.4492977, "id": "67ba6055-094b-4c86-bb26-95fc242ea895"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '7c170588-1591-4252-a668-197329e95b54',
    1793345988.4499238,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1793345988.4499238, "id": "7c170588-1591-4252-a668-197329e95b54"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ec116cde-16ca-4fd8-a1ee-c4c1e3d87a0b',
    1793345988.450237,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1793345988.450237, "id": "ec116cde-16ca-4fd8-a1ee-c4c1e3d87a0b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f1e038f0-ef9b-4f36-8277-561e12895696',
    1793346018.9799132,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1793346018.9799132, "id": "f1e038f0-ef9b-4f36-8277-561e12895696"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '75587547-4fc3-4592-8313-ac178920f110',
    1793346018.9806836,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1793346018.9806836, "id": "75587547-4fc3-4592-8313-ac178920f110"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '102dc22e-aca9-4382-b18a-0f1f1a70633b',
    1793346018.9811804,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1793346018.9811804, "id": "102dc22e-aca9-4382-b18a-0f1f1a70633b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '5f2dbced-0ce4-4044-893a-6e8308ba95c1',
    1793346023.9861443,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B06", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1793346023.9861443, "id": "5f2dbced-0ce4-4044-893a-6e8308ba95c1"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '4f61dbcb-8423-4fe9-890f-f8c78cea9ebb',
    1793346023.9868999,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B07", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1793346023.9868999, "id": "4f61dbcb-8423-4fe9-890f-f8c78cea9ebb"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '1f06717d-fe52-4aa3-bcf4-a873d5d62354',
    1793346023.988456,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1793346023.988456, "id": "1f06717d-fe52-4aa3-bcf4-a873d5d62354"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'b9e9dcd0-c9f9-4281-9feb-16586e4b7885',
    1793346403.6132472,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "fb3ae3d1-5cb2-45a5-a27d-43b7cfc012c0", "bedId": "B09", "source": "SOURCE_A", "eventTime": 1793346392.7085905, "note": "Ignored \u2013 older than current knowledge", "ts": 1793346403.6132472, "id": "b9e9dcd0-c9f9-4281-9feb-16586e4b7885"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '9abd6320-aced-4c8f-b385-53e80199f6a2',
    1793346404.6433828,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1793346404.6433828, "id": "9abd6320-aced-4c8f-b385-53e80199f6a2"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '5d289081-5d57-4190-85e0-b97ab143c81b',
    1793346404.6533213,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1793346404.6533213, "id": "5d289081-5d57-4190-85e0-b97ab143c81b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'e8f86881-5f76-4451-9e53-45c2c7769fc4',
    1793346404.7119405,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "d6ac6c75-a0de-44c4-ac02-8c442b8d8c82", "bedId": "B05", "source": "SOURCE_A", "eventTime": 1793346404.7115092, "note": "Ignored \u2013 older than current knowledge", "ts": 1793346404.7119405, "id": "e8f86881-5f76-4451-9e53-45c2c7769fc4"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '687796dc-5b56-414e-8f3f-4ef03f9e691d',
    1793346404.7124462,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "712f2567-af6c-4ed7-bfbe-6f406454a934", "bedId": "B05", "source": "SOURCE_B", "eventTime": 1793346404.7615092, "note": "Ignored \u2013 older than current knowledge", "ts": 1793346404.7124462, "id": "687796dc-5b56-414e-8f3f-4ef03f9e691d"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ebd27b8c-028f-4d21-860f-1c1716ebc76b',
    1793346404.741514,
    'HUMAN_CONFIRMATION',
    '{"type": "HUMAN_CONFIRMATION", "bedId": "B01", "user": "tester", "state": "AVAILABLE", "reason": "ok", "ts": 1793346404.741514, "id": "ebd27b8c-028f-4d21-860f-1c1716ebc76b"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'd2f4a034-9024-4c9e-b494-5ddfbaa6f14c',
    1793346404.9546287,
    'RAPID_STATE_CHANGES',
    '{"ts": 1793346404.9546287, "type": "RAPID_STATE_CHANGES", "bedId": "B05", "count": 11, "id": "d2f4a034-9024-4c9e-b494-5ddfbaa6f14c"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '7a2e820a-42ac-402a-a3fa-61b355cb7baa',
    1793346405.115095,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B09", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1793346405.115095, "id": "7a2e820a-42ac-402a-a3fa-61b355cb7baa"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f69be2ae-86c6-40ee-8866-9aa837dff11a',
    1793346406.668379,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1793346406.668379, "id": "f69be2ae-86c6-40ee-8866-9aa837dff11a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'f059f521-0ade-4c83-88e4-cbc056009fb7',
    1793346419.9709454,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B01", "ts": 1793346419.9709454, "id": "f059f521-0ade-4c83-88e4-cbc056009fb7"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ff6754dd-d82a-45eb-a74c-640d87ee8d48',
    1793346419.9713988,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1793346419.9713988, "id": "ff6754dd-d82a-45eb-a74c-640d87ee8d48"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8c536bed-1385-4a54-80b1-824f2027d1d0',
    1793346424.9768577,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B01", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_OCCUPIED", "ts": 1793346424.9768577, "id": "8c536bed-1385-4a54-80b1-824f2027d1d0"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c606f91e-1ca3-4a24-9403-ea4bd0a027ea',
    1793346435.4885576,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1793346435.4885576, "id": "c606f91e-1ca3-4a24-9403-ea4bd0a027ea"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '870616cb-8899-4a2c-8fa3-7cd977b9f7c5',
    1793346451.0046377,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1793346451.0046377, "id": "870616cb-8899-4a2c-8fa3-7cd977b9f7c5"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '63fb1c6c-cbd3-42ad-bb06-80d6d2f923ce',
    1793346466.5217254,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B10", "ts": 1793346466.5217254, "id": "63fb1c6c-cbd3-42ad-bb06-80d6d2f923ce"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '02e09086-5aa7-4997-8e64-736a0b5b8dec',
    1793346471.5264206,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B10", "reason": "RECONCILIATION_TIMEOUT", "retries": 13, "recommendation": "LIKELY_AVAILABLE", "ts": 1793346471.5264206, "id": "02e09086-5aa7-4997-8e64-736a0b5b8dec"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'ad982f14-5c06-408c-bd6b-ff15a5060a9c',
    1793346701.995165,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1793346701.995165, "id": "ad982f14-5c06-408c-bd6b-ff15a5060a9c"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '955a752f-2898-4a54-82f0-33a61c36529a',
    1793346732.5339618,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1793346732.5339618, "id": "955a752f-2898-4a54-82f0-33a61c36529a"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '31d967f6-6b6a-45ff-8731-04170096ab73',
    1793346737.5397892,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1793346737.5397892, "id": "31d967f6-6b6a-45ff-8731-04170096ab73"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '2e75f61a-84a3-4c59-9b6b-08c21d7bad27',
    1793349093.246333,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B06", "ts": 1793349093.246333, "id": "2e75f61a-84a3-4c59-9b6b-08c21d7bad27"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '516dc347-9f21-4ea0-bc36-cc92268188bc',
    1793349093.2472777,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B07", "ts": 1793349093.2472777, "id": "516dc347-9f21-4ea0-bc36-cc92268188bc"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '0b78a474-068c-4a49-96f5-0a1c470ec802',
    1793349093.2477736,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1793349093.2477736, "id": "0b78a474-068c-4a49-96f5-0a1c470ec802"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '4d46e1e7-9207-405e-9a85-6194b83b8ec1',
    1793349113.8070445,
    'ADMIN_DRIFT_CORRECTED',
    '{"type": "ADMIN_DRIFT_CORRECTED", "bedId": "B05", "from": "AVAILABLE", "to": "OCCUPIED", "ts": 1793349113.8070445, "id": "4d46e1e7-9207-405e-9a85-6194b83b8ec1"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    'c331d5f4-1292-4f20-9309-e32a7f822fcd',
    1793349113.8251393,
    'OUT_OF_ORDER_STALE_EVENT',
    '{"type": "OUT_OF_ORDER_STALE_EVENT", "eventId": "b882ea9e-ad34-4740-b5b5-956f7f7eeb3a", "bedId": "B05", "source": "SOURCE_A", "eventTime": 1793349113.824634, "note": "Ignored \u2013 older than current knowledge", "ts": 1793349113.8251393, "id": "c331d5f4-1292-4f20-9309-e32a7f822fcd"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '8f4d26bc-b8e4-4503-b0e7-04162582fde4',
    1793349123.7839372,
    'LEASE_EXPIRED',
    '{"type": "LEASE_EXPIRED", "bedId": "B08", "ts": 1793349123.7839372, "id": "8f4d26bc-b8e4-4503-b0e7-04162582fde4"}'
);
INSERT INTO audit_log (id, ts, type, data)
VALUES (
    '54815046-703f-4071-9156-ffb37b24542d',
    1793349128.7905564,
    'RECONCILIATION_TIMEOUT',
    '{"type": "RECONCILIATION_TIMEOUT", "bedId": "B08", "reason": "RECONCILIATION_TIMEOUT", "retries": 10, "recommendation": "LIKELY_AVAILABLE", "ts": 1793349128.7905564, "id": "54815046-703f-4071-9156-ffb37b24542d"}'
);