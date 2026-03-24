# Test helper for signing in users during integration tests
module AuthenticationHelpers
  def sign_in_as(user, password: "password123")
    post session_url, params: { email_address: user.email_address, password: password }
  end
end
