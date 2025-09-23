# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview


## Development Workflow

### Commit Message Format
Use descriptive commit messages that explain what was changed and why:
- `feat: Added a really nice feature`
- `fix: fixed a really bad error`
- `refactor: refactored the code because of X`
- `docs: created comprehensive project documentation`

## Task Management

For ongoing development priorities, reference the `docs/tasks.md` file which contains:
- **High Priority Tasks**: Critical features and improvements
- **Medium Priority Tasks**: Enhanced functionality and user experience
- **Low Priority Tasks**: Nice-to-have features and integrations
- **Technical Debt**: Code quality and infrastructure improvements

When suggesting next steps, always check this file for current priorities and user feedback items.

## Important Notes

- **No Emojis in Code**: Documentation and user-facing text should not include emojis unless specifically requested
- **Security First**: Always follow security best practices, never commit secrets, validate all inputs
- **Code Quality**: Maintain existing patterns, use descriptive names, include proper error handling
- **Testing**: Run both backend and frontend tests before committing changes
- **Documentation**: Keep documentation current with code changes