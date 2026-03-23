# MCP Server Builder & Testing Tool

**Full Name:** Daniel Fadehan  
**University:** Redeemer's University  
**Program:** Computer Science  
**Year:** 3rd Year  
**Expected Graduation:** 2027  

---

## Executive Summary

The Model Context Protocol (MCP) acts as the API layer of the AI world, defining a standard way for AI agents to discover, understand, and interact with tools, data, and software systems—much like REST or GraphQL do for traditional applications.

This project strengthens the MCP Developer ecosystem by providing an intuitive visual environment to **create** MCP servers without writing code and **comprehensively test** both locally-built and external MCP servers.

The application is structured around two main tabs: **Create** and **Test**, providing a seamless workflow from server construction to validation.

---

## Part 1: Creation (Create Tab)

The Create tab provides a visual environment for constructing MCP servers without writing code.

### 1.1 Server Creation Flow

#### Step-by-Step Process

| Step | Action | Details |
|------|--------|---------|
| 1 | Click "+" button | Opens the server creation modal |
| 2 | Enter server name | Unique identifier (e.g., `weather-api`) |
| 3 | Select transport type | Choose `STDIO` or `HTTP` |
| 4 | Click "Create Server" | Server appears in sidebar (empty state) |
| 5 | Add components | Add Tools, Resources, or Prompts to the server |

![Creating an MCP Server](images/1.%20creating%20an%20mcp%20server.png)

#### Design Rationale: Why Components Are Added After Server Creation

We chose a two-step approach (create server → add components) rather than a single wizard for several reasons:

1. **Incremental Building:** Developers often start with one tool and iteratively add more. A monolithic creation flow would require knowing everything upfront.

2. **Server Reusability:** A single server can host multiple tools, resources, and prompts. Separating server creation from component creation reflects this one-to-many relationship.

3. **Complexity Management:** Tools require a visual workflow builder, which needs dedicated screen space. Embedding this in a creation wizard would be overwhelming.

4. **Flexibility:** Users can add a tool, test it immediately, then add another—supporting a tight feedback loop.

**Alternative Considered:** A wizard-style "Quick Start" flow that guides users through server → tool → resource → prompt in sequence. This could be offered as an optional onboarding experience alongside the current flexible approach.

---

### 1.2 Defining Server Components

Once a server is created, users can add three types of MCP primitives. Each has a different complexity level and corresponding UI:

| Component | Complexity | UI Approach | Requires Workflow? |
|-----------|------------|-------------|-------------------|
| **Tools** | Dynamic execution logic | Visual workflow builder | ✅ Yes |
| **Resources** | Static data templates | Form-based configuration | ❌ No |
| **Prompts** | Static message templates | Form-based configuration | ❌ No |

#### Why Only Tools Have Workflows

**Tools** perform dynamic actions at runtime:
- Make API calls with variable inputs
- Process and transform data
- Execute conditional logic
- Return computed results

This requires a visual workflow builder to express the execution logic.

**Resources** are simpler—they expose data via URI templates:
- Define a URI pattern: `weather/{city}`
- Define a response template with variable interpolation
- No runtime logic—just pattern matching and string substitution

**Prompts** are also static templates:
- Define typed arguments
- Define message templates using those arguments
- No execution logic—templates are expanded when requested

---

#### 1.2.1 Adding Tools

Tools are executable functions that AI models can invoke.

**Creation Steps:**
1. Click "Add Tool" within a server
2. Enter tool name (e.g., `get_forecast`)
3. Enter description (human-readable explanation)
4. Click "Create" → Workflow canvas opens

![Creating a Tool](images/2.%20creating%20a%20tool%20within%20the%20server.png)

**Tool Configuration:**
- **Name:** Identifier used in MCP tool calls
- **Description:** Helps AI understand when to use this tool
- **Workflow:** Visual definition of execution logic (see Section 1.3)

---

#### 1.2.2 Adding Resources

Resources expose data to AI models via URI patterns.

**Creation Steps:**
1. Click "Add Resource" within a server
2. Select type: Static Resource or Resource Template
3. Configure URI pattern, MIME type, and response template
4. Click "Save"

![Resource Configuration](images/6.%20mcp%20resource%20config.png)

**Resource Configuration Fields:**
| Field | Description | Example |
|-------|-------------|---------|
| Type | Static or Template | Resource Template |
| URI Template | Pattern with variables | `weather/{city}` |
| MIME Type | Content type | `application/json` |
| Response Template | Data structure with `{{variable}}` interpolation | `{"city": "{{city}}", "data": {...}}` |

**No workflow needed:** Resources use simple variable substitution. When a client requests `weather/tokyo`, the system extracts `city=tokyo` and interpolates it into the response template.

---

#### 1.2.3 Adding Prompts

Prompts are reusable conversation starters with typed arguments.

**Creation Steps:**
1. Click "Add Prompt" within a server
2. Define arguments (name, type, description)
3. Configure message templates using arguments
4. Click "Save"

![Prompt Configuration](images/7.%20configuring%20a%20prompt%20template.png)

**Prompt Configuration:**
- **Arguments:** Typed parameters (String, Number, Boolean) with descriptions
- **Messages:** Array of message objects using `{{argument}}` syntax

**No workflow needed:** Prompts are template expansions—the system substitutes argument values into the message templates.

---

### 1.3 Visual Workflow Builder (Tools Only)

The workflow builder is the core of tool creation, allowing users to define execution logic visually.

![Workflow Orchestration](images/3.%20orchestrating%20the%20workflow%20for%20the%20tool.png)

#### 1.3.1 Architecture Overview

The workflow builder uses a **node-based visual programming paradigm**, similar to n8n or Node-RED:

```
┌─────────┐      ┌──────────────┐      ┌───────────┐      ┌────────┐
│  Input  │─────▶│  Processing  │─────▶│ Transform │─────▶│ Output │
│  Node   │      │    Nodes     │      │   Nodes   │      │  Node  │
└─────────┘      └──────────────┘      └───────────┘      └────────┘
     │                  │                    │                 │
     ▼                  ▼                    ▼                 ▼
  Define            Make API            Reshape            Return
  params            calls               data               result
```

#### 1.3.2 Available Node Types

The system ships with a core set of node types and is designed to be **extensible**. As we support more capabilities, we add new node types by implementing their executor and code template (see Section 3.3).

**Current Node Types:**

| Node Type | Icon | Purpose | Configuration |
|-----------|------|---------|---------------|
| **Input** | ▶️ | Define tool parameters | Name, type, description, required flag |
| **HTTP Request** | 🌐 | Make external API calls | Method, URL, headers, query params, body |
| **Transform** | 🔄 | Reshape/extract data | Field mappings using JSONPath syntax |
| **Conditional** | ❓ | Branch based on conditions | If/else expressions |
| **Code** | 📝 | Custom JavaScript logic | Code snippet editor |
| **Output** | 📤 | Define final response | Source node selection |

**Future Node Types (Extensible):**
- **Loop** — Iterate over arrays
- **Parallel** — Execute multiple branches concurrently
- **Delay** — Wait for a specified duration
- **Database** — Query databases directly
- **AI Call** — Invoke other AI models

Adding a new node type requires implementing:
1. An **executor** function (runs at preview time)
2. A **code template** function (generates TypeScript for export)
3. A **validation** function (checks configuration)
4. A **config schema** (defines the UI form)

#### 1.3.3 Data Flow Model

Each node operates on a shared **execution context**—a JavaScript object that accumulates results as the workflow executes:

```javascript
// Execution Context Structure
{
  "env": {
    "API_KEY": "xxx"           // Environment variables
  },
  "input_1": {
    "city": "Tokyo",           // From Input node
    "units": "celsius"
  },
  "http_1": {
    "location": { "name": "Tokyo" },  // From HTTP Request node
    "current": { "temp_c": 22 }
  },
  "transform_1": {
    "city": "Tokyo",           // From Transform node
    "temperature": 22
  }
}
```

