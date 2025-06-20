require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  setup do
    @user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )
  end

  test "reset password email" do
    mail = PasswordsMailer.reset(@user)

    assert_equal "Reset your password", mail.subject
    assert_equal [ @user.email_address ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "reset your password", mail.body.encoded
  end
end
