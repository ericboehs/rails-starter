# These CLI checks run without booting Rails or opening a real database/server.
require "bundler/setup"
require "minitest/autorun"
require "fileutils"
require "open3"
require "rbconfig"
require "tmpdir"

class TemplateScriptsTest < Minitest::Test
  SOURCE_ROOT = File.expand_path("..", __dir__)

  def setup
    @root = Dir.mktmpdir("starter-script-test-")
    FileUtils.mkdir_p([ path("bin"), path("config"), path("storage") ])
    %w[ rename-app setup watch-ci ].each do |script|
      FileUtils.cp(File.join(SOURCE_ROOT, "bin", script), path("bin/#{script}"))
    end
    File.write(path("config/application.rb"), "module RailsStarter\nend\n")
    File.write(path("README.md"), "Rails Starter / RailsStarter / rails_starter\n")
  end

  def teardown
    FileUtils.remove_entry(@root)
  end

  def test_rename_works_outside_app_directory_and_handles_acronyms
    output, status = run_script("rename-app", "JSONApi", chdir: Dir.tmpdir)
    assert status.success?, output
    assert_equal "module JSONApi\nend\n", File.read(path("config/application.rb"))
    assert_equal "JSONApi / JSONApi / json_api\n", File.read(path("README.md"))
    assert_includes output, "Credentials and databases were left untouched"
    refute_includes output, "db:drop"
  end

  def test_rename_does_not_touch_credential_files_or_database
    # Deliberately fake sentinels, not copied from a real checkout or secret store.
    protected_files = %w[ config/master.key config/credentials.yml.enc storage/development.sqlite3 ]
    protected_files.each { |file| File.write(path(file), "fictional fixture sentinel") }
    output, status = run_script("rename-app", "PsstWeb")
    assert status.success?, output
    protected_files.each { |file| assert_equal "fictional fixture sentinel", File.read(path(file)) }
  end

  def test_invalid_names_and_extra_arguments_change_nothing
    [ [], [ "" ], [ "snake_case" ], [ "../Bad" ], [ "Two Words" ], [ "One", "Two" ] ].each do |args|
      output, status = run_script("rename-app", *args)
      refute status.success?, output
      assert_includes output, "Usage:"
      assert_equal "module RailsStarter\nend\n", File.read(path("config/application.rb"))
    end
  end

  def test_rename_refuses_already_renamed_application
    run_script("rename-app", "PsstWeb")
    output, status = run_script("rename-app", "OtherApp")
    refute status.success?, output
    assert_includes output, "not an unrenamed"
    assert_equal "module PsstWeb\nend\n", File.read(path("config/application.rb"))
  end

  def test_rename_preflights_links_before_any_write
    File.write(path("outside.txt"), "Rails Starter sentinel")
    FileUtils.rm(path("README.md"))
    File.symlink(path("outside.txt"), path("README.md"))
    output, status = run_script("rename-app", "PsstWeb")
    refute status.success?, output
    assert_includes output, "Refusing to rename"
    assert_equal "module RailsStarter\nend\n", File.read(path("config/application.rb"))
    assert_equal "Rails Starter sentinel", File.read(path("outside.txt"))
  end

  def test_setup_without_server_prepares_database_signs_hooks_and_builds_css
    fake_commands
    output, status = run_script("setup", "--skip-server", chdir: Dir.tmpdir)
    assert status.success?, output
    assert_includes calls, "rails db:prepare"
    assert_includes calls, "rails tailwindcss:build"
    %w[ pre-commit post-checkout post-merge post-rewrite ].each do |hook|
      assert_includes calls, "bundle exec overcommit --sign #{hook}"
    end
    refute_includes calls, "db:reset"
    refute_includes calls, "dev started"
  end

  def test_setup_reset_is_explicit_and_default_starts_development
    fake_commands
    output, status = run_script("setup", "--reset")
    assert status.success?, output
    assert_includes calls, "rails db:reset"
    assert_includes calls, "dev started"
  end

  def test_setup_aborts_if_hook_signing_fails
    fake_commands
    output, status = run_script("setup", "--skip-server", env: { "FIXTURE_FAIL_SIGN" => "1" })
    refute status.success?, output
    refute_includes calls, "rails db:prepare"
    refute_includes calls, "dev started"
  end

  def test_setup_rejects_unknown_options_without_starting_commands
    fake_commands
    output, status = run_script("setup", "--typo")
    refute status.success?, output
    refute File.exist?(path("calls.log"))
  end

  def test_watch_ci_exits_successfully_when_checks_pass
    executable("git", "printf 'fixture-branch\\n'\n")
    executable("jq", "exit 0\n")
    executable("gh", "printf 'CI\\tpass\\t1s\\thttps://example.invalid/fixture\\n'\n")
    output, status = run_script("watch-ci")
    assert status.success?, output
    assert_includes output, "All checks passed"
  end

  private

  def path(relative)
    File.join(@root, relative)
  end

  def run_script(script, *args, chdir: @root, env: {})
    # Bundler's RUBYOPT would prepend its own bin directory in the child and
    # accidentally replace the fixture bundle command with a real one.
    environment = { "PATH" => "#{path('bin')}:#{ENV.fetch('PATH')}", "FIXTURE_LOG" => path("calls.log"),
                    "RUBYOPT" => nil, "RUBYLIB" => nil, "BUNDLE_GEMFILE" => nil }.merge(env)
    interpreter = script == "watch-ci" ? "/bin/bash" : RbConfig.ruby
    Open3.capture2e(environment, interpreter, path("bin/#{script}"), *args, chdir: chdir)
  end

  def fake_commands
    executable("bundle", <<~SH)
      printf 'bundle %s\n' "$*" >> "$FIXTURE_LOG"
      if [ "${FIXTURE_FAIL_SIGN:-}" = 1 ] && [ "${3:-}" = --sign ]; then exit 1; fi
    SH
    executable("rails", "printf 'rails %s\\n' \"$*\" >> \"$FIXTURE_LOG\"\n")
    executable("dev", "printf 'dev started\\n' >> \"$FIXTURE_LOG\"\n")
  end

  def executable(name, body)
    File.write(path("bin/#{name}"), "#!/bin/sh\n#{body}")
    File.chmod(0o755, path("bin/#{name}"))
  end

  def calls
    File.read(path("calls.log"))
  end
end
