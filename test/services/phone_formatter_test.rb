require "test_helper"

class PhoneFormatterTest < ActiveSupport::TestCase
  test "returns nil for blank input" do
    assert_nil PhoneFormatter.call(nil)
    assert_nil PhoneFormatter.call("")
  end

  test "formats 10-digit number" do
    assert_equal "(555) 123-4567", PhoneFormatter.call("5551234567")
  end

  test "formats 11-digit number with leading 1" do
    assert_equal "(555) 123-4567", PhoneFormatter.call("15551234567")
  end

  test "formats number with punctuation" do
    assert_equal "(555) 123-4567", PhoneFormatter.call("+1 (555) 123-4567")
  end

  test "returns original for non-standard length" do
    assert_equal "12345", PhoneFormatter.call("12345")
  end
end
