# Entity: Expense (Imprevisto)

## Fields
- id (UUID)
- propertyId (UUID)
- contractId (UUID, optional)
- supplierId (UUID)
- category (string)
- description (string)
- issueDate (date)
- amount (number)
- currency (string)
- attachmentUrl (string)
- approvalStatus (enum: pending, approved, rejected)

## Relationships
- belongsTo Property
- belongsTo Supplier
- optionally belongsTo Contract
- may create an Invoice (expenseRecharge) to Owner

## Invariants
- approval required when amount exceeds threshold
