# Managing Multiple Azure DevOps Organizations

This guide explains how to work with multiple Azure DevOps organizations in Claude Code using environment variables.

## Overview

The recommended approach for managing multiple organizations is using **environment variables**. This approach is clean, flexible, and keeps your configuration code separate from sensitive credentials.

---

## Quick Start

### Setup

1. Create environment files for each organization in the `environments/` directory:
   ```bash
   # Copy the example template
   cp environments/example.env.org_name environments/.env.msvante

   # Edit with your credentials
   nano environments/.env.msvante
   # Add: AZURE_DEVOPS_ORG=msvante
   #      AZURE_DEVOPS_PAT=your_msvante_pat_here

   # Or create new ones directly
   cat > environments/.env.other-org << EOF
   AZURE_DEVOPS_ORG=other-org
   AZURE_DEVOPS_PAT=your_other_org_pat_here
   EOF
   ```

2. Ensure `.mcp.json` uses environment variable references:
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

### Switching Organizations

To switch between organizations, source the appropriate environment file before starting Claude Code:

```bash
# Switch to msvante organization
source .env.msvante
code .

# Or in a single command
source .env.msvante && code .
```

---

## Detailed Setup Guide

### Step 1: Prepare Environment Files

Create environment files in the `environments/` directory for each organization you work with. Each file defines your organization name and Personal Access Token.

**File naming convention:** `environments/.env.<org-name>`

**Example - environments/.env.msvante:**
```bash
AZURE_DEVOPS_ORG=msvante
AZURE_DEVOPS_PAT=your_pat_for_msvante_here
```

**Example - environments/.env.another-org:**
```bash
AZURE_DEVOPS_ORG=another-org
AZURE_DEVOPS_PAT=your_pat_for_another_org_here
```

**Tip:** Copy from the template:
```bash
cp environments/example.env.org_name environments/.env.msvante
```

### Step 2: Verify .mcp.json Configuration

Your `.mcp.json` should reference environment variables (not hardcoded values):

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

**Note:** If you created `.mcp.json` from `.mcp.json.example`, you may need to replace hardcoded values with `${AZURE_DEVOPS_ORG}` and `${AZURE_DEVOPS_PAT}`.

### Step 3: Verify .gitignore Configuration

The `.gitignore` is configured to:
- Ignore all `.env.*` files in the `environments/` directory (sensitive credentials)
- Explicitly include `environments/example.env.org_name` (template for team)

Verify:

```bash
grep -A 2 "Azure DevOps environment" .gitignore
```

Should show:
```
# Azure DevOps environment files (ignore all .env files in environments dir except example)
environments/.env.*
!environments/example.env.org_name
```

### Step 4: Use the Helper Script

Use the provided script to manage organization switching:

```bash
# Show available environments
./scripts/mcp-switch-org.sh list

# Switch to an organization and open Claude Code
./scripts/mcp-switch-org.sh msvante

# Switch and start development
./scripts/mcp-switch-org.sh another-org
```

---

## Helper Script

The `scripts/mcp-switch-org.sh` script automates the switching process.

### Usage

```bash
./scripts/mcp-switch-org.sh [organization]
```

### Commands

| Command | Description |
|---------|-------------|
| (no args) | Show available organizations |
| `org-name` | Source environment and open Claude Code |
| `list` | List available environments |

### Examples

```bash
# List available organizations
./scripts/mcp-switch-org.sh list

# Switch to msvante
./scripts/mcp-switch-org.sh msvante

# Switch to another-org
./scripts/mcp-switch-org.sh another-org
```

---

## Workflow Examples

### Example 1: Working with a Single Primary Organization

If you primarily work with one organization but occasionally need another:

```bash
# Start with primary organization
source .env.msvante && code .

# Later, if you need to switch:
source .env.other-org
# Restart Claude Code
```

### Example 2: Quick Organization Switching

Use the helper script for quick switching:

```bash
./scripts/mcp-switch-org.sh msvante      # Switch and open Claude Code
# ... work with msvante ...

./scripts/mcp-switch-org.sh other-org    # Switch to different organization
# ... work with other-org ...
```

### Example 3: Multiple Projects with Different Organizations

If you have different projects using different organizations:

```bash
cd project-a
source .env.org-a && code .

cd project-b
source .env.org-b && code .
```

---

## Adding a New Organization

### Step 1: Create Environment File

Copy the example template to create a new environment file:

```bash
cp environments/example.env.org_name environments/.env.new-org
```

Or create directly:

```bash
cat > environments/.env.new-org << EOF
AZURE_DEVOPS_ORG=new-org
AZURE_DEVOPS_PAT=your_pat_for_new_org
EOF
```

### Step 2: Edit with Your Credentials

Edit the file with your organization's PAT:

```bash
nano environments/.env.new-org
```

### Step 3: Use It

