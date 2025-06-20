# Developer Tools

This directory contains scripts to help developers and AI assistants maintain code quality and run tests efficiently.

## Key Scripts

### `ci`
Comprehensive CI pipeline that runs all checks and tests. Use `./bin/ci --fix` to automatically fix formatting issues before running checks.

- **Code formatting**: eclint and rubocop
- **Security scanning**: brakeman
- **Testing**: Rails unit and system tests
- **Coverage reporting**: Automatically generates coverage reports when available

### `coverage`
Generates test coverage reports to help identify untested code.

### `watch-ci`
Continuously monitors files and runs CI checks on changes for rapid feedback during development.

## Usage Tips

- Run `./bin/ci --fix` to automatically resolve formatting issues
- Use `./bin/watch-ci` during development for real-time feedback
- Check `./bin/coverage` periodically to maintain good test coverage
