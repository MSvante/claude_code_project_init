# MCP (Model Context Protocol) Starter Template

⚠️ **Disclaimer**

**Note from the Author:**
MCP (Model Context Protocol) Servers are evolving rapidly. While remote MCP servers exist and are being developed by Microsoft and other providers, this template currently focuses only on local MCP server setups. Remote MCP implementations will likely reduce the need for manual configuration, but this template has not yet incorporated those capabilities.

This project has been tested and confirmed to run on a Windows environment. While Docker-based configurations are possible, I have not yet implemented or tested them. Contributions or improvements in that area are very welcome.

Python dependencies in this template are managed using pip. While I'm aware that uv is becoming the modern standard for dependency management, experienced users should be able to adapt the setup accordingly.

The template includes two Microsoft-related MCP servers:
(You do not need to setup both servers, they can run indivually)

- **Azure MCP Server** – official Microsoft-supported
- **DevOps MCP Server** – community-supported (unofficial)
 

⚠️ **Intended Use:**
This template is designed strictly for internal experimentation and demo purposes only. Please do not use it in production environments, since it is using a community MCP server. Microsoft will likely release an official version very soon. You can add or remove MCP servers and experiment with Copilot instruction files to understand how the Copilot Agent behaves and how we can properly control its capabilities.

### Future Development & Contributions Welcome

Looking to contribute?

- **Docker-based Configuration**: Create containerized setup for consistent deployment across environments
- **Remote MCP Integration**: Explore and document integration with remote MCP services
- **Cross-platform Testing**: Verify and document setup process for macOS and Linux environments
- **Creating Custom MCP Servers**: Develop examples for building specialized MCP servers beyond Azure/DevOps
- **Security Hardening**: Implement additional security measures for credential handling and access control
- **Advanced Copilot Instructions**: Develop instruction files that demonstrate effective agent limitations

---


## Prerequisites

Before setting up this template, ensure you have the following installed:

