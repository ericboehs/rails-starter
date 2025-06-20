# ViewComponent Guide

ViewComponent is a framework for building reusable, testable & encapsulated view components in Ruby on Rails. This guide covers implementation, best practices, and advanced features based on the official ViewComponent documentation.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Component Structure](#component-structure)
3. [Templates & Rendering](#templates--rendering)
4. [Slots & Content Areas](#slots--content-areas)
5. [Collections](#collections)
6. [Testing](#testing)
7. [Translations (I18n)](#translations-i18n)
8. [Performance & Caching](#performance--caching)
9. [Advanced Features](#advanced-features)
10. [Best Practices](#best-practices)

## Getting Started

### Installation

Add to your Gemfile:

```ruby
gem "view_component"
```

### Basic Component

Generate a component:

```bash
bin/rails generate component Example title
```

This creates:
- `app/components/example_component.rb`
- `app/components/example_component.html.erb`
- `test/components/example_component_test.rb`

Example component structure:

```ruby
# app/components/example_component.rb
class ExampleComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end

  private

  attr_reader :title
end
```

```erb
<!-- app/components/example_component.html.erb -->
<h1><%= title %></h1>
```

Render in views:

```erb
<%= render ExampleComponent.new(title: "Hello World") %>
```

## Component Structure

### Basic Component Class

```ruby
class ButtonComponent < ViewComponent::Base
  def initialize(text:, variant: :primary, **options)
    @text = text
    @variant = variant
    @options = options
  end

  private

  attr_reader :text, :variant, :options

  def button_classes
    base = "btn"
    variant_class = variant == :primary ? "btn-primary" : "btn-secondary"
    "#{base} #{variant_class}"
  end
end
```

### Template Options

ViewComponent supports multiple template formats:

1. **ERB** (`.html.erb`)
2. **Haml** (`.html.haml`)
3. **Slim** (`.html.slim`)
4. **Inline templates**

Inline template example:

```ruby
class InlineComponent < ViewComponent::Base
  erb_template <<~ERB
    <div class="inline-component">
      <%= content %>
    </div>
  ERB
end
```

## Templates & Rendering

### Template Variants

Support different variants for different contexts:

```ruby
class AlertComponent < ViewComponent::Base
  def initialize(message:, variant: :info)
    @message = message
    @variant = variant
  end

  private

  attr_reader :message, :variant
end
```

Templates:
- `alert_component.html.erb` (default)
- `alert_component.mobile.html.erb` (mobile variant)
- `alert_component.print.html.erb` (print variant)

### Before Render Hook

Use `before_render` for setup with access to view context:

```ruby
class HeaderComponent < ViewComponent::Base
  def before_render
    @current_user = helpers.current_user
    @navigation_items = build_navigation
  end

  private

  def build_navigation
    # Build navigation based on current user
  end
end
```

## Slots & Content Areas

Slots allow components to accept multiple content areas:

```ruby
class CardComponent < ViewComponent::Base
  include ViewComponent::SlotHelper

  # Single slot
  renders_one :header, "HeaderComponent"
  renders_one :footer

  # Multiple slots
  renders_many :actions, "ActionComponent"

  # Slot with block
  renders_one :body do |classes: nil|
    content_tag :div, content, class: ["card-body", classes].compact.join(" ")
  end

  class HeaderComponent < ViewComponent::Base
    def initialize(title:, classes: nil)
      @title = title
      @classes = classes
    end

    private

    attr_reader :title, :classes
  end

  class ActionComponent < ViewComponent::Base
    def initialize(text:, url:, method: :get)
      @text = text
      @url = url
      @method = method
    end

    private

    attr_reader :text, :url, :method
  end
end
```

Usage:

```erb
<%= render CardComponent.new do |card| %>
  <% card.with_header(title: "Card Title") %>
  <% card.with_body(classes: "p-4") do %>
    <p>Card content goes here</p>
  <% end %>
  <% card.with_action(text: "Edit", url: edit_path) %>
  <% card.with_action(text: "Delete", url: delete_path, method: :delete) %>
  <% card.with_footer do %>
    <small class="text-muted">Last updated: <%= @record.updated_at %></small>
  <% end %>
<% end %>
```

## Collections

Render components for collections efficiently:

```ruby
# Render collection of user components
<%= render UserComponent.with_collection(@users) %>

# With counter
<%= render UserComponent.with_collection(@users, counter: true) %>

# Custom collection parameter name
<%= render UserComponent.with_collection(@users, as: :person) %>
```

Collection component:

```ruby
class UserComponent < ViewComponent::Base
  def initialize(user:, counter: nil)
    @user = user
    @counter = counter
  end

  private

  attr_reader :user, :counter

  def css_classes
    classes = ["user-card"]
    classes << "user-card--even" if counter&.even?
    classes
  end
end
```

## Testing

### Basic Component Testing

```ruby
# test/components/button_component_test.rb
require "test_helper"

class ButtonComponentTest < ViewComponent::TestCase
  test "renders button with text" do
    render_inline ButtonComponent.new(text: "Click me")
    
    assert_selector "button", text: "Click me"
    assert_selector "button.btn.btn-primary"
  end

  test "renders secondary variant" do
    render_inline ButtonComponent.new(text: "Cancel", variant: :secondary)
    
    assert_selector "button.btn.btn-secondary"
  end

  test "passes through options" do
    render_inline ButtonComponent.new(
      text: "Submit", 
      disabled: true, 
      data: { confirm: "Are you sure?" }
    )
    
    assert_selector "button[disabled]"
    assert_selector "button[data-confirm='Are you sure?']"
  end
end
```

### Testing with Slots

```ruby
class CardComponentTest < ViewComponent::TestCase
  test "renders card with header and body" do
    render_inline CardComponent.new do |card|
      card.with_header(title: "Test Card")
      card.with_body { "Card content" }
    end

    assert_selector ".card"
    assert_selector ".card-header", text: "Test Card"
    assert_selector ".card-body", text: "Card content"
  end
end
```

### Component Previews

Create previews for development:

```ruby
# test/components/previews/button_component_preview.rb
class ButtonComponentPreview < ViewComponent::Preview
  # Preview at /rails/view_components/button_component/default
  def default
    render ButtonComponent.new(text: "Default Button")
  end

  # Preview at /rails/view_components/button_component/variants
  def variants
    render_with_template(
      locals: {
        primary: ButtonComponent.new(text: "Primary", variant: :primary),
        secondary: ButtonComponent.new(text: "Secondary", variant: :secondary)
      }
    )
  end

  # With parameters
  def with_params(text: "Custom Text", variant: :primary)
    render ButtonComponent.new(text: text, variant: variant.to_sym)
  end
end
```

## Translations (I18n)

### Component Translations

ViewComponent integrates with Rails I18n:

```ruby
class WelcomeComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  private

  attr_reader :user

  def welcome_message
    t(".welcome", name: user.name)
  end
end
```

Translation file (`config/locales/en.yml`):

```yaml
en:
  welcome_component:
    welcome: "Welcome back, %{name}!"
```

### Translation Keys

ViewComponent automatically scopes translation keys:

```ruby
class Navigation::ItemComponent < ViewComponent::Base
  def link_text
    # Looks for: navigation.item_component.link_text
    t(".link_text")
  end
end
```

### Translation Helpers

Use Rails translation helpers in components:

```ruby
class FormComponent < ViewComponent::Base
  def submit_text
    t("forms.submit", default: "Submit")
  end

  def required_field_label(field)
    t(".#{field}_label") + " " + content_tag(:span, "*", class: "required")
  end
end
```

## Performance & Caching

### Component Caching

Cache expensive components:

```ruby
class ExpensiveComponent < ViewComponent::Base
  def initialize(user:, options: {})
    @user = user
    @options = options
  end

  def cache_key
    [@user, @options, self.class.name]
  end

  private

  attr_reader :user, :options
end
```

In template:

```erb
<% cache component.cache_key do %>
  <%= render component %>
<% end %>
```

### Conditional Rendering

Optimize rendering with conditional logic:

```ruby
class ConditionalComponent < ViewComponent::Base
  def initialize(show_advanced: false, user: nil)
    @show_advanced = show_advanced
    @user = user
  end

  def render?
    @user&.admin? || @show_advanced
  end

  private

  attr_reader :show_advanced, :user
end
```

## Advanced Features

### Helpers Integration

Access Rails helpers in components:

```ruby
class UtilityComponent < ViewComponent::Base
  include IconHelper  # Direct inclusion
  
  def formatted_date
    helpers.time_ago_in_words(Time.current)
  end

  def profile_link
    helpers.link_to "Profile", helpers.user_path(current_user)
  end

  # Using use_helpers for specific helpers
  use_helpers :current_user, :user_path
  
  def navigation_link
    link_to "Dashboard", user_path(current_user)
  end
end
```

### Instrumentation

Monitor component performance:

```ruby
# config/application.rb
config.view_component.instrumentation_enabled = true

# Subscribe to events
ActiveSupport::Notifications.subscribe("render.view_component") do |event|
  Rails.logger.info "Rendered #{event.payload[:name]} in #{event.duration}ms"
end
```

### Component Generators

Custom component generators:

```bash
# Generate component with custom template
bin/rails generate component Card title body --template=tailwind

# Generate with namespace
bin/rails generate component Admin::UserCard user
```

## Best Practices

### 1. Component Organization

Organize components by feature or domain:

```
app/components/
├── ui/
│   ├── button_component.rb
│   ├── card_component.rb
│   └── alert_component.rb
├── auth/
│   ├── login_form_component.rb
│   └── signup_form_component.rb
└── shared/
    ├── header_component.rb
    └── footer_component.rb
```

### 2. Component Composition

Build complex components from simpler ones:

```ruby
class ProductCardComponent < ViewComponent::Base
  def initialize(product:)
    @product = product
  end

  private

  attr_reader :product

  def price_component
    PriceComponent.new(amount: product.price, currency: product.currency)
  end

  def badge_component
    return unless product.on_sale?
    BadgeComponent.new(text: "Sale", variant: :success)
  end
end
```

### 3. Props Validation

Validate component inputs:

```ruby
class ButtonComponent < ViewComponent::Base
  VALID_VARIANTS = [:primary, :secondary, :danger].freeze

  def initialize(text:, variant: :primary, **options)
    @text = text
    @variant = validate_variant(variant)
    @options = options
  end

  private

  attr_reader :text, :variant, :options

  def validate_variant(variant)
    unless VALID_VARIANTS.include?(variant)
      raise ArgumentError, "Invalid variant: #{variant}. Must be one of #{VALID_VARIANTS}"
    end
    variant
  end
end
```

### 4. CSS Class Management

Manage CSS classes effectively:

```ruby
class ComponentBase < ViewComponent::Base
  private

  def css_classes(*classes, **conditionals)
    all_classes = classes.flatten.compact
    
    conditionals.each do |css_class, condition|
      all_classes << css_class if condition
    end
    
    all_classes.join(" ")
  end
end

class AlertComponent < ComponentBase
  def initialize(message:, variant: :info, dismissible: false)
    @message = message
    @variant = variant
    @dismissible = dismissible
  end

  private

  attr_reader :message, :variant, :dismissible

  def alert_classes
    css_classes(
      "alert",
      "alert-#{variant}",
      "alert-dismissible" => dismissible
    )
  end
end
```

### 5. Content Security

Sanitize user content appropriately:

```ruby
class UserContentComponent < ViewComponent::Base
  def initialize(content:, allow_html: false)
    @content = content
    @allow_html = allow_html
  end

  private

  attr_reader :content, :allow_html

  def safe_content
    if allow_html
      sanitize(content, tags: %w[b i em strong], attributes: [])
    else
      h(content)
    end
  end
end
```

### 6. Component Documentation

Document component APIs:

```ruby
# Renders a styled button component
#
# @param text [String] The button text
# @param variant [Symbol] The button style (:primary, :secondary, :danger)
# @param disabled [Boolean] Whether the button is disabled
# @param options [Hash] Additional HTML attributes
#
# @example Basic usage
#   <%= render ButtonComponent.new(text: "Save") %>
#
# @example With variant and options
#   <%= render ButtonComponent.new(
#     text: "Delete", 
#     variant: :danger,
#     data: { confirm: "Are you sure?" }
#   ) %>
class ButtonComponent < ViewComponent::Base
  # Component implementation...
end
```

### 7. Testing Strategy

Test component behavior thoroughly:

```ruby
class ButtonComponentTest < ViewComponent::TestCase
  test "renders with required attributes" do
    render_inline ButtonComponent.new(text: "Click me")
    
    assert_selector "button", text: "Click me"
  end

  test "applies variant classes correctly" do
    render_inline ButtonComponent.new(text: "Test", variant: :danger)
    
    assert_selector "button.btn-danger"
  end

  test "handles edge cases" do
    # Test with nil/empty values
    render_inline ButtonComponent.new(text: "")
    assert_selector "button"

    # Test with special characters
    render_inline ButtonComponent.new(text: "Save & Continue")
    assert_selector "button", text: "Save & Continue"
  end
end
```

This guide provides a comprehensive overview of ViewComponent usage in our Rails application. For more detailed information, refer to the [official ViewComponent documentation](https://viewcomponent.org/).