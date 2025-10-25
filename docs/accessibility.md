# Accessibility Testing

This application uses automated accessibility testing to ensure WCAG 2.1 AA compliance.

## Overview

We use [axe-core](https://github.com/dequelabs/axe-core-gems) to automatically test for accessibility violations in our system tests. Axe-core validates that pages meet the four principles of accessibility:

- **Perceivable**: Information must be presentable to users in ways they can perceive
- **Operable**: Interface components must be operable by all users
- **Understandable**: Information and operation must be understandable
- **Robust**: Content must be robust enough to work with current and future technologies

## Running Accessibility Tests

All accessibility tests are system tests located in `test/system/accessibility_test.rb`:

```bash
# Run all accessibility tests
bin/rails test:system test/system/accessibility_test.rb

# Run a specific accessibility test
bin/rails test:system test/system/accessibility_test.rb:11
```

These tests are automatically run as part of the CI pipeline (`bin/ci`).

## Writing Accessibility Tests

Use the `assert_accessible` helper method in any system test:

```ruby
require "application_system_test_case"

class MyFeatureTest < ApplicationSystemTestCase
  test "my page is accessible" do
    visit my_page_path
    assert_accessible  # Checks for WCAG 2.1 AA violations
  end
end
```

The helper is defined in `test/application_system_test_case.rb` and automatically:
- Runs axe-core against the current page
- Checks against WCAG 2.1 AA standards and best practices
- Provides detailed failure messages with links to documentation

## Understanding Violations

When axe-core finds accessibility issues, it reports them with:

1. **Rule name**: The specific accessibility rule that was violated
2. **Impact level**: Critical, serious, moderate, or minor
3. **Affected nodes**: Specific HTML elements with the issue
4. **How to fix**: Actionable steps to resolve the violation
5. **Documentation link**: Link to detailed explanation at dequeuniversity.com

Example violation:

```
Found 1 accessibility violation:

1) landmark-one-main: Document should have one main landmark (moderate)
    https://dequeuniversity.com/rules/axe/4.11/landmark-one-main
    The following 1 node violate this rule:

        Selector: html
        HTML: <html class="h-full">
        Fix all of the following:
        - Document does not have a main landmark
```

## Common Accessibility Patterns

### Semantic HTML Landmarks

Always use semantic HTML5 landmarks:

```erb
<main>
  <!-- Main content goes here -->
</main>

<nav>
  <!-- Navigation links -->
</nav>

<header>
  <!-- Page header -->
</header>

<footer>
  <!-- Page footer -->
</footer>
```

### Heading Hierarchy

Every page should have exactly one `<h1>` element, followed by a logical hierarchy:

```erb
<h1>Page Title</h1>
<h2>Section Title</h2>
<h3>Subsection Title</h3>
```

### Form Accessibility

Always use proper labels and attributes:

```erb
<%= form.label :email_address, "Email" %>
<%= form.email_field :email_address,
  required: true,
  autocomplete: "email",
  aria: { describedby: "email-hint" } %>
<span id="email-hint" class="text-sm">We'll never share your email.</span>
```

### Image Alt Text

Provide meaningful alt text for images:

```erb
<%= image_tag "logo.png", alt: "Company Logo" %>
```

## Manual Testing

While axe-core catches many issues automatically, some accessibility checks require manual testing:

1. **Keyboard navigation**: Tab through the page and ensure all interactive elements are reachable
2. **Screen reader**: Test with VoiceOver (Mac), NVDA (Windows), or JAWS
3. **Color contrast**: Verify text has sufficient contrast (4.5:1 for normal text, 3:1 for large text)
4. **Zoom/magnification**: Test at 200% zoom to ensure layout remains usable

## Browser Extension

Install the [axe DevTools browser extension](https://www.deque.com/axe/devtools/) for Chrome/Firefox to test pages during development. This helps catch issues before writing tests.

## Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Deque University Rules Reference](https://dequeuniversity.com/rules/axe/4.11)
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [MDN Accessibility Guide](https://developer.mozilla.org/en-US/docs/Web/Accessibility)

## Configuration

The axe-core configuration is in `test/application_system_test_case.rb`:

```ruby
def assert_accessible(page = self.page,
                     matcher = Axe::Matchers::BeAxeClean.new.according_to(:wcag21aa, "best-practice"))
  audit_result = matcher.audit(page)
  assert(audit_result.passed?, audit_result.failure_message)
end
```

This checks for:
- `:wcag21aa` - WCAG 2.1 Level AA compliance
- `"best-practice"` - Additional accessibility best practices

You can customize the rules by modifying the matcher in your tests.