- [Node.js](https://nodejs.org/) (v16.x or later)
  - Used to run JavaScript-based agent tools or UI components that interact with the MCP server.
- [npm](https://www.npmjs.com/) (comes with Node.js)
  - Required for managing and installing JavaScript dependencies.
- [Python](https://www.python.org/) (v3.11 or later) 
- [VS Code](https://code.visualstudio.com/) (latest version recommended)
- [GitHub Copilot](https://github.com/features/copilot) extension installed in VS Code
  - **Note**: You'll need to request a GitHub Copilot license from your IT department

### Optional dependencies (based on which MCP servers you'll use)

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) - Required for Azure MCP Server
- [Azure DevOps Extension](https://marketplace.visualstudio.com/items?itemName=ms-vsts.team) - Required for Azure DevOps MCP

## Windows Setup Instructions

Follow these steps to set up the MCP environment on a Windows PC:

1. **Install Prerequisites**:
   - Python 3.11+
   - Node.js 16+ (or later) 
   - VS Code 
   - Git

2. **Install GitHub Copilot**:
   - ! Important Requirement ! - Get a Copilot License Key from IT Support
   - ! Important Requirement ! - You need to have a personal GitHub account to which you can assign the Copilot License
   - ! Important Requirement ! - Create a Personal Access Token (PAT) in Github
   - Open VS Code
   - Click on the Extensions icon in the Activity Bar (or press `Ctrl+Shift+X`)
   - Search for "GitHub Copilot"
   - Click Install
   - Sign in to GitHub when prompted

3. **Clone the Repository**:
   - Clone the repo: 
     ```
     git clone https://Inspari-Accelerators@dev.azure.com/Inspari-Accelerators/Accelerators/_git/copilot-mcp-template
     ```

4. **Setup MCP Environment**:
   - Run the setup script with Python:
     ```
     pip install -r requirements.txt
     python setup.py
     ```
   - Follow the prompts to configure your MCP servers

5. **Register MCP Servers in VS Code**:
   - **Option 1: Using VS Code Command Palette**
     - Press `Ctrl+Shift+P` to open the Command Palette
     - Type "Copilot: Register MCP Server..." and select it
     - Choose the desired MCP server from the dropdown list (e.g., "Azure MCP Server")
     - Provide any requested credentials when prompted
       - For Azure: You may need your API key or use existing Azure CLI login
       - For Azure DevOps: You'll need a Personal Access Token (PAT)
   
   - **Option 2: Manual Configuration (Advanced)**
     - Open the `.vscode/mcp.json` file in VS Code
     - The file already contains configurations for Azure and Azure DevOps MCP servers
     - Update relevant parameters such as `AZURE_DEVOPS_ORG_URL` and project name
     - Save the file
     - No additional registration is needed for servers defined in this file
     - Use the "Start" button next to each server entry to launch them

6. **Verify the Installation**:
   - **Option 1: Using the Start button in VS Code (Recommended)**
     - Open the `.vscode/mcp.json` file in VS Code
     - Look for a "Start" icon above each server definition
     - Click this icon to start the server
     - If the server starts running without errors, your setup is working
     - In GitHub Copilot Chat, you'll see a "Select Tools" icon (looks like a utility/tools icon)
     - This icon shows all the functions accessible to the agent
     - When properly installed, you should see Azure DevOps functions in this list
   
   - **Option 2: Check the Output panel**
     - After registering an MCP server, you should see a confirmation message
     - Test the connection by asking Copilot a question related to the registered MCP server
     - Check the Output panel (`View > Output`, then select "MCP" from the dropdown) for any logs

## Enabling GitHub Copilot Agent Mode

⚠️ **Important**: To use MCP servers, GitHub Copilot must be in Agent Mode. This allows Copilot to access and use external tools provided by MCP.

**How to verify Agent Mode is enabled:**

1. Open VS Code and click on the GitHub Copilot Chat icon in the activity bar
2. In the chat interface, look for the "Select Tools" icon (wrench/utility icon)
3. If the icon is present, Agent Mode is enabled
4. If the icon is missing, you need to enable Agent Mode:
   - Open VS Code settings (File > Preferences > Settings)
   - Search for "Copilot Agent"
   - Ensure "GitHub Copilot: Enable Agent" is checked
   - Restart VS Code after making changes

**Testing Agent Mode with MCP:**

After enabling Agent Mode and starting your MCP server(s), try these specific examples:

1. **For Azure DevOps MCP**:
   ```
   Can you show me work items assigned to me in the current project?
   ```
   This will query your Azure DevOps instance and display your assigned work items.
   
   Or more specifically:
   ```
   What's my Azure DevOps account name and which projects do I have access to?
   ```
   This will return your authenticated identity and available projects.

2. **For Azure MCP Server**:
   ```
   List my Azure resource groups and their locations
   ```
   This will display your Azure resource groups if properly authenticated.
   
   Or try:
   ```
   Summarize my Azure subscription details including subscription ID and name
   ```
   This will use the Azure CLI authentication to provide information about your current subscription.

These examples verify that your MCP servers are properly connected and that GitHub Copilot can access their capabilities through Agent Mode.

## Available MCP Servers (This Template)

This template includes configuration for the following MCP servers:

1. **Azure MCP Server** - Provides Copilot with capabilities for interacting with Azure services
2. **Azure DevOps MCP** - Connects Copilot with Azure DevOps services

## Configuration Details

MCP servers are configured in the `.vscode/mcp.json` file. This file contains:

- **Input definitions**: For securely handling credentials like API keys and tokens
- **Server definitions**: Configuration for each MCP server, including command, arguments, and environment variables

## Customizing for Your Environment

You may need to adjust paths in the `mcp.json` file based on your Node.js installation location:

1. Open `.vscode/mcp.json`
2. Update the `command` path to match your Node.js installation 
3. Update the `PATH` environment variable if needed

## Extending This Template

To add additional MCP servers:

1. Add a new entry under the `"servers"` section in `.vscode/mcp.json`
2. Follow the same structure as existing server definitions
3. Include any required environment variables

## Examples

The `examples` folder contains Python examples showing how to:

1. Use MCP capabilities with GitHub Copilot (see `mcp-copilot-prompt-commands.md`)

## Additional Resources

- The `examples` folder contains Python examples showing how to programmatically interact with MCP servers
- [Model Context Protocol Introduction](https://modelcontextprotocol.io/introduction) - Official documentation on MCP concepts and architecture
- [MCP.so](https://mcp.so/) - MCP community resource hub
- [Azure MCP Server (Official)](https://github.com/Azure/azure-mcp) - Official Microsoft MCP server (currently in public preview)
- [Azure DevOps MCP Server](https://github.com/Tiberriver256/mcp-server-azure-devops) - Community-created MCP server for Azure DevOps integration (note: community projects may change over time)
- Check the official [MCP documentation](https://github.com/microsoft/model-context-protocol) for more details

## Security Considerations

When using MCP servers, be aware of these security risks and recommended prevention measures:

### Common Security Risks

- **Server Trust Issues**: Malicious MCP servers can impersonate legitimate servers
- **Prompt Injection Attacks**: Crafted prompts that trick AI into making unsafe tool calls
- **Tool Description Poisoning**: Hidden malicious instructions in tool descriptions
- **Insufficient Sandboxing**: Inadequate isolation of MCP servers and tools
- **Plaintext Credential Exposure**: Sensitive data stored in local configuration files
- **Weak Authentication**: Missing or insufficient authentication between MCP client and server
- **Consent Fatigue**: Repeated permission requests causing users to grant excessive access

### Prevention Measures

- **Use Trusted Sources**: Only install MCP servers from official repositories
- **Regular Auditing**: Periodically review MCP server configurations and logs
- **Secure Authentication**: Implement strong authentication for all MCP deployments
- **Credential Protection**: Encrypt sensitive configuration files and use secure credential management
- **Minimum Access**: Grant MCP servers only the permissions they absolutely need
- **HTTPS Communication**: Ensure all client-server interactions use encrypted connections
- **Sandboxing**: Deploy comprehensive isolation for MCP servers and tools
- **Review Tool Descriptions**: Carefully verify the descriptions of tools before using them
- **Security Logging**: Enable logging of all MCP server activities for forensic purposes

### Update MCP Servers

- Clear NPX cache to ensure latest version is downloaded
  ```
  npx clear-npx-cache
  ```

- **##** For Azure MCP Server specifically (if needed)
  ```
  npm cache clean --force @azure/mcp
  npm cache clean --force @tiberriver256/mcp-server-azure-devops
  ```