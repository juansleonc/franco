# Data Sources Mapping

Source spreadsheets in `docs/` and their mapped entities:

- BASE DE DATOS  PROVEEDORES.xlsx → `Supplier`
- BASE DE DATOS IMPREVISTOS.xlsx → `Expense`
- BASE DE DATOS PAGOS ADMINISTRACION 2025.xlsx → `Invoice` (adminFee) and `Payment`
- BASE DE DATOS REQUERIMIENTOS CLIENTES.xlsx → `Client Requirement`

Notes:
- Column-to-field mapping to be finalized after header review of each file.
- All target fields and JSON Schemas are defined under `./schemas/`.
