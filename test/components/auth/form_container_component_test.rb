# frozen_string_literal: true

require "test_helper"

class Auth::FormContainerComponentTest < ViewComponent::TestCase
  def test_renders_with_title_key
    component = Auth::FormContainerComponent.new(title_key: "auth.sign_in.title")
    render_inline(component) { "Form content" }

    assert_selector "h2", text: "Sign in to your account"
    assert_text "Form content"
    assert_selector ".flex.min-h-full.flex-col"
  end

  def test_renders_with_title_and_subtitle
    component = Auth::FormContainerComponent.new(
      title_key: "auth.sign_in.title",
      title: "Custom Title",
      subtitle: "Custom Subtitle"
    )
    render_inline(component) { "Form content" }

    assert_selector "h2", text: "Custom Title"
    assert_selector "p", text: "Custom Subtitle"
  end

  def test_renders_logo
    component = Auth::FormContainerComponent.new(title_key: "auth.sign_in.title")
    render_inline(component) { "Form content" }

    assert_selector "img[alt='RailsStarter']"
  end

  def test_renders_with_title_key_only
    component = Auth::FormContainerComponent.new(title_key: "auth.sign_up.title")
    render_inline(component) { "Form content" }

    assert_selector "h2", text: "Create your account"
    assert_text "Form content"
  end

  def test_renders_with_subtitle_key
    component = Auth::FormContainerComponent.new(
      title_key: "auth.sign_in.title",
      subtitle_key: "auth.sign_in.subtitle"
    )
    render_inline(component) { "Form content" }

    assert_selector "h2", text: "Sign in to your account"
    assert_selector "p", text: "Welcome back to RailsStarter"
  end

  def test_renders_with_nil_title_key
    component = Auth::FormContainerComponent.new(
      title_key: nil,
      title: "Custom Title"
    )
    render_inline(component) { "Form content" }

    assert_selector "h2", text: "Custom Title"
    assert_text "Form content"
  end
end
