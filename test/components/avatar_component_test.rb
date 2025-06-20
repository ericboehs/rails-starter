require "test_helper"

class AvatarComponentTest < ViewComponent::TestCase
  test "renders avatar with default size" do
    user = User.create!(email_address: "test@example.com", password: "password123")
    render_inline(AvatarComponent.new(user: user))

    assert_selector "div.size-8.rounded-full.bg-emerald-600"
    assert_selector "img.size-8.rounded-full"
    assert_selector "span.text-sm.font-medium.text-white.hidden"
  end

  test "renders avatar with custom size" do
    user = User.create!(email_address: "test@example.com", password: "password123")
    render_inline(AvatarComponent.new(user: user, size: 20, text_size: "2xl"))

    assert_selector "div.size-20.rounded-full.bg-emerald-600"
    assert_selector "img.size-20.rounded-full"
    assert_selector "span.text-2xl.font-medium.text-white.hidden"
  end

  test "includes user email as alt text" do
    user = User.create!(email_address: "test@example.com", password: "password123")
    render_inline(AvatarComponent.new(user: user))

    assert_selector "img[alt='#{user.email_address}']"
  end

  test "includes fallback initials" do
    user = User.create!(email_address: "test@example.com", password: "password123")
    render_inline(AvatarComponent.new(user: user))

    assert_text user.initials
  end
end
