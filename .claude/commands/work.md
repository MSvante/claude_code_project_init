Read and analyze the next task from docs/tasks.md, then directly invoke the appropriate specialized agent(s) based on the task characteristics.

## Agent Routing Logic

Analyze the task and determine which specialized agent(s) to invoke:

### Task Analysis Keywords
- **Business/Product tasks**: Requirements definition, feature evaluation, task breakdown
  → Use `business-product-owner` agent

- **Python Backend tasks**: API development, database work, Python services, FastAPI, Django, backend logic
  → Use `python-backend-engineer` agent

- **Frontend/UI tasks**: React components, UI design, frontend logic, styling, user interfaces
  → Use `ui-engineer` agent

- **Code Review tasks**: Review code, security audit, architecture review, quality check
  → Use `senior-code-reviewer` agent

- **Frontend QA tasks**: Test UI, validate forms, check user flows, security testing of frontend
  → Use `frontend-qa-tester` agent

- **MCP tasks**: Implement MCP server, configure MCP, troubleshoot MCP, integrate external services
  → Use `mcp-server-architect` agent

### Workflow Pattern

1. **Read the task** from docs/tasks.md
2. **Identify the task type** using the keywords above
3. **Invoke the appropriate agent(s)** directly using the Task tool with the specific subagent_type
4. **For complex tasks requiring multiple agents**:
   - Sequence the agents in logical order (e.g., implementation → review → testing)
   - Run independent work in parallel when possible
   - Pass context between agents explicitly

### Multi-Agent Tasks

If a task requires multiple specialized agents:
- **Backend + Frontend**: Invoke agents sequentially (backend first, then frontend)
- **Implementation + Review**: Always run review after implementation
- **Implementation + Testing**: Run testing after implementation completes
- **Review + Testing**: Can run in parallel after implementation

IMPORTANT: All new work should be done on branches that are not main.

## Direct Agent Invocation

When invoking agents, be explicit:
- Use the Task tool with the specific `subagent_type` parameter
- Provide clear context about what the agent should accomplish
- Make it visible in logs which agent is handling which part of the task 