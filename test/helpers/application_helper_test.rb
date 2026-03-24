require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "format_phone returns nil for blank input" do
    assert_nil format_phone(nil)
    assert_nil format_phone("")
  end

  test "format_phone formats 10-digit number" do
    assert_equal "(555) 123-4567", format_phone("5551234567")
  end

  test "format_phone formats 11-digit number with leading 1" do
    assert_equal "(555) 123-4567", format_phone("15551234567")
  end

  test "format_phone formats number with punctuation" do
    assert_equal "(555) 123-4567", format_phone("+1 (555) 123-4567")
  end

  test "format_phone returns original for non-standard length" do
    assert_equal "12345", format_phone("12345")
  end

  test "nav_link renders active state for current page" do
    # Stub current_page? to return true
    def current_page?(_path)
      true
    end

    result = nav_link("Dashboard", "/")
    assert_includes result, "border-emerald-500"
    assert_includes result, 'aria-current="page"'
    assert_includes result, "Dashboard"
  end

  test "nav_link renders inactive state for other pages" do
    def current_page?(_path)
      false
    end

    result = nav_link("Products", "/products")
    assert_includes result, "border-transparent"
    assert_includes result, "Products"
    assert_not_includes result, "aria-current"
  end

  test "mobile_nav_link renders active state for current page" do
    def current_page?(_path)
      true
    end

    result = mobile_nav_link("Dashboard", "/")
    assert_includes result, "border-emerald-500"
    assert_includes result, 'aria-current="page"'
  end

  test "mobile_nav_link renders inactive state for other pages" do
    def current_page?(_path)
      false
    end

    result = mobile_nav_link("Products", "/products")
    assert_includes result, "border-transparent"
    assert_not_includes result, "aria-current"
  end
end
