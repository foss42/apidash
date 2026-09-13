# GSoC 2026 Proposal: Multimodal AI and Agent API Eval Framework

* **Candidate:** Yahia (Yaya) Alkawas 
* **Project:** #2 - Multimodal AI and Agent API Eval Framework
* **Mentor:** animator

## Abstract
This project aims to develop an end-to-end evaluation framework within API Dash to benchmark Text, Image, and Voice AI models and Agents. The architecture focuses on a "dependency-lite" approach, ensuring the framework is easy to install for end-users while providing a professional, real-time benchmarking experience.

## Proposed Architecture
* **Frontend (React/TypeScript):** A dynamic UI for configuring request parameters and visualizing multimodal results.
* **Backend (Python):** A robust bridge to tools like `lm-harness` and `lighteval`.
* **Execution:** Utilizing Python's `subprocess` for background tasks and **Server-Sent Events (SSE)** for real-time log streaming to minimize user dependencies.

## Implementation Milestones (350 Hours)
* **Phase 1 (Weeks 1-4):** Designing unified TypeScript interfaces for multimodal data contracts and setting up the core Python benchmarking wrapper.
* **Phase 2 (Weeks 5-8):** Building the UI configuration suite for Voice and Image request parameters.
* **Phase 3 (Weeks 9-12):** Implementing AI Agent session-state tracking and final reporting exports.

## Experience
As a CS student at Cairo University and a security researcher at HackerOne, I have extensive experience building scalable, secure Full-Stack applications using Node.js, React, and Python.

## 🚀 Proof of Concept (PoC)

To demonstrate the feasibility of the real-time streaming architecture, I have developed a functional Proof of Concept. This PoC integrates the FastAPI backend with the React frontend to handle live execution logs.

**[▶️ Watch the PoC Demo Video on Google Drive](https://drive.google.com/file/d/1yU1CVqcSTt9s4fWjEeRO6JzHmB7sXRpY/view?usp=drive_link)**

### **Technical Highlights of the PoC:**
* **Real-Time Streaming:** Implemented **Server-Sent Events (SSE)** using FastAPI’s `StreamingResponse` to pipe live output from a Python subprocess directly to the UI.
* **Terminal UI Component:** Developed a custom React/TypeScript terminal component that handles high-frequency data updates with 0% to 100% progress tracking.
* **Architecture:** Proves the "dependency-lite" approach by avoiding heavy message brokers like Redis, ensuring the framework remains lightweight and portable.

### MCP Alignment Architecture
​Standardized Tooling: "I will utilize MCP to standardize how the evaluation framework connects to external 'Multimodal Tools' (e.g., Vision-to-Text APIs, Audio Analysis tools)."
​Agentic Testing: "By implementing an MCP-compatible server, the framework will be able to evaluate not just model outputs, but also the accuracy of tool-calls made by Agentic AI models."
​Interoperability: "This ensures that any MCP-compatible model or agent can be plugged into the API Dash evaluation pipeline without custom glue code."
