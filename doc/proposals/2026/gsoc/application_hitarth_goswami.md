# GSoC 2026 Proposal: API Explorer (OpenAPI Parser)
**Name:** Hitarth Goswami
**GitHub:** @hitarthium
**University:** Silver Oak University
**Project:** API Dash
**Target Issue:** #8 (API Explorer)
**Expected Size:** 175 Hours

## 1. Abstract & Problem Statement
API Dash is an incredible local API client, but currently, users must manually construct every endpoint. Modern backend teams rely heavily on OpenAPI/Swagger specifications. Issue #8 identifies the need for an "API Explorer"—a feature allowing users to import an OpenAPI specification (JSON/YAML), parse it, and visually explore the available endpoints directly within the API Dash workspace. 

This project will build a robust, native Dart OpenAPI parser and integrate a seamless UI explorer into the existing Flutter architecture, allowing users to auto-generate `RequestModels` with a single click.

## 2. Technical Architecture
The implementation will be divided into three core layers to maintain the strict separation of concerns within the API Dash codebase.



### A. The Parsing Layer (Dart)
Instead of relying on heavy, bloated third-party code-generation packages, I will utilize lightweight AST (Abstract Syntax Tree) parsing to read OpenAPI v3.0/3.1 files. 
* Implement a `SpecParser` utility to ingest raw YAML/JSON.
* Map parsed paths, methods, parameters, and request bodies to native Dart data classes (`OpenApiEndpoint`, `OpenApiParameter`).

### B. The State Management Layer (Riverpod)
* Introduce a new `api_explorer_provider.dart` to manage the state of the loaded specification.
* Ensure the loaded spec is cached in the local workspace so it persists across app restarts without breaking the Apple Sandbox restrictions on macOS.

### C. The UI/UX Layer (Flutter)
* **The Import Interface:** A dedicated "Import Spec" modal accepting file uploads or raw text pasting.
* **The Explorer Sidebar:** A collapsible tree-view rendering the parsed endpoints, grouped by OpenAPI `tags`. 
* **The Injection Action:** A "Load to Workspace" button that maps the `OpenApiEndpoint` data directly into API Dash's existing `RequestModel` format, auto-filling the URL, method, headers, and query parameters in the main UI.

## 3. Implementation Timeline (12 Weeks)

* **Community Bonding & Setup (Weeks 1-2):**
  * Finalize the exact OpenAPI spec parameters to support (focusing on v3.0 core features first).
  * Map out the integration points with the existing Riverpod state.

* **Phase 1: Parsing Engine & State (Weeks 3-5):**
  * Develop the YAML/JSON ingestion utility.
  * Build the Dart data classes representing the spec.
  * Write comprehensive unit tests for the parser against public Swagger files (e.g., Petstore API).

* **Phase 2: UI Integration (Weeks 6-9):**
  * Build the Explorer Sidebar UI components using API Dash's existing design tokens (colors, typography).
  * Implement the tag-based grouping and collapsible tree logic.

* **Phase 3: The Engine Bridge & Polish (Weeks 10-12):**
  * Build the translation layer: mapping the parsed `OpenApiEndpoint` to the active `RequestModel`.
  * Ensure macOS native file-picker permissions are correctly handled.
  * Finalize documentation, user guides, and integration tests.

## 4. Why Me?
I am a Computer Engineering student specializing in AI/ML and software architecture. I have experience building native, multi-platform applications using React, Firebase, and local Python architectures (including active contributions to FOSSASIA's hardware mock layers). 

I currently build and compile API Dash natively on macOS (Apple Silicon). Because of this, I have a deep understanding of the local file system constraints and Flutter desktop deployment flows. In fact, I recently contributed to the API Dash developer guide by diagnosing and documenting a fix for the exact macOS Apple Sandbox file-access constraints that this API Explorer file-picker will need to navigate. I am ready to hit the ground running.