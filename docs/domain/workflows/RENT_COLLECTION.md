# Workflow: Rent Collection

1. Generate monthly rent invoice per active lease contract based on `paymentDueDay`.
2. Notify tenant with invoice details and due date.
3. Receive payment and create `Payment` with method and reference.
4. Allocate payment to open invoices (FIFO or specified).
5. If late, calculate penalty per `penaltyPolicy` and issue additional invoice.
6. Reconcile bank statement and link to payment.
