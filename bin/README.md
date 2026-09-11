# Developer tools

| Command | Purpose |
| --- | --- |
| `bin/rename-app PascalCaseName` | Rename an untouched template from any directory. Changes allowlisted source references only; never touches credentials or databases. |
| `bin/setup --skip-server` | Install gems and verified Git hooks, prepare the selected database, build local Tailwind CSS, and exit. |
| `bin/setup` | The same setup, then start development. `--reset` explicitly resets the selected database; unknown flags fail early. |
| `bin/dev` | Rails server. The development-only Puma plugin also watches Tailwind source. |
| `bin/ci` | Run setup, template CLI checks, Overcommit, actionlint, Zeitwerk, dependency/code audits, Rails/system tests, seeds, and merged coverage enforcement. |
| `bin/ci --fix` | Apply Ruby/ERB formatter fixes before running the checks. |
| `bin/coverage` | Collate SimpleCov suites using locked dependencies; fail below 95% line/branch or 80% per-file coverage. No HTML scraping or independent gem resolution. |
| `bin/watch-ci [seconds]` | Poll GitHub CI for the current branch. Requires `gh` and `jq`; does not watch local files or run local CI. |

Use `RAILS_ENV=test bin/ci` for the full pipeline. Local CI also needs actionlint and Chrome/Chromium. Rails and system coverage use distinct `COVERAGE_SUITE` names so their results merge instead of replacing one another.

Rename **before** setup for a new application, and do not run destructive database resets against existing work. Refer to the root [README](../README.md) for bootstrap and privacy boundaries.
