# Franco Technology Stack and Usage Guide

This document specifies the technologies we will use and how we will use them to deliver incremental, shippable modules. All code and identifiers must be in English.

## Architecture Overview
- API-first backend; mobile app as primary client.
- Clear separation between domain logic, API transport, and background jobs.
- Domain model and rules are defined in `docs/domain` and drive implementation.

## Backend (API)
- Language/Framework: Ruby 3.x + Rails 7.x (API-only mode)
  - Why: Rapid delivery, batteries-included, strong ecosystem for APIs.
  - How: Controllers return JSON; serializers for response shaping; services for domain logic.
- Persistence: PostgreSQL 15+
  - How: UUID primary keys; normalized schema; reference JSON Schemas under `docs/domain/schemas` when designing tables.
  - Migrations: Reversible; add indexes for FK and common filters; use `pgcrypto` for UUIDs.
- Caching/Queues: Redis 7+
  - How: Rails cache store and Sidekiq job queue.
- Background Jobs: Sidekiq + sidekiq-cron
  - How: Scheduled jobs for rent invoicing, reconciliation imports, notifications.
- Authentication: Devise + devise-jwt (stateless API tokens)
  - How: Issue JWT on login; include role claims; token expiration and refresh flow.
- Authorization: Pundit
  - How: Policy per resource; enforce in controllers; scope queries by role.
- Serialization: jsonapi-serializer or ActiveModelSerializers (plain JSON)
  - How: Keep response contracts stable; version endpoints as `/v1`.
- Validation: ActiveModel validations aligned to JSON Schemas
  - How: Mirror constraints (enums, formats, required) from `docs/domain/schemas`.
- File Storage: Active Storage + S3-compatible (e.g., AWS S3)
  - How: Store attachments for expenses, statements, receipts.
- Emails/SMS: Postmark (email), Twilio (SMS)
  - How: Background delivery; template variables; idempotent sending.
- Pagination/Filtering: Pagy for pagination; Ransack or manual filtering
  - How: Default page size 25; max 100.
- Money & Time: money-rails; time zone aware
  - How: Store amounts in minor units; currency per contract; all times UTC in DB.
- Security/PII: Lockbox for encryption at rest; attr filtering in logs
  - How: Encrypt sensitive fields (bank accounts, documents); scrub logs.
- Observability: Lograge, Sentry, healthcheck endpoint
  - How: Structured logs; error tracking with tags (tenant, userId); `/health` for uptime.
- API Documentation: RSwag (OpenAPI)
  - How: Generate OpenAPI from request specs; publish `/api-docs` on staging.

## Mobile App (React Native)
- Runtime: React Native (Expo), TypeScript
  - Why: Faster delivery; OTA updates for non-native changes.
  - How: Monorepo-friendly config; align naming with backend.
- Data Layer: React Query
  - How: Query keys per entity; normalized caching; optimistic updates for simple mutations.
- Navigation: React Navigation (stack + tabs)
  - How: Typed routes; deep linking for notifications.
- State: Zustand (lightweight local state)
  - How: Only for UI/local state; server state stays in React Query.
- Forms/Validation: React Hook Form + Zod
  - How: Zod schemas derived from backend/OpenAPI where possible.
- UI Toolkit: NativeBase or Tamagui (TBD)
  - How: Accessible components; design tokens.
- Testing: Jest + React Testing Library; optional Detox for E2E
  - How: Unit test hooks and components; smoke E2E on critical flows.

## Tooling & Dev Experience
- Version Control & CI: GitHub + GitHub Actions
  - How: PR checks run linters, tests, security scans, and type checks.
- Linting/Formatting: RuboCop (Rails), StandardRB or RuboCop defaults; ESLint + Prettier (RN)
  - How: Pre-commit hooks via lefthook or pre-commit.
- Commit Style: Conventional Commits
  - How: `feat:`, `fix:`, `docs:`, etc.; semantic PR titles.
- Containers: Docker (optional for dev), docker-compose for local stack
  - How: Services for Postgres, Redis, API, and (optionally) Expo dev tools.

## Environments & Deployment
- Environments: development, staging, production
  - How: Feature flags via Flipper; config via environment variables.
- Hosting (suggested):
  - API: Fly.io/Render/Heroku (choose based on cost/perf); Postgres managed.
  - Assets: S3; CDN optional.
  - Mobile: Expo EAS builds and OTA updates.
- Secrets: Rails credentials and platform secret stores
  - How: Never commit secrets; rotate quarterly.

## Integrations
- Bank Statements: CSV import first; later banking APIs
  - How: Parse CSV to a normalized model; manual matching UI; audit trail.
- Notifications: Webhooks for outbound events (optional)
  - How: Sign webhook payloads; retries with backoff.

## Testing Strategy
- Backend: RSpec (model, request, job specs); FactoryBot; Faker
  - How: Request specs double as API docs with RSwag.
- Mobile: Jest + RTL; minimal Detox
  - How: Cover loading/error/success states per screen.
- Data: Contract tests between RN and API (schema/contract checks)

## Data & Migration Strategy
- IDs: UUIDs; foreign keys with `on_delete: restrict` unless otherwise needed.
- Seeding: Idempotent seeds for demo data; factories for tests.
- Imports: CSV pipelines with validations; reject invalid rows with reasons.

## Conventions
- English-only code and docs (business docs may include Spanish originals under `docs/`).
- API versioning via `/v1`; avoid breaking changes within a major version.
- Time: store UTC; display in user locale/time zone.
- Error handling: standardized error envelope with code/message/details.

## Mapping to Modules (from `docs/plan`)
- Core Setup: Rails API skeleton, Postgres/Redis, RN app, CI, linting.
- Contracts & Properties: CRUD, validations, overlap rules, schemas.
- Rent Invoicing & Notifications: Cron job via Sidekiq; email/SMS via Postmark/Twilio.
- Payments & Reconciliation: Payment endpoints, CSV import, matching jobs.
- Expenses & Suppliers: File uploads (Active Storage), approval rules, supplier KYC.
- Admin Fees & Owner Statements: Fee calculation jobs; PDF generation via Prawn.

## Non-Goals (initial phases)
- Multi-tenant isolation across companies (single-tenant for now).
- Offline-first mobile beyond basic caching.
- Complex banking API integrations before CSV stability.
