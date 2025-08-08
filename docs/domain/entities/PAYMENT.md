# Entity: Payment

## Fields
- id (UUID)
- payerType (enum: tenant, owner)
- payerId (UUID)
- receivedDate (date)
- method (enum: bankTransfer, cash, card, check, other)
- reference (string)
- amount (number)
- currency (string)
- bankReconciliationId (UUID, optional)

## Relationships
- hasMany Allocations
- belongsTo Tenant or Owner

## Invariants
- amount equals sum(allocations.amount)
