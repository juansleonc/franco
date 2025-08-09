## Common workflow commands

### Docker compose
- Start services: `docker compose up -d`
- Stop services: `docker compose down`
- Rails tests inside container:
  - `docker compose exec api bash -lc "bundle install && RAILS_ENV=test bundle exec rails db:prepare && COVERAGE=true bundle exec rspec --format progress"`

### Rails (host, if you have Ruby)
- Install gems: `bundle install`
- Prepare test DB: `RAILS_ENV=test DB_HOST=127.0.0.1 DB_USER=postgres DB_PASSWORD=postgres bundle exec rails db:prepare`
- Run tests with coverage: `COVERAGE=true bundle exec rspec --format progress`

### Mobile app (React Native)
- Install deps: `cd app && npm ci`
- Lint: `npm run lint`
- Typecheck: `npm run typecheck`
- Tests (CI mode + coverage): `npm run test:ci -- --coverage`

### Git branching and PRs
- Create branch: `git checkout -b feature/my-feature`
- Push branch: `git push -u origin feature/my-feature`
- Open PR (web): compare `main...feature/my-feature`

### CI tips
- Re-run a failed job from PR Checks tab
- Coverage artifacts: `rails-coverage` and `app-coverage` in PR artifacts
- Danger, CodeQL, Security jobs run on PR automatically
