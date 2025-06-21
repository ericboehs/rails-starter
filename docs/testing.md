# Testing Guide

This document outlines the testing strategy and best practices for the RailsStarter application.

## Overview

The application maintains **99%+ test coverage** using Rails' built-in Minitest framework with SimpleCov for coverage analysis. Tests are organized by type and run in parallel for optimal performance.

## Test Structure

### Test Organization

```
test/
├── components/           # ViewComponent tests
│   ├── auth/            # Authentication component tests
│   ├── alert_component_test.rb
│   └── avatar_component_test.rb
├── controllers/         # Controller tests
├── mailers/            # Mailer tests
├── models/             # Model tests
├── system/             # End-to-end system tests
├── fixtures/           # Test data
└── test_helper.rb      # Test configuration
```

### Test Types

1. **Unit Tests** - Models, components, and isolated logic
2. **Controller Tests** - HTTP request/response testing
3. **System Tests** - Browser-based end-to-end testing
4. **Mailer Tests** - Email functionality testing

## Running Tests

### Basic Commands

```bash
# Run all tests
bin/rails test

# Run specific test type
bin/rails test:system
bin/rails test:models
bin/rails test:controllers

# Run specific test file
bin/rails test test/models/user_test.rb

# Run specific test method
bin/rails test test/models/user_test.rb::test_validates_email_presence
```

### CI Pipeline

Run the full CI pipeline including tests:

```bash
# Full CI pipeline
bin/ci

# Watch CI status in real-time
bin/watch-ci

# Generate detailed coverage report
bin/coverage
```

## Test Configuration

### SimpleCov Setup

Coverage configuration in `test/test_helper.rb`:

```ruby
SimpleCov.start "rails" do
  enable_coverage :branch
  minimum_coverage line: 95, branch: 95
  minimum_coverage_by_file 80
  
  # Parallel test support
  parallelize_setup do |worker|
    SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
  end
end
```

### Parallel Testing

Tests run in parallel using multiple workers:

```ruby
# test/test_helper.rb
parallelize(workers: :number_of_processors)
```

## Writing Tests

### Model Testing

```ruby
# test/models/user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should validate presence of email" do
    user = User.new(password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "should normalize email address" do
    user = User.create!(
      email_address: "  TEST@EXAMPLE.COM  ",
      password: "password123"
    )
    assert_equal "test@example.com", user.email_address
  end

  test "should generate initials correctly" do
    user = User.new(email_address: "john.doe@example.com")
    assert_equal "JD", user.initials
  end
end
```

### Controller Testing

```ruby
# test/controllers/users_controller_test.rb
require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )
  end

  test "should create user with valid params" do
    assert_difference("User.count") do
      post users_url, params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to new_session_url
    assert_equal "Account created successfully! Please sign in.", flash[:notice]
  end

  test "should require authentication for profile" do
    get user_url
    assert_redirected_to new_session_url
  end

  private

  def sign_in_as(user)
    post session_url, params: { 
      email_address: user.email_address, 
      password: "password123" 
    }
  end
end
```

### ViewComponent Testing

```ruby
# test/components/auth/button_component_test.rb
require "test_helper"

class Auth::ButtonComponentTest < ViewComponent::TestCase
  test "renders primary button" do
    component = Auth::ButtonComponent.new(
      text: "Sign In", 
      type: :submit, 
      variant: :primary
    )
    render_inline(component)

    assert_selector "button[type='submit']"
    assert_text "Sign In"
    assert_selector "button.bg-emerald-600"
  end

  test "applies custom classes" do
    component = Auth::ButtonComponent.new(
      text: "Test", 
      class: "w-full"
    )
    render_inline(component)

    assert_selector "button.w-full"
  end
end
```

### System Testing

```ruby
# test/system/authentication_test.rb
require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(
      email_address: "test@example.com",
      password: "password123"
    )
  end

  test "user can sign in with valid credentials" do
    visit new_session_path

    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password123"
    click_button "Sign in"

    assert_current_path root_path
    assert_text "Welcome to RailsStarter"
  end

  test "user sees error with invalid credentials" do
    visit new_session_path

    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "wrongpassword"
    click_button "Sign in"

    assert_current_path session_path
    assert_text "Invalid email address or password"
  end
end
```

## Testing Patterns

### Authentication in Tests

Helper method for signing in users:

```ruby
# In test files
def sign_in_as(user)
  post session_url, params: { 
    email_address: user.email_address, 
    password: "password123" 
  }
end

# Usage in tests
test "should show user profile when authenticated" do
  sign_in_as(@user)
  get user_url
  assert_response :success
end
```

### Testing Flash Messages

