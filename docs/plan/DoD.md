# Definition of Done (DoD)

For any feature or module increment to be considered done:

- Requirements documented in `docs/domain` and reflected in the module sheet.
- API contracts defined and reviewed (OpenAPI or equivalent if backend present).
- UI screens implemented with loading/error/success states and accessibility (if applicable).
- Tests: unit + integration + basic E2E happy path.
- Data model migrations reviewed and reversible.
- Security checks (authZ/authN) and data validations in place.
- Performance considerations addressed (N+1, indexes, pagination where relevant).
- Monitoring/Logging hooks added for critical flows.
- Documentation updated (README, CHANGELOG if needed).
