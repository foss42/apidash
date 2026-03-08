# GSoC 2026 Idea Doc: Robust MCP Testing & Client Infrastructure
**Related Idea:** Idea #1 (MCP Testing)  
**Related Issue:** [#1307](https://github.com/foss42/apidash/issues/1307)  
**Author:** Atharva Bodade

---

## 1. The Problem Statement: Beyond "Vibe Testing"
To fulfill the mandate of "MCP Testing" (Idea #1), API Dash must act as a deterministic and highly resilient host. Current proposals focus heavily on the UI/UX layer, but local agent testing relies on naive `Process.start` or TCP loopbacks. This introduces "Vibe Testing" risks:
1. **Stream Pollution:** Real-world MCP servers (Python/Node) leak debug logs into `stdout`, crashing standard parsers.
2. **The "Zombie" Problem:** Failed tests often leave orphaned child processes, blocking ports and leaking memory.
3. **Happy-Path Bias:** Most tools only test if a server *works*. A true testing harness must validate how a server *fails*.

## 2. Architectural Blueprint: Stability-First Testing

### Pillar A: The "File Descriptor (FD) Bridge" (High-Integrity Transport)
Instead of naive redirection, we will implement a **Dual-Stream Transport** using Dart's asynchronous streams.
* **Line-Buffered Heuristic Parser:** Only lines following strict JSON-RPC 2.0 frames are passed to the assertion engine.
* **Noise Segregation:** Non-JSON output (logs, banners) is routed to a separate **"Server Debug Console"**, ensuring protocol traffic remains pristine for automated assertions. This enables support for all 6 MCP primitives (including long-running **Notifications**) without stream corruption.

### Pillar B: "Zombies-No-More" (Native Process Reaper)
Repetitive automated testing requires a sterile environment. 
* **Process Group Isolation (PGID):** Every spawned MCP server is attached to a unique PGID.
* **The Native Reaper:** Utilizing Dart's ability to interface with OS-level signals (SIGTERM/SIGKILL to the `-pgid`), we ensure the entire execution tree (including sub-processes like local DBs) is annihilated during teardown, preventing resource leaks.

### Pillar C: Adversarial Fuzzing (The "Testing" in MCP Testing)
We move beyond "Inspection" to true "Validation" by becoming an adversary.
* **Toxic Payload Engine:** A testing mode that fires malicious payloads targeting specific primitives:
  * **Sampling Fuzzing:** Sending malformed `createMessage` responses to see if the server handles LLM-side errors.
  * **Boundary Fuzzing:** Sending paths outside of declared **Roots** to verify server-side security enforcement.
* **Protocol Compliance Scorecard:** Automatically verify if the server returns standard error codes (`-32700`, `-32600`) under stress.

## 3. Implementation Strategy: The Native Advantage
* **Native vs. Proxy:** Unlike Web/Node-based proposals, this native implementation avoids "Middleware Latency" and provides direct OS-level process control.
* **Internal Package:** The `mcp_engine` will be built as a modular internal package (`lib/services/mcp`), ensuring API Dash's core remains lean while providing a robust foundation for future MCP features.

## 4. Why This Architecture?
This proposal positions API Dash as the **"Postman + Chaos Monkey"** for MCP. By controlling the raw File Descriptors and process lifecycles, we provide a level of deterministic testing that web-based proxies cannot match, making API Dash the definitive environment for professional MCP developers.
