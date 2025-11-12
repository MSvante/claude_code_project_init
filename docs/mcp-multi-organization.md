# Managing Multiple Azure DevOps Organizations

This guide explains how to work with multiple Azure DevOps organizations in Claude Code using the MCP configuration.

## Overview

There are three main approaches to managing multiple organizations:

1. **Single Organization (Simple)** - Work with one organization at a time
2. **Multiple Servers (Advanced)** - Load all organizations simultaneously
3. **Environment-Based (Recommended)** - Switch organizations using environment variables

Choose the approach that best fits your workflow.

---

## Approach 1: Single Organization (Simple)

This is the simplest approach and works best if you primarily work with one organization but occasionally need to switch.

### Setup

1. Use the single organization template:
   ```bash
   cp .mcp.json.example .mcp.json
   ```

2. Update with your primary organization details

### Switching Organizations

Use the provided helper script:

```bash
# Show current organization
./scripts/mcp-switch-org.sh

# Switch to a different organization
./scripts/mcp-switch-org.sh another-org

# Show all available organizations
./scripts/mcp-switch-org.sh show-all

# Restore previous organization
./scripts/mcp-switch-org.sh restore
```

### How It Works

The script:
1. Backs up your current `.mcp.json`
2. Creates a new `.mcp.json` for the target organization
3. Reminds you to update the PAT for the new organization
4. Allows you to restore the previous configuration

### Advantages

- Simple setup
- Low configuration overhead
- Claude Code loads quickly with minimal tools
- Easy to understand and debug

### Disadvantages

- Need to switch and update PAT each time
- Requires Claude Code restart after switching
- Can't work with multiple orgs simultaneously

---

## Approach 2: Multiple Servers (Advanced)

Load all organizations simultaneously so you can switch without restarting Claude Code.

### Setup

1. Copy the multi-organization template:
   ```bash
   cp .mcp.json.multi-org.example .mcp.json
   ```

2. Update each organization's configuration:
   ```json
   {
     "mcpServers": {
       "azure-devops-msvante": {
         "command": "node",
         "args": [".mcp-servers/azure-devops-mcp/dist/index.js", "msvante", "--authentication", "env"],
         "env": {
           "AZURE_DEVOPS_PAT": "YOUR_MSVANTE_PAT"
         }
       },
       "azure-devops-other": {
         "command": "node",
         "args": [".mcp-servers/azure-devops-mcp/dist/index.js", "other-org", "--authentication", "env"],
         "env": {
           "AZURE_DEVOPS_PAT": "YOUR_OTHER_ORG_PAT"
         }
       }
     }
   }
   ```

3. Update PAT values for each organization

### Using Multiple Organizations

When prompting Claude Code, specify which organization you want to work with:

- "List projects in the msvante organization"
- "Show work items from the other-org Azure DevOps"
- "Create a PR in the third-org organization"

Claude Code will intelligently route your request to the appropriate MCP server.

### Advantages

- No restart needed to switch organizations
- Can reference multiple orgs in single prompt
- More efficient if frequently switching
- All organizations available simultaneously

### Disadvantages

- More complex configuration
- Higher memory usage (multiple servers running)
- Potentially slower startup (multiple servers initializing)
- Claude Code has more tools loaded at once

---

## Approach 3: Environment-Based (Recommended)

Use environment variables to switch organizations without modifying `.mcp.json`.

### Setup

1. Create an environment configuration file `.env.devops`:
   ```bash
   AZURE_DEVOPS_ORG=msvante
   AZURE_DEVOPS_PAT=your_pat_here
   ```

2. Create `.mcp.json` that references the environment:
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

3. Before starting Claude Code, source your environment:
   ```bash
   source .env.devops
   code .  # or open Claude Code
   ```

### Switching Organizations

Switch by changing the environment variables:

```bash
# Switch to another organization
export AZURE_DEVOPS_ORG=another-org
export AZURE_DEVOPS_PAT=another_org_pat
# Restart Claude Code
```

Or create separate environment files:

```bash
# .env.msvante
AZURE_DEVOPS_ORG=msvante
AZURE_DEVOPS_PAT=msvante_pat

# .env.other
AZURE_DEVOPS_ORG=other-org
AZURE_DEVOPS_PAT=other_org_pat
```

Then switch by sourcing the appropriate file:

```bash
source .env.msvante && code .
```

### Advantages

- Most flexible approach
- No `.mcp.json` modifications needed
- Clean separation of configuration and code
- Easy to use different PATs for different contexts
- Works well with CI/CD pipelines

### Disadvantages

- Requires environment variable setup
- Environment must be set before starting Claude Code
- Need to remember to source the correct `.env` file
- `.env.*` files should not be committed (already in `.gitignore`)

---

## Switching Organizations: Quick Reference

### Single Organization with Helper Script

