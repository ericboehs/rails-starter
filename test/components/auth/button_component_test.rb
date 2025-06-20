# frozen_string_literal: true

require "test_helper"

class Auth::ButtonComponentTest < ViewComponent::TestCase
  def test_renders_primary_button
    component = Auth::ButtonComponent.new(text: "Sign In", type: :submit, variant: :primary)
    render_inline(component)

    assert_selector "button[type='submit']"
    assert_text "Sign In"
    assert_selector "button.bg-emerald-600"
  end

  def test_renders_secondary_button
    component = Auth::ButtonComponent.new(text: "Cancel", variant: :secondary)
    render_inline(component)

    assert_selector "button"
    assert_text "Cancel"
    assert_selector "button.bg-white"
  end

  def test_applies_custom_classes
    component = Auth::ButtonComponent.new(text: "Test", class: "w-full")
    render_inline(component)

    assert_selector "button.w-full"
  end

  def test_renders_button_with_unknown_variant
    component = Auth::ButtonComponent.new(
      text: "Unknown Variant Button",
      variant: :unknown
    )
    render_inline(component)

    assert_selector "button", text: "Unknown Variant Button"
    # Should still render button but without variant-specific classes
    assert_selector ".rounded-md" # Should have base classes
  end
end
