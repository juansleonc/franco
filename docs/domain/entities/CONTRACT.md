# Entity: Contract

## Fields
- id (UUID)
- propertyId (UUID)
- ownerId (UUID)
- tenantId (UUID)
- type (enum: lease, management)
- startDate (date)
- endDate (date)
- rentAmount (number)
- currency (string, ISO 4217)
- adminFeeType (enum: fixed, percentage)
- adminFeeValue (number)
- depositAmount (number)
- paymentDueDay (number 1-28)
- penaltyPolicy (json)
- terms (text)

## Relationships
- belongsTo Property
- belongsTo Owner
- belongsTo Tenant
- hasMany Invoices

## Invariants
- startDate < endDate
- active overlap for same property and type is not allowed
