# frozen_string_literal: true

require "test_helper"

class AlertComponentTest < ViewComponent::TestCase
  def test_renders_success_alert
    component = AlertComponent.new(type: :success, message: "Success message")
    render_inline(component)

    assert_text "Success message"
    assert_selector ".bg-green-50"
    assert_selector ".text-green-800"
  end

  def test_renders_alert_with_messages_list
    component = AlertComponent.new(
      type: :success,
      messages: [ "First message", "Second message" ]
    )
    render_inline(component)

    assert_text "First message"
    assert_text "Second message"
    assert_selector "ul"
  end

  def test_renders_error_alert
    component = AlertComponent.new(type: :error, message: "Error message")
    render_inline(component)

    assert_text "Error message"
    assert_selector ".bg-red-50"
    assert_selector ".text-red-800"
  end

  def test_renders_warning_alert
    component = AlertComponent.new(type: :warning, message: "Warning message")
    render_inline(component)

    assert_text "Warning message"
    assert_selector ".bg-yellow-50"
    assert_selector ".text-yellow-800"
  end

  def test_renders_info_alert
    component = AlertComponent.new(type: :info, message: "Info message")
    render_inline(component)

    assert_text "Info message"
    assert_selector ".bg-blue-50"
    assert_selector ".text-blue-800"
  end

  def test_renders_dismissible_alert
    component = AlertComponent.new(
      type: :success,
      message: "Dismissible message",
      dismissible: true
    )
    render_inline(component)

    assert_selector "button"
    assert_text "Dismissible message"
  end

  def test_renders_alert_type_with_icon
    component = AlertComponent.new(
      type: :success,
      message: "Message with icon"
    )
    render_inline(component)

    # Check that the component includes SVG icon
    assert_selector "svg", count: 1
  end

  def test_renders_alert_type_without_dismissible
    component = AlertComponent.new(
      type: :warning,
      message: "Warning message",
      dismissible: false
    )
    render_inline(component)

    assert_no_selector "button"
    assert_text "Warning message"
  end

  def test_renders_all_alert_icon_types
    [ :success, :error, :warning, :info ].each do |type|
      component = AlertComponent.new(type: type, message: "Test message")
      render_inline(component)

      assert_selector "svg"
    end
  end

  def test_renders_alert_type_alias
    component = AlertComponent.new(type: :alert, message: "Alert message")
    render_inline(component)

    assert_text "Alert message"
    assert_selector ".bg-red-50" # Should use error styling
  end

  def test_renders_dismissible_button_styles_for_all_types
    [ :success, :error, :warning, :info ].each do |type|
      component = AlertComponent.new(
        type: type,
        message: "Dismissible #{type} message",
        dismissible: true
      )
      render_inline(component)

      assert_selector "button"
      assert_text "Dismissible #{type} message"
    end
  end

  def test_handles_unknown_alert_type_gracefully
    component = AlertComponent.new(
      type: :unknown,
      message: "Unknown type message"
    )
    render_inline(component)

    assert_text "Unknown type message"
    # Should still render but without type-specific styling
    assert_selector ".rounded-md" # Base classes should still be present
  end

  def test_handles_unknown_type_with_dismissible_button
    component = AlertComponent.new(
      type: :unknown,
      message: "Unknown type dismissible",
      dismissible: true
    )
    render_inline(component)

    assert_text "Unknown type dismissible"
    assert_selector "button" # Should still render dismiss button
  end
end
