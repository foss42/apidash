### Initial Idea Submission

**Full Name:** Samay  
**University name:** Manipal Institute of Technology  
**Program you are enrolled in (Degree & Major/Minor):** B.Tech in Computer and Communication Engineering  
**Year:** 2nd Year  
**Expected graduation date:** 2028  

**Project Title:** Native Local-First AI & Agent Evaluation Framework for API Dash

**Relevant issues:** Relates to #1054 / #1390

---

### Abstract:
Evaluating and benchmarking LLMs and AI Agents is currently a fragmented and complex process that requires multiple environments and compromises user privacy. I propose integrating a **native, local-first evaluation framework directly into API Dash**. This will allow developers to run standardized benchmarks (MMLU, HumanEval), evaluate multimodal models (Image/Audio), and measure Agentic tool-calling reliability—all from a beautiful unified GUI, with their data remaining 100% private.

### Idea description:

I propose a **fully native, Flutter-integrated architecture** for the AI and Agent Evaluation Framework. Unlike previous suggestions of using a separate React/Tauri subsystem, this approach keeps the evaluation experience entirely within the main API Dash desktop application, maintaining a zero-config, low-overhead environment.

The solution consists of three core layers:
1. **The Native Evaluator (Flutter UI):** A specialized "Evaluation" tab built using Riverpod for robust state management. It provides a real-time log terminal, interactive result visualization, and a configuration suite for selecting benchmarks.
2. **The Logic Provider (Riverpod Notifiers):** A state-driven layer that manages benchmark parameters, execution status, and live log updates without causing UI blocking.
3. **The Local Execution Engine (Python/CLI):** A companion Python runner (`eval_backend/runner.py`) that executes heavy evaluation scripts (httpx, lm-harness) locally on the user's machine. This is triggered asynchronously via `Process.start`, respecting the privacy-first desktop philosophy of API Dash.

#### Why a Native Flutter Implementation?
* **Zero Overhead**: No need for extra runtimes like a bundled Chromium instance or Node.js. It reuses API Dash's existing design system for a consistent look and feel.
* **Unified Workspace**: No context switching. Users can export their API request collections directly into the evaluation framework as "Agent Workflows" (using a JSON contract).
* **Real-time Performance**: Using standard process pipelines, execution logs are streamed directly to the terminal UI as they happen, avoiding the timeouts common in web-based benchmark tools.

#### Architectural Justification:
This architecture directly addresses constraints identified in the API Dash roadmap:
1. **Privacy & Security**: Since benchmarks often involve proprietary test datasets and sensitive API keys, local execution ensures data never leaves the developer's laptop.
2. **Streaming & Log Triage**: Benchmarks can take minutes to run. Our implementation uses an asynchronous Riverpod-driven terminal UI that handles real-time logs without freezing the main application.
3. **Mobile-Ready Isolation**: By encapsulating heavy Python scripts in an external process runner, we protect the core Flutter app's ability to remain light and portable.

#### Progress & Current Status (Proof of Concept):
I have already implemented a **working prototype** of this framework within API Dash. The prototype currently supports:
*   **API Stress Testing**: Local load testing with configurable concurrency.
*   **Agentic Workflow Eval**: Real-time execution of multi-step API chains.
*   **Standardized Benchmarks**: Simulated placeholders for MMLU and HumanEval ready for full Python integration.
*   **Dynamic Logs**: A real-time terminal window with auto-scrolling execution logs.

I look forward to expanding this framework to support advanced multimodal evaluations and enhanced data visualization during GSoC 2026.
