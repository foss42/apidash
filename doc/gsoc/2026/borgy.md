# GSoC'26 Final Report: Agentic API Testing via the API Dash MCP Server

> Final report summarizing my contributions to API Dash as part of GSoC'26.

## Project Details

1. **Contributor:** Abdelrahman El-Borgy
2. **Mentors:** Ashita P, Ankit M, Ragul Raj M
3. **Organization:** API Dash
4. **Project:** Model Context Protocol (MCP) Server for Agentic API Testing

#### Quick Links: 
* [GSoC Project Page](https://summerofcode.withgoogle.com/programs/2026/projects/RQmFSAnm)
* [Midterm Progress](https://dev.to/foss42/building-api-dash-mcp-server-adding-spa-mcp-app-10b4)
* [Code Repository](https://github.com/foss42/apidash)
* [NPM Package: `apidash-mcp`](https://www.npmjs.com/package/apidash-mcp)

---

## Project Description

This project focused on bridging the gap between artificial intelligence and local API testing by building the official **Model Context Protocol (MCP)** server for API Dash. 

Previously, utilizing AI for API debugging required constant context switching: copying payloads, pasting them into a chat window, asking the LLM for help, and copying the fixed payload back to your testing client. 

To solve this, I authored and published the `apidash-mcp` package. This server acts as a seamless background bridge between AI assistants (like VS Code Copilot, Claude, Roo Code, or Cline) and the **native API Dash Flutter engine**. By exposing a secure set of tools, the AI gains full programmatic access to API Dash's core execution capabilities, local Hive database history ledger, and interactive studio canvas. 

This lays the foundation for true "Agentic API Testing." Your AI can now autonomously draft HTTP requests, execute them through your local machine, inspect the runtime payloads, and visually render the results directly in a Single Page Application (SPA) workbench—without you ever leaving your editor.

---

## Features

The MCP Server integrates seamlessly with AI clients to make API testing completely agentic and visual:

### 1. Prompt-Driven HTTP Requests
You can send HTTP requests purely through natural language prompts. The results are immediately and beautifully displayed in the SPA workbench instead of a raw text terminal.
<p align="center">
  <img src="./GIFs/MakePOST.gif" alt="Send Request Demo" />
  <br>
  <em>Drafting and executing a POST request via prompt</em>
</p>

### 2. Interactive SPA Workbench
You are not restricted to just chat. You can modify the request details directly within the MCP app SPA workbench UI and resend it without needing to type a new prompt to the LLM.
<p align="center">
  <img src="./GIFs/ModifyRequest.gif" alt="Modify Request Demo" />
  <br>
  <em>Modifying request parameters and resending directly via the UI</em>
</p>

### 3. Request Management
Keep your workspace organized. You can easily name, edit, and copy your API requests directly within the interface for quick reuse.
<p align="center">
  <img src="./GIFs/TitleEdit_copy_clear.gif" alt="Manage Request Demo" />
  <br>
  <em>Renaming, duplicating, and clearing requests to organize the workspace</em>
</p>

### 4. Agentic Auto-Fix for Failed Requests
If you encounter a failed request, you can ask the LLM what went wrong directly. The LLM will diagnose the issue, autonomously fix the request parameters, resend it, and display the successful result. 
<p align="center">
  <img src="./GIFs/FaultedRequest.gif" alt="Auto-fix Demo" />
  <br>
  <em>The LLM autonomously diagnosing and resolving a 4xx/5xx faulted request</em>
</p>

### 5. Persistent Request History
Never lose a test. All your requests are automatically saved in a dedicated History tab, powered by a local Hive database, allowing you to get back to past executions whenever you need them.
<p align="center">
  <img src="./GIFs/HistoryTab.gif" alt="History Tab Demo" />
  <br>
  <em>Browsing the local Hive-powered execution history ledger</em>
</p>

### 6. Intent-Based Navigation
The MCP server understands UI navigation intents. Providing a direct prompt like *"show my history"* tells the LLM to redirect you to the intended tab of the SPA automatically.
<p align="center">
  <img src="./GIFs/promptNavigation.gif" alt="Navigation Demo" />
  <br>
  <em>Directing the SPA UI tabs via conversational user intents</em>
</p>

### 7. Environment Variables Configuration
A dedicated Variables tab lets you set up new environments and securely manage your environment variables right from the workbench.
<p align="center">
  <img src="./GIFs/Request_with_var_prompt.gif" alt="Environment Variables Request Demo" />
  <br>
  <em>Executing requests utilizing securely configured environment variables</em>
</p>

### 8. Advanced Environment Controls
Seamlessly edit, delete, and duplicate your environments to quickly switch between local, staging, and production setups during your testing sessions.
<p align="center">
  <img src="./GIFs/customVarEnv.gif" alt="Manage Environments Demo" />
  <br>
  <em>Managing and swapping between local, staging, and production environments</em>
</p>

---

## How to Setup the Environment

Because this MCP server communicates directly with the native API Dash Flutter engine, setup requires the native application to be installed and discoverable by your system.

### Prerequisites
* **Node.js:** (v18 or higher) with `npx` installed.
* **API Dash Desktop App:** The latest native application must be installed on your machine.
* **MCP Client:** An AI assistant (e.g., VS Code Copilot, Roo Code, Cline).

### Step 1: Configure the API Dash Path
The server needs to know where your `apidash` executable is located. You can configure this in one of two ways:

**Option A: Add to System PATH (Recommended)**

If API Dash is in your global system PATH, the server finds it **automatically**.
* **Windows:** Add the folder containing `apidash.exe` to your System/User `Path` via Environment Variables.
* **macOS/Linux:** Add `export PATH="$PATH:/path/to/apidash_folder"` to your `~/.zshrc` or `~/.bashrc`.

**Option B: Configure via `APIDASH_PATH`**
If you prefer not to modify your system PATH, you will pass the exact executable path inside your AI client's MCP configuration JSON in the next step.

### Step 2: Client Configuration (VS Code Example)
Add the server to your client's configuration file (e.g., `mcp.json`). 
* If you used **Option A**, omit the `"env"` block entirely. 
```json
{
	"servers": {
		"apidash": {
      "command": "npx",
      "args": [
        "-y",
        "apidash-mcp@latest"
      ]
    }
	}
}
```
* If you used **Option B**, include the `"env"` block as shown below:

```json
{
  "servers": {
    "apidash": {
      "command": "npx",
      "args": [
        "-y",
        "apidash-mcp@latest"
      ]
      "env": {
        "APIDASH_PATH": "C:\\Your\\Path\\To\\apidash.exe" 
      }
    }
  }
}
```

*(Note: If you used Option B earlier, you will need to add the `env` block back into this JSON to specify the `APIDASH_PATH`. On Windows, remember to escape backslashes `\\` in the path).*

**The Easier Way (GUI Setup):**
If you prefer not to edit JSON files manually, most modern AI clients in VS Code offer a user interface to do this for you.

1. Open your AI extension's side panel (e.g., GitHub Copilot, Roo Code, or Qodo Gen).
2. Look for the **Tools** or **MCP Servers** section and click **Add New MCP Server**.
3. Simply enter `npx` as the command and `-y apidash-mcp@latest` as the arguments. Save the configuration, and the extension will automatically build the JSON file for you.

### Step 3: Restart and Test
Restart your AI client to spin up the bridge. You can now prompt it: *"Use API Dash to send a GET request to https://api.publicapis.org/entries and summarize the results."*

## Pull Requests Summary

| Feature | PR | Status | Comments |
|---|---|---|---|
| Initial MCP Server setup & NPM package scaffolding | [#1700](https://github.com/foss42/apidash/pull/1700) | Open | Established the base architecture for `apidash-mcp`. |
| Implementation of Agentic API Testing tools | [#1711](https://github.com/foss42/apidash/pull/1711) | Open | Added `execute_request` and network handlers. |
| SPA Workbench integration for visual data rendering | [#1720](https://github.com/foss42/apidash/pull/1720) | Open | Enabled AI to serve interactive UI components. |
| Documentation, error handling, and release workflow | [#1737](https://github.com/foss42/apidash/pull/1737) | Open | Finalized the NPM publish pipeline and user guides. |



## Future Work

* **Agentic Chained Full Endpoints Testing:** Currently, the server supports testing single, isolated endpoints. The next step is to implement stateful agentic test suites, allowing the AI to autonomously chain multiple requests together, pass variables between responses and subsequent payloads, and fully automate complex end-to-end API scenario testing.

## Conclusion

Google Summer of Code 2026 with API Dash has been an incredibly rewarding journey. Building the `apidash-mcp` package challenged me to think beyond traditional user interfaces and dive into the emerging world of Agentic AI. I am proud to have built a tool that empowers developers to integrate API Dash directly into their AI workflows.

This experience taught me the rigor required to publish public packages, the importance of backward compatibility, and how to design open standards. Collaborating with my mentors and the API Dash community has vastly improved my technical communication and architectural decision-making. 

I am deeply grateful to Ashita P, Ankit M, and Ragul Raj M for their constant support, code reviews, and mentorship. I look forward to continuing my contributions to open source and seeing how the community leverages `apidash-mcp`.