Use the helper script to switch to the new organization:

```bash
./scripts/mcp-switch-org.sh new-org
```

Or manually source it:

```bash
source environments/.env.new-org && code .
```

---

## Security Best Practices

### 1. Protect Environment Files

Environment files contain Personal Access Tokens. Protect them:

```bash
# Restrict file permissions
chmod 600 .env.*

# Verify they're excluded from git
git status | grep .env   # Should show nothing
```

### 2. Use Strong PATs

When creating Personal Access Tokens:
- Use appropriate scopes (Code, Work Items, Build, Release)
- Set reasonable expiration dates (90 days to 1 year)
- Regularly rotate tokens
- Revoke old tokens

### 3. Environment Variable Isolation

Keep environment variables isolated:
- Don't export them permanently in shell profile
- Only source them when needed
- Use separate files per organization
- Clean up after switching if sensitive

### 4. .gitignore Configuration

The `.gitignore` already includes:
```
*.env
.mcp.json
.mcp.local.json
```

This prevents accidental commits of sensitive files.

### 5. Handle PAT Expiration

When a PAT expires:

1. Create a new PAT in Azure DevOps
2. Update the corresponding `.env.*` file
3. Test the connection before removing old PAT

---

## Troubleshooting

### Organization Not Found

**Problem**: "Cannot find organization" error when running commands

**Solutions**:
1. Verify the organization name is correct:
   ```bash
   echo $AZURE_DEVOPS_ORG
   ```
2. Check the environment file:
   ```bash
   cat .env.org-name
   ```
3. Verify the organization exists at `https://dev.azure.com/<org-name>`

### Authentication Failed

**Problem**: "Authentication failed" or "Invalid credentials"

**Solutions**:
1. Check the PAT is correct:
   ```bash
   echo $AZURE_DEVOPS_PAT
   ```
2. Verify PAT hasn't expired - create a new one if needed
3. Ensure PAT has appropriate scopes (Code, Work Items, Build, Release)
4. Verify you sourced the correct environment file:
   ```bash
   source .env.correct-org
   ```

### Environment Not Set

**Problem**: Claude Code doesn't recognize the organization

**Solutions**:
1. Ensure you sourced the environment before starting Claude Code:
   ```bash
   source .env.org-name && code .
   ```
2. Verify the variables are set:
   ```bash
   echo $AZURE_DEVOPS_ORG
   echo $AZURE_DEVOPS_PAT
   ```
3. Restart Claude Code after sourcing environment
4. Check that `.mcp.json` references environment variables with `${VARIABLE_NAME}` syntax

### Wrong Organization Active

**Problem**: Working with the wrong organization

**Solutions**:
1. Verify which organization is currently set:
   ```bash
   echo $AZURE_DEVOPS_ORG
   ```
2. Source the correct environment file:
   ```bash
   source .env.correct-org
   ```
3. Restart Claude Code
4. Test with a simple query: "List my Azure DevOps projects"

---

## File References

| File | Purpose |
|------|---------|
| `environments/example.env.org_name` | Template file (committed to git, shows structure) |
| `environments/.env.org-name` | Actual environment configs (gitignored, contains PAT) |
| `.mcp.json` | MCP configuration (uses environment variables) |
| `scripts/mcp-switch-org.sh` | Helper script for switching organizations |
| `.gitignore` | Excludes sensitive files, allows example template |

---

## Best Practices

1. **Naming Convention**: Use clear environment file names matching organization names
   - `.env.msvante` for msvante organization
   - `.env.other-org` for other-org organization

2. **File Permissions**: Restrict access to environment files
   ```bash
   chmod 600 .env.*
   ```

3. **PAT Rotation**: Periodically create new PATs and revoke old ones

4. **One Source at a Time**: Source only one environment file at a time to avoid conflicts

5. **Document Organizations**: Keep a note of all organizations you work with

6. **Test After Switching**: Always test the connection after switching:
   ```bash
   # In Claude Code, ask:
   # "List my Azure DevOps projects"
   ```

---

## Advanced: Multiple Organizations Simultaneously

If you absolutely need to access multiple organizations simultaneously from one Claude Code instance, you can configure multiple MCP servers in `.mcp.json`. However, this is not recommended for simplicity reasons.

Instead, consider:
- Opening separate Claude Code windows for different organizations
- Using the environment-based approach and switching as needed
- Creating project-specific configurations

---

## Additional Resources

- [MCP Setup Guide](./mcp-setup-guide.md) - General MCP configuration
- [Azure DevOps MCP Setup](./azure-devops-mcp-setup.md) - Azure DevOps specific setup
- [Personal Access Tokens](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate) - PAT management

---

## Version History

- **v2.0** (2025-11-12): Simplified to environment-based approach only
- **v1.0** (2025-11-12): Initial multi-organization guide with three approaches
