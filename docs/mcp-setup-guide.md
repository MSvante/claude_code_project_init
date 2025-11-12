# MCP Configuration Setup Guide

This guide provides step-by-step instructions for setting up the Model Context Protocol (MCP) configuration for Claude Code projects.

## Quick Start

### 1. Copy the Example Configuration

```bash
cp .mcp.json.example .mcp.json
```

### 2. Update Configuration Values

Edit `.mcp.json` and replace the placeholder values:
- `YOUR_ORG_NAME`: Your Azure DevOps organization name
- `YOUR_PERSONAL_ACCESS_TOKEN_HERE`: Your Azure DevOps Personal Access Token

### 3. Verify Configuration

Once configured, Claude Code will automatically use the MCP servers defined in `.mcp.json` when you interact with it.

---

## Detailed Setup Instructions

### Step 1: Understand the Configuration Structure

The `.mcp.json` file uses this structure:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "executable-or-interpreter",
      "args": ["path-to-server", "configuration-args"],
      "env": {
        "ENVIRONMENT_VARIABLE": "value"
      }
    }
  }
}
```

**Key Components:**
- `mcpServers`: Root object containing all MCP server configurations
- `server-name`: Unique identifier for the server (e.g., `azure-devops`)
- `command`: The executable or interpreter to run (e.g., `node` for Node.js servers)
- `args`: Command-line arguments passed to the server
- `env`: Environment variables available to the server process

### Step 2: Configure Azure DevOps Integration

#### 2.1 Gather Required Information

Before configuring, you'll need:
- **Azure DevOps Organization Name**: The organization slug from your Azure DevOps URL
  - Example: If your URL is `https://dev.azure.com/mycompany/`, the org name is `mycompany`
- **Personal Access Token (PAT)**: Authentication token for your Azure DevOps account

#### 2.2 Create a Personal Access Token

1. Navigate to your Azure DevOps organization: `https://dev.azure.com/YOUR_ORG_NAME/`
2. Click your **profile icon** (top right corner)
3. Select **Personal access tokens**
4. Click **+ New Token**
5. Fill in the token details:
   - **Name**: Give it a descriptive name (e.g., `claude-code-mcp`)
   - **Organization**: Select your organization
   - **Expiration**: Set an appropriate expiration (90 days to 1 year recommended)
   - **Scopes**: Select the following scopes:
     - `Code (Read & Write)` - For reading/writing code and pull requests
     - `Work Items (Read)` - For accessing task and work item details
     - `Build (Read)` - For pipeline and build information
     - `Release (Read)` - For release pipeline information

6. Click **Create**
7. **Important**: Copy the token immediately - you won't be able to see it again!

#### 2.3 Update .mcp.json

1. Copy the example configuration:
   ```bash
   cp .mcp.json.example .mcp.json
   ```

2. Edit `.mcp.json` and update these values:
   ```json
   {
     "mcpServers": {
       "azure-devops": {
         "command": "node",
         "args": [".mcp-servers/azure-devops-mcp/dist/index.js", "YOUR_ORG_NAME", "--authentication", "env"],
         "env": {
           "AZURE_DEVOPS_PAT": "YOUR_PERSONAL_ACCESS_TOKEN_HERE"
         }
       }
     }
   }
   ```

   Replace:
   - `YOUR_ORG_NAME`: Your Azure DevOps organization name (e.g., `msvante`)
   - `YOUR_PERSONAL_ACCESS_TOKEN_HERE`: Your generated PAT token

### Step 3: Verify Installation

#### 3.1 Check File Structure

Ensure the following files exist:
- `.mcp.json` - Your configuration file (created from `.mcp.json.example`)
- `.mcp-servers/azure-devops-mcp/dist/index.js` - The MCP server binary

Verify with:
```bash
ls -la .mcp.json .mcp-servers/azure-devops-mcp/dist/index.js
```

#### 3.2 Test the Connection

You can test the MCP server connection by asking Claude Code:
- "Show me the projects in my Azure DevOps organization"
- "List the work items in the RandomHyggeMakker project"
- "What are the recent builds?"

If the connection is working, Claude Code will retrieve and display the information from Azure DevOps.

### Step 4: Security Best Practices

#### 4.1 Protect Your Configuration

The `.mcp.json` file contains your Personal Access Token, which is sensitive. Protect it by:

1. **Never commit to version control**: The `.gitignore` file already excludes `.mcp.json`
2. **Use appropriate file permissions**: Keep the file readable only by your user
   ```bash
   chmod 600 .mcp.json
   ```