```bash
# Current organization
./scripts/mcp-switch-org.sh

# Switch to new organization
./scripts/mcp-switch-org.sh <org-name>

# Update PAT in .mcp.json
nano .mcp.json

# Restart Claude Code
```

### Multiple Servers

```bash
# Just mention the organization in your prompt
"List projects in <org-name> organization"

# Or be specific
"Show work items for msvante Azure DevOps"
```

### Environment-Based

```bash
# Source environment file
source .env.<org-name>

# Start Claude Code
code .

# Or restart Claude Code with the environment loaded
```

---

## Adding a New Organization

### Method 1: Using the Helper Script

The helper script automatically backs up your configuration and creates a new one for any organization listed in `.mcp.json.multi-org.example`.

### Method 2: Manual Multi-Org Setup

1. Edit `.mcp.json` and add a new server:
   ```json
   {
     "mcpServers": {
       "azure-devops-new-org": {
         "command": "node",
         "args": [".mcp-servers/azure-devops-mcp/dist/index.js", "new-org", "--authentication", "env"],
         "env": {
           "AZURE_DEVOPS_PAT": "NEW_ORG_PAT"
         }
       }
     }
   }
   ```

2. Update the PAT for the new organization

3. Restart Claude Code

### Method 3: Environment-Based

Create a new environment file:

```bash
cat > .env.new-org << EOF
AZURE_DEVOPS_ORG=new-org
AZURE_DEVOPS_PAT=new_org_pat
EOF
```

Then use it:

```bash
source .env.new-org && code .
```

---

## Troubleshooting

### Organization Not Found

**Problem**: "Cannot find organization" error

**Solutions**:
1. Verify the organization name is correct
2. Check that the organization exists at `https://dev.azure.com/<org-name>`
3. Ensure your PAT is for the correct organization
4. Verify the PAT has appropriate scopes

### PAT Expired

**Problem**: Authentication fails after switching organizations

**Solution**:
1. Create a new PAT in Azure DevOps
2. Update the PAT value in your configuration
3. Test the connection: "List my Azure DevOps projects"

### Server Not Responding

**Problem**: MCP server doesn't respond after switching

**Solutions**:
1. Restart Claude Code
2. Verify Node.js is still running: `pgrep node`
3. Check that the MCP server is built: `ls .mcp-servers/azure-devops-mcp/dist/`
4. Rebuild if needed: `cd .mcp-servers/azure-devops-mcp && npm install && npm run build`

### Configuration Conflicts

**Problem**: Multiple servers interfering with each other

**Solution**:
Use unique server names in `.mcp.json`:
```json
{
  "mcpServers": {
    "ado-msvante": { ... },
    "ado-other": { ... }
  }
}
```

---

## Best Practices

1. **Security**: Never commit `.mcp.json` with real PATs (use `.gitignore`)
2. **Backups**: The helper script automatically backs up your config
3. **Testing**: Test new organization configs with a simple prompt first
4. **Documentation**: Document which org names you use and what they're for
5. **PAT Rotation**: Regularly rotate your PATs for security
6. **Clear Naming**: Use clear server names that indicate the organization

---

## Recommended Workflow

Based on typical usage patterns, here's the recommended approach:

**If you primarily work with one organization:**
- Use **Approach 1: Single Organization** with the helper script
- Minimal overhead, easy to manage

**If you work with 2-3 organizations regularly:**
- Use **Approach 3: Environment-Based** with separate `.env` files
- Good balance of flexibility and simplicity

**If you work with many organizations or need simultaneous access:**
- Use **Approach 2: Multiple Servers**
- More complex but most powerful

**If you work with different organizations in different projects:**
- Use **Approach 3: Environment-Based** per project
- Keep project-specific `.env` files in `.gitignore`

---

## Additional Resources

- [MCP Setup Guide](./mcp-setup-guide.md) - General MCP configuration
- [Azure DevOps MCP Setup](./azure-devops-mcp-setup.md) - Azure DevOps specifics
- [Azure DevOps REST API](https://docs.microsoft.com/en-us/rest/api/azure/devops) - API reference
- [Personal Access Tokens](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate) - PAT management

---

## Helper Script Reference

### Usage

```bash
./scripts/mcp-switch-org.sh [command]
```

### Commands

| Command | Description |
|---------|-------------|
| (no args) | Show current organization |
| `org-name` | Switch to organization |
| `list` or `current` | Show current organization |
| `show-all` or `list-all` | List all available organizations |
| `restore` | Restore previous organization from backup |

### Examples

```bash
# Show current
./scripts/mcp-switch-org.sh

# Switch to msvante
./scripts/mcp-switch-org.sh msvante

# List all available
./scripts/mcp-switch-org.sh show-all

# Restore previous
./scripts/mcp-switch-org.sh restore
```

---

## Version History

- **v1.0** (2025-11-12): Initial multi-organization guide with three approaches and helper script
