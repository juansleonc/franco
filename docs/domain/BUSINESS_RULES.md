# Core Business Rules

This document distills rules from spreadsheets in `docs/`.

## Rent and Administration
- Monthly rent is due on the agreed due date in the contract.
- Administration fee is calculated per contract rules (fixed or percentage of collected rent) and is charged to the owner.
- Late payments may incur penalties per contract terms.

## Payments and Invoices
- Every payment must reference exactly one payer (tenant or owner) and one or more invoices.
- Payment allocation is FIFO by default unless a specific invoice is referenced.
- A payment cannot exceed the open balance of targeted invoices.

## Expenses (Imprevistos)
- Each expense must be tied to a property and optionally to a contract if within lease scope.
- Expenses require an associated supplier and supporting document (invoice or receipt).
- Owner approval may be required above a configurable threshold.

## Suppliers
- Suppliers must have basic KYC data (legal name, tax id, contact, bank details) before payment.
- Duplicate suppliers are detected by tax id and legal name similarity.

## Client Requirements
- Requirements are tracked with status: New → In Progress → Blocked/Waiting → Done/Cancelled.
- Each requirement must be linked to a property or contract where applicable.

## Reconciliations
- Bank reconciliation runs monthly; all payments must map to bank movements.
- Unreconciled items older than 30 days are escalated.
