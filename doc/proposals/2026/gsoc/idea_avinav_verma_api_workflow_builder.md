### Initial Idea Submission

Full Name: Avinav Verma   
University name: Indian Institute of Information Technology and Management (ABV-IIITM), Gwalior  
Program you are enrolled in (Degree & Major/Minor): Integrated IT + MBA 
Year: 3rd Year  
Expected graduation date: June 2028  

Project Title: API Automation & Workflow Builder for API Dash  

Relevant issues:  
- Related to API Explorer concept

---

## Idea Description

API Dash provides a convenient interface for testing APIs and managing requests. With the proposed **API Explorer**, developers will be able to discover and import public APIs into their workspace. However, real-world API usage often involves more than sending a single request. Developers frequently need to authenticate with multiple services, reuse credentials, chain API calls together, and automate repetitive interactions.

This proposal introduces an **API Automation & Workflow Builder** for API Dash. The goal is to extend API Dash from a simple API testing tool into a lightweight platform for building and automating multi-step API workflows.

The system will allow developers to visually construct API pipelines where the output of one API request can be used as the input for another. It will also provide centralized credential management and automatic handling of authentication tokens, making API interactions easier and more efficient.

---

## Key Features

### 1. Credential Manager
Many APIs require authentication using API keys, OAuth tokens, or client credentials. Currently, developers must manually configure these credentials for each request.

The proposed credential manager will allow users to securely store authentication information and reuse it across multiple API requests. This reduces repeated configuration and improves organization when working with several services.

  
**Support for Multiple Profiles**

The credential manager will support multiple user profiles or environments.  
Each profile can maintain its own set of API credentials, tokens, and configuration variables.

For example, a developer may maintain separate profiles for:

• Personal projects  
• Work environments  
• Testing or sandbox APIs  

Switching between profiles will automatically apply the appropriate credentials to API requests and workflows. This allows developers to test integrations across different environments without repeatedly reconfiguring authentication details.

---

### 2. Automatic Token Refresh
Many APIs issue temporary tokens that expire after a fixed time interval. When a token expires, the user must manually request a new one before continuing.

The system will automatically detect expired tokens and call the appropriate refresh endpoint when necessary. The new token will be stored and used automatically for subsequent requests, preventing interruptions in API workflows.

**Edge Case Handling:**
* **Expired Refresh Tokens:** If the refresh token itself expires or is revoked, the system will pause the workflow and elegantly prompt the user to re-authenticate rather than failing silently or looping infinitely.
* **Network Interruptions:** If a refresh fails due to a network timeout, the engine will implement a standard exponential backoff retry mechanism before marking the workflow step as failed.
  
![Credential Manager Flow](/doc/proposals/2026/gsoc/images/Avinav_Credential_Manager.png)

---

### 3. API Workflow Chaining
Developers often need to combine multiple APIs to complete a task. For example:

Weather API → AI summarization API → Notification API

Instead of manually copying responses between requests, API Dash will allow users to build workflows where the output of one API call becomes the input of the next. To achieve this cleanly, users will be able to utilize **JSONPath** expressions to extract specific data points from a JSON response body and map them to the headers, query parameters, or body of the subsequent request.

While the initial iteration will focus on linear workflows, the architecture will be designed with the future possibility of **Basic Control Flow** (e.g., executing different requests based on a successful 200 vs a 404 response).
  
![API Workflow Chain](/doc/proposals/2026/gsoc/images/Avinav_Workflow.png)

---

### 4. Visual Workflow Builder
A visual interface will allow users to create API workflows using drag-and-drop components. Each block will represent an API request, and arrows between blocks will represent the flow of data.

Users will be able to define how outputs from one request map to inputs of another. Internally, these workflows will be stored as structured JSON configurations and executed by a workflow engine.
  
![Workflow Builder](/doc/proposals/2026/gsoc/images/Avinav_Flowchart_structure.png)

---

### 5. Exporting & Sharing Workflows
Because workflows are stored internally as structured JSON files, developers will be able to easily export, import, and share their pipeline configurations. This makes API Dash a highly collaborative tool, allowing teams to share complex integration tests or staging environments effortlessly.

---

## Implementation Approach & Technical Architecture

The feature will be implemented natively in Dart as an extension to API Dash's existing Flutter architecture. 

1. **Credential Manager Module:** Handles secure, encrypted storage of API keys and tokens locally using Flutter's secure storage solutions.
2. **Workflow Execution Engine:** A background Dart service that parses the JSON workflow configurations. It executes API requests sequentially, utilizes JSONPath for data extraction and mapping, and handles asynchronous errors.
3. **Token Refresh Handler:** An interceptor integrated into the HTTP client that detects 401 Unauthorized responses, triggers the refresh logic, and queues pending requests until the new token is secured.
4. **Workflow Builder Interface (UI):** Building a visual node-editor requires careful Flutter state management and efficient rendering (such as `CustomPaint` for the node connections). Constructing the drag-and-drop pipeline will involve utilizing `StatefulWidget`s effectively to ensure that the state of complex interactive elements (like draggable nodes and resizable layout dividers) is perfectly preserved across UI rebuilds without degrading canvas performance.

Each workflow will be stored internally as a structured configuration that defines:
- The sequence of API calls
- How outputs map to inputs
- Authentication details for each step

---

## Possible Development Plan

* **Phase 1: Community Bonding & Planning:** Familiarize myself deeply with the API Dash codebase, refine the JSON schema for workflow configurations, and discuss the optimal state management approach for the visual builder with mentors.
* **Phase 2: Credential Management & Token Handling:** Implement secure local storage for credentials, build the UI for adding/editing API keys, and develop the HTTP interceptor logic to handle 401 errors and automatic token refreshing.
* **Phase 3: Workflow Engine Core:** Build the Dart engine capable of parsing the workflow JSON, executing sequential requests, and mapping response data to subsequent inputs.
* **Phase 4: Visual Workflow Builder UI:** Develop the interactive Flutter UI. Focus on the drag-and-drop canvas, node connections, and ensuring state is preserved cleanly during complex user interactions.
* **Phase 5: Integration & Error Handling:** Connect the visual builder UI to the execution engine. Implement clear visual feedback for successful steps and errors within the UI.
* **Phase 6: Testing & Documentation:** Finalize unit and widget tests, write comprehensive user documentation, and prepare the final pull request.

---

## Expected Benefits

This feature expands API Dash beyond simple request testing and provides a powerful environment for experimenting with API integrations.

Developers will be able to:
- build multi-step API workflows
- reuse authentication credentials
- automate API interactions
- test complex API integrations more efficiently

Overall, this will improve developer productivity and make API Dash a more versatile tool for API exploration and automation.
