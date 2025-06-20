require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )
  end

  test "should get new" do
    get new_session_url
    assert_response :success
    assert_select "h2", "Sign in to your account"
  end

  test "should create session with valid credentials" do
    post session_url, params: {
      email_address: @user.email_address,
      password: "password123"
    }

    assert_redirected_to root_url
    assert_not_nil cookies[:session_id]
  end

  test "should not create session with invalid credentials" do
    post session_url, params: {
      email_address: @user.email_address,
      password: "wrongpassword"
    }

    assert_redirected_to new_session_url
    assert_equal "Invalid email or password", flash[:alert]
  end

  test "should not create session with non-existent user" do
    post session_url, params: {
      email_address: "nonexistent@example.com",
      password: "password123"
    }

    assert_redirected_to new_session_url
    assert_equal "Invalid email or password", flash[:alert]
  end

  test "should destroy session" do
    # First sign in
    post session_url, params: {
      email_address: @user.email_address,
      password: "password123"
    }

    # Then sign out
    delete session_url
    assert_redirected_to new_session_url
  end

  test "should redirect to intended URL after authentication" do
    # Try to access protected page
    get user_url
    assert_redirected_to new_session_url

    # Sign in
    post session_url, params: {
      email_address: @user.email_address,
      password: "password123"
    }

    # Should redirect to originally requested page
    assert_redirected_to user_url
  end
end
