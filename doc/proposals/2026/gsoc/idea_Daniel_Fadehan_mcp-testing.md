### Initial Idea Submission

**Full Name:** Daniel Fadehan  
**University name:** Redeemer's University  
**Program you are enrolled in:** Computer Science  
**Year:** 3rd year  
**Expected graduation date:** 2027  

**Project Title:** MCP Testing  


**Idea description:**

The Model Context Protocol (MCP) acts as the API layer of the AI world, defining a standard way for AI agents to discover, understand, and interact with tools, data, and software systems - much like REST or GraphQL do for traditional applications.

In this project, my task is to strengthen the MCP Developer ecosystem by designing and building the capability to intuitively create and comprehensively test MCP servers and clients.

For my idea, I am looking at structuring the application around two main tabs: **Create** and **Test**, providing a seamless workflow from server construction to validation.

---

## Part 1: Creation (Create Tab)

The Create tab provides an intuitive visual environment for constructing MCP servers without writing code.

### 1.1 Server Setup

Users begin by creating a new MCP server with basic configuration:
- **Server Name:** A unique identifier for the server (e.g., `weather-api`)
- **Transport Type:** Choose between `STDIO` or `HTTP` transport protocols

The sidebar displays all created servers, allowing users to manage multiple MCP servers within a single workspace.

![Creating an MCP Server](images/1.%20creating%20an%20mcp%20server.png)

### 1.2 Defining Server Components

Once a server is created, users can add three types of MCP primitives:

#### Tools
Tools are executable functions that the AI can invoke. Users define:
- **Tool Name:** (e.g., `get_forecast`)
- **Description:** Human-readable explanation of what the tool does

![Creating a Tool](images/2.%20creating%20a%20tool%20within%20the%20server.png)

#### Resources
Resources expose data to the AI model. Configuration includes:
- **Type:** Resource Template or Static Resource
- **URI Template:** Dynamic URI patterns with variables (e.g., `weather/{city}`)
- **MIME Type:** Content type specification (e.g., `application/json`)
- **Response Template:** Define the response structure with variable interpolation using `{{variable}}` syntax

![Resource Configuration](images/6.%20mcp%20resource%20config.png)

#### Prompts
Prompt templates provide reusable conversation starters:
- **Arguments:** Define typed parameters (String, Number, etc.) with descriptions
- **Messages:** Configure the prompt messages that use the defined arguments

![Prompt Configuration](images/7.%20configuring%20a%20prompt%20template.png)

### 1.3 Visual Workflow Builder

For each tool, users orchestrate the execution logic using a visual node-based workflow editor:

- **Input Node:** Entry point that defines tool parameters (name, type, description, required flag)
- **Processing Nodes:** Add HTTP requests, conditional logic, data transformations
- **Output Node:** Defines the final response returned by the tool

The workflow flows left-to-right: `Input → Processing → Output`

![Workflow Orchestration](images/3.%20orchestrating%20the%20workflow%20for%20the%20tool.png)

![Input Parameters](images/4.%20specifying%20the%20input%20parameters%20for%20the%20server.png)

### 1.4 Workflow Execution Preview

Users can test their workflow directly within the Create tab:
- Click **Execute** to run the workflow
- View execution results showing each step (input → apiCall → output)
- Inspect the output data in real-time

![Running the Workflow](images/5.%20running%20the%20tool%20workflow.png)

---

## Part 2: Testing (Test Tab)

The Test tab provides a comprehensive environment for validating MCP servers, supporting both locally-built servers and external servers.

I am looking at building the test suite upon the already existing mcp inspector, so all the features that exist within the suite are already avaible out of the box, so I would simply extend the ui to be more intuitive to use. 

### 2.1 Server Selection

Users can test servers from two sources:

- **Builder Preview:** Test servers created within the Create tab
- **External Server:** Connect to any external MCP server via STDIO or HTTP

![Testing Server Selection](images/8.%20testing%20a%20server%20built%20within%20the%20workflow.png)

### 2.2 Testing Built-in Servers (Builder Preview)

When testing a server built in the workflow:
1. Select the server from the dropdown (e.g., `weather`, `test`)
2. The connection shows as **"Local Builder Mode"**
3. All tools, resources, and prompts are automatically discovered

Testing interface features:
- **Form View:** User-friendly form with labeled input fields
- **JSON View:** Raw JSON input for advanced users
- **Run Tool:** Execute the tool with provided parameters
- **Execution Details:** View step-by-step execution (input → apiCall → output)
- **History:** Track previous test runs with timing information

![Running a Tool Test](images/9.%20running%20the%20tool.png)

### 2.3 Testing External Servers

For external MCP servers:
1. Switch to **External Server** mode
2. Provide connection details (command/URL)
3. Connect and discover available tools
4. Test tools with the same rich interface

The UI displays tool metadata including annotations like `Read-only` and `Idempotent` to help users understand tool behavior.

![Testing External Server](images/10.%20testing%20an%20external%20server.png)

### 2.4 Test Results & Debugging

Each test execution provides:
- **Success/Failure Status** with response time (e.g., `Success 226ms`)
- **Final Output:** The complete response data
- **Execution Steps:** Breakdown of each workflow step with intermediate state
- **Copy functionality:** Easily copy outputs for further use



