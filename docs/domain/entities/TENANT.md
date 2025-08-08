# Entity: Tenant

## Fields
- id (UUID)
- fullNameOrLegalName (string)
- documentType (enum: nationalId, passport, taxId)
- documentNumber (string)
- email (string)
- phone (string)
- address (string)
- emergencyContact (json: name, phone)

## Relationships
- hasMany Contracts
- hasMany Payments

## Invariants
- documentNumber + documentType must be unique
