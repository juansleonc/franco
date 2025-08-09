# Engineering Standards for Franco

This document defines baseline code quality and architecture standards for the Franco project. It is the source of truth for contributors.

## Code Principles

- SOLID principles as default design heuristics
  - Single Responsibility: every class/module has one reason to change
  - Open/Closed: extend via new classes/objects, avoid modifying stable code
  - Liskov Substitution: public contracts must be substitutable by subtype
  - Interface Segregation: prefer narrow, cohesive interfaces
  - Dependency Inversion: depend on abstractions, inject collaborators
- Clean Code
  - Intention-revealing names; no abbreviations
  - Small functions; guard clauses; avoid deep nesting
  - No comments for obvious code; document “why”, not “how”
  - Handle errors explicitly; avoid silent rescue

## Ruby on Rails

- Services/Interactors
  - Complex domain logic goes into POROs under `app/services/**`
  - Each service exposes a single `call` and returns typed result objects
- Serializers
  - Use `ActiveModelSerializers` for API responses; serializers are dumb/mapping-only
- Security & Observability
  - Enforce Pundit for authorization
  - Lograge enabled; Sentry configured for errors
- Performance
  - Avoid N+1; preload associations in controllers/services
  - Add DB indexes for FK and search columns

## Testing

- RSpec + FactoryBot
  - Use factories (`create/build`) instead of `Model.create!` in specs
  - Keep tests independent and fast; prefer request/model specs over heavy feature tests
  - Use `let`/`let!` to setup, avoid `before :all`
- Coverage & CI
  - CI must pass: RuboCop, RSpec, Brakeman, Bundler Audit
  - YAML/Markdown lint must be clean
  - Always run tests inside Docker to match CI environment:
    - `docker compose exec api bash -lc "RAILS_ENV=test bundle exec rspec --format progress"`
    - Do not commit code if the above command is not green

## Linting & Style

- RuboCop
  - Inherits `rubocop-rails-omakase`; enables `rubocop-rspec`, `rubocop-performance`, `rubocop-factory_bot`
  - No disabled cops without rationale in PR description
- JavaScript/TypeScript (App)
  - ESLint + TypeScript must pass; no `any` unless justified
  - Keep UI components pure; side-effects in hooks/services

## Git & PRs

- Small, cohesive PRs with descriptive titles
- Commit messages focus on the “why” and impact
- PR includes brief test plan and risk
