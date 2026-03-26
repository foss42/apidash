# User Guide

## Comprehensive Guide to API Dash

### 1. **How API Dash Works (Overview)**

API Dash is a cross-platform, AI-powered desktop and mobile API client built with Flutter. It runs locally on your device and stores data using Hive database (no cloud dependency). The core workflow is:
- Create requests via an intuitive UI
- Configure URL, method, headers, parameters, body, and authentication
- Send the request and inspect the response
- Export code or share/import collections

**Data Flow:**
- User Input → Request Configuration → Local Storage (Hive) → Network Request → Response Handling → Display/Export

---

### 2. **Where to See Logs**

The **Logs Tab** provides a terminal-style interface to view all important events:

**Location:** Available as a tab in the main request interface

**What it displays:**
- JavaScript console output from pre/post scripts (`ad.console.log()`, `ad.console.warn()`, `ad.console.error()`)
- System messages from the JavaScript runtime
- Stack traces for fatal errors from scripts
- Other application events in chronological order

**Features:**
- Search by text to find specific log entries
- Filter by severity level (info, warning, error)
- Color-coded for easy severity identification
- Accessible through the request editor interface

**Example log entries from scripts:**
```javascript
ad.console.log("Starting pre-request script...");
ad.console.warn("API Key environment variable is missing!");
ad.console.error("Request failed with error:", error);
```

---

### 3. **Where to Add Variables (Environment Variables)**

The **Environment Variables Manager** supports two scopes:

**Access:** Settings/Environment Variables section

**Global Variables:**
- Available regardless of active environment
- Use for shared values across all environments

**Environment Variables:**
- Specific to an environment (e.g., Development, Production, Staging)
- Override global variables when that environment is active
- Activate via dropdown in the request editor

**Scope Hierarchy:** Environment Scope > Global Scope (if both have same variable name)

**Supported Fields for Variables:**
- URL field
- Params (key & value)
- Headers (key & value)
- Authentication fields
- Request body (when supported)
- Pre/Post-request scripts

**How to use:**
- Type `{{VARIABLE_NAME}}` or `{VARIABLE_NAME}` in any supported field
- API Dash provides auto-suggestions as you type
- Blue highlighting = variable found and will be substituted
- Red highlighting = variable not found (will substitute as empty string)

**Example:**
```
Global: API_URL = https://api.example.com
Development Environment: API_URL = https://dev.example.com
Production Environment: API_URL = https://prod.example.com
```

---

### 4. **How to Add New Requests**

**Creating a Request:**

