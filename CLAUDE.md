# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 8.0.2 application called **GitHub Team Auditor** (`GithubTeamAuditor` module) built for auditing GitHub teams. The application uses modern Rails features including Solid libraries (Cache, Queue, Cable) and is configured for deployment with Kamal.

## Development Commands

### Code Quality & Testing
- `bin/ci` - Run full CI pipeline (formatting, linting, security scan, tests, coverage)
- `bin/ci --fix` - Auto-fix formatting issues before running CI checks  
- `bin/coverage` - Generate detailed test coverage report with line/branch analysis
- `bin/watch-ci` - Monitor CI status in real-time during development

### Standard Rails Commands
- `bin/rails server` - Start development server
- `bin/rails test` - Run test suite
- `bin/rails test:system` - Run system tests
- `bin/setup` - Initial application setup

### Individual Quality Tools
- `rubocop` - Ruby style checking (Rails Omakase style)
- `rubocop -A` - Auto-fix Ruby style violations
- `brakeman` - Security vulnerability scanning
- `npx eclint check` - EditorConfig compliance checking
- `npx eclint fix` - Auto-fix EditorConfig violations

## Architecture & Configuration

### Modern Rails Stack
- **Rails 8.0.2** with modern asset pipeline (Propshaft)
- **SQLite3** for all environments including production
- **ImportMap** for JavaScript (no Node.js bundling)
- **Hotwire** (Turbo + Stimulus) for interactivity
- **Solid Libraries**: Database-backed cache, queue, and cable

### Multi-Database Setup
The application uses separate SQLite databases:
- Primary database for application data
- `cache` database for Solid Cache
- `queue` database for Solid Queue  
- `cable` database for Solid Cable

### Code Quality Standards
- **EditorConfig**: UTF-8, LF line endings, 2-space indentation
- **RuboCop**: Rails Omakase configuration (DHH's opinionated style)
- **Brakeman**: Security scanning integrated into CI
- **SimpleCov**: Test coverage with detailed HTML reports

### Testing Setup
- **Minitest** (Rails default) for unit and integration tests
- **Capybara + Selenium** for system tests
- **SimpleCov** for coverage analysis with branch coverage tracking
- Pre-commit hooks run full CI pipeline to ensure quality

## Key Files & Directories

### Application Structure
- `app/` - Standard Rails MVC structure (currently minimal)
- `config/application.rb` - Main application configuration
- `config/database.yml` - Multi-database SQLite configuration
- `config/deploy.yml` - Kamal deployment configuration

### Development Tools
- `bin/ci` - Comprehensive CI script with formatting, linting, security, and testing
- `bin/coverage` - Advanced coverage reporting with HTML parsing
- `bin/watch-ci` - Real-time CI monitoring using GitHub CLI
- `.editorconfig` - Code formatting standards

### Quality Assurance
- `rubocop` configured with Rails Omakase
- `brakeman` for security scanning
- `eclint` for EditorConfig enforcement
- Pre-commit hooks ensure code quality

## Development Workflow

1. **Setup**: Run `bin/setup` for initial configuration
2. **Development**: Use `bin/watch-ci` for real-time feedback during coding
3. **Quality Check**: Run `bin/ci --fix` to auto-fix issues and verify code quality
4. **Testing**: Use `bin/rails test` and `bin/rails test:system` for targeted testing
5. **Coverage**: Check `bin/coverage` for detailed test coverage analysis

The application emphasizes code quality with automated formatting, comprehensive testing, and security scanning integrated into the development workflow.
