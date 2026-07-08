 ***

# GSoC 2026 Proposal: API Explorer Automation Pipeline
**Project:** End-to-End OpenAPI Ingestion and Template Generation for API Dash

## About Me
* **Full Name:** Rishav Singh
* **Contact Info:** rsingh15124@gmail.com
* **Discord Handle:** cloud90902
* **GitHub Profile:** [github.com/rishav-singh15](https://github.com/rishav-singh15)
* **LinkedIn:** [linkedin.com/in/rishav-singh-a00b11289](https://www.linkedin.com/in/rishav-singh-a00b11289/)
* **Time Zone:** IST (UTC+5:30)
* **Resume:** [View Public Resume](https://drive.google.com/file/d/1nqQxPL9Xbmc1swm0skFSHHIHMONov5Gy/view?usp=sharing)

## University Information
* **University:** MIT-WPU
* **Program:** B.Tech Engineering (ECE AI & ML)
* **Year of Study:** 3rd Year
* **Expected Graduation:** May 2027

---

## Motivation & Experience

### FOSS Contributions
I have been actively contributing to **API Dash**, focusing on the **API Explorer** feature (#619). I approach this project not just as a feature implementation, but as a system to be evolved and refined.

* **Architectural Analysis:** I conducted a deep dive into PR #837, tracing the interaction between `ApiTemplate`, mock JSON, and provider layers. This allowed me to identify the primary bottleneck: the absence of an automated ingestion pipeline.
* **PR #1475 (Fetch Layer):** Implemented a working `TemplateFetchService` to consume remote templates. [View PR](https://github.com/foss42/apidash/pull/1475)
* **Pipeline PoC:** Built a standalone pipeline to convert OpenAPI specs into API Dash-compatible templates. [View Repository](https://github.com/rishav-singh15/api-explorer-pipeline)

### Community Interaction & Design Discussions
Beyond code, I actively leveraged the **API Explorer (#619)** discussion thread as a platform to validate system assumptions. I used these interactions to:
* **Deconstruct existing architecture:** Traced current data flows and identified the lack of a real ingestion pipeline.
* **Propose targeted solutions:** Engaged in architectural debates regarding static JSON serving vs. external sources and alignment with the `TemplatesService`.
* **Public Iteration:** Shared incremental updates (PoC → Integration → Validation) and addressed observed flaws, such as categorization logic, in a transparent feedback loop.

By grounding my discussions in **working implementations** rather than abstract ideas, I ensured my contributions remained aligned with the project’s long-term technical direction.

### Featured Project: API Explorer Pipeline
I am most proud of how I evolved the API Explorer pipeline through iterative failure. My initial implementation revealed a flawed assumption: naive substring matching for categorization led to false positives (e.g., detecting "ai" inside "api").

Instead of a temporary patch, I redesigned the logic from first principles:
* **Token-based parsing:** Abandoned substring matching for higher precision.
* **Weighted Inference:** Implemented a signal-based priority system (Paths > Tags > API Name).
* **Decoupled Architecture:** Recognizing that the Explorer UI was still maturing, I built the pipeline as an independent, modular service to prevent premature coupling.

---

## Project Proposal

### 1. Abstract
Currently, API Dash relies on manually defined templates. To scale API discovery, an automated system is required. This project introduces a **Python-based pipeline** that automatically converts public API specifications (OpenAPI, HTML, Markdown) into structured templates. These are hosted as static JSON and consumed by API Dash through a lightweight fetch layer. A working PoC has already validated this end-to-end flow.

### 2. Detailed Description

#### Architecture Overview
The system is designed as a modular, unidirectional pipeline:
`OpenAPI/Docs` → `Parsing Engine` → `Normalization` → `Tagging` → `JSON Output` → `GitHub Hosting` → `TemplateFetchService` → `API Dash UI`.

#### Technical Components
* **Parsing Engine:** Extracts endpoints, parameters, and request bodies while handling malformed specs.
* **Normalization Layer:** Maps extracted data into the `ApiTemplate` schema, ensuring strict frontend compatibility.
* **Auto-Tagging System:** Employs rule-based keyword matching and weighted inference (Paths > Tags > Name) to ensure high-accuracy categorization.
* **Integration Layer:** A Dart-based `TemplateFetchService` enabling dynamic loading without backend complexity.

### 3. Challenges & Strategic Solutions
| Challenge | Strategic Approach |
| :--- | :--- |
| **Categorization Conflict** | Implemented token-based weighted inference to resolve substring collisions. |
| **Spec Inconsistency** | Developed a robust validation layer with intelligent fallback handling. |
| **Architectural Fluency** | Designed the pipeline to be modular, allowing for independent scaling and testing. |

---

## 4. Weekly Timeline

* **Week 1:** Finalize the robust OpenAPI parser and metadata extraction logic.
* **Week 2:** Implement the transformation layer for the `ApiTemplate` schema.
* **Week 3:** Refine the tagging system and categorization weights.
* **Week 4:** Automate the pipeline via **GitHub Actions** for CI/CD template generation.
* **Week 5:** Full integration with API Dash; replacing mock data with the live fetch layer.
* **Week 6:** Edge-case testing, performance optimization, and final documentation.

## Conclusion
This project transforms API Dash from a manual API client into a dynamic discovery platform. By focusing on a modular, failure-tested pipeline and maintaining a tight feedback loop with the community, we ensure the system is built for longevity and scale.

***