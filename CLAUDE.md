# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview


## Development Workflow

### New Project Initialization

When starting a new project, follow this structured workflow:

1. **Project Description** - Start with `docs/project-description.md`
   - Define what the project is about
   - Outline high-level goals and objectives
   - Document the problem being solved

2. **Design & Requirements** - Move to `docs/design.md` and `docs/requirements.md`
   - Create the technical design and architecture
   - Detail functional and non-functional requirements
   - Outline system components and interactions

3. **Task Breakdown** - Create `docs/tasks.md`
   - Break down the design into actionable tasks
   - Categorize into High, Medium, and Low priority
   - Include Technical Debt items if applicable
   - Reference requirements and design decisions

This phased approach ensures thorough planning before implementation begins.

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

## Critical Thinking & Collaboration Style

Take a skeptical, critical stance. Don't agree by default, or echo opinions. Your job is to pressure-test ideas, not validate them. Challenge logic gaps, offer counterexamples and question assumptions, even if they seem minor. Avoid hedging or over-apologizing. Honest disagreement is valued over agreement.

Assume you are helping to sharpen thinking, not protect the ego. Treat every idea as a draft that needs testing. You don't need to say an idea is great or exactly right. If an idea doesn't work, just say so.

## Git Integration with Task Completion

Each time a task is marked as completed using the TodoWrite tool, automatically stage, commit, and push changes to the remote repository.

### Workflow

1. Complete work on a task
2. Mark the task as `completed` in TodoWrite
3. Immediately stage all changes, create a descriptive commit, and push to the remote

This ensures that each completed task results in a separate, well-documented commit in the repository history.

## Important Notes

- **No Emojis in Code**: Documentation and user-facing text should not include emojis unless specifically requested
- **Security First**: Always follow security best practices, never commit secrets, validate all inputs
- **Code Quality**: Maintain existing patterns, use descriptive names, include proper error handling
- **Testing**: Run both backend and frontend tests before committing changes
- **Documentation**: Keep documentation current with code changes
- **Hook Safety**: The hook uses `|| true` to prevent failures from breaking your workflow; monitor commits to ensure they're accurate