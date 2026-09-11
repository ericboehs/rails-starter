require "bundler/setup"
require "minitest/autorun"
require "fileutils"
require "json"
require "open3"
require "rbconfig"
require "tmpdir"

class CoverageScriptTest < Minitest::Test
  SOURCE_ROOT = File.expand_path("..", __dir__)

  def setup
    @root = File.realpath(Dir.mktmpdir("coverage-script-test-"))
    %w[ bin coverage app/services ].each { |dir| FileUtils.mkdir_p(File.join(@root, dir)) }
    FileUtils.cp(File.join(SOURCE_ROOT, "bin/coverage"), File.join(@root, "bin/coverage"))
    @source = File.join(@root, "app/services/fixture.rb")
    File.write(@source, "puts :first\nputs :second\n")
  end

  def teardown
    FileUtils.remove_entry(@root)
  end

  def test_missing_results_fail_with_direction
    output, status = report
    refute status.success?
    assert_includes output, "Run bin/rails test first"
  end

  def test_merged_suites_meet_threshold_together
    write_results("rails" => [ 1, 0 ], "system" => [ 0, 1 ])
    output, status = report
    assert status.success?, output
    assert_includes output, "Line coverage: 100.00%"
  end

  def test_empty_report_is_not_a_passing_coverage_result
    File.write(File.join(@root, "coverage/.resultset.json"), JSON.generate({ "rails" => { coverage: {}, timestamp: Time.now.to_i } }))
    output, status = report
    refute status.success?, output
    assert_includes output, "No application files"
  end

  def test_below_threshold_results_fail
    write_results("rails" => [ 1, 0 ])
    output, status = report
    refute status.success?, output
    assert_includes output, "below the expected minimum coverage"
  end

  private

  def write_results(suites)
    data = suites.transform_values do |lines|
      { coverage: { @source => { lines: lines, branches: {} } }, timestamp: Time.now.to_i }
    end
    File.write(File.join(@root, "coverage/.resultset.json"), JSON.generate(data))
  end

  def report
    env = { "BUNDLE_GEMFILE" => File.join(SOURCE_ROOT, "Gemfile"), "GITHUB_STEP_SUMMARY" => nil }
    Open3.capture2e(env, RbConfig.ruby, File.join(@root, "bin/coverage"), chdir: @root)
  end
end
