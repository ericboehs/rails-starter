require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "should belong to user" do
    user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )

    session = Session.new(
      user: user,
      user_agent: "Test Agent",
      ip_address: "127.0.0.1"
    )

    assert session.valid?
    assert_equal user, session.user
  end

  test "should require user" do
    session = Session.new(
      user_agent: "Test Agent",
      ip_address: "127.0.0.1"
    )

    assert_not session.valid?
    assert_includes session.errors[:user], "must exist"
  end

  test "should store user agent and ip address" do
    user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )

    session = Session.create!(
      user: user,
      user_agent: "Mozilla/5.0 Test Browser",
      ip_address: "192.168.1.100"
    )

    assert_equal "Mozilla/5.0 Test Browser", session.user_agent
    assert_equal "192.168.1.100", session.ip_address
  end
end
