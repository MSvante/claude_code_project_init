# MCP Configuration Setup Guide

This guide provides step-by-step instructions for setting up the Model Context Protocol (MCP) configuration for Claude Code projects.

## Quick Start

### 1. Create Environment Configuration

Create an environment file in the `environments/` directory using the example template:

```bash
cp environments/example.env.org_name environments/.env.your_org_name
```

### 2. Update Environment Variables

Edit the newly created file (e.g., `environments/.env.your_org_name`) and replace:
- `INSERT_YOUR_ORG_NAME_HERE`: Your Azure DevOps organization name
- `INSERT_YOUR_PAT_HERE`: Your Azure DevOps Personal Access Token

Example:
```env
AZURE_DEVOPS_ORG="mycompany"
AZURE_DEVOPS_PAT="your-pat-token-here"
```

### 3. Activate Configuration

Use the MCP organization switcher script to activate the configuration:

```bash
./scripts/mcp-switch-org.sh your_org_name
```

The script will source the environment file and open Claude Code with the correct environment variables loaded.

---

## Detailed Setup Instructions

### Step 1: Understand the Configuration Structure

The MCP configuration is split into two parts:

**`.mcp.json`** - Server configuration (contains template variables):
```json
{
  "mcpServers": {
    "azure-devops": {
      "command": "node",
      "args": [".mcp-servers/azure-devops-mcp/dist/index.js", "${AZURE_DEVOPS_ORG}", "--authentication", "env"],
      "env": {
        "AZURE_DEVOPS_PAT": "${AZURE_DEVOPS_PAT}"
      }
    }
  }
}
```

**`environments/.env.org_name`** - Environment variables (contains actual values):
```env
AZURE_DEVOPS_ORG="your-org-name"
AZURE_DEVOPS_PAT="your-pat-token"
```

**Key Components:**
- `${AZURE_DEVOPS_ORG}`: Template variable replaced by environment variable
- `${AZURE_DEVOPS_PAT}`: Template variable replaced by environment variable
- `environments/` directory: Contains organization-specific environment files
- Environment variables are loaded by sourcing the appropriate `.env` file

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

#### 2.3 Create Environment File

1. Copy the example environment template:
   ```bash
   cp environments/example.env.org_name environments/.env.myorg
   ```

2. Edit the environment file and update these values:
   ```env
   AZURE_DEVOPS_ORG="myorg"
   AZURE_DEVOPS_PAT="your-pat-token-here"
   ```

   Replace:
   - `myorg`: Your Azure DevOps organization name (e.g., `msvante`)
   - `your-pat-token-here`: Your generated PAT token

3. Use the MCP organization switcher script to activate the configuration:
   ```bash
   ./scripts/mcp-switch-org.sh myorg
   ```

   The script will source the environment file and open Claude Code with the correct environment variables loaded.

### Step 3: Verify Installation

#### 3.1 Check File Structure

Ensure the following files exist:
- `.mcp.json` - Server configuration file
- `environments/.env.myorg` - Your organization environment file
- `.mcp-servers/azure-devops-mcp/dist/index.js` - The MCP server binary

Verify with:
```bash
ls -la .mcp.json environments/.env.myorg .mcp-servers/azure-devops-mcp/dist/index.js
```

#### 3.2 Verify Environment is Sourced

Make sure you've sourced the environment file in your current shell session:

```bash
source environments/.env.myorg
echo $AZURE_DEVOPS_ORG  # Should display your org name
```

#### 3.3 Test the Connection

You can test the MCP server connection by asking Claude Code (after sourcing the environment file):
- "Show me the projects in my Azure DevOps organization"
- "List the work items in the RandomHyggeMakker project"
- "What are the recent builds?"

If the connection is working, Claude Code will retrieve and display the information from Azure DevOps.

### Step 4: Security Best Practices

#### 4.1 Protect Your Configuration

The environment files in `environments/` contain your Personal Access Token, which is sensitive. Protect them by:

1. **Never commit to version control**: The `.gitignore` file already excludes `environments/.env*`
2. **Use appropriate file permissions**: Keep the files readable only by your user
   ```bash
   chmod 600 environments/.env.myorg
   ```
3. **Store securely**: If needed, store the PAT in your system's credential manager and reference it via environment variables

#### 4.2 Token Management

1. **Token Expiration**: Set a reasonable expiration date (90 days to 1 year)
2. **Token Rotation**: Periodically create new tokens and revoke old ones
3. **Token Revocation**: To revoke a token:
   - Go to `https://dev.azure.com/YOUR_ORG_NAME/_usersSettings/tokens`
   - Find the token in the list
   - Click **Revoke** or **Delete**

### Step 5: Working with Multiple Organizations

For detailed information on working with multiple Azure DevOps organizations, see the [Multi-Organization Guide](./mcp-multi-organization.md).

The recommended approach uses environment files in the `environments/` directory for each organization:

```bash
# Copy the example template for each organization
cp environments/example.env.org_name environments/.env.msvante
cp environments/example.env.org_name environments/.env.other-org

# Edit with your credentials
nano environments/.env.msvante
nano environments/.env.other-org
```

Then switch between organizations using the MCP switcher script:

```bash
# Switch to msvante organization
./scripts/mcp-switch-org.sh msvante

# Switch to other-org organization
./scripts/mcp-switch-org.sh other-org

# List available organizations
./scripts/mcp-switch-org.sh list
```

See [Multi-Organization Guide](./mcp-multi-organization.md) for detailed instructions and examples.

---

## Troubleshooting

### Environment Variables Not Loading

**Problem**: "AZURE_DEVOPS_ORG is not set" or authentication fails

**Solutions**:
1. Verify you've sourced the environment file: `echo $AZURE_DEVOPS_ORG`
2. If empty, source the file again: `source environments/.env.myorg`
3. Check the file exists and has correct values: `cat environments/.env.myorg`
4. Ensure file permissions are correct: `ls -la environments/.env.myorg`

### Authentication Errors

**Problem**: "Authentication failed" or "Invalid credentials"

**Solutions**:
1. Verify the environment is sourced: `echo $AZURE_DEVOPS_PAT` should not be empty
2. Verify the PAT in your environment file is correct (no extra spaces)
3. Check the PAT hasn't expired in Azure DevOps
4. Ensure the PAT has the required scopes
5. Create a new PAT if needed

### Server Connection Issues

**Problem**: "Cannot find MCP server" or "Command not found"

**Solutions**:
1. Verify Node.js is installed: `node --version`
2. Check the MCP server path is correct: `ls .mcp-servers/azure-devops-mcp/dist/index.js`
3. Verify the environment is sourced: `echo $AZURE_DEVOPS_ORG` should display your org name
4. Rebuild the server if needed:
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

**Problem**: Changes to `.mcp.json` or environment variables aren't reflected

**Solutions**:
1. Use the MCP switcher script to properly load the environment: `./scripts/mcp-switch-org.sh myorg`
2. Or manually source the environment file: `source environments/.env.myorg && code .`
3. Reload/restart Claude Code
4. Verify the JSON syntax in `.mcp.json` is valid (no trailing commas, proper quotes)
5. Check environment file syntax: `cat environments/.env.myorg`
6. Check file permissions: `ls -la .mcp.json environments/.env.myorg`
7. Ensure files are in the correct locations (project root)

---

## File Locations Reference

| File/Directory | Purpose |
|---|---|
| `.mcp.json` | MCP server configuration (contains template variables) |
| `environments/` | Directory containing organization-specific environment files |
| `environments/example.env.org_name` | Template for creating new organization environment files |
| `environments/.env.myorg` | Your organization environment file (created from template) |
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
