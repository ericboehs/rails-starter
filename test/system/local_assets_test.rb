require "application_system_test_case"

class LocalAssetsTest < ApplicationSystemTestCase
  test "sign in uses compiled local CSS rather than a browser CDN" do
    css = Rails.root.join("app/assets/builds/tailwind.css").read
    %w[ .size-8 .size-20 .text-sm .text-2xl ].each { |token| assert_includes css, token }

    { "light" => "rgb(5, 150, 105)", "dark" => "rgb(16, 185, 129)" }.each do |scheme, color|
      page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [ { name: "prefers-color-scheme", value: scheme } ])
      visit new_session_path
      assert_no_selector "script[src^='https://'], script[src^='http://']", visible: :all
      assert_equal color, page.evaluate_script("getComputedStyle(document.querySelector('.bg-emerald-600')).backgroundColor")
      page.driver.browser.execute_cdp("Emulation.setDeviceMetricsOverride", width: 375, height: 900, deviceScaleFactor: 1, mobile: true)
      assert_equal 375, page.evaluate_script("window.innerWidth")
      assert page.evaluate_script("document.documentElement.scrollWidth <= window.innerWidth")
      if ENV["CAPTURE_STARTER_QA"] == "1"
        page.save_screenshot(Rails.root.join("tmp/screenshots/local-sign-in-#{scheme}.png"))
      end
    end
  ensure
    page.driver.browser.execute_cdp("Emulation.clearDeviceMetricsOverride")
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [])
  end
end
