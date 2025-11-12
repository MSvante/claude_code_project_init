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

Make sure you've sourced the environment file in your current shell session. If you used the script, it will be sourced automatically. To verify:

```bash
echo $AZURE_DEVOPS_ORG  # Should display your org name
echo $AZURE_DEVOPS_PAT  # Should display your PAT (though it won't be visible)
```

Or manually source the environment file:

```bash
source environments/.env.myorg
```

#### 3.3 Test the Connection

You can test the MCP server connection by asking Claude Code (after sourcing the environment file):
- "Show me the projects in my Azure DevOps organization"
- "List the work items in the RandomHyggeMakker project"
- "What are the recent builds?"

If the connection is working, Claude Code will retrieve and display the information from Azure DevOps.