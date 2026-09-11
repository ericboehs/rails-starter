# Rails Starter Template

A Rails 8.1 application template with authentication, reusable components, and a checked-in CI pipeline.

## Stack

- **Ruby 4.0.6**, **Rails 8.1.3.1**, **Bundler 4.0.20**; exact dependencies are in `Gemfile.lock`.
- SQLite in development/test; separate primary, cache, queue, and cable databases in production.
- Propshaft, Importmap, Turbo, Stimulus, and ViewComponent. No Node.js bundler required.
- Tailwind CSS v4 compiled locally by `tailwindcss-rails`, not a browser CDN.
- Solid Cache, Queue, and Cable; optional Docker/Kamal deployment.
- Minitest, Capybara/Selenium, axe accessibility checks, and SimpleCov coverage gates.

## Start a new application

Use GitHub's **Use this template** action, clone the resulting repository, then install the Ruby version in `.ruby-version` with your Ruby manager.

**Rename before setup:** setup starts the development server unless `--skip-server` is passed.

```sh
bin/rename-app YourAppName
bin/setup --skip-server
bin/dev
```

Visit **http://localhost:3000**. Create an account at `/users/new`; the template does not seed a shared administrator or default password.

`bin/rename-app` takes one PascalCase name (for example, `PsstWeb`), works from any directory, and updates a fixed set of source/documentation references. It refuses symlink destinations and an already-renamed application. Review the resulting README, agent guidance, and deployment settings before committing.

### Credentials are separate

Renaming **does not read, regenerate, or overwrite credentials**, and does not reset databases. Never copy another application's `.env`, master key, encrypted credentials, local databases, or deployment secrets into a new application.

Set up fresh application secrets through your secret manager and environment injection when needed. Keep keys and secret values out of source control, documentation, and command logs. This template ships no encrypted application credentials or master keys; development/test can boot without production credentials.

### Development commands

```sh
bin/setup --skip-server              # install gems/hooks, prepare DB, compile CSS, then exit
bin/setup                           # same, then start bin/dev
bin/dev                             # Rails server plus a development-only Tailwind watcher
bin/rails tailwindcss:build          # one-off CSS rebuild
bin/rails assets:precompile          # production pipeline also builds Tailwind
bin/rails test                      # Rails tests, with coverage thresholds
COVERAGE_SUITE=system SKIP_COVERAGE_MINIMUM=1 bin/rails test:system
bin/coverage                        # merge suites and enforce final coverage thresholds
RAILS_ENV=test bin/ci                # full checked-in CI pipeline
```

`bin/setup --reset` is explicitly destructive: it resets the selected environment's database. Normal setup/rename does not drop databases. Unknown setup options fail before commands start.

CSS source is `app/assets/tailwind/application.css`; output under `app/assets/builds` is ignored by Git. Keep complete class names in source or add explicit Tailwind source declarations for dynamically constructed tokens, as done for `AvatarComponent`.

## Quality checks

`bin/ci` runs:

- Setup and isolated template-script tests (no real databases or servers in those fixtures).
- Overcommit hooks: Ruby/ERB/Reek and file-format checks.
- Actionlint and Rails Zeitwerk autoload checks.
- Bundler/Importmap dependency audits and Brakeman code analysis.
- Rails tests, browser/accessibility tests, seed validation, and merged coverage enforcement.

Install `actionlint` and Chrome/Chromium locally to run the same checks. CI installs its own tools. `bin/ci --fix` additionally runs formatting auto-fixes.

Coverage gates are **95% line**, **95% branch**, and **80% per file**. Rails and system tests use separate suite names so merging does not overwrite earlier results. System tests can defer thresholds until `bin/coverage`; the final report fails when coverage is insufficient or empty. CI clears previous coverage before running tests so stale results cannot inflate it. Reports remain under ignored `coverage/`.

Never bypass Git hooks or add inline RuboCop/Reek suppressions. Prefer conventional commits. See [CLAUDE.md](CLAUDE.md), [developer tools](bin/README.md), and [the maintenance audit](docs/maintenance-audit.md).

## Before deployment or privacy-sensitive use

- Configure your application's host allowlist, CSP, mail delivery, and deployment settings; the template's placeholders are not production configuration.
- Existing Gravatar support requests external images. Disable or replace it for offline/private applications such as a local session companion.
- Production Docker builds exclude development **and test** gems and build CSS locally. Docker/Kamal deployment requires its own validation and explicitly provisioned secrets.

## License

[MIT](https://opensource.org/licenses/MIT).