1. Click the **"+"** button at the top of the collection pane (left sidebar)
2. A new request opens in the editor
3. Configure the request:
   - **HTTP Method:** Select GET, HEAD, POST, PUT, PATCH, DELETE, or OPTIONS
   - **URL:** Enter endpoint URL (defaults to https:// if scheme omitted)
   - **Request Type:** Choose HTTP, GraphQL, or AI
   - Continue to configure other tabs as needed

**Organizing Requests:**
- **Naming:** Right-click (desktop) or long-press (mobile) → Rename
- **Reordering:** Drag-and-drop requests to reorder
- **Duplicating:** Right-click → Duplicate to copy all settings
- **Deleting:** Right-click → Delete
- **Searching:** Use search bar to filter by name or URL

---

### 5. **How to Set Up GraphQL API**

**Creating a GraphQL Request:**

1. Click the **"+"** button to create a new request
2. Select **GraphQL** from the request type switcher (next to HTTP method dropdown)
3. Enter the GraphQL endpoint URL

**Configuring GraphQL Requests:**

- **Query Tab:** Write your GraphQL query or mutation
  ```graphql
  query GetUsers {
    users {
      id
      name
      email
    }
  }
  ```

- **Variables Tab:** Add variables in JSON format
  ```json
  {
    "userId": "123",
    "limit": 10
  }
  ```

- **Headers Tab:** Add authentication headers and other custom headers

- **Pre/Post-Request Scripts:** Full JavaScript access via `ad.request.query.get()` and `ad.request.query.set()`
  ```javascript
  let gqlQuery = ad.request.query.get();
  ad.console.log("Current GraphQL query:", gqlQuery);
  ```

**GraphQL-specific API scripting:**
- `ad.request.query.get()`: Get current GraphQL query
- `ad.request.query.set(newQuery)`: Set GraphQL query

**Click Send** to execute the GraphQL request

---

### 6. **How the AI Option Works**

**AI Requests:**
1. Select **AI** from the request type switcher
2. Configure an AI provider and model in Settings
   - Support for local Ollama instances or cloud providers
3. Enter your prompt or message
4. Click Send to get AI response

**AI Provider Configuration:**
- Set API key and endpoint in Settings
- Choose your preferred model
- Network access required (except for local Ollama)

**Dashbot (In-app AI Assistant):**

Dashbot is an AI-powered assistant that helps you work with your requests without leaving the app:

**How to Open Dashbot:**
- Click the Dashbot FAB button (floating window)
- Toggle between floating panel and docked tab view

**Available Tasks:**
- **Explain Response:** AI analyzes last response for selected request
- **Debug Error:** Analyzes failing response and proposes minimal fixes
- **Generate Documentation:** Creates clean Markdown docs (downloadable)
- **Generate Tests:** Builds JavaScript tests for post-response scripts
- **Generate Code:** Produces runnable code in 30+ languages
- **Import cURL:** Paste cURL command → Dashbot parses and creates request
- **Import OpenAPI:** Upload, paste, or fetch OpenAPI spec → Import endpoints

**Smart Features:**
- Base URL extracted as environment variable automatically
- Diffs compare imported requests with current selection
- One-click actions (Apply to Selected or Create New)
- Request-scoped conversations (auto-switches context)

---

### 7. **How HTTP Works in API Dash**

**HTTP Request Components:**

1. **Method & URL**
   - Select HTTP method from dropdown
   - Enter full endpoint URL
   - Scheme defaults to `https://` if omitted

2. **Query Parameters** (Params Tab)
   - Click "Add Parameter"
   - Enter key-value pairs
   - Auto-appended to URL: `?key=value&key2=value2`
   - Toggle on/off without deleting

3. **Headers** (Headers Tab)
   - Click "Add Header"
   - Enter custom HTTP headers
   - Auto-suggestions for common headers (Content-Type, Authorization)
   - Toggle headers on/off

4. **Request Body** (Body Tab)
   - **JSON:** Syntax highlighted JSON with validation
   - **Text:** Plain text content
   - **Form URL-Encoded:** `application/x-www-form-urlencoded`
   - **Multipart Form Data:** File uploads, `multipart/form-data`
   - Content-Type header set automatically

5. **Authentication** (Authentication Tab)
   - Basic Auth
   - API Key
   - Bearer Token
   - JWT
   - Digest
   - OAuth 1.0
   - OAuth 2.0 (Authorization Code, Client Credentials, Resource Owner Password)

6. **Request Scripts**
   - **Pre-Request Script:** Runs JavaScript before sending (modify headers, params, body)
   - **Post-Response Script:** Runs JavaScript after receiving response (test, extract data, update env vars)

**Response Inspection:**
- Status Code (200 OK, 404 Not Found, etc.)
- Response Time (milliseconds)
- Response Size
- Response Headers
- Response Body in multiple modes:
  - **Preview:** Rendered view (formatted JSON, images, PDFs, video, audio, etc.)
  - **Code:** Syntax-highlighted raw response
  - **Raw:** Plain text output

---

### 8. **Which Functions Don't Work (Limitations)**

**Currently Not Supported (Planned/Open Issues):**

1. **WebSocket**
   - Status: Open issue [#15](https://github.com/foss42/apidash/issues/15)
   - Workaround: Use HTTP client for REST alternatives

2. **gRPC**
   - Status: Open issue [#14](https://github.com/foss42/apidash/issues/14)
   - Note: Requires binary protocol handling

3. **MQTT**
   - Status: Open issue [#115](https://github.com/foss42/apidash/issues/115)
   - Alternative: Use dedicated MQTT clients

4. **hurl Import Format**
   - Status: Open issue [#123](https://github.com/foss42/apidash/issues/123)
   - Workaround: Convert hurl to cURL first

**OAuth Limitations:**
- OAuth flows work best with standard providers
- Some legacy servers returning non-JSON token responses may have issues (documented at [oauth_authentication_limitations.md](doc/dev_guide/oauth_authentication_limitations.md))
- Desktop OAuth requires free port 8080-8090 for callback server
- Mobile uses in-app OAuth flow

**Scripting Limitations:**
- JavaScript sandbox for pre/post scripts (not arbitrary code execution)
- Some edge cases with very large scripts in UI (scrolling/folding issues)

**Import Limitations:**
- cURL import ignores transport flags (`-L` follow redirects, `-k` insecure SSL, etc.)
- Some advanced curl options don't map to requests
- Must review and adjust imported requests if advanced options were used

---

### 9. **Details About Outputs**

API Dash provides multiple output options:

**Response Display Options:**
- **Preview Mode:** Rich rendering with syntax highlighting
- **Code Mode:** Raw formatted response with highlighting
- **Raw Mode:** Plain text view
- **Download:** Save response body to Downloads folder (any MIME type)

**Supported MIME Types (50+):**

| Category | Types |
|----------|-------|
| **Structured Data** | JSON, XML, YAML, TOML, NDJSON |
| **Web** | HTML, CSS, JavaScript |
| **Documents** | PDF, Markdown, SQL |
| **Images** | PNG, JPEG, GIF, SVG, WebP, BMP, ICO, APNG, AVIF, and 10+ more |
| **Audio** | MP3, WAV, OGG, AAC, FLAC |
| **Video** | MP4, WebM, OGG, AVI, MOV, MKV, WMV |
| **Streaming** | Server-Sent Events (SSE) |

**Code Generation (30+ languages):**

Select from:
- **Languages:** C, C#, Dart, Go, Java, JavaScript, Julia, Kotlin, PHP, Python, Ruby, Rust, Swift, HAR, cURL
- **Libraries:** Each language has 1-4 library options (e.g., Python: requests, http.client)
- **Output:** Runnable code with imports, error handling, authentication

**Code Generation Features:**
- Live updates as you modify request
- One-click copy to clipboard
- Includes all headers, params, body, auth
- Sets up environment variables
- Provides dependency hints

**Data Export:**
1. **HAR (HTTP Archive):** Export single collection or entire workspace
2. **Save Workspace:** Local file system persistence (Settings > Create Workspace)
3. **Duplicated Requests:** Create copies to workspace

**History Export:**
- Can duplicate from history and create new requests
- History auto-clears based on retention period (1 week to forever)
- Date-based grouping with request clustering



