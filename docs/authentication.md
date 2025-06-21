# Authentication System

This document outlines the authentication system implemented in the RailsStarter application.

## Overview

The application uses a session-based authentication system built with Rails 8.0.2, providing secure user management with email/password authentication and password reset functionality.

## Architecture

### Core Components

- **User Model** (`app/models/user.rb`) - Handles user data and authentication
- **Session Model** (`app/models/session.rb`) - Manages user sessions
- **Current Model** (`app/models/current.rb`) - Thread-safe current user access
- **Authentication Concern** (`app/controllers/concerns/authentication.rb`) - Shared authentication logic

### Controllers

- **SessionsController** - Sign in/out functionality
- **UsersController** - User registration and profile management
- **PasswordsController** - Password reset functionality

## Authentication Flow

### User Registration

1. User visits `/users/new`
2. Fills out registration form with email and password
3. System validates input and creates user account
4. User is redirected to sign-in page with success message

### Sign In

1. User visits `/sessions/new` (sign-in page)
2. Enters email and password
3. System validates credentials
4. Creates new session and sets session cookie
5. Redirects to dashboard or intended page

### Sign Out

1. User clicks sign-out link
2. System destroys current session
3. Redirects to sign-in page

### Password Reset

1. User clicks "Forgot Password" on sign-in page
2. Enters email address on reset form
3. System generates secure token and sends reset email
4. User clicks link in email to reset password
5. User enters new password on reset form
6. System updates password and invalidates reset token

## Models

### User Model

```ruby
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  
  validates :email_address, presence: true, uniqueness: true
  normalizes :email_address, with: ->(email) { email.strip.downcase }
end
```

**Key features:**
- Secure password handling with `has_secure_password`
- Email normalization (strip whitespace, lowercase)
- Unique email validation
- Session management

### Session Model

```ruby
class Session < ApplicationRecord
  belongs_to :user
  
  before_create { self.token = SecureRandom.base58(32) }
end
```

**Key features:**
- Secure random token generation
- Association with user
- Automatic cleanup on user deletion

### Current Model

```ruby
class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
end
```

**Key features:**
- Thread-safe current user access
- Request-scoped session management
- Nil-safe user delegation

## Authentication Helpers

### Required Authentication

Use the `authentication_required` method in controllers:

```ruby
class DashboardController < ApplicationController
  before_action :authentication_required
  
  def index
    # Only accessible to authenticated users
  end
end
```

### Skip Authentication

Skip authentication for specific actions:

```ruby
class UsersController < ApplicationController
  skip_before_action :authentication_required, only: [:new, :create]
end
```

### Current User Access

Access the current user anywhere in the application:

```ruby
# In controllers
def show
  @user = Current.user
end

# In views
<%= Current.user.email_address %>

# In components
class AvatarComponent < ViewComponent::Base
  def initialize(user: Current.user)
    @user = user
  end
end
```

## Security Features

### Password Security

- **BCrypt hashing** - Passwords are securely hashed using BCrypt
- **Minimum requirements** - Validated on the client and server side
- **Password confirmation** - Required during registration and updates

### Session Security

- **Secure tokens** - 32-character Base58 encoded tokens
- **HttpOnly cookies** - Session cookies are not accessible via JavaScript
- **Session cleanup** - Sessions are destroyed on sign-out and user deletion

### CSRF Protection

- **Built-in Rails CSRF protection** - All forms include CSRF tokens
- **API-safe** - CSRF tokens are automatically handled by Rails

## Components

### Authentication UI Components

The authentication system uses ViewComponents for consistent UI:

- **Auth::FormContainerComponent** - Wrapper for auth forms
- **Auth::InputComponent** - Form input fields with validation
- **Auth::ButtonComponent** - Styled buttons for forms
- **Auth::LinkComponent** - Navigation links between auth pages
- **AlertComponent** - Flash messages and error display

### Usage Example

```erb
<%= render Auth::FormContainerComponent.new(title_key: "auth.sign_in.title") do %>
  <%= render 'shared/flash_messages' %>
  
  <%= form_with url: session_path, local: true do |form| %>
    <%= render Auth::InputComponent.new(
      form: form,
      field: :email_address,
      label: t("auth.sign_in.email_label"),
      type: :email,
      required: true
    ) %>
    
    <%= render Auth::ButtonComponent.new(
      text: t("auth.sign_in.submit_button"),
      type: :submit,
      variant: :primary
    ) %>
  <% end %>
<% end %>
```

## Configuration

### Session Configuration

Sessions are configured in `config/application.rb`:

```ruby
# Session store configuration
config.session_store :cookie_store, key: '_rails_starter_session'
```

### Routes

Authentication routes in `config/routes.rb`:

```ruby
# Authentication routes
resource :session, only: [:new, :create, :destroy]
resource :password, only: [:new, :create, :edit, :update]
resource :user, only: [:new, :create, :show, :edit, :update]
```

## Testing

### Authentication in Tests

Helper method for signing in users during tests:

```ruby
def sign_in_as(user)
  post session_url, params: { 
    email_address: user.email_address, 
    password: "password123" 
  }
end
```

### Test Coverage

- **Unit tests** - User, Session, and Current models
- **Controller tests** - Authentication flows and edge cases
- **System tests** - End-to-end authentication workflows
- **Component tests** - Authentication UI components

## Deployment Considerations

### Environment Variables

No sensitive authentication configuration is required - the system uses Rails' built-in secure defaults.

### Database

Ensure proper indexing on the sessions table:

```sql
CREATE INDEX index_sessions_on_user_id ON sessions(user_id);
CREATE INDEX index_sessions_on_token ON sessions(token);
```

### Security Headers

Consider adding security headers in production:

```ruby
# config/application.rb
config.force_ssl = true  # In production
```

## Future Enhancements

Potential improvements to consider:

1. **Two-factor authentication** - SMS or TOTP-based 2FA
2. **OAuth integration** - GitHub, Google, or other providers
3. **Session management** - User-visible session list and revocation
4. **Account lockout** - Protection against brute force attacks
5. **Password complexity** - Configurable password requirements
6. **Remember me** - Extended session duration option

## Troubleshooting

### Common Issues

1. **"Invalid email or password"** - Check email normalization and password case sensitivity
2. **Session not persisting** - Verify cookie configuration and HTTPS in production
3. **CSRF token errors** - Ensure forms include `csrf_meta_tags` in layout
4. **Password reset not working** - Check email configuration and token expiration

For more assistance, check the test files for expected behavior and error handling patterns.