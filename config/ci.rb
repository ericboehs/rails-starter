# Run using bin/ci
# Run with fixes: bin/ci --fix

CI.run do
  step "Setup", "bin/setup --skip-server"
  step "Tests: Template bootstrap", "ruby test/template_scripts_test.rb"

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

  # Do not let a previous CI run's cached coverage hide untested lines.
  step "Tests: Fresh coverage", "ruby -rfileutils -e 'FileUtils.rm_rf(%q[coverage])'"
  step "Tests: Rails", "env COVERAGE_SUITE=rails bin/rails test"
  step "Tests: System", "env COVERAGE_SUITE=system SKIP_COVERAGE_MINIMUM=1 bin/rails test:system"
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
