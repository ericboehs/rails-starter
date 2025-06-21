require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email_address: "test@example.com", password: "password123")
  end

  test "should get index when authenticated" do
    sign_in_as(@user)
    get root_url

    assert_response :success
    assert_select "h1", "Welcome to RailsStarter"
  end

  test "should redirect to sign in when not authenticated" do
    get root_url

    assert_redirected_to new_session_url
  end

  private

  def sign_in_as(user)
    post session_url, params: { email_address: user.email_address, password: "password123" }
  end
end
