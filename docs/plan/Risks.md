# Risks & Mitigations

- Domain ambiguity from spreadsheets only
  - Mitigation: validate rules with stakeholders per module kickoff; maintain `BUSINESS_RULES.md`.
- Data quality issues (duplicates, missing fields)
  - Mitigation: implement import validations and data cleaning rules.
- Scope creep on admin/accounting features
  - Mitigation: strict module scoping and acceptance criteria per sprint.
- Integration risk with banking statements
  - Mitigation: start with CSV import; defer API integrations to a later milestone.
