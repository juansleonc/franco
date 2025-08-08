# Entity: Supplier

## Fields
- id (UUID)
- legalName (string)
- taxId (string)
- email (string)
- phone (string)
- address (string)
- bankAccount (json)
- rating (number 1-5)

## Relationships
- hasMany Expenses

## Invariants
- taxId must be unique
