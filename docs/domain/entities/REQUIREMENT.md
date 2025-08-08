# Entity: Client Requirement

## Fields
- id (UUID)
- title (string)
- description (text)
- requesterType (enum: owner, tenant, lead)
- requesterId (UUID, optional)
- propertyId (UUID, optional)
- contractId (UUID, optional)
- status (enum: new, inProgress, blocked, waiting, done, cancelled)
- priority (enum: low, medium, high, urgent)
- createdAt (datetime)
- updatedAt (datetime)

## Relationships
- belongsTo Property (optional)
- belongsTo Contract (optional)

## Invariants
- transitions must follow workflow statuses