3. **Store securely**: If needed, store the PAT in your system's credential manager and reference it via environment variables

#### 4.2 Token Management

1. **Token Expiration**: Set a reasonable expiration date (90 days to 1 year)
2. **Token Rotation**: Periodically create new tokens and revoke old ones
3. **Token Revocation**: To revoke a token:
   - Go to `https://dev.azure.com/YOUR_ORG_NAME/_usersSettings/tokens`
   - Find the token in the list
   - Click **Revoke** or **Delete**

### Step 5: Multiple Organizations

For detailed information on working with multiple Azure DevOps organizations, see the [Multi-Organization Guide](./mcp-multi-organization.md).

**Quick Reference:**

If you need to configure multiple organizations, you have three approaches:

1. **Single Organization with Switching** - Use the helper script to switch between orgs
   ```bash
   ./scripts/mcp-switch-org.sh another-org
   ```

2. **Multiple Servers** - Load all organizations simultaneously:
   ```json
   {
     "mcpServers": {
       "azure-devops-org1": {
         "command": "node",
         "args": [".mcp-servers/azure-devops-mcp/dist/index.js", "org1", "--authentication", "env"],
         "env": {
           "AZURE_DEVOPS_PAT": "ORG1_PAT_TOKEN"
         }
       },
       "azure-devops-org2": {
         "command": "node",
         "args": [".mcp-servers/azure-devops-mcp/dist/index.js", "org2", "--authentication", "env"],
         "env": {
           "AZURE_DEVOPS_PAT": "ORG2_PAT_TOKEN"
         }
       }
     }
   }
   ```

3. **Environment-Based** - Switch using environment variables (recommended)
   ```bash
   source .env.org1 && code .
   ```

See [Multi-Organization Guide](./mcp-multi-organization.md) for detailed instructions and examples.

---

## Troubleshooting

### Authentication Errors

**Problem**: "Authentication failed" or "Invalid credentials"

**Solutions**:
1. Verify the PAT is correct (no extra spaces)
2. Check the PAT hasn't expired
3. Ensure the PAT has the required scopes
4. Create a new PAT if needed

### Server Connection Issues

**Problem**: "Cannot find MCP server" or "Command not found"

**Solutions**:
1. Verify Node.js is installed: `node --version`
2. Check the MCP server path is correct: `ls .mcp-servers/azure-devops-mcp/dist/index.js`
3. Rebuild the server if needed:
   ```bash
   cd .mcp-servers/azure-devops-mcp
   npm install
   npm run build
   ```

### Work Item Access Issues

**Problem**: Cannot read work items or get permission errors

**Solutions**:
1. Verify your PAT has "Work Items (Read)" scope
2. Ensure your Azure DevOps account has access to the project
3. Check the organization name is correct in the configuration
4. Verify the project name is correct (case-sensitive in some contexts)

### Configuration Not Being Applied

**Problem**: Changes to `.mcp.json` aren't reflected

**Solutions**:
1. Reload/restart Claude Code
2. Verify the JSON syntax is valid (no trailing commas, proper quotes)
3. Check file permissions: `ls -la .mcp.json`
4. Ensure the file is in the correct location (project root)

---

## File Locations Reference

| File/Directory | Purpose |
|---|---|
| `.mcp.json` | Your active MCP configuration (created from example) |
| `.mcp.json.example` | Template showing required configuration format |
| `.mcp-servers/` | Directory containing installed MCP servers |
| `.mcp-servers/azure-devops-mcp/` | Azure DevOps MCP server installation |
| `docs/azure-devops-mcp-setup.md` | Detailed Azure DevOps integration documentation |
| `docs/mcp-setup-guide.md` | This file - general MCP setup instructions |

---

## Additional Resources

- [Claude Code MCP Documentation](https://code.claude.com/docs/en/mcp.md)
- [Azure DevOps MCP GitHub Repository](https://github.com/microsoft/azure-devops-mcp)
- [Azure DevOps REST API Reference](https://docs.microsoft.com/en-us/rest/api/azure/devops)
- [Personal Access Tokens Documentation](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate)

---

## Next Steps

Once your MCP configuration is set up:

1. **Test the integration** by asking Claude Code about your Azure DevOps projects
2. **Read the Azure DevOps MCP documentation** in `docs/azure-devops-mcp-setup.md`
3. **Explore available MCP tools** - the MCP server provides many Azure DevOps operations
4. **Consider additional MCP servers** - you can add more servers to `.mcp.json` as needed

---

## Version History

- **v1.0** (2025-11-12): Initial setup guide created for Azure DevOps MCP integration
