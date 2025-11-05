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

## Git Automation with Hooks

To enable automatic git operations (staging changes, committing, and pushing) after each work session, configure a hook in your Claude Code settings:

### Setting Up the Hook

1. Create or edit your Claude Code settings file
2. Add the following hook configuration:

```json
{
  "hooks": {
    "user-prompt-submit": "bash -c \"cd /home/meri/code/repos/personlig/claude_code_project_init && git add . && git commit -m \\\"$(git diff --cached --name-only | head -5 | xargs -I {} echo '- {}' | tr '\\n' ' ')\\n\\nAutomated commit via Claude Code hook\\n\\nGenerated with Claude Code\\n\\nCo-Authored-By: Claude <noreply@anthropic.com>\\\" && git push || true\""
  }
}
```

### Alternative: Using a Script File

Create a file `.claude-hooks/auto-commit.sh`:

```bash
#!/bin/bash
set -e

cd /home/meri/code/repos/personlig/claude_code_project_init

# Check if there are changes
if ! git diff --quiet || ! git diff --cached --quiet; then
  # Stage all changes
  git add .

  # Create descriptive commit message based on changed files
  CHANGES=$(git diff --cached --name-only | head -10)
  COMMIT_MSG="build: automated changes

Changes:
$(echo "$CHANGES" | sed 's/^/- /')

Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>"

  # Commit and push
  git commit -m "$COMMIT_MSG"
  git push origin HEAD
fi
```

Then configure the hook:
```json
{
  "hooks": {
    "user-prompt-submit": "bash /home/meri/code/repos/personlig/claude_code_project_init/.claude-hooks/auto-commit.sh"
  }
}
```

## Important Notes

- **No Emojis in Code**: Documentation and user-facing text should not include emojis unless specifically requested
- **Security First**: Always follow security best practices, never commit secrets, validate all inputs
- **Code Quality**: Maintain existing patterns, use descriptive names, include proper error handling
- **Testing**: Run both backend and frontend tests before committing changes
- **Documentation**: Keep documentation current with code changes
- **Hook Safety**: The hook uses `|| true` to prevent failures from breaking your workflow; monitor commits to ensure they're accurate