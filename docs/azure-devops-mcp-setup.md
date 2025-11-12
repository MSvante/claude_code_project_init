# Azure DevOps MCP Server Integration Setup

This document describes the Azure DevOps MCP (Model Context Protocol) server integration that has been configured for this Claude Code project.

## Overview

The Azure DevOps MCP server enables Claude Code to interact with your Azure DevOps organization and project directly from the IDE. This allows you to:

- Read work item details, descriptions, and acceptance criteria
- Access project information and repository details
- Create pull requests directly from Claude Code
- View build and pipeline information
- Retrieve team member and permission information

## Configuration

### Installed Components

1. **MCP Server Location**: `.mcp-servers/azure-devops-mcp/`
   - Official Microsoft Azure DevOps MCP server
   - Repository: https://github.com/microsoft/azure-devops-mcp

2. **Configuration File**: `.mcp.json`
   - Defines the MCP server connection and authentication
   - Located at project root

### Configuration Details

```json
{
  "mcpServers": {
    "azure-devops": {
      "command": "node",
      "args": [".mcp-servers/azure-devops-mcp/dist/index.js", "msvante", "--authentication", "env"],
      "env": {
        "AZURE_DEVOPS_PAT": "your-pat-token-here"
      }
    }
  }
}
```

**Configuration Parameters:**
- `command`: Node.js runtime for executing the MCP server
- `args`:
  - Path to the compiled MCP server
  - Organization name: `msvante`
  - Authentication method: `env` (uses environment variables)
- `env`: Environment variables for authentication
  - `AZURE_DEVOPS_PAT`: Personal Access Token for authentication

### Azure DevOps Organization Details

- **Organization**: msvante
- **Organization URL**: https://dev.azure.com/msvante/
- **Project**: RandomHyggeMakker
- **Project URL**: https://dev.azure.com/msvante/RandomHyggeMakker

## Authentication

### Personal Access Token (PAT)

The integration uses Azure DevOps Personal Access Tokens for secure authentication.

**PAT Scopes Required:**
- `Code` (Read & Write) - For PR creation and repository access
- `Work Items` (Read) - For accessing task and work item details
- `Build` (Read) - For build and pipeline information
- `Release` (Read) - For release pipeline information

**Important Security Notes:**
- The PAT is stored in `.mcp.json` - treat this file as sensitive
- Never commit the PAT to public repositories
- Consider storing the PAT in environment variables instead for enhanced security
- Add `.mcp.json` to `.gitignore` if you plan to use this in a shared repository

## Usage

Once configured, the MCP server is automatically available in Claude Code. You can:

1. Ask Claude Code to read work items from your Azure DevOps project
2. Request PR creation with proper linking to work items
3. Get information about project structure and repositories
4. Access build and pipeline status information

Example requests:
- "Show me the details of work item #123"
- "Create a pull request for the RandomHyggeMakker project"
- "What are the recent builds in the project?"

## Maintenance

### Updating the MCP Server

To update to the latest version of the Azure DevOps MCP server:

```bash
cd .mcp-servers/azure-devops-mcp
git pull origin main
npm install
npm run build
```

### Renewing the Personal Access Token

If the PAT expires or needs to be replaced:

1. Visit https://dev.azure.com/msvante/_usersSettings/tokens
2. Create a new PAT with the same scopes as above
3. Update the `AZURE_DEVOPS_PAT` value in `.mcp.json`
4. Verify the connection works by testing a simple command in Claude Code

## Troubleshooting

### Server fails to start

If the MCP server fails to start, check:
- Node.js is installed and accessible (`node --version`)
- The PAT is valid and has not expired
- The organization name is correct (`msvante`)
- Environment variables are properly set

### Authentication errors

If you see authentication errors:
- Verify the PAT has sufficient scopes
- Check the PAT hasn't expired
- Ensure the PAT is correctly copied into `.mcp.json` (no extra spaces)

### Work item access issues

If Claude Code cannot read work items:
- Verify your Azure DevOps account has access to the RandomHyggeMakker project
- Check the PAT has "Work Items (Read)" scope
- Ensure the project name is correct in Azure DevOps

## References

- [Azure DevOps MCP GitHub Repository](https://github.com/microsoft/azure-devops-mcp)
- [Azure DevOps REST API Documentation](https://docs.microsoft.com/en-us/rest/api/azure/devops)
- [Claude Code MCP Configuration Guide](https://code.claude.com/docs/en/mcp.md)
- [Azure DevOps Personal Access Tokens](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate)

## Implementation Phases

This initial setup (Phase 1) establishes:
- Authentication and basic connectivity
- Work item reading capabilities
- MCP server integration with Claude Code

Future phases (as defined in task 6) could include:
- Phase 2: Advanced work item access and filtering
- Phase 3: Automated PR creation with work item linking
- Phase 4: Helper scripts and workflow automation
- Phase 5: Build monitoring and release pipeline integration
