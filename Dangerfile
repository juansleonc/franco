# Dangerfile
# Automated PR hygiene checks

warn('PR is still a draft') if github.pr_draft?

# Focus on code changes; do not enforce PR body content
fail('PR title is empty') if github.pr_title.to_s.strip.empty?

# Branch naming convention (informational; enforcement via workflow)
source = github.branch_for_head
unless source =~ /^(feature|fix|chore|docs|ci|refactor|test|hotfix)\/.*$/
  warn("Branch name '#{source}' does not follow convention. Expected prefixes: feature/, fix/, chore/, docs/, ci/, refactor/, test/, hotfix/.")
end

# Encourage small PRs
changed_files = (git.added_files + git.modified_files + git.deleted_files).uniq
if changed_files.size > 80
  warn('Large PR detected (>80 changed files). Consider splitting into smaller PRs.')
end

# Skip PR body checks; focus Danger on code diffs only

# Nudge to include tests if code changed
unless changed_files.any? { |f| f =~ %r{^(api/spec/|app/__tests__/|app/.*/__tests__/)} }
  warn('No test changes detected. Consider adding tests for new or changed behavior.')
end

########################################
# Professional code review (diff-aware)
########################################

def diff_for(path)
  git.diff_for_file(path)&.patch.to_s
end

added = git.added_files
modified = git.modified_files
all_changed = (added + modified).uniq

# 1) Prevent risky column names (e.g., method) in migrations/models
added_migrations = added.select { |f| f =~ %r{^api/db/migrate/.*\.rb$} }
added_migrations.each do |mf|
  patch = diff_for(mf)
  if patch =~ /t\.\w+\s+:method\b/
    warn("Migration #{mf} defines a column named `method`. Consider renaming to `payment_method` to avoid clashing with Ruby's `Object#method` and confusion in AR.")
  end
end

# 2) Coverage threshold lowered check
if modified.include?("api/spec/rails_helper.rb")
  patch = diff_for("api/spec/rails_helper.rb")
  lowered = patch =~ /-\s*minimum_coverage\s+\d+/ && patch =~ /\+\s*minimum_coverage\s+([0-9]+)/
  if lowered
    new_val = patch[/\+\s*minimum_coverage\s+(\d+)/, 1]
    warn("Coverage threshold adjusted to #{new_val}%. Ensure this is intentional and justified in the PR description.")
  end
end

# 3) Detect FK type mismatches (uuid vs bigint) within new migrations
if added_migrations.any?
  uuid_tables = added_migrations.select { |mf| diff_for(mf) =~ /create_table\s+.*id:\s*:uuid/ }
  added_migrations.each do |mf|
    patch = diff_for(mf)
    if patch =~ /references\s+:\w+.*type:\s*:bigint/ && uuid_tables.any?
      warn("#{mf}: Mixing uuid tables with bigint references in the same milestone. Verify PK/FK types are consistent across domain.")
    end
  end
end

# 4) PaymentAllocation callback sanity
if added.include?("api/app/models/payment_allocation.rb") || modified.include?("api/app/models/payment_allocation.rb")
  body = File.read("api/app/models/payment_allocation.rb") rescue ""
  if body.include?("after_commit :update_invoice_balance_and_status") && !body.include?("destroy")
    warn("PaymentAllocation updates invoice balance on commit but does not appear to handle destroy/update reversal. Consider handling update/destroy to keep balances consistent.")
  end
end

# 5) Routes added without controllers (scaffold warning)
routes_touched = modified.include?("api/config/routes.rb") || added.include?("api/config/routes.rb")
if routes_touched
  missing = []
  missing << 'invoices_controller' unless all_changed.any? { |f| f =~ %r{^api/app/controllers/.*/invoices_controller\.rb$} }
  missing << 'payments_controller' unless all_changed.any? { |f| f =~ %r{^api/app/controllers/.*/payments_controller\.rb$} }
  missing << 'bank_statements_controller' unless all_changed.any? { |f| f =~ %r{^api/app/controllers/.*/bank_statements_controller\.rb$} }
  missing << 'statement_lines_controller' unless all_changed.any? { |f| f =~ %r{^api/app/controllers/.*/statement_lines_controller\.rb$} }
  unless missing.empty?
    warn("Routes updated but controllers are not included in this PR (#{missing.join(', ')}). If this is scaffolding, please mention next steps.")
  end
end

# 6) Positive signal: if no warnings/fails produced beyond size/draft/title, acknowledge readiness
if status_report[:warnings].empty? && status_report[:errors].empty?
  message('Code review: No issues found in the diff. Looks good to merge.')
end
