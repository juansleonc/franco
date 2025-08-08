# Workflow: Expense Approval

1. Create `Expense` with supplier, property, amount, and attachment.
2. If amount > threshold, request owner approval.
3. Upon approval, schedule payment to supplier.
4. Optionally recharge the expense to owner via `Invoice` (expenseRecharge).
5. Pay supplier and mark expense as settled.
