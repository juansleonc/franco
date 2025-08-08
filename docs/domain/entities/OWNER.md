# Entity: Owner

## Fields
- id (UUID)
- fullName (string)
- documentType (enum: nationalId, passport, taxId)
- documentNumber (string)
- email (string)
- phone (string)
- address (string)
- bankAccount (json: bankName, accountType, accountNumber, routing)
- notes (text)

## Relationships
- hasMany Properties
- hasMany Contracts (through Properties)

## Invariants
- documentNumber + documentType must be unique
