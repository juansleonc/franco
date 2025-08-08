# Entity: Invoice

## Fields
- id (UUID)
- contractId (UUID)
- type (enum: rent, adminFee, expenseRecharge, other)
- issueDate (date)
- dueDate (date)
- amount (number)
- currency (string)
- status (enum: draft, issued, partiallyPaid, paid, void)
- lines (array: description, quantity, unitPrice)

## Relationships
- belongsTo Contract
- hasMany Payments (through allocations)

## Invariants
- amount equals sum(lines)
- cannot be paid if status is void
