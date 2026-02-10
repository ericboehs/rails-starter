# frozen_string_literal: true

require "test_helper"

# Tests the Auth::InputComponent component
class Auth::InputComponentTest < ViewComponent::TestCase
  def test_renders_email_input
    form = ActionView::Helpers::FormBuilder.new(:user, User.new, vc_test_controller.view_context, {})
    component = Auth::InputComponent.new(
      form: form,
      field: :email_address,
      label: "Email",
      type: :email,
      required: true
    )
    render_inline(component)

    assert_selector "input[type='email']"
    assert_selector "label", text: "Email"
    assert_selector "input[required]"
  end

  def test_renders_password_input
    form = ActionView::Helpers::FormBuilder.new(:user, User.new, vc_test_controller.view_context, {})
    component = Auth::InputComponent.new(
      form: form,
      field: :password,
      label: "Password",
      type: :password
    )
    render_inline(component)

    assert_selector "input[type='password']"
    assert_selector "label", text: "Password"
  end
end
