# Dangerfile
# Automated PR hygiene checks

warn('PR is still a draft') if github.pr_draft?

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

# Ensure PR template sections present
required_sections = [ /## Summary/i, /## Checklist/i, /## How to test/i ]
missing = required_sections.reject { |rx| rx.match?(github.pr_body.to_s) }
warn("PR body may be missing template sections: #{missing.map(&:source).join(', ')}") unless missing.empty?

# Nudge to include tests if code changed
unless changed_files.any? { |f| f =~ %r{^(api/spec/|app/__tests__/|app/.*/__tests__/)} }
  warn('No test changes detected. Consider adding tests for new or changed behavior.')
end
