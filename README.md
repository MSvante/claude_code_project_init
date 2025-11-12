# Claude Code Project Init

A project initialization template designed to work seamlessly with Claude Code, providing a structured foundation for software development projects with comprehensive documentation and development workflows.

## Overview

This repository serves as a template for initializing new projects with Claude Code integration. It includes essential documentation templates, project structure guidelines, and development workflows optimized for AI-assisted development.

## Features

- **Structured Documentation**: Comprehensive template files for requirements, design, and task management
- **Claude Code Integration**: Pre-configured with CLAUDE.md for optimal AI assistant behavior
- **Development Workflow**: Standardized commit message formats and contribution guidelines
- **Task Management**: Built-in task tracking and prioritization system
- **MIT Licensed**: Open source and ready for modification

## Project Structure

```
├── docs/
│   ├── requirements.md    # Business requirements and user stories
│   ├── design.md         # Technical architecture and design decisions
│   └── tasks.md          # Task tracking and development roadmap
├── .claude/
│   └── settings.local.json # Claude Code configuration
├── CLAUDE.md             # Instructions for Claude Code assistant
├── LICENSE               # MIT License
└── README.md             # This file
```

## Getting Started

### Prerequisites

- Git installed on your system
- Access to Claude Code (claude.ai/code)

### Using This Template

1. **Fork or Clone**: Fork this repository or use it as a template for your new project
2. **Customize Documentation**: Update the files in the `docs/` directory with your project specifics:
   - Edit `docs/requirements.md` with your business requirements
   - Update `docs/design.md` with your technical architecture
   - Modify `docs/tasks.md` with your development roadmap
3. **Configure Claude Code**: Adjust `CLAUDE.md` and `.claude/settings.local.json` as needed
4. **Update README**: Replace this README with your project-specific information

### Development Workflow

This template follows a structured development approach:

1. **Requirements Gathering**: Document business needs in `docs/requirements.md`
2. **Design Planning**: Outline technical architecture in `docs/design.md`
3. **Task Management**: Track development progress in `docs/tasks.md`
4. **Implementation**: Use Claude Code for AI-assisted development
5. **Documentation**: Keep all documentation current with code changes

## Documentation

### Requirements Document (`docs/requirements.md`)
Contains business-focused requirements using user story mapping methodology. Describes functionality without technical implementation details.

### Design Document (`docs/design.md`)
Technical documentation including high-level architecture, core components, error handling strategies, and testing approaches.

### Tasks Document (`docs/tasks.md`)
Development roadmap with prioritized tasks organized by:
- **Bugs**: Highest priority issues
- **High Priority**: Critical features and improvements
- **Medium Priority**: Enhanced functionality
- **Low Priority**: Nice-to-have features
- **Technical Debt**: Code quality improvements

### MCP Configuration Setup

This project includes Azure DevOps MCP server integration for seamless work item and pull request management from Claude Code.

**Quick Start:**
1. Copy `.mcp.json.example` to `.mcp.json`
2. Update with your Azure DevOps organization and Personal Access Token
3. Claude Code automatically uses the MCP server

**Documentation:**
- [MCP Setup Guide](./docs/mcp-setup-guide.md) - Complete setup instructions
- [Azure DevOps MCP Setup](./docs/azure-devops-mcp-setup.md) - Azure DevOps specific configuration
- [Multi-Organization Management](./docs/mcp-multi-organization.md) - Work with multiple organizations

**Helper Scripts:**
- `./scripts/mcp-switch-org.sh` - Quickly switch between organizations

## Commit Message Format

Use descriptive commit messages that explain what was changed and why:

- `feat: Added user authentication system`
- `fix: Fixed memory leak in data processing`
- `refactor: Improved error handling across modules`
- `docs: Updated API documentation`

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on how to contribute to this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Claude Code Integration

This project is optimized for use with Claude Code. The included `CLAUDE.md` file provides specific instructions for the AI assistant, including:

- Project overview and context
- Development workflow guidelines
- Code quality standards
- Security best practices
- Task management integration

For more information about Claude Code, visit [claude.ai/code](https://claude.ai/code).

## Support

If you encounter any issues or have questions:

1. Check the documentation in the `docs/` directory
2. Review the task list in `docs/tasks.md`
3. Create an issue describing your problem or question

## Acknowledgments

- Designed for seamless integration with Claude Code
- Follows modern software development best practices
- Inspired by successful open source project structures