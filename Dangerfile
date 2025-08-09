# Dangerfile
# Basic checks for PR hygiene and review support

warn('PR is still a draft') if github.pr_draft?

fail('PR title is empty') if github.pr_title.to_s.strip.empty?

# Enforce branch naming via Danger (redundant with workflow, but helpful inline)
source = github.branch_for_head
unless source =~ /^(feature|fix|chore|docs|ci|refactor|test|hotfix)\/.+$/
  warn("Branch name '#{source}' does not follow convention. Expected prefixes: feature/, fix/, chore/, docs/, ci/, refactor/, test/, hotfix/.")
end

# Encourage small PRs
added = git.added_files.count
modified = git.modified_files.count
if (added + modified) > 80
  warn('Large PR detected (>80 changed files). Consider splitting into smaller PRs.')
end

# Ensure PR template sections are addressed
template_checks = [
  /## Summary/i,
  /## Checklist/i,
  /## How to test/i,
]
missing = template_checks.reject { |rx| rx.match?(github.pr_body.to_s) }
warn("PR body may be missing template sections: #{missing.map(&:source).join(', ')}") unless missing.empty?

# Prefer including tests
unless (git.modified_files + git.added_files).any? { |f| f =~ %r{^(api/spec/|app/__tests__/|app/.*/__tests__/)} }
  warn('No test changes detected. Consider adding tests for new or changed behavior.')
end
