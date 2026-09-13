### About

1. **Full Name:** Amogha Karanth Uchila
2. **Contact info:** amoghak07@gmail.com
3. **Discord handle:** bluepheniix (Member of API Dash Discord)
4. **Home page:** N/A
5. **Blog:** N/A
6. **GitHub profile link:** https://github.com/BluePhen1x
7. **Twitter, LinkedIn, other socials:** https://www.linkedin.com/in/amogha-karanth-179890348
8. **Time zone:** IST (UTC +5:30)

### University Info

1. **University name:** JSS Academy of Technical Education (JSSATE), Bangalore
2. **Program you are enrolled in:** B.E. in Computer Science (Major) + **B.S. in Data Science, IIT Madras**
3. **Year:** 2nd Year
4. **Expected graduation date:** June 2028 (B.E.) / June 2027 (IITM)

### Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before?**
   I am an active observer of the API Dash ecosystem. I am currently deep-diving into the `packages/genai` and networking layers to ensure my proposed framework maintains architectural parity with the core project.

2. **What is your one project/achievement that you are most proud of? Why?**
   Maintaining high academic standing in my B.E. at JSSATE while simultaneously pursuing the **IIT Madras Data Science** program. This dual-track education allows me to bridge the gap between core systems (Java, OS, DDCO) and high-level AI research/evaluation.

3. **What kind of problems or challenges motivate you the most to solve them?**
   I am motivated by **Multimodal Alignment**—specifically, creating quantitative benchmarks to evaluate how AI models interpret vision and voice data. My focus is on moving the industry from "vibes-based" testing to rigorous, mathematically-backed evaluation.

4. **Will you be working on GSoC full-time?**
   Yes, I am committing to the **350-hour (Large)** project scope. I will be working full-time (40 hours/week) and have no other academic or professional commitments during the summer.

5. **Do you mind regularly syncing up with the project mentors?**
   Not at all. I value iterative development and believe regular syncs are essential for catching architectural edge cases and ensuring alignment with Ankit's vision for a professional-grade tool.

6. **What interests you the most about API Dash?**
   The focus on **Native Performance**. Most AI tools are bloated web-hybrids, but API Dash is a fast, native Flutter tool that treats AI as a first-class citizen.

7. **Can you mention some areas where the project can be improved?**
   The current AI implementation is excellent for individual request exploration, but it lacks a **Scientific Evaluation Layer**. Developers need a native tool to benchmark model accuracy, latency, and cost across multiple providers using custom datasets.

8. **Have you interacted with and helped API Dash community?**
   Active on Discord, participating in technical discussions regarding the Multimodal Eval Framework implementation and performance optimizations.

---

### Project Proposal Information

1. **Proposal Title:** Native Multimodal AI & Agentic Evaluation Engine

2. **Abstract**
As AI models move into Multimodal (Vision/Voice) and Agentic workflows, developers lack a native tool to quantify "Model Intelligence." I propose a **Zero-Dependency, Native Flutter Evaluation Engine** for API Dash. This engine will allow developers to run datasets through multiple AI providers side-by-side, using **Dart Isolates** for parallel execution and **Riverpod** for state management. By integrating mathematical scoring (Cosine Similarity) directly into the native app, we provide a unified "Source of Truth" for AI engineering without the friction of external Python servers.

3. **Detailed Description**

#### A. The Evaluation Pipeline (Core Architecture)
To handle a 350-hour scope, I propose a production-grade 4-stage deterministic pipeline:
**Ingest → Parallel Fan-out → Mathematical Scoring → Visual Reporting.**

