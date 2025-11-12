#!/bin/bash

# Azure DevOps Organization Switcher
# Environment-based approach for switching between organizations
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

# Function to list available environments
list_envs() {
    print_status "Available environments:"
    if ls "$PROJECT_ROOT"/environments/.env.* 1> /dev/null 2>&1; then
        ls "$PROJECT_ROOT"/environments/.env.* | xargs -n1 basename | sed 's/^\.env\./  - /' | sort
    else
        print_warning "No .env files found"
        echo ""
        echo "Create environment files with:"
        echo "  cat > .env.org-name << EOF"
        echo "  AZURE_DEVOPS_ORG=org-name"
        echo "  AZURE_DEVOPS_PAT=your-pat-here"
        echo "  EOF"
    fi
}

# Function to switch organization
switch_org() {
    local org_name="$1"

    if [ -z "$org_name" ]; then
        list_envs
        exit 0
    fi

    # Validate organization name format
    if [[ "$org_name" =~ ^- ]]; then
        print_error "Invalid organization name: $org_name"
        echo ""
        echo "Usage: $0 [organization]"
        echo ""
        echo "Examples:"
        echo "  $0 msvante           (switch to msvante)"
        echo "  $0 other-org         (switch to other-org)"
        echo "  $0 list              (list available environments)"
        exit 1
    fi

    case "$org_name" in
        list|--list|-l)
            list_envs
            exit 0
            ;;
    esac

    # Check if environment file exists
    local env_file="$PROJECT_ROOT/environments/.env.$org_name"
    if [ ! -f "$env_file" ]; then
        print_error "Environment file not found: .env.$org_name"
        echo ""
        echo "Available environments:"
        list_envs
        echo ""
        echo "To create a new environment:"
        echo "  cat > .env.$org_name << EOF"
        echo "  AZURE_DEVOPS_ORG=$org_name"
        echo "  AZURE_DEVOPS_PAT=your-pat-here"
        echo "  EOF"
        exit 1
    fi

    # Source the environment
    print_status "Sourcing environment: .env.$org_name"
    source "$env_file"

    # Verify required variables
    if [ -z "$AZURE_DEVOPS_ORG" ] || [ -z "$AZURE_DEVOPS_PAT" ]; then
        print_error "Environment file is missing required variables"
        echo "Required variables: AZURE_DEVOPS_ORG, AZURE_DEVOPS_PAT"
        exit 1
    fi

    print_success "Switched to organization: $AZURE_DEVOPS_ORG"
    echo ""
    print_status "Starting Claude Code..."
    echo ""

    # Open Claude Code with the environment loaded
    code .
}

# Main script
switch_org "$@"
