# Rails Starter: agent guidance

## Project

This is **Rails Starter**, a reusable template using the `RailsStarter` namespace—not a GitHub auditing application. It provides authentication, account/profile pages, and ViewComponents to build on.

- Ruby **4.0.6**, Rails **8.1.3.1**, Bundler **4.0.20**. Keep `.ruby-version`, `Gemfile`, `Gemfile.lock`, and the Docker Ruby argument aligned.
- SQLite; separate Solid Cache/Queue/Cable databases in production.
- Propshaft, Importmap, Turbo, Stimulus, ViewComponent, and locally compiled Tailwind v4. No browser CSS compiler or Node.js bundler.
- Docker/Kamal support is a starting point, not a configured deployment.

## Setup and checks

- Rename a fresh template with `bin/rename-app PascalCaseName` **before** setup. It changes only allowlisted source references; credentials/databases stay untouched.
- `bin/setup --skip-server` installs dependencies and verified hooks, prepares the database, compiles CSS, then exits.
- `bin/setup` also starts `bin/dev`. `--reset` explicitly resets a database; never use it casually on an existing application.
- `bin/dev` runs Rails with a development-only Puma Tailwind watcher.
- `bin/rails tailwindcss:build` compiles CSS; production `assets:precompile` does this automatically.
- `RAILS_ENV=test bin/ci` runs the full pipeline; `--fix` adds formatter auto-fixes. Requires actionlint and Chrome/Chromium locally.
- `bundle exec ruby test/template_scripts_test.rb` exercises rename/setup in temporary fake applications without opening real servers or databases.
- `bin/rails test` runs Rails tests.
- `COVERAGE_SUITE=system SKIP_COVERAGE_MINIMUM=1 bin/rails test:system` runs system tests separately, deferring their coverage threshold to `bin/coverage`.
- `bin/coverage` collates SimpleCov results with the locked gem version and enforces the final coverage gate.
- `bin/watch-ci` watches GitHub CI status; it is not a local filesystem watcher.

## Architecture

- `app/components`: ViewComponent classes/templates. Use full utility class names or explicit Tailwind source declarations for computed names.
- `app/assets/tailwind/application.css`: local Tailwind source. Generated `app/assets/builds` files are ignored.
- `app/javascript/controllers`: Stimulus controllers, including the existing tooltip controller.
- `config/ci.rb`: authoritative CI steps.
- `test/test_helper.rb`: coverage and parallelization configuration.
- `config/database.yml`: local SQLite configuration and production Solid databases.
- `config/deploy.yml`: deployment placeholders; review for each generated app.

## Quality standards

- **Never use `git commit --no-verify` or otherwise bypass hooks.**
- **Never add inline RuboCop disables.** Fix the code or configure an appropriate rule in `.rubocop.yml`.
- **Never add Reek suppressions**, either inline or new exclusions. Fix the code.
- Existing repository lint hooks and Overcommit checks must continue working. Do not disable signature verification to make CI pass.
- Run whole-project audits as well as file linters: Zeitwerk, Bundler audit, Importmap audit, and Brakeman.
- Test with Minitest; browser tests use Capybara/Selenium and axe-core (WCAG 2.1 AA). See `docs/accessibility.md`.
- SimpleCov gates: **95% line / 95% branch**, **80% per file**. Keep Rails/system suite names distinct so results merge correctly.
- Preserve unrelated work and use conventional commit messages (`feat:`, `fix:`, `chore:`, `test:`, etc.).

## Privacy and template safety

- Do not read or copy real credentials, keys, `.env` files, local databases, or deployment secrets during template maintenance. Use a secret-free temporary source copy for bootstrap/runtime tests.
- Keep secret values out of files, docs, commits, and logs; prefer secret-manager/environment injection for real applications.
- No default administrator or shared password is seeded. Create accounts through the normal registration flow.
- Gravatar still makes external image requests. Privacy-sensitive apps should replace it; compiled Tailwind alone does not make the entire template offline.
- Production hosts, CSP, mail settings, and credentials must be configured per application. Never deploy with template placeholders.
