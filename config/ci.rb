# Run using bin/ci
# Run with fixes: bin/ci --fix

CI.run do
  step "Setup", "bin/setup --skip-server"

  # Apply fixes if --fix flag is passed
  if ARGV.include?("--fix")
    step "Style: RuboCop auto-fix", "bin/rubocop -A"
    step "Style: ERB lint auto-fix", "bundle exec erb_lint --autocorrect"
  end

  step "Lint: Overcommit checks", "bundle exec overcommit --run"
  step "Style: GitHub Actions", "actionlint"
  step "Quality: Zeitwerk autoloading", "bin/rails zeitwerk:check"
  step "Security: Bundler vulnerability audit", "bundle exec bundle-audit check --update"
  step "Security: Importmap vulnerability audit", "bin/importmap audit"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"

  step "Tests: Rails", "bin/rails test"
  step "Tests: System", "bin/rails test:system"
  step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"
  step "Tests: Coverage report", "bin/coverage"

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  # if success?
  #   step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
  # else
  #   failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
  # end
end
