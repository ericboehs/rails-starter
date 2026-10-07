require "test_helper"
require "axe/matchers/be_axe_clean"

# Silence Puma server output during system tests
Capybara.server = :puma, { Silent: true }

# Base class for system tests with Capybara and accessibility testing setup
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ] do |options|
    # Stop macOS Chrome copying its ~1 GB app bundle into
    # /var/folders/.../X/com.google.Chrome.code_sign_clone/ on every launch;
    # headless Chrome often leaves the copy behind.
    options.add_argument("--disable-features=MacAppCodeSignClone")
  end

  # Assert that the current page is accessible according to WCAG 2.1 AA standards
  def assert_accessible(page = self.page, matcher = Axe::Matchers::BeAxeClean.new.according_to(:wcag21aa, "best-practice"))
    audit_result = matcher.audit(page)
    assert(audit_result.passed?, audit_result.failure_message)
  end
end
