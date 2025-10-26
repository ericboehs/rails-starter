require "application_system_test_case"

# Tests application accessibility compliance with WCAG 2.1 AA standards
class AccessibilityTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(
      email_address: "accessibility@example.com",
      password: "password123"
    )
  end

  test "sign up page is accessible" do
    visit new_user_path
    assert_accessible
  end

  test "sign in page is accessible" do
    visit new_session_path
    assert_accessible
  end

  test "password reset page is accessible" do
    visit new_password_path
    assert_accessible
  end

  test "home page is accessible when signed in" do
    sign_in_as @user
    visit root_path
    assert_accessible
  end

  test "user page is accessible" do
    sign_in_as @user
    visit user_path(@user)
    assert_accessible
  end

  private

  def sign_in_as(user)
    visit new_session_path
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password123"
    click_button "Sign in"
  end
end
