# Template maintenance audit — September 2026

## Scope and baseline

Audited tracked application/tooling source and configuration, dependency versions,
and GitHub CI run/job metadata. Secrets, encrypted credentials, local databases,
deployment secret files, user-level lint configuration, and remote CI log contents were
not inspected. Runtime/bootstrap checks use a temporary source-only copy, with
fresh test data and no application secrets copied from the working checkout.

The starting GitHub main was `ee2632e` (its April 12 push CI passed). The local
checkout additionally contains `69bac6c`, the tooltip Stimulus controller; this
commit is preserved unchanged. Recent dependency-PR CI metadata showed failures
in the `Run CI pipeline` step, but metadata alone does not establish their cause.
No remote CI success is claimed for this maintenance branch until it is pushed
and tested there.

## Changes

- Align Ruby 4.0.6 across the runtime declarations and Docker image argument.
- Require Rails 8.1.3.1 or newer in the 8.1 series; update the lockfile with stable
  Bundler 4.0.20 and compatible minor/patch gem updates. Respect the existing
  dependency cooldown; broad major-version upgrades are not part of this pass.
- Replace the Tailwind browser CDN with a local v4 compiler and a development-only
  Puma watcher. Keep the emerald palette and explicitly include dynamically
  constructed avatar size/text classes. Production asset precompilation also
  builds CSS. Generated assets stay ignored.
- Make rename independent of the caller's directory, validate its name/arguments,
  preflight source links before writing, and refuse an already-renamed app.
  Credentials and databases remain untouched. Remove the misleading credential
  regeneration promise and destructive database-reset recommendation.
- Make setup reject unknown options and fail if hook signing fails; build CSS
  even with `--skip-server`. Keep resets explicitly opt-in.
- Remove the seeded shared administrator/default password. Registration remains
  available through `/users/new`.
- Correct `watch-ci`'s `set -e` handling so its internal success code does not
  cause an unsuccessful process exit. Test it with fake Git/GitHub commands.
- Use distinct Rails/system coverage suite names and enforce the merged coverage
  thresholds with the locked SimpleCov implementation. Clear previous CI coverage
  first, reject empty reports, and replace independent Bundler-inline dependency
  resolution and HTML scraping.
- Retain signature verification in CI, bound job runtime, and exclude both
  development and test gems from production Docker images.
- Refresh the README and agent/tooling guidance so the project is accurately
  described as a reusable Rails Starter template.

## Validation

The complete checked-in `bin/ci` pipeline is exercised in the secret-free copy:
bootstrap fixtures, Overcommit (RuboCop, ERB lint, Reek and format checks),
actionlint, Zeitwerk, Bundler/Importmap audits, Brakeman, Rails/system tests,
seeds, and merged coverage gates. Dedicated CLI tests cover invalid names,
caller-independent rename, credential/database sentinels, symlink refusal,
setup flags, hook-signing failures, and CI watch success. Coverage-report tests
verify missing results, suite merging, and a failing below-threshold report.

The local-assets browser regression checks compiled CSS, the dynamic avatar
classes, absence of browser script CDNs, and mobile overflow. Runtime checks do
not use real session data, email addresses, or production secrets.

Final local verification:

- Full `bin/ci` passed for the unchanged template namespace and a newly renamed
  `StarterSmoke` fixture, both with fresh test databases and no copied secrets.
- 97 Rails/CLI tests (285 assertions), 11 system tests (38 assertions), and the
  separately invoked 10 bootstrap CLI checks passed with no failures or skips.
- Coverage: **99.27% line / 97.50% branch**. Below-threshold and empty-report
  fixtures correctly exit unsuccessfully.
- Overcommit, actionlint, dependency audits, and Brakeman passed. Brakeman found
  zero warnings/errors. Zeitwerk passed with its informational notice that mailer
  previews are not eager-loaded.
- Rename from a different working directory, setup without starting a server,
  zero seeded accounts, and production asset precompilation all passed in the
  renamed fixture. No Docker build or deployment was performed.
- Light/dark sign-in screens were rendered and inspected. The mobile check uses
  an explicit **375px** emulated viewport (not Chrome's minimum native window
  width), verifies the exact width and absence of overflow, and confirms the
  local CSS palette. Test captures contain no real user/session data.

## Remaining application-specific work

- The starter still supports external Gravatar images. An offline/private app
  such as psst-web should replace them with local initials or another local asset.
- Configure CSP, production host allowlists, mail settings, and deployment for
  each generated application. Existing commented/default settings are not a
  complete production policy.
- Do not blindly copy credentials or working directories into a generated app.
  Provision new secrets through a secret manager/environment when needed.
- GitHub Actions remain pinned to the reviewed SHAs. Existing major-version
  dependency/action PRs are not automatically merged as part of this local pass.
- Docker image builds and actual deployment are separate from host-side asset
  precompilation and local CI; neither is implied by a passing local test suite.
