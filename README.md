# GitHub Team Auditor

A Rails 8.0.2 application for auditing GitHub teams.

## Features

- **User Authentication** - Secure session-based authentication system
- **Modern Rails Stack** - Built with Rails 8.0.2, SQLite3, and modern asset pipeline
- **Component-Based UI** - ViewComponent architecture for maintainable UI components
- **Responsive Design** - Tailwind CSS with dark mode support
- **Comprehensive Testing** - 99%+ test coverage with SimpleCov

## Tech Stack

- **Rails 8.0.2** with modern asset pipeline (Propshaft)
- **SQLite3** for all environments including production
- **ImportMap** for JavaScript (no Node.js bundling required)
- **Hotwire** (Turbo + Stimulus) for interactive features
- **Tailwind CSS** via CDN for styling
- **ViewComponent** for reusable UI components
- **Solid Libraries** for database-backed cache, queue, and cable

## Getting Started

### Prerequisites

- Ruby 3.2+
- Rails 8.0.2+
- SQLite3

### Installation

1. Clone the repository
2. Install dependencies:
  ```bash
  bin/setup
  ```

3. Start the development server:
  ```bash
  bin/rails server
  ```

4. Visit `http://localhost:3000`

## Development

### Code Quality

Run the full CI pipeline (formatting, linting, security scan, tests):

```bash
bin/ci
```

Auto-fix formatting issues:

```bash
bin/ci --fix
```

Watch CI status in real-time:

```bash
bin/watch-ci
```

### Testing

Run tests:

```bash
bin/rails test
```

Generate coverage report:

```bash
bin/coverage
```

### Code Standards

- **EditorConfig**: UTF-8, LF line endings, 2-space indentation
- **RuboCop**: Rails Omakase configuration
- **SimpleCov**: 95% minimum coverage requirement
- **Conventional Commits**: Structured commit messages

## Architecture

### Database Setup

Multi-database configuration with separate SQLite databases:
- Primary database for application data
- Cache database for Solid Cache
- Queue database for Solid Queue
- Cable database for Solid Cable

### Component System

The application uses ViewComponent for UI components:
- `Auth::*` components for authentication flows
- `AvatarComponent` for user avatars
- `AlertComponent` for flash messages and errors
- `UserPageComponent` for profile page layouts

## Contributing

1. Follow the existing code style and conventions
2. Ensure tests pass: `bin/ci`
3. Maintain test coverage above 95%
4. Use conventional commit messages

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