```ruby
test "displays success message after user creation" do
  post users_url, params: { user: valid_user_params }
  
  assert_redirected_to new_session_url
  assert_equal "Account created successfully! Please sign in.", flash[:notice]
end
```

### Testing Form Submissions

```ruby
test "creates user with valid parameters" do
  assert_difference("User.count") do
    post users_url, params: {
      user: {
        email_address: "new@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }
  end
end

test "does not create user with invalid parameters" do
  assert_no_difference("User.count") do
    post users_url, params: {
      user: {
        email_address: "",
        password: "password123",
        password_confirmation: "password123"
      }
    }
  end
  
  assert_response :unprocessable_entity
end
```

### Testing ViewComponents with Current User

```ruby
# For components that depend on Current.user
test "renders avatar for current user" do
  user = User.create!(email_address: "test@example.com", password: "password123")
  
  # Set current user in component context
  render_inline(AvatarComponent.new(user: user))
  
  assert_selector "img[alt='#{user.email_address}']"
  assert_text user.initials
end
```

## Coverage Requirements

### Coverage Thresholds

- **Minimum line coverage**: 95%
- **Minimum branch coverage**: 95%
- **Per-file minimum**: 80%

### Coverage Exclusions

Files excluded from coverage requirements:

- `app/channels/application_cable/connection.rb`
- `app/jobs/application_job.rb`
- Configuration files (`config/`)
- Database files (`db/`)
- Test files (`test/`)

### Viewing Coverage Reports

```bash
# Generate and view coverage report
bin/coverage

# Open HTML coverage report
open coverage/index.html
```

## Best Practices

### Test Organization

1. **Group related tests** - Use `describe` blocks or clear test names
2. **Setup data in `setup` method** - Keep tests DRY
3. **Use meaningful assertions** - Test behavior, not implementation
4. **Test edge cases** - Empty inputs, boundary conditions, error states

### Test Data Management

```ruby
# Good: Create test data in setup
setup do
  @user = User.create!(
    email_address: "test@example.com", 
    password: "password123"
  )
end

# Good: Use factories or builder methods
def valid_user_params
  {
    email_address: "user@example.com",
    password: "password123",
    password_confirmation: "password123"
  }
end
```

### Assertion Guidelines

```ruby
# Good: Specific assertions
assert_equal "test@example.com", user.email_address
assert_includes response.body, "Welcome"
assert_selector "button.btn-primary"

# Avoid: Overly generic assertions
assert user.valid?
assert_response :success
```

### Testing Components in Isolation

```ruby
# Good: Test component behavior directly
test "applies correct CSS classes" do
  component = Auth::ButtonComponent.new(text: "Test", variant: :secondary)
  render_inline(component)
  
  assert_selector "button.bg-white"
  assert_selector "button.text-gray-900"
end

# Good: Test component with different inputs
test "handles empty text gracefully" do
  component = Auth::ButtonComponent.new(text: "")
  render_inline(component)
  
  assert_selector "button"
  assert_text ""
end
```

## Debugging Tests

### Common Issues

1. **Test isolation** - Ensure tests don't depend on each other
2. **Database state** - Use transactions or manual cleanup
3. **Time-dependent tests** - Use `freeze_time` or relative assertions
4. **Async behavior** - Use appropriate waits in system tests

### Debugging Techniques

```ruby
# Add debugging output
test "debug failing test" do
  user = User.create!(email_address: "test@example.com", password: "password123")
  puts "Created user: #{user.inspect}"
  puts "User valid?: #{user.valid?}"
  puts "User errors: #{user.errors.full_messages}"
  
  # Your test assertions...
end

# Use pry for interactive debugging
test "interactive debugging" do
  user = User.new(email_address: "test@example.com")
  binding.pry  # Interactive debugging session
  assert user.valid?
end
```

### System Test Debugging

```ruby
# Take screenshots during system tests
test "debug system test with screenshot" do
  visit new_session_path
  take_screenshot  # Saves screenshot to tmp/screenshots/
  
  fill_in "Email", with: "test@example.com"
  take_screenshot  # Another screenshot after interaction
end
```

## Continuous Integration

### Pre-commit Hooks

The application runs full CI pipeline before commits:

1. **EditorConfig** - Formatting consistency
2. **RuboCop** - Code style and quality
3. **Brakeman** - Security vulnerability scanning
4. **Tests** - Full test suite with coverage

### Coverage Enforcement

- **Minimum coverage enforced** - CI fails below 95%
- **Coverage drops blocked** - Prevents regression
- **Per-file coverage** - Ensures no untested files

This testing strategy ensures high code quality and prevents regressions while maintaining fast development velocity.