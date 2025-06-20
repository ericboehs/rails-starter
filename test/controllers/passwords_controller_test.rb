require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )
  end

  test "should get new" do
    get new_password_url
    assert_response :success
    assert_select "h2", "Forgot your password?"
  end

  test "should create password reset request with valid email" do
    post passwords_url, params: {
      email_address: @user.email_address
    }

    assert_redirected_to new_session_url
    assert_equal "Password reset instructions sent (if user with that email address exists).", flash[:notice]
  end

  test "should create password reset request with invalid email" do
    post passwords_url, params: {
      email_address: "nonexistent@example.com"
    }

    assert_redirected_to new_session_url
    assert_equal "Password reset instructions sent (if user with that email address exists).", flash[:notice]
  end

  test "should get edit with valid token" do
    token = @user.signed_id(purpose: :password_reset, expires_in: 20.minutes)
    get edit_password_url(token: token)
    assert_response :success
    assert_select "h2", "Reset your password"
  end

  test "should update password with valid params" do
    token = @user.signed_id(purpose: :password_reset, expires_in: 20.minutes)

    patch password_url(token: token), params: {
      password: "newpassword123",
      password_confirmation: "newpassword123"
    }

    assert_redirected_to new_session_url
    assert_equal "Password has been reset.", flash[:notice]
  end

  test "should not update password with invalid params" do
    token = @user.signed_id(purpose: :password_reset, expires_in: 20.minutes)

    patch password_url(token: token), params: {
      password: "new",
      password_confirmation: "different"
    }

    assert_redirected_to edit_password_url(token: token)
    assert_equal "Passwords did not match.", flash[:alert]
  end
end
