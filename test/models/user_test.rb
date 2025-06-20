require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email_address: "existing@example.com",
      password: "password123"
    )
  end

  test "should create user with valid attributes" do
    user = User.new(
      email_address: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.valid?
    assert user.save
  end

  test "should require email address" do
    user = User.new(password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "should require password" do
    user = User.new(email_address: "test@example.com")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "should validate unique email address" do
    User.create!(
      email_address: "test@example.com",
      password: "password123"
    )

    duplicate_user = User.new(
      email_address: "test@example.com",
      password: "password123"
    )
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email_address], "has already been taken"
  end

  test "should authenticate with correct password" do
    user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )

    authenticated_user = User.authenticate_by(
      email_address: "test@example.com",
      password: "password123"
    )
    assert_equal user, authenticated_user
  end

  test "should not authenticate with incorrect password" do
    User.create!(
      email_address: "test@example.com",
      password: "password123"
    )

    authenticated_user = User.authenticate_by(
      email_address: "test@example.com",
      password: "wrongpassword"
    )
    assert_nil authenticated_user
  end

  test "should generate initials from email" do
    user = User.new(email_address: "john.doe@example.com")
    assert_equal "J", user.initials
  end

  test "should generate avatar URL" do
    user = User.new(email_address: "test@example.com")
    avatar_url = user.avatar_url
    assert_includes avatar_url, "gravatar.com"
    assert_includes avatar_url, "d=" # default parameter
  end

  test "should have many sessions" do
    user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )

    session1 = user.sessions.create!(user_agent: "Test Agent 1", ip_address: "127.0.0.1")
    session2 = user.sessions.create!(user_agent: "Test Agent 2", ip_address: "127.0.0.1")

    assert_includes user.sessions, session1
    assert_includes user.sessions, session2
    assert_equal 2, user.sessions.count
  end

  test "should destroy dependent sessions when user is destroyed" do
    user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )

    session = user.sessions.create!(user_agent: "Test Agent", ip_address: "127.0.0.1")
    session_id = session.id

    user.destroy

    assert_not Session.exists?(session_id)
  end

  test "should generate initials from email with nil email" do
    user = User.new(email_address: nil)
    assert_equal "?", user.initials
  end

  test "should find user by password reset token" do
    token = @user.signed_id(purpose: :password_reset, expires_in: 20.minutes)
    found_user = User.find_by_password_reset_token!(token)
    assert_equal @user, found_user
  end

  test "should raise error for invalid password reset token" do
    assert_raises(ActiveSupport::MessageVerifier::InvalidSignature) do
      User.find_by_password_reset_token!("invalid_token")
    end
  end
end
