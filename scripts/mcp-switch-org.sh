#!/bin/bash

# MCP Organization Switcher
# This script helps quickly switch between different Azure DevOps organizations
# Usage: ./scripts/mcp-switch-org.sh [org-name]
# Example: ./scripts/mcp-switch-org.sh msvante

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration files
MCP_CONFIG="$PROJECT_ROOT/.mcp.json"
MCP_BACKUP="$PROJECT_ROOT/.mcp.json.backup"
MCP_MULTI_ORG="$PROJECT_ROOT/.mcp.json.multi-org.example"
MCP_SINGLE_ORG="$PROJECT_ROOT/.mcp.json.example"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[MCP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Function to show current organization
show_current_org() {
    if [ -f "$MCP_CONFIG" ]; then
        local org=$(grep -o '"azure-devops[^"]*"' "$MCP_CONFIG" | head -1 | tr -d '"')
        if [ -z "$org" ]; then
            print_warning "No active organization found in .mcp.json"
        else
            print_status "Current primary organization: $org"
        fi
    else
        print_warning ".mcp.json not found"
    fi
}

# Function to list all available servers
list_servers() {
    if [ -f "$MCP_MULTI_ORG" ]; then
        print_status "Available organizations (from .mcp.json.multi-org.example):"
        grep -o '"azure-devops-[^"]*"' "$MCP_MULTI_ORG" | tr -d '"' | sed 's/^/  - /'
    else
        print_warning "No multi-org configuration found"
    fi
}

# Function to create backup
backup_config() {
    if [ -f "$MCP_CONFIG" ]; then
        cp "$MCP_CONFIG" "$MCP_BACKUP"
        print_status "Backed up current .mcp.json to .mcp.json.backup"
    fi
}

# Function to switch to organization
switch_org() {
    local org_name="$1"

    if [ -z "$org_name" ]; then
        print_error "Organization name required"
        echo "Usage: $0 [org-name] [--dry-run]"
        echo ""
        echo "Examples:"
        echo "  $0 msvante"
        echo "  $0 another-org"
        echo "  $0 list                  (show current org)"
        echo "  $0 show-all              (show all available orgs)"
        echo "  $0 restore               (restore from backup)"
        exit 1
    fi

    case "$org_name" in
        list|current)
            show_current_org
            exit 0
            ;;
        show-all|list-all)
            list_servers
            exit 0
            ;;
        restore)
            if [ -f "$MCP_BACKUP" ]; then
                cp "$MCP_BACKUP" "$MCP_CONFIG"
                print_success "Restored .mcp.json from backup"
                show_current_org
            else
                print_error "No backup found"
                exit 1
            fi
            exit 0
            ;;
    esac

    # Check if organization configuration exists in multi-org file
    if ! grep -q "\"azure-devops-$org_name\"" "$MCP_MULTI_ORG" 2>/dev/null; then
        print_error "Organization '$org_name' not found in .mcp.json.multi-org.example"
        echo ""
        print_status "Available organizations:"
        list_servers
        exit 1
    fi

    # Extract the organization's configuration
    local start_line=$(grep -n "\"azure-devops-$org_name\"" "$MCP_MULTI_ORG" | cut -d: -f1)
    if [ -z "$start_line" ]; then
        print_error "Could not extract configuration for '$org_name'"
        exit 1
    fi

    # Backup current config
    backup_config

    # Create new config with single organization
    # This is a simplified approach - in practice, you might want to keep all orgs loaded
    cat > "$MCP_CONFIG" << EOJSON
{
  "mcpServers": {
    "azure-devops": {
      "command": "node",
      "args": [".mcp-servers/azure-devops-mcp/dist/index.js", "$org_name", "--authentication", "env"],
      "env": {
        "AZURE_DEVOPS_PAT": "ENTER_YOUR_PAT_FOR_$org_name"
      }
    }
  }
}
EOJSON

    print_success "Switched to organization: $org_name"
    print_warning "Remember to update the AZURE_DEVOPS_PAT in .mcp.json with your PAT for '$org_name'"
    echo ""
    print_status "Next steps:"
    echo "  1. Edit .mcp.json and replace ENTER_YOUR_PAT_FOR_$org_name with your actual PAT"
    echo "  2. Restart Claude Code to load the new configuration"
    echo "  3. Test with: 'List my ADO projects'"
    echo ""
    print_status "To restore previous organization:"
    echo "  $0 restore"
}

# Main script
if [ $# -eq 0 ]; then
    show_current_org
else
    switch_org "$@"
fi
