require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )
  end

  test "user can sign in with valid credentials" do
    visit new_session_path

    # Check that the sign-in form is displayed
    assert_text "Sign in to your account"
    # Note: subtitle is not shown unless subtitle_key is provided to FormContainerComponent

    # Fill in the form
    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password123"

    # Submit the form
    click_button "Sign in"

    # Should be redirected after successful sign in
    # Note: The exact redirect location depends on the authentication setup
    assert_current_path "/"
  end

  test "user cannot sign in with invalid credentials" do
    visit new_session_path

    # Fill in the form with wrong password
    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "wrongpassword"

    # Submit the form
    click_button "Sign in"

    # Should remain on sign-in page with error
    assert_current_path new_session_path
    assert_text "Invalid email or password"
  end

  test "user can access forgot password" do
    visit new_session_path

    # Click forgot password link
    click_link "Forgot password?"

    # Should be on password reset page
    assert_current_path new_password_path
  end

  test "sign in form has proper styling and components" do
    visit new_session_path

    # Check that form elements have proper styling classes
    assert_selector "input[type='email']", class: /block w-full rounded-md/
    assert_selector "input[type='password']", class: /block w-full rounded-md/
    assert_selector "button[type='submit']", class: /bg-emerald-600/

    # Check for proper labels
    assert_selector "label", text: "Email address"
    assert_selector "label", text: "Password"
  end

  test "form has proper accessibility attributes" do
    visit new_session_path

    email_input = find("input[type='email']")
    password_input = find("input[type='password']")

    # Check for proper IDs and labels
    assert email_input[:id].present?
    assert password_input[:id].present?

    # Check for autocomplete attributes
    assert_equal "username", email_input[:autocomplete]
    assert_equal "current-password", password_input[:autocomplete]

    # Check for required attributes
    assert email_input[:required]
    assert password_input[:required]
  end
end