**Variable Reference Syntax:**
Users reference data from previous nodes using `{{nodeId.path}}` syntax:

| Reference | Resolves To |
|-----------|-------------|
| `{{input_1.city}}` | `"Tokyo"` |
| `{{http_1.current.temp_c}}` | `22` |
| `{{env.API_KEY}}` | Environment variable value |

![Input Parameters](images/4.%20specifying%20the%20input%20parameters%20for%20the%20server.png)

#### 1.3.4 Execution Model

When a workflow runs, the system:

1. **Parses** the workflow graph (nodes and edges)
2. **Sorts** nodes topologically based on dependencies
3. **Executes** each node in order, passing the shared context
4. **Returns** the output node's result

```
Topological Sort Example:
─────────────────────────
Edges: A→B, B→C, A→C

Valid execution order: A → B → C
(C depends on both A and B, so it runs last)
```

[![](https://mermaid.ink/img/pako:eNqNk12PmkAUhv_KZPamTVzjB6zARRurdEvXigG03aIXEzwo2ZExM0Orq_73MgPW7cZNOgmE4Tzvez4YDjhhS8AOTin7nawJlyj6NM9RucKoH0Tv4qkAjgY0S54EcneQFBIW79Ht7Qc06QehG08IF4C-M_6kLNDX0B8vKgMd1-SsP_KG_cg9zAjNlkRe-FOFVvczpjRHL_-l4CNyg8AP4nBdmtfyjOXI5ZxxsbginFWy0A-iOGJbRtkqSwhFIeNy8TKdInR53tiLYi_PZFZKnwENWC5hd4ZVVGMj358cvjEOaFzOTHz8p3YV1OkfQRzRvRvF9yDrgTGO0vJSKhTtt1Abl5D2dX-4g7gerYbquHqvgcEXd_BwCIskAfEqrQ5d8oaRH7hxKFWRAYiCSpTlr_rRzN-GrpuN2RF97nujaux61mgIkmRULK52rQT-NJpMozgAWfAc-YXcFrJquiqlVlaYLmDohZNR_zEeZmJLyb7mBJqQHGiJVwIh9xSq44jSjFLnptNJTBMaSfltuXOTpulLsDb9H1QfrRqE1CjXG6CaxVscbuAVz5bYkbyABt4A3xC1xQflMMdyDRuYY6d8XBL-NMfz_FRqtiT_ydjmLOOsWK2xkxIqyl2xVX_JMCMrTi4I5EvgA1bkEjumdsDOAe-w0zF7TaNttlq2Yd21Wl27gffY6dpN2-iZhmVZttFtdaxTAz_rlK2mZXYs2zS61l2v3W532qc_JKo9xQ?type=png)](https://mermaid.live/edit#pako:eNqNk12PmkAUhv_KZPamTVzjB6zARRurdEvXigG03aIXEzwo2ZExM0Orq_73MgPW7cZNOgmE4Tzvez4YDjhhS8AOTin7nawJlyj6NM9RucKoH0Tv4qkAjgY0S54EcneQFBIW79Ht7Qc06QehG08IF4C-M_6kLNDX0B8vKgMd1-SsP_KG_cg9zAjNlkRe-FOFVvczpjRHL_-l4CNyg8AP4nBdmtfyjOXI5ZxxsbginFWy0A-iOGJbRtkqSwhFIeNy8TKdInR53tiLYi_PZFZKnwENWC5hd4ZVVGMj358cvjEOaFzOTHz8p3YV1OkfQRzRvRvF9yDrgTGO0vJSKhTtt1Abl5D2dX-4g7gerYbquHqvgcEXd_BwCIskAfEqrQ5d8oaRH7hxKFWRAYiCSpTlr_rRzN-GrpuN2RF97nujaux61mgIkmRULK52rQT-NJpMozgAWfAc-YXcFrJquiqlVlaYLmDohZNR_zEeZmJLyb7mBJqQHGiJVwIh9xSq44jSjFLnptNJTBMaSfltuXOTpulLsDb9H1QfrRqE1CjXG6CaxVscbuAVz5bYkbyABt4A3xC1xQflMMdyDRuYY6d8XBL-NMfz_FRqtiT_ydjmLOOsWK2xkxIqyl2xVX_JMCMrTi4I5EvgA1bkEjumdsDOAe-w0zF7TaNttlq2Yd21Wl27gffY6dpN2-iZhmVZttFtdaxTAz_rlK2mZXYs2zS61l2v3W532qc_JKo9xQ)
---

### 1.4 Workflow Execution Preview

Users can test workflows directly within the Create tab without leaving the editor.

![Running the Workflow](images/5.%20running%20the%20tool%20workflow.png)

#### 1.4.1 Execution Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| **Full Execution** | Runs workflow with real API calls | Final testing |
| **Mock Mode** | Uses mocked responses for external services | Development without API keys |
| **Step-by-Step** | Pauses after each node | Debugging complex workflows |

#### 1.4.2 Execution Panel Details

When the user clicks **Execute**, the panel shows:

```
┌─────────────────────────────────────────────────┐
│ ✅ Execution Completed                     226ms │
├─────────────────────────────────────────────────┤
│ EXECUTION STEPS                                  │
│                                                  │
│ ● input      12ms   ✓                           │
│   └─ { city: "Tokyo", units: "celsius" }        │
│                                                  │
│ ● http_1    198ms   ✓                           │
│   └─ GET api.weatherapi.com/v1/current.json     │
│   └─ Status: 200 OK                             │
│                                                  │
│ ● transform   8ms   ✓                           │
│   └─ Extracted 3 fields                         │
│                                                  │
│ ● output      8ms   ✓                           │
├─────────────────────────────────────────────────┤
│ OUTPUT DATA                                      │
│ {                                                │
│   "city": "Tokyo",                               │
│   "temperature": 22,                             │
│   "condition": "Sunny"                           │
│ }                                                │
│                                         [Copy 📋]│
└─────────────────────────────────────────────────┘
```

**Features:**
- **Timeline:** Visual representation of each step's duration
- **Step Status:** Success (✓), Failed (✗), Skipped (○) with color coding
- **Expandable Details:** Click any step to see full input/output data
- **Request Inspector:** For HTTP nodes, view full request and response
- **Error Details:** Stack trace and suggested fixes for failed steps
- **Copy Button:** One-click copy of output data

---

### 1.5 Editing Existing MCP Servers, Import/Export & Persistence

#### 1.5.1 Scope: Builder-Created Servers Only

For external MCP servers, reverse-engineering arbitrary code into our node graph would be unreliable—specific executor nodes may not exist for arbitrary logic. Therefore, **editing is restricted to servers built within the workflow builder**.

To support editing, we need a way to persist and restore the complete workflow state.

#### 1.5.2 The Manifest File: Portable Workflow Definition

Every exported MCP server includes a `mcp-builder.manifest.json` file that captures the complete workflow definition, enabling re-import and editing.

**Manifest Structure:**

```json
{
  "$schema": "https://apidash.dev/schemas/mcp-builder-manifest-v1.json",
  "version": "1.0.0",
  "exportedAt": "2026-03-06T10:30:00Z",
  "builderVersion": "1.0.0",
  
  "server": {
    "id": "uuid-here",
    "name": "weather-api",
    "description": "Weather data MCP server",
    "transport": "stdio",
    "createdAt": "2026-03-01T00:00:00Z",
    "updatedAt": "2026-03-06T10:30:00Z"
  },
  
  "tools": [
    {
      "id": "tool-uuid",
      "name": "get_forecast",
      "description": "Get weather forecast for a city",
      "workflow": {
        "nodes": [
          {
            "id": "input_1",
            "type": "input",
            "position": { "x": 100, "y": 100 },
            "data": {
              "parameters": [
                { "name": "city", "type": "string", "required": true }
              ]
            }
          },
          {
            "id": "http_1",
            "type": "http_request",
            "position": { "x": 300, "y": 100 },
            "data": {
              "method": "GET",
              "url": "https://api.weather.com/v1/forecast",
              "headers": {
                "Authorization": "Bearer {{env.WEATHER_API_KEY}}"
              },
              "queryParams": {
                "city": "{{input_1.city}}"
              }
            }
          }
        ],
        "edges": [
          { "id": "e1", "source": "input_1", "target": "http_1" }
        ]
      }
    }
  ],
  
  "resources": [...],
  "prompts": [...],
  
  "envVariables": [
    {
      "name": "WEATHER_API_KEY",
      "description": "API key for weather.com (used in tool: get_forecast)",
      "required": true
    }
  ]
}
```

**What's Included in the Manifest:**

| Section | Contents |
|---------|----------|
| `server` | Name, description, transport type, timestamps |
| `tools` | Tool definitions with complete workflow graphs (nodes + edges) |
| `resources` | URI templates, MIME types, response templates |
| `prompts` | Arguments, message templates |
| `envVariables` | **Declarations only** — names and descriptions, NOT values |

#### 1.5.3 Security: Handling API Keys & Secrets

Users often need API keys in HTTP request nodes. We must handle these securely:

**The Problem:**
- Manifests are portable and may be shared publicly
- API keys and secrets should never be stored in the manifest
- Workflows must still function when imported

**Solution: Environment Variable References**

Instead of storing actual values, workflows use **environment variable references**:

```
{{env.WEATHER_API_KEY}}
{{env.DATABASE_PASSWORD}}
{{env.AUTH_TOKEN}}
```

**Example HTTP Request Node:**
```json
{
  "id": "http_1",
  "type": "http_request",
  "data": {
    "method": "GET",
    "url": "https://api.weather.com/v1/forecast",
    "headers": {
      "Authorization": "Bearer {{env.WEATHER_API_KEY}}"
    }
  }
}
```

**In the Manifest (envVariables section):**
```json
{
  "envVariables": [
    {
      "name": "WEATHER_API_KEY",
      "description": "API key for weather.com",
      "required": true
    }
  ]
}
```

> ⚠️ **Important:** The actual value `sk-abc123...` is **never** stored in the manifest.

**Where Secrets Are Actually Stored:**

| Context | Storage Location | Security |
|---------|------------------|----------|
| **Local Development** | `.env` file (gitignored) | User's machine only |
| **Cloud Sync** | Encrypted in database | AES-256, per-user encryption |
| **Exported ZIP** | **NOT included** | User must configure on import |

**Automatic Secret Detection:**

The export service scans workflow nodes for hardcoded secrets and warns users:

```typescript
// If user accidentally hardcoded an API key
if (typeof data.apiKey === 'string' && !data.apiKey.startsWith('{{env.')) {
  warnings.push(`Found hardcoded value in node ${node.id}. Consider using {{env.API_KEY}} instead.`);
}
```

#### 1.5.4 Import Workflow

When importing a manifest, the system:

1. **Parses** the JSON manifest file
2. **Validates** version compatibility and workflow structure
3. **Detects** required environment variables
4. **Prompts** user to provide secret values
5. **Creates** the server in the builder

**Import Dialog with Environment Variable Prompts:**

```
┌─────────────────────────────────────────────────────────────┐
│  Import MCP Server                                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✓ Server: weather-api                                      │
│  ✓ Tools: 2    Resources: 1    Prompts: 0                  │
│                                                             │
│  ⚠️  This server requires 2 environment variables:          │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ WEATHER_API_KEY *                                    │   │
│  │ ┌─────────────────────────────────────────────────┐ │   │
│  │ │ sk-abc123...                                    │ │   │
│  │ └─────────────────────────────────────────────────┘ │   │
│  │ API key for weather.com                             │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ BACKUP_API_KEY (optional)                            │   │
│  │ ┌─────────────────────────────────────────────────┐ │   │
│  │ │                                                 │ │   │
│  │ └─────────────────────────────────────────────────┘ │   │
│  │ Fallback API key                                    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  [ ] Save secrets to secure local storage                   │
│                                                             │
│                              [Cancel]  [Import Server]      │
└─────────────────────────────────────────────────────────────┘
```

#### 1.5.5 Cloud Sync (Optional Enhancement)

For users who want multi-device access and automatic backup:

**User Authentication:**
- OAuth providers: GitHub, Google
- Benefits: Multi-device access, automatic backup, sharing

**Sync Flow:**
```
Local Change → Mark as "pending" → User clicks "Sync" → 
  → Check version (optimistic locking) →
    → If no conflict: Update cloud, increment version
    → If conflict: Show diff, let user resolve
```

**Conflict Resolution:**

| Scenario | Resolution |
|----------|------------|
| Same version, different changes | Show side-by-side diff, user picks |
| Local is newer | Push to cloud |
| Cloud is newer | Prompt to pull or force push |
| Offline edits | Queue changes, sync when online |

**Secure Vault for Cloud Secrets:**

For users who opt into cloud-synced secrets:

```
User Password/Key
       │
       ▼
┌──────────────────┐
│  Derive Key      │  (PBKDF2 with user-specific salt)
│  (per-user)      │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  AES-256-GCM     │  Encrypt secret value
│  Encryption      │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Store in DB     │  Only encrypted blob + IV stored
│  (SecureVault)   │
└──────────────────┘
```

- **Zero-knowledge:** Server never sees plaintext secrets
- **User-held key:** Derived from user's password
- **Decryption on client:** Only happens in user's browser

---

### 1.6 Code Export & Deployment

After building and testing, users can export their server as a deployable package.

#### Export Options

| Option | Output | Use Case |
|--------|--------|----------|
| **Download ZIP** | Complete project with source + package.json | Self-hosting, customization |
| **Download Docker** | Dockerfile + source | Container deployment |
| **Deploy to Vercel** | One-click deployment | Quick cloud hosting |
| **Deploy to Railway** | One-click deployment | Alternative cloud hosting |

#### What's in the Export ZIP

```
weather-mcp-server/
├── src/
│   └── index.ts              # Generated MCP server code
├── package.json              # Dependencies and scripts
├── tsconfig.json             # TypeScript configuration
├── .env.example              # Environment variable template (no values!)
├── Dockerfile                # (Optional) Container config
├── README.md                 # Setup and usage instructions
└── mcp-builder.manifest.json # ← For re-importing into the builder
```

> 💡 **Re-importing:** To edit a previously exported server, import the `mcp-builder.manifest.json` file back into the Create tab. This restores the full workflow with all nodes, edges, and configurations.

**Contents of .env.example:**
```bash
# Environment variables required by this MCP server
# Copy this file to .env and fill in your values

# API key for weather.com (used in tool: get_forecast)
WEATHER_API_KEY=

```

#### Running the Exported Server

```bash
# 1. Extract and install
unzip weather-mcp-server.zip
cd weather-mcp-server
npm install

# 2. Configure environment
cp .env.example .env
# Edit .env with your API keys

# 3. Build and run
npm run build
npm start

# Or use with Claude Desktop
# Add to claude_desktop_config.json:
{
  "mcpServers": {
    "weather": {
      "command": "node",
      "args": ["/path/to/weather-mcp-server/build/index.js"],
      "env": {
        "WEATHER_API_KEY": "your-key"
      }
    }
  }
}
```

---

## Part 2: Testing (Test Tab)

The Test tab provides a comprehensive environment for validating MCP servers. It extends the existing [MCP Inspector](https://github.com/modelcontextprotocol/inspector) with an enhanced UI and additional features.

### 2.1 Server Selection

Users can test servers from two sources:

| Mode | Description | Connection |
|------|-------------|------------|
| **Builder Preview** | Test servers created in Create tab | Local (in-memory) |
| **External Server** | Connect to any MCP server | STDIO or HTTP transport |

![Testing Server Selection](images/8.%20testing%20a%20server%20built%20within%20the%20workflow.png)

---

### 2.2 Testing Built-in Servers (Builder Preview)

**Connection Flow:**
1. Select server from dropdown (e.g., `weather`, `test`)
2. Connection shows as **"Local Builder Mode"**
3. Tools, resources, and prompts are automatically discovered

**Testing Interface:**

| Feature | Description |
|---------|-------------|
| **Form View** | User-friendly form with labeled input fields |
| **JSON View** | Raw JSON input for advanced users |
| **Run Tool** | Execute with provided parameters |
| **Execution Details** | Step-by-step breakdown with intermediate state |
| **History** | Track previous test runs with timing |

![Running a Tool Test](images/9.%20running%20the%20tool.png)

---

### 2.3 Testing External Servers

**Connection Flow:**
1. Switch to **External Server** mode
2. Select transport type (STDIO or HTTP)
3. Enter connection details:
   - STDIO: Command to run (e.g., `npx @modelcontextprotocol/server-weather`)
   - HTTP: Server URL (e.g., `http://localhost:3000/mcp`)
4. Click **Connect**
5. Discover and test available tools

![Testing External Server](images/10.%20testing%20an%20external%20server.png)

**Tool Metadata Display:**
The UI shows tool annotations to help users understand behavior:
- `Read-only` — Tool doesn't modify state
- `Idempotent` — Safe to retry
- `Destructive` — May delete data (shows warning)

---

### 2.4 Test Results & Debugging

Each test execution provides:

| Feature | Description |
|---------|-------------|
| **Status** | Success/Failure with response time (e.g., `Success 226ms`) |
| **Final Output** | Complete response data with syntax highlighting |
| **Execution Steps** | For builder preview servers, shows workflow step breakdown |
| **Error Details** | Error message, stack trace, and context |
| **Copy Button** | Copy output to clipboard |
| **History** | All previous test runs for comparison |

---

## Part 3: Technical Architecture

### 3.1 Tech Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Frontend** | React 18 + Vite | Fast development server, modern bundling |
| **UI Components** | shadcn/ui + Tailwind CSS | Consistent, accessible UI |
| **Workflow Canvas** | React Flow | Node-based visual editor |
| **State Management** | Zustand | Lightweight global state |
| **Code Editor** | Monaco Editor | JSON/code editing with syntax highlighting |
| **Backend** |  Express.js | Lightweight HTTP server, long-running request support |
| **Database** | PostgreSQL + Prisma | Persist servers, workflows, test history |
| **MCP SDK** | @modelcontextprotocol/sdk | MCP protocol implementation |
| **Code Generation** | TypeScript Compiler API | Validate generated code |
| **Export Packaging** | Archiver (npm) | Create ZIP files |
| **Sandbox Execution** | isolated-vm | Safe code execution for Code nodes |

### 3.2 Key Data Models

```typescript
// Server
interface MCPServer {
  id: string;
  name: string;
  transport: 'stdio' | 'http';
  tools: Tool[];
  resources: Resource[];
  prompts: Prompt[];
  createdAt: Date;
  updatedAt: Date;
}

// Tool with Workflow
interface Tool {
  id: string;
  name: string;
  description: string;
  workflow: Workflow;
}

// Workflow (node-based)
interface Workflow {
  nodes: WorkflowNode[];
  edges: WorkflowEdge[];
}

interface WorkflowNode {
  id: string;
  type: 'input' | 'http_request' | 'transform' | 'conditional' | 'code' | 'output';
  position: { x: number; y: number };
  data: Record<string, any>;  // Type-specific configuration
}

interface WorkflowEdge {
  id: string;
  source: string;  // Source node ID
  target: string;  // Target node ID
}
```

---

### 3.3 Node Type System: Executors & Templates

The core architecture that enables both preview execution and code export is the **Node Type Definition** system. Each node type is defined with both an executor (for runtime) and a code template (for export), ensuring they always produce identical behavior.


[![](https://mermaid.ink/img/pako:eNp9Ul2TmjAU_SuZ7CtrBUGR6eyMVdoy49co2k5LHyJcMLNAmBh2ta7_vYGI7tpt88CQ3HPOPfckRxyyCLCD45Q9h1vCBfI_BTmSa1duEk6KLRq5n72p53uz6c8ATyUc-YcC0AhimlNBWR7gX4pSrYhyCKvTi1C1Jq4_kOwJCBIRQT5u-IcHIVU0lJNMfml4I7McfnUnFWXI8pgmaBluIVO8lYdixjMUvW_A_e4OJc_dQ1gKxmvKoswFzQDFZR7-RfDdyXw88N26WTUdZEVKBNTM-iSBHDiRYm9468HYGynemqQ0Ik23s2XpOHyEKwfyKMhvsl0tB18qgdWOJPBGfb5w1577TdbmHJ4oPCM1kXSvUtjBDjVD3gQwny38Zhp3XzAurpRmuvdsVdGh-_uHprk6bfKpK0pcFdT3jK2qLwFeyutEC9iVqQjwC1q4y9W48jIrRVGKS1Ml8z_OJSpxSEE5i2maOnfEtqy4p4UsZdy5i-P4Ne7iVWE7G9uIu__Aqj5npGGElgWvkFjDCacRdgQvQcMZ8IxUW3ysNAIs5HuUITryNyL8McBBfpKcguQ_GMsaGmdlssVOTNKd3JWFfCQwokRe_hUiLwD4kMknih1TryWwc8R77Fh6y9Sttt62-rZh6R3d1PABO3rfbPXNntXpt7tdvWf3uicN_667tlu2Zdh9y-zY3Z6u64Z--gMtEjDF?type=png)](https://mermaid.live/edit#pako:eNp9Ul2TmjAU_SuZ7CtrBUGR6eyMVdoy49co2k5LHyJcMLNAmBh2ta7_vYGI7tpt88CQ3HPOPfckRxyyCLCD45Q9h1vCBfI_BTmSa1duEk6KLRq5n72p53uz6c8ATyUc-YcC0AhimlNBWR7gX4pSrYhyCKvTi1C1Jq4_kOwJCBIRQT5u-IcHIVU0lJNMfml4I7McfnUnFWXI8pgmaBluIVO8lYdixjMUvW_A_e4OJc_dQ1gKxmvKoswFzQDFZR7-RfDdyXw88N26WTUdZEVKBNTM-iSBHDiRYm9468HYGynemqQ0Ik23s2XpOHyEKwfyKMhvsl0tB18qgdWOJPBGfb5w1577TdbmHJ4oPCM1kXSvUtjBDjVD3gQwny38Zhp3XzAurpRmuvdsVdGh-_uHprk6bfKpK0pcFdT3jK2qLwFeyutEC9iVqQjwC1q4y9W48jIrRVGKS1Ml8z_OJSpxSEE5i2maOnfEtqy4p4UsZdy5i-P4Ne7iVWE7G9uIu__Aqj5npGGElgWvkFjDCacRdgQvQcMZ8IxUW3ysNAIs5HuUITryNyL8McBBfpKcguQ_GMsaGmdlssVOTNKd3JWFfCQwokRe_hUiLwD4kMknih1TryWwc8R77Fh6y9Sttt62-rZh6R3d1PABO3rfbPXNntXpt7tdvWf3uicN_667tlu2Zdh9y-zY3Z6u64Z--gMtEjDF)

#### 3.3.1 Node Type Definition Interface

```typescript
interface NodeTypeDefinition {
  // Metadata
  type: string;           // e.g., 'http_request'
  name: string;           // e.g., 'HTTP Request'
  icon: string;           // e.g., 'Globe'
  category: 'input' | 'action' | 'transform' | 'output' | 'control';
  
  // UI Configuration
  configSchema: JSONSchema;  // Defines the configuration form
  
  // Runtime Executor (runs during preview)
  executor: (config: NodeConfig, context: ExecutionContext) => Promise<any>;
  
  // Code Template (generates TypeScript for export)
  codeTemplate: (node: WorkflowNode, ctx: GeneratorContext) => GeneratedCode;
  
  // Validation
  validate: (config: NodeConfig) => ValidationResult;
}

interface GeneratedCode {
  code: string;           // The TypeScript code lines
  imports: string[];      // Required imports
  helpers: string[];      // Helper functions needed
}
```

#### 3.3.2 Example: HTTP Request Node Definition

```typescript
const httpRequestNode: NodeTypeDefinition = {
  type: 'http_request',
  name: 'HTTP Request',
  icon: 'Globe',
  category: 'action',
  
  configSchema: {
    type: 'object',
    properties: {
      method: { type: 'string', enum: ['GET', 'POST', 'PUT', 'DELETE'] },
      url: { type: 'string' },
      queryParams: { type: 'object' },
      headers: { type: 'object' },
      body: { type: 'object' },
    },
    required: ['method', 'url'],
  },
  
  // EXECUTOR: Runs at preview time
  executor: async (config, context) => {
    const url = new URL(interpolateVariables(config.url, context));
    
    // Add query parameters
    if (config.queryParams) {
      for (const [key, value] of Object.entries(config.queryParams)) {
        const resolved = interpolateVariables(value as string, context);
        url.searchParams.append(key, String(resolved));
      }
    }
    
    // Make the request
    const response = await fetch(url.toString(), {
      method: config.method,
      headers: config.headers || {},
      body: config.body ? JSON.stringify(config.body) : undefined,
    });
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }
    
    return response.json();
  },
  
  // CODE TEMPLATE: Generates equivalent TypeScript
  codeTemplate: (node, ctx) => {
    const config = node.data;
    const nodeId = node.id;
    
    // Generate query params code
    const queryParamsCode = config.queryParams
      ? Object.entries(config.queryParams)
          .map(([key, value]) => 
            `url_${nodeId}.searchParams.append("${key}", String(${generateVariableAccess(value as string)}));`
          )
          .join('\n    ')
      : '';
    
    const code = `
    // HTTP Request: ${nodeId}
    const url_${nodeId} = new URL("${config.url}");
    ${queryParamsCode}
    
    const response_${nodeId} = await fetch(url_${nodeId}.toString(), {
      method: "${config.method}",
      headers: ${JSON.stringify(config.headers || {})},
      ${config.body ? `body: JSON.stringify(${JSON.stringify(config.body)}),` : ''}
    });
    
    if (!response_${nodeId}.ok) {
      throw new Error(\`HTTP \${response_${nodeId}.status}\`);
    }
    
    context["${nodeId}"] = await response_${nodeId}.json();`;
    
    return { code, imports: [], helpers: [] };
  },
  
  validate: (config) => {
    const errors: string[] = [];
    if (!config.url) errors.push('URL is required');
    if (!config.method) errors.push('Method is required');
    return { valid: errors.length === 0, errors };
  },
};
```

#### 3.3.3 Node Type Registry

All node types are registered in a central registry:

```typescript
const NODE_TYPE_REGISTRY: Map<string, NodeTypeDefinition> = new Map([
  ['input', inputNode],
  ['http_request', httpRequestNode],
  ['transform', transformNode],
  ['conditional', conditionalNode],
  ['code', codeNode],
  ['output', outputNode],
]);

// Adding a new node type is simple:
NODE_TYPE_REGISTRY.set('loop', loopNode);
NODE_TYPE_REGISTRY.set('database', databaseNode);
```


[![](https://mermaid.ink/img/pako:eNptUu9r2zAQ_VeECmMDJ0T-FccfCiOLx2DLBy_5sNWjKNY5MbUlT5ZY0zT_-05pGuJSfTjQe-9O9053oKUSQFNaNepfuePakO95IQme3m62mnc7ki--fvu5yn_dFXSJYrLad0By2Na90fuC_nmRu5PffXzFyQ_efTpTIEUh3xSdr_N8sVxhzbnVGqQhl9r9oOaSoaaWnTVD2Ed4Z0x3r-Gvhf4NGyBrNJd9pXQ7pEKkSiVFbWoleTMkoxMpYIjGiCprrnt4z1O2Xq3zBWoza6wGsng0IHt8Zegoc44apboh6gx1XPOmgWFTmTMjuOEb3g8by5wXXt-XmPReZ0tGPuCkXAhcCF2IXIjJaHRLzj-dOVnmZJmTZSEZjUe3zwX9LAThPZEAAkRBn13C2bPZN3DZDFLVTZPe8CSKqqlXqkbp9Kaqqmvty3DOymCT-FV8pfRwZ9QDjATvcQk136ckIhH16FbXgqZGW_BoC7rl7koPrjL-8A5anEhK3Hz0Q0ELecScjsvfSrWvaVrZ7Y6mFW96vNkORwlfao5_1l5Q3EABeq6sNDRlM3YqQtMDfcTrNByHLJpMwmk08_1Z7NE9TQN_PEPAn7BgmvgJ848efTq9OhknkZ_MojBI4iljzGfH_4bH_9s?type=png)](https://mermaid.live/edit#pako:eNptUu9r2zAQ_VeECmMDJ0T-FccfCiOLx2DLBy_5sNWjKNY5MbUlT5ZY0zT_-05pGuJSfTjQe-9O9053oKUSQFNaNepfuePakO95IQme3m62mnc7ki--fvu5yn_dFXSJYrLad0By2Na90fuC_nmRu5PffXzFyQ_efTpTIEUh3xSdr_N8sVxhzbnVGqQhl9r9oOaSoaaWnTVD2Ed4Z0x3r-Gvhf4NGyBrNJd9pXQ7pEKkSiVFbWoleTMkoxMpYIjGiCprrnt4z1O2Xq3zBWoza6wGsng0IHt8Zegoc44apboh6gx1XPOmgWFTmTMjuOEb3g8by5wXXt-XmPReZ0tGPuCkXAhcCF2IXIjJaHRLzj-dOVnmZJmTZSEZjUe3zwX9LAThPZEAAkRBn13C2bPZN3DZDFLVTZPe8CSKqqlXqkbp9Kaqqmvty3DOymCT-FV8pfRwZ9QDjATvcQk136ckIhH16FbXgqZGW_BoC7rl7koPrjL-8A5anEhK3Hz0Q0ELecScjsvfSrWvaVrZ7Y6mFW96vNkORwlfao5_1l5Q3EABeq6sNDRlM3YqQtMDfcTrNByHLJpMwmk08_1Z7NE9TQN_PEPAn7BgmvgJ848efTq9OhknkZ_MojBI4iljzGfH_4bH_9s)
---

### 3.4 Code Generation Pipeline

The code generator transforms a workflow definition into a complete, runnable MCP server.

[![](https://mermaid.ink/img/pako:eNp9U-9v2jAQ_VcsV5o2iaYkkALRVIkFilg3iBpKp459MMkFPBI7ckx_Uf73nZOyNt3UfLBy9r13797ZOxrJGKhHk1TeRWumNJl9WQiCX7FdrhTL12Q8Ca5mPxd0LPKtXtBf1bH5rnH3WqqNAZOv4XTyealOznYCKYsGgXgFxb4GCBEQgroFRXwpEr56BrAMGkQrJopcKv2CAREvxBs5wTgYfhtPhkjlYyEyAgGKaS4FCXgOKRdQqznHRNsic5bymGkgB8FlaX8N0YawNCWl6BrQ9OxYZCZzmcoVj1hKQlRX4gagQWVYikgVg6rhRohrWQddQEINOTFSq4qmmDF9Blme4vnHTzV0H9Fti_SLArJliujSrgoqs6Upecf1miwlT0GVDHXVPhK4KPshhzBSPNekbPLAkCOM3FZmoGfvWj29mlWjn241zp6cI7bu0XjwA48LFZ1wEcO9pevHwYUxI2fRhq3A-l28qldqDY1YXUTlXfj3fDgxw7NA3Fpwz9CuequDqYFfDvuD70Mri9-_NX3_oj8yl-acC5xkUGmq8d2MA9NMabj1yPP_EV6TDyQkx8dnZF5tzMtgVgWzMhhVwagM-lXQr9L85zzfhE8LGrACHXsyPiIx2oUruoIr9o4rtvgGcc54ahDDy0vzmNb48oZKSfVi_DtcpQhs8689-gFvA26QhKepd-Q4ketCI8ILr7yjJElep2HF5zRI2vi9SqMNulI8pp5WW2jQDN8GMyHdGQIc8Roy9NrD35ipzYIuxB4xORM3UmYHmJLb1Zp6CUsLjLa5ea4DznCA2d9dhbMA5cut0NSze25JQr0dvcew07batttstjtuz3F6pw36QL2WY_Vww2narU7X6drOvkEfy6pNq-s63Z7bbnVPO7ZtO87-DyeRg3s?type=png)](https://mermaid.live/edit#pako:eNp9U-9v2jAQ_VcsV5o2iaYkkALRVIkFilg3iBpKp459MMkFPBI7ckx_Uf73nZOyNt3UfLBy9r13797ZOxrJGKhHk1TeRWumNJl9WQiCX7FdrhTL12Q8Ca5mPxd0LPKtXtBf1bH5rnH3WqqNAZOv4XTyealOznYCKYsGgXgFxb4GCBEQgroFRXwpEr56BrAMGkQrJopcKv2CAREvxBs5wTgYfhtPhkjlYyEyAgGKaS4FCXgOKRdQqznHRNsic5bymGkgB8FlaX8N0YawNCWl6BrQ9OxYZCZzmcoVj1hKQlRX4gagQWVYikgVg6rhRohrWQddQEINOTFSq4qmmDF9Blme4vnHTzV0H9Fti_SLArJliujSrgoqs6Upecf1miwlT0GVDHXVPhK4KPshhzBSPNekbPLAkCOM3FZmoGfvWj29mlWjn241zp6cI7bu0XjwA48LFZ1wEcO9pevHwYUxI2fRhq3A-l28qldqDY1YXUTlXfj3fDgxw7NA3Fpwz9CuequDqYFfDvuD70Mri9-_NX3_oj8yl-acC5xkUGmq8d2MA9NMabj1yPP_EV6TDyQkx8dnZF5tzMtgVgWzMhhVwagM-lXQr9L85zzfhE8LGrACHXsyPiIx2oUruoIr9o4rtvgGcc54ahDDy0vzmNb48oZKSfVi_DtcpQhs8689-gFvA26QhKepd-Q4ketCI8ILr7yjJElep2HF5zRI2vi9SqMNulI8pp5WW2jQDN8GMyHdGQIc8Roy9NrD35ipzYIuxB4xORM3UmYHmJLb1Zp6CUsLjLa5ea4DznCA2d9dhbMA5cut0NSze25JQr0dvcew07batttstjtuz3F6pw36QL2WY_Vww2narU7X6drOvkEfy6pNq-s63Z7bbnVPO7ZtO87-DyeRg3s)

#### 3.4.1 Code Generator Implementation

```typescript
class MCPCodeGenerator {
  private registry: Map<string, NodeTypeDefinition>;
  
  constructor(registry: Map<string, NodeTypeDefinition>) {
    this.registry = registry;
  }
  
  /**
   * Generate complete MCP server from workflow
   */
  generate(server: MCPServer): GeneratedServer {
    const files: GeneratedFile[] = [];
    
    // Generate main server file
    const serverCode = this.generateServerCode(server);
    files.push({ path: 'src/index.ts', content: serverCode });
    
    // Generate package.json
    files.push({ path: 'package.json', content: this.generatePackageJson(server) });
    
    // Generate tsconfig.json
    files.push({ path: 'tsconfig.json', content: this.generateTsConfig() });
    
    // Generate .env.example
    const envVars = this.extractEnvVariables(server);
    files.push({ path: '.env.example', content: this.generateEnvExample(envVars) });
    
    // Generate README
    files.push({ path: 'README.md', content: this.generateReadme(server) });
    
    // Generate Dockerfile (optional)
    files.push({ path: 'Dockerfile', content: this.generateDockerfile() });
    
    return { files, valid: true };
  }
  
  /**
   * Generate the main TypeScript server file
   */
  private generateServerCode(server: MCPServer): string {
    const toolExecutors: string[] = [];
    const toolDefinitions: string[] = [];
    const allHelpers: Set<string> = new Set();
    
    // Generate code for each tool
    for (const tool of server.tools) {
      const { executorCode, definition, helpers } = this.generateToolCode(tool);
      toolExecutors.push(executorCode);
      toolDefinitions.push(definition);
      helpers.forEach(h => allHelpers.add(h));
    }
    
    return `#!/usr/bin/env node
/**
 * ${server.name} MCP Server
 * Auto-generated by MCP Builder
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================
${this.generateHelpers(allHelpers)}

// ============================================================================
// TOOL DEFINITIONS
// ============================================================================
const TOOLS = [
${toolDefinitions.join(',\n')}
];

// ============================================================================
// TOOL EXECUTORS
// ============================================================================
${toolExecutors.join('\n\n')}

// ============================================================================
// SERVER SETUP
// ============================================================================
const server = new Server(
  { name: "${server.name}", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools: TOOLS }));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  
  try {
    let result;
    switch (name) {
${server.tools.map(t => `      case "${t.name}": result = await execute_${t.name}(args); break;`).join('\n')}
      default: throw new Error(\`Unknown tool: \${name}\`);
    }
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  } catch (error) {
    return {
      content: [{ type: "text", text: \`Error: \${error.message}\` }],
      isError: true,
    };
  }
});

const transport = new StdioServerTransport();
server.connect(transport);
`;
  }
  
  /**
   * Generate code for a single tool
   */
  private generateToolCode(tool: Tool): { 
    executorCode: string; 
    definition: string; 
    helpers: string[];
  } {
    const workflow = tool.workflow;
    const helpers: string[] = [];
    
    // Sort nodes topologically
    const orderedNodes = this.topologicalSort(workflow.nodes, workflow.edges);
    
    // Generate code for each node
    const stepCodes: string[] = [];
    for (const node of orderedNodes) {
      const nodeType = this.registry.get(node.type);
      if (!nodeType) throw new Error(`Unknown node type: ${node.type}`);
      
      const generated = nodeType.codeTemplate(node, {});
      stepCodes.push(generated.code);
      helpers.push(...generated.helpers);
    }
    
    // Find input node for schema
    const inputNode = workflow.nodes.find(n => n.type === 'input');
    const inputSchema = this.generateInputSchema(inputNode!);
    
    const executorCode = `
async function execute_${tool.name}(args: any): Promise<any> {
  const context: Record<string, any> = { env: process.env };
  
${stepCodes.join('\n')}
}`;

    const definition = `  {
    name: "${tool.name}",
    description: "${tool.description}",
    inputSchema: ${JSON.stringify(inputSchema, null, 4).split('\n').map((l, i) => i === 0 ? l : '    ' + l).join('\n')},
  }`;
    
    return { executorCode, definition, helpers };
  }
  
  /**
   * Topological sort for execution order
   */
  private topologicalSort(nodes: WorkflowNode[], edges: WorkflowEdge[]): WorkflowNode[] {
    const nodeMap = new Map(nodes.map(n => [n.id, n]));
    const inDegree = new Map<string, number>();
    const adjacency = new Map<string, string[]>();
    
    // Initialize
    for (const node of nodes) {
      inDegree.set(node.id, 0);
      adjacency.set(node.id, []);
    }
    
    // Build graph
    for (const edge of edges) {
      inDegree.set(edge.target, (inDegree.get(edge.target) || 0) + 1);
      adjacency.get(edge.source)!.push(edge.target);
    }
    
    // Kahn's algorithm
    const queue: string[] = [];
    for (const [nodeId, degree] of inDegree) {
      if (degree === 0) queue.push(nodeId);
    }
    
    const result: WorkflowNode[] = [];
    while (queue.length > 0) {
      const nodeId = queue.shift()!;
      result.push(nodeMap.get(nodeId)!);
      
      for (const child of adjacency.get(nodeId) || []) {
        inDegree.set(child, inDegree.get(child)! - 1);
        if (inDegree.get(child) === 0) {
          queue.push(child);
        }
      }
    }
    
    if (result.length !== nodes.length) {
      throw new Error('Cycle detected in workflow');
    }
    
    return result;
  }
  
  /**
   * Generate input schema from Input node
   */
  private generateInputSchema(inputNode: WorkflowNode): object {
    const params = inputNode.data.parameters || [];
    const properties: Record<string, any> = {};
    const required: string[] = [];
    
    for (const param of params) {
      properties[param.name] = {
        type: param.type || 'string',
        description: param.description || '',
      };
      if (param.required) required.push(param.name);
    }
    
    return { type: 'object', properties, required };
  }
  
  /**
   * Generate helper functions
   */
  private generateHelpers(needed: Set<string>): string {
    const helpers: Record<string, string> = {
      interpolateVariables: `
function interpolateVariables(value: any, context: Record<string, any>): any {
  if (typeof value !== "string") return value;
  const pattern = /\\{\\{([^}]+)\\}\\}/g;
  return value.replace(pattern, (_, path) => {
    const parts = path.trim().split(".");
    let current: any = context;
    for (const part of parts) {
      if (current == null) return "";
      current = current[part];
    }
    return String(current ?? "");
  });
}`,
    };
    
    return Array.from(needed)
      .filter(h => helpers[h])
      .map(h => helpers[h])
      .join('\n');
  }
  
  // ... additional methods for package.json, Dockerfile, etc.
}
```

#### 3.4.2 Variable Interpolation Compilation

The `{{variable}}` syntax used in the visual builder is compiled to TypeScript code:

| User Input | Generated Code |
|------------|----------------|
| `{{input_1.city}}` | `context["input_1"]?.city` |
| `{{env.API_KEY}}` | `process.env.API_KEY` |
| `https://api.com?q={{input_1.query}}` | `` `https://api.com?q=${context["input_1"]?.query}` `` |

```typescript
/**
 * Convert {{variable}} syntax to TypeScript code
 */
function generateVariableAccess(value: string): string {
  if (typeof value !== 'string') return JSON.stringify(value);
  
  const pattern = /\{\{([^}]+)\}\}/g;
  const fullMatch = value.match(/^\{\{([^}]+)\}\}$/);
  
  // If entire string is one variable, return direct access
  if (fullMatch) {
    return pathToCode(fullMatch[1].trim());
  }
  
  // Otherwise, build template literal
  return '`' + value.replace(pattern, (_, path) => {
    return '${' + pathToCode(path.trim()) + '}';
  }) + '`';
}

function pathToCode(path: string): string {
  const parts = path.split('.');
  
  // Handle environment variables
  if (parts[0] === 'env') {
    return `process.env.${parts.slice(1).join('.')}`;
  }
  
  // Handle context access: context["nodeId"]?.field?.subfield
  return `context["${parts[0]}"]${parts.slice(1).map(p => `?.${p}`).join('')}`;
}
```

---

### 3.5 Export Packaging System

The export system creates a complete, ready-to-run ZIP package.

```typescript
import Archiver from 'archiver';
import { Writable } from 'stream';

class ExportPackager {
  /**
   * Create a ZIP file from generated server
   */
  async createZip(server: MCPServer): Promise<Buffer> {
    const generator = new MCPCodeGenerator(NODE_TYPE_REGISTRY);
    const generated = generator.generate(server);
    
    // Validate generated code compiles
    const compileResult = await this.validateTypeScript(generated.files);
    if (!compileResult.valid) {
      throw new Error(`Generated code has errors:\n${compileResult.errors.join('\n')}`);
    }
    
    // Create ZIP
    return new Promise((resolve, reject) => {
      const chunks: Buffer[] = [];
      const archive = Archiver('zip', { zlib: { level: 9 } });
      
      archive.on('data', chunk => chunks.push(chunk));
      archive.on('end', () => resolve(Buffer.concat(chunks)));
      archive.on('error', reject);
      
      // Add each generated file
      for (const file of generated.files) {
        archive.append(file.content, { name: `${server.name}/${file.path}` });
      }
      
      archive.finalize();
    });
  }
  
  /**
   * Validate TypeScript compiles without errors
   */
  private async validateTypeScript(files: GeneratedFile[]): Promise<{ valid: boolean; errors: string[] }> {
    const ts = await import('typescript');
    
    const tsFile = files.find(f => f.path.endsWith('.ts'));
    if (!tsFile) return { valid: true, errors: [] };
    
    const result = ts.transpileModule(tsFile.content, {
      compilerOptions: {
        module: ts.ModuleKind.NodeNext,
        target: ts.ScriptTarget.ES2022,
        strict: true,
      },
      reportDiagnostics: true,
    });
    
    const errors = result.diagnostics?.map(d => 
      typeof d.messageText === 'string' ? d.messageText : d.messageText.messageText
    ) || [];
    
    return { valid: errors.length === 0, errors };
  }
}
```

---

### 3.6 Deployment Integration

For one-click deployment, the system integrates with cloud platforms.

[![](https://mermaid.ink/img/pako:eNp9kd2OmzAQhV_F8t6yET8mAS4qRYRWUSMlooVtt1SVF0yga2xkoNk0yrvX4CQKUbPcGHu-OXNm5gBTnhHowZzyXVpg0YJVmDAgv6Z72QpcFyD4tlmHX38kMHiruQTWdVty1iTwpwL773m5kcCC7xjlOOuvo3AchH6w6glSU74HLQcxESmhIyqcL1dP8-8jLMQl3eH9iFus_c9BONRLX4kAywpvyYUgLEvYTQuq_q-Pq_WTTFOlgSpSEdaOvRoS-UQYEbglwJfjGYdNGfYF6YMnoY3gv0l6o2JJbNM1BfhTYjDfLMdRdGnyXd_RlyA8u44a2ep5wiO16H3H0ZXj28VE1tXaxhF0rik61gDKU0zpf91KTfD4-EHaUIepDksdSEFqA8NTrLhYcbHiYnRpvt3TwSjIS0q9B-vFMfOplnLKhfeQ5_k1dpJVpK7rd7AInRDTTG2b3BO7S0ENbkWZQa8VHdFgRUSF-ys89PkJbAtSyaF78jfD4jWBCTvKnBqzZ86rc5rg3baAXo5pI29dncmNLEosV11dXoUcLBE-71gLPTTVBxHoHeAb9Bx9ggzkOq7tIMN1dVuDe-i5-sRFM9uwpro7M2eWc9Tg36GqPnFsU9LIcqYzwzBM4_gPTfkoSQ?type=png)](https://mermaid.live/edit#pako:eNp9kd2OmzAQhV_F8t6yET8mAS4qRYRWUSMlooVtt1SVF0yga2xkoNk0yrvX4CQKUbPcGHu-OXNm5gBTnhHowZzyXVpg0YJVmDAgv6Z72QpcFyD4tlmHX38kMHiruQTWdVty1iTwpwL773m5kcCC7xjlOOuvo3AchH6w6glSU74HLQcxESmhIyqcL1dP8-8jLMQl3eH9iFus_c9BONRLX4kAywpvyYUgLEvYTQuq_q-Pq_WTTFOlgSpSEdaOvRoS-UQYEbglwJfjGYdNGfYF6YMnoY3gv0l6o2JJbNM1BfhTYjDfLMdRdGnyXd_RlyA8u44a2ep5wiO16H3H0ZXj28VE1tXaxhF0rik61gDKU0zpf91KTfD4-EHaUIepDksdSEFqA8NTrLhYcbHiYnRpvt3TwSjIS0q9B-vFMfOplnLKhfeQ5_k1dpJVpK7rd7AInRDTTG2b3BO7S0ENbkWZQa8VHdFgRUSF-ys89PkJbAtSyaF78jfD4jWBCTvKnBqzZ86rc5rg3baAXo5pI29dncmNLEosV11dXoUcLBE-71gLPTTVBxHoHeAb9Bx9ggzkOq7tIMN1dVuDe-i5-sRFM9uwpro7M2eWc9Tg36GqPnFsU9LIcqYzwzBM4_gPTfkoSQ)

```typescript
class DeploymentService {
  /**
   * Deploy to Vercel
   */
  async deployToVercel(server: MCPServer, token: string): Promise<string> {
    const generator = new MCPCodeGenerator(NODE_TYPE_REGISTRY);
    const generated = generator.generate(server);
    
    // Create Vercel deployment
    const response = await fetch('https://api.vercel.com/v13/deployments', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        name: server.name,
        files: generated.files.map(f => ({
          file: f.path,
          data: Buffer.from(f.content).toString('base64'),
          encoding: 'base64',
        })),
        projectSettings: {
          framework: null,  // Node.js
        },
      }),
    });
    
    const deployment = await response.json();
    return deployment.url;
  }
}
```

---

### 3.7 MCP Inspector Integration

The Test tab extends the existing MCP Inspector:

- **Reused:** Protocol handling, transport layer, tool discovery
- **Extended:** Enhanced UI, history tracking, AI chat with API Key (so users can test without having to setup their mcp servers on tools like claude to test)
- **Added:** Builder Preview mode for in-memory server testing

[![](https://mermaid.ink/img/pako:eNqVk1-TmjAUxb9KJvuyO2MdFkSBN1eYMdOqjGDbaelDhKCZAnGS4C7r-N17Yd0_VvvQPCWZ37k593A54FRkDHs4L8RjuqVSo_ghqRAsVa83ku62iMyjMJjEi-XPBM8mISKV2rFUC4lugyfNqoxldwn-9aI6Uy6DVRT4IFuyWrEM5VKU7_IzTbvC5SJeAB1KoUUqCjSlVVawSzBejucRgLGkUEyA6S-0ucL5JJq0mIBaPlep2DPZnFHg_v1wpYPgexzM_a6HRS1R16_iolIXb60IMEG1pVUKna7IBTBugTFBkLJGt5CHQuOQoM-subtgpySKW-NMaTTlCsL6P9tj_8XznD2iCd3RNS-45kxdiTz4SoJvgD7UvMiYRKFkew6yGczFBU7ms2AGMKk-zVgJrlDE5P6v5N_MdZvTMOmmYKd5QDkvCu9muB6ZjtGD7yykd5Pn-UfyNfcTa60dMx_-g-2aPYGmmdo2-wDiHt5InmFPy5r1cMlkSdsjPrQlEqy3rIQ-PdhmVP5OcFIdQbOj1Q8hyleZFPVmi72cFgpO9S6jmvmcQtjl261s_wQ5EXWlsWe7XQ3sHfAT9lyn71qu4xruvW3cD0yzhxu4HfVt0x5aI9uyh4ZjOMcefu4eNfqOCeFYhjOwXNMejIbHP0iuEPk?type=png)](https://mermaid.live/edit#pako:eNqVk1-TmjAUxb9KJvuyO2MdFkSBN1eYMdOqjGDbaelDhKCZAnGS4C7r-N17Yd0_VvvQPCWZ37k593A54FRkDHs4L8RjuqVSo_ghqRAsVa83ku62iMyjMJjEi-XPBM8mISKV2rFUC4lugyfNqoxldwn-9aI6Uy6DVRT4IFuyWrEM5VKU7_IzTbvC5SJeAB1KoUUqCjSlVVawSzBejucRgLGkUEyA6S-0ucL5JJq0mIBaPlep2DPZnFHg_v1wpYPgexzM_a6HRS1R16_iolIXb60IMEG1pVUKna7IBTBugTFBkLJGt5CHQuOQoM-subtgpySKW-NMaTTlCsL6P9tj_8XznD2iCd3RNS-45kxdiTz4SoJvgD7UvMiYRKFkew6yGczFBU7ms2AGMKk-zVgJrlDE5P6v5N_MdZvTMOmmYKd5QDkvCu9muB6ZjtGD7yykd5Pn-UfyNfcTa60dMx_-g-2aPYGmmdo2-wDiHt5InmFPy5r1cMlkSdsjPrQlEqy3rIQ-PdhmVP5OcFIdQbOj1Q8hyleZFPVmi72cFgpO9S6jmvmcQtjl261s_wQ5EXWlsWe7XQ3sHfAT9lyn71qu4xruvW3cD0yzhxu4HfVt0x5aI9uyh4ZjOMcefu4eNfqOCeFYhjOwXNMejIbHP0iuEPk)

---

## Part 4: Security & Error Handling

### 4.1 Security Considerations

| Concern | Approach |
|---------|----------|
| **API Keys** | Stored as environment variables, never in workflow JSON |
| **Code Execution** | Code node runs in sandboxed VM (vm2 or isolated-vm) |
| **External Requests** | HTTPS enforced, timeout limits applied |
| **Generated Code** | Keys referenced via `process.env`, not hardcoded |
| **Export** | `.env.example` provided, actual keys never included |

### 4.2 Error Handling Strategy

| Error Type | Example | Handling |
|------------|---------|----------|
| Validation Error | Missing required field | Inline error, prevent save |
| HTTP Error | API returns 404 | Show in execution panel with full response |
| Runtime Error | JSONPath returns undefined | Warning + continue (graceful degradation) |
| Cycle Detection | A → B → A | Block save, show visualization |
| Type Error | String where number expected | TypeScript compilation catches this |

---

## Part 5: Extensibility

### 5.1 Adding New Node Types

The system is designed to grow. Adding a new node type follows this pattern:

```typescript
// 1. Define the node type
const databaseNode: NodeTypeDefinition = {
  type: 'database',
  name: 'Database Query',
  icon: 'Database',
  category: 'action',
  
  configSchema: {
    type: 'object',
    properties: {
      connectionString: { type: 'string' },
      query: { type: 'string' },
    },
    required: ['connectionString', 'query'],
  },
  
  executor: async (config, context) => {
    // Runtime execution logic
  },
  
  codeTemplate: (node, ctx) => {
    // Generate equivalent TypeScript
    return { code: '...', imports: ['pg'], helpers: [] };
  },
  
  validate: (config) => {
    // Validation logic
    return { valid: true, errors: [] };
  },
};

// 2. Register it
NODE_TYPE_REGISTRY.set('database', databaseNode);

// 3. Add UI component for the config panel
// (React component that renders based on configSchema)
```

### 5.2 Plugin Architecture (Future)

The node type system is designed to support third-party plugins:

```typescript
interface NodeTypePlugin {
  id: string;
  name: string;
  version: string;
  nodeTypes: NodeTypeDefinition[];
  
  // Optional: custom UI components
  components?: Record<string, React.ComponentType>;
  
  // Optional: additional helpers for generated code
  helpers?: Record<string, string>;
}
```