#### B. Technical Implementation Logic
- **Native Data Ingestor:** A stream-based parser for CSV/JSONL datasets, ensuring that 100+ row benchmarks do not cause memory spikes on the main thread.
- **Parallel Isolate Runner:** Uses **Dart Isolates** (multi-threading) to trigger simultaneous requests to multiple AI providers (Gemini, OpenAI, Claude). This allows for high-throughput benchmarking without freezing the Flutter UI.
- **Agentic Traceability:** For Agentic APIs, I will implement a "Trace Log" that records intermediate tool-calls, allowing developers to verify the reasoning path of the agent.
- **Intelligence Metrics (IIT Madras Edge):** I will implement **Cosine Similarity** (via native Dart vector math) to compare AI outputs against reference data, alongside **Time to First Token (TTFT)** and **Token-Cost Estimation**.

#### C. Human-in-the-Loop (HITL) Workflow
The evaluation lifecycle will be governed by a strict state machine:
`IDLE` → `INGESTING` → `AWAITING_APPROVAL` (Gate) → `EXECUTING` → `SCORING` → `REPORT_READY`.

```text
    Orchestrator (Riverpod State Machine)
    │
    ├── Ingests CSV/JSONL (Dataset Manager)
    │
    ├── Spawns Dart Isolates (Parallel Execution)
    │   ├── Gemini (Vision) ──┐
    │   ├── GPT-4o (Vision) ──┼──▶ Raw Response Aggregator
    │   └── Claude (Vision) ──┘
    │
    ├── Scoring Engine (Math Layer)
    │   └── "Calculate Cosine Similarity vs Ground Truth"
    │
    └── Results Dashboard (Visual Layer)
        └── "Side-by-side Model Audit & Performance Charts"
```
#### D. The Visual Benchmarking Dashboard
I will build a "Compare Mode" UI featuring **Linked ScrollControllers**, allowing developers to visually compare the outputs of multiple models side-by-side. The dashboard will include performance charts (using `fl_chart`) to visualize latency and accuracy trends.

4. **Weekly Timeline (350-Hour / 12-Week Intensive Scope)**

| Phase | Week | Primary Focus | Technical Sub-Tasks & Deliverables |
| :--- | :--- | :--- | :--- |
| **Bonding** | **Pre-Week 1** | **Environment & Spec** | Setup Melos monorepo; audit the `genai` package; finalize JSON schema for results. |
| **Phase 1** | **Week 1** | **Data Ingestion** | Build a stream-based CSV/JSONL parser in Dart; implement native file-pickers. |
| **Phase 1** | **Week 2** | **Persistence Layer** | Setup **Hive** boxes for benchmark history; implement auto-save/recovery for long-running evals. |
| **Phase 1** | **Week 3** | **Parallel Engine (Isolates)** | Build the Isolate-based "Fan-out" runner; handle multi-threaded error propagation. |
| **Phase 1** | **Week 4** | **Execution Logic** | Integrate runner with `better_networking` layer; implement request throttling. |
| **Phase 2** | **Week 5** | **Vision Support** | Implement Image-to-Tensor logic; handle base64/URL encoding for multimodal requests. |
| **Phase 2** | **Week 6** | **Audio Support** | Build audio-buffer handler for voice model testing; implement basic metadata extraction. |
| **Phase 2** | **Week 7** | **Scoring Core** | Implement native Dart Cosine Similarity; calculate Time-to-First-Token (TTFT) and Latency. |
| **Phase 2** | **Week 8** | **Cost & Tokens** | Build a token-usage estimation engine to calculate financial cost per benchmark. |
| **Phase 3** | **Week 9** | **Comparison UI** | Build the "Compare Mode" dashboard; implement **Linked ScrollControllers** for side-by-side auditing. |
| **Phase 3** | **Week 10** | **Visual Analytics** | Integrate `fl_chart` for accuracy/latency trends; build the "Model Leaderboard" view. |
| **Phase 3** | **Week 11** | **Agentic Tracing** | Implement "Step-Trace" logging for multi-turn agent calls; build a visual timeline of tool-calls. |
| **Phase 3** | **Week 12** | **Polish & Handoff** | Conduct a performance audit; write user guides; final code cleanup and PR submission. |
