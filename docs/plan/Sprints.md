# Sprint Plan (First 4 Sprints)

Sprint 1 (2 weeks)
- Module: Core Setup
  - Finalize domain docs; approve glossary and rules.
  - Set up repo structure; CI; testing frameworks.
  - Import Suppliers (CSV) — create schema and validation.
- Acceptance Criteria
  - Entities and schemas reviewed.
  - CSV import for suppliers validates and stores sample dataset.

Sprint 2 (2 weeks)
- Module: Contracts & Properties
  - CRUD for Properties and Contracts.
  - Generate rent schedule preview per contract.
  - Tenant CRUD.
- Acceptance Criteria
  - Create contract with due day creates correct schedule.
  - Prevent overlapping active leases per property.

Sprint 3 (2 weeks)
- Module: Rent Invoicing & Notifications
  - Monthly rent invoice generation job.
  - Notification templates (email/SMS) placeholders.
  - Basic dashboard for open invoices.
- Acceptance Criteria
  - Given contracts with due day X, invoices are generated correctly.
  - Invoices reflect lines and totals; statuses flow from draft → issued.

Sprint 4 (2 weeks)
- Module: Payments & Reconciliation MVP
  - Payment entry, allocation to invoices (FIFO/specify invoice).
  - Bank CSV import and manual matching.
  - Reports: aging, payment receipts.
- Acceptance Criteria
  - Payment allocations do not exceed open balance.
  - Reconciliation locks period with zero difference.
