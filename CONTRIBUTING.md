# Contributing to Claude Code Project Init

Thank you for your interest in contributing to this project! This guide will help you get started with contributing through forks and pull requests.

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- Git installed on your local machine
- A GitHub account
- Basic familiarity with Git and GitHub workflows
- Access to Claude Code (optional but recommended)

### Development Environment

This project is designed to work with Claude Code, but you can contribute using any development environment. If using Claude Code:

1. The `CLAUDE.md` file contains specific instructions for the AI assistant
2. The `.claude/` directory contains configuration files
3. Follow the existing code patterns and documentation standards

## Fork and Clone Workflow

### 1. Fork the Repository

1. Navigate to the main repository on GitHub
2. Click the "Fork" button in the top-right corner
3. Select your GitHub account as the destination
4. Wait for the fork to be created

### 2. Clone Your Fork

```bash
# Clone your fork to your local machine
git clone https://github.com/YOUR_USERNAME/claude_code_project_init.git

# Navigate to the project directory
cd claude_code_project_init

# Add the original repository as upstream
git remote add upstream https://github.com/ORIGINAL_OWNER/claude_code_project_init.git

# Verify your remotes
git remote -v
```

### 3. Set Up Development Environment

```bash
# Create a new branch for your feature/fix
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/bug-description
```

## Making Changes

### Branch Naming Conventions

Use descriptive branch names that indicate the type of change:

- `feature/user-authentication` - New features
- `fix/memory-leak-processing` - Bug fixes
- `docs/api-documentation` - Documentation updates
- `refactor/error-handling` - Code refactoring
- `test/unit-tests-auth` - Test additions/improvements

### Code Guidelines

1. **Follow Existing Patterns**: Maintain consistency with existing code style
2. **Documentation**: Update relevant documentation in the `docs/` directory
3. **Commit Messages**: Use the established format:
   ```
   feat: Added user authentication system
   fix: Fixed memory leak in data processing
   refactor: Improved error handling across modules
   docs: Updated API documentation
   ```

4. **No Secrets**: Never commit sensitive information (API keys, passwords, etc.)
5. **Security First**: Follow security best practices in all code changes

### Documentation Updates

When making changes, ensure you update:

- `docs/requirements.md` - If adding new business requirements
- `docs/design.md` - If changing technical architecture
- `docs/tasks.md` - Update task status or add new tasks
- `README.md` - If changing project structure or setup
- `CLAUDE.md` - If modifying Claude Code instructions

## Submitting Changes

### 1. Commit Your Changes

```bash
# Stage your changes
git add .

# Commit with a descriptive message
git commit -m "feat: Add user authentication system

- Implemented login/logout functionality
- Added password hashing with bcrypt
- Created user session management
- Updated documentation for auth endpoints"
```

### 2. Keep Your Fork Updated

```bash
# Fetch latest changes from upstream
git fetch upstream

# Switch to main branch
git checkout main

# Merge upstream changes
git merge upstream/main

# Push updated main to your fork
git push origin main
```

### 3. Rebase Your Feature Branch (Optional but Recommended)

```bash
# Switch to your feature branch
git checkout feature/your-feature-name

# Rebase against updated main
git rebase main

# Force push if you've already pushed this branch
git push --force-with-lease origin feature/your-feature-name
```

### 4. Push Your Changes

```bash
# Push your feature branch to your fork
git push origin feature/your-feature-name
```

## Creating a Pull Request

### 1. Open a Pull Request

1. Navigate to your fork on GitHub
2. Click "Compare & pull request" (or "New pull request")
3. Ensure the base repository and branch are correct:
   - Base repository: `ORIGINAL_OWNER/claude_code_project_init`
   - Base branch: `main`
   - Head repository: `YOUR_USERNAME/claude_code_project_init`
   - Compare branch: `feature/your-feature-name`

### 2. Fill Out PR Template

Provide a clear and detailed description:

```markdown
## Summary
Brief description of what this PR accomplishes.

## Changes Made
- List specific changes
- Include any new features
- Mention bug fixes
- Note documentation updates

## Testing
- Describe how you tested your changes
- Include any relevant test results
- Note if new tests were added

## Documentation
- List any documentation that was updated
- Mention if new documentation was created

## Breaking Changes
- Note any breaking changes
- Explain migration path if applicable

## Checklist
- [ ] Code follows project style guidelines
- [ ] Documentation has been updated
- [ ] Tests pass (if applicable)
- [ ] Commit messages follow the established format
- [ ] No sensitive information is included
```

### 3. Review Process

1. **Automated Checks**: Ensure any CI/CD checks pass
2. **Code Review**: Address feedback from maintainers
3. **Updates**: Make requested changes and push to the same branch
4. **Approval**: Wait for approval from project maintainers

## Code Review Guidelines

### For Contributors

- Be open to feedback and suggestions
- Respond promptly to review comments
- Make requested changes in a timely manner
- Ask questions if feedback is unclear

### For Reviewers

- Be constructive and specific in feedback
- Focus on code quality, security, and maintainability
- Suggest improvements rather than just pointing out problems
- Acknowledge good work and improvements

## Issue Reporting

Before creating a pull request, consider:

1. **Search Existing Issues**: Check if the issue already exists
2. **Create an Issue First**: For significant changes, create an issue to discuss the approach
3. **Reference Issues**: Link your PR to relevant issues using keywords:
   ```
   Fixes #123
   Closes #456
   Resolves #789
   ```

## Types of Contributions

We welcome various types of contributions:

- **Bug Fixes**: Resolve existing issues
- **Feature Additions**: Add new functionality
- **Documentation**: Improve or add documentation
- **Performance**: Optimize existing code
- **Testing**: Add or improve test coverage
- **Refactoring**: Improve code structure without changing functionality

## Getting Help

If you need assistance:

1. **Documentation**: Check the `docs/` directory for detailed information
2. **Issues**: Create an issue for bugs or feature requests
3. **Discussions**: Use GitHub Discussions for general questions
4. **Code Comments**: Leave comments on specific lines in pull requests

## Recognition

All contributors will be recognized for their efforts. Significant contributors may be invited to become project maintainers.

## Code of Conduct

This project adheres to a code of conduct that promotes:

- **Respectful Communication**: Be kind and professional
- **Inclusive Environment**: Welcome contributors from all backgrounds
- **Constructive Feedback**: Focus on improving the project
- **Collaborative Spirit**: Work together toward common goals

## License

By contributing to this project, you agree that your contributions will be licensed under the same MIT License that covers the project.

Thank you for contributing to Claude Code Project Init!