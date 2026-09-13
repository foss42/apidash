![GSOCBANNER_APIDASH](./images/dhairya%20application%20images/GSOCBANNER_APIDASH.jpg)


# GSoC 2026 Proposal - Open Responses and Generative UI Dashboard for API Dash

<!-- #####  Dhairya Jangir -->

**Organization:** API Dash (foss42/apidash)     
**Contributor:** Dhairya Jangir         
**Email:** dhairya.collegeacc@gmail.com             
**GitHub:** [github.com/DhairyaJangir](https://github.com/dhairyajangir)  
**LinkedIn:** [linkedin.com/in/dhairya-jangir](https://www.linkedin.com/in/dhairya-jangir-163aaa318/)  
**Location:** Pune, Maharashtra, India (UTC+5:30)  
**Year:** Second Year           
**University:** MIT Art Design and Technology University            
**CGPA:** 8.60 / 10.00          
**Expected Graduation:** September 2028             
**Project Size:** medium  

## University Info

- University: MIT Art Design and Technology University
- Program: B.Tech
- Year: Second Year
- CGPA: 8.60 / 10.00
- Expected Graduation: September 2028

---

## Motivation and Past Experience

### 1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?

Yes. I actively contribute to API Dash and other open source projects. I work in architecture-first increments and prioritize production-ready quality.

- API Dash contributions:
  - https://github.com/foss42/apidash/pull/1499
  - https://github.com/foss42/apidash/pull/1492
- Other open source contributions:
  - Nextcloud Mail (Germany):
    - https://github.com/nextcloud/mail/pull/11943
    - https://github.com/nextcloud/mail/pull/11980
  - Automagik Genie (Brazil):
    - https://github.com/automagik-dev/genie/pull/378
    - https://github.com/automagik-dev/genie/pull/383
    - https://github.com/automagik-dev/genie/pull/402
- GitHub profile:
  - https://github.com/dhairyajangir
- Relevant product work:
  - SAKHI (Flutter): https://github.com/dhairyajangir/sakhi
  - Supply Chain Cargo Management System: https://github.com/dhairyajangir/Supply-Chain-Cargo-Management-System

### 2. What is your one project or achievement that you are most proud of? Why?

I am most proud of sustained open-source delivery across multiple repositories. The key achievement is consistency: entering unfamiliar codebases quickly, understanding architecture constraints, and shipping maintainable work that passes review.

### 3. What kind of problems or challenges motivate you the most to solve them?

I am motivated by developer-experience bottlenecks where the data exists but practical understanding is difficult. AI response workflows are a good example: payloads contain rich state and semantics, but current tools expose them in a cognitively expensive way.

### 4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?

I will prioritize GSoC as my primary commitment during coding weeks. I will continue lightweight university work in parallel, with fixed execution blocks dedicated to this project.

### 5. Do you mind regularly syncing up with project mentors?

Not at all. I prefer regular syncs and scoped PR reviews. My execution model is:
- small, reviewable PRs
- early blocker reporting
- fast turnaround on review feedback
- visible weekly progress

### 6. What interests you the most about API Dash?

API Dash already has strong response rendering foundations and AI-aware direction. This idea naturally extends existing architecture by adding structured interpretation for modern AI-native payloads.

### 7. Can you mention some areas where the project can be improved?

- Better observability for AI-native output types.
- Better streaming debugging UX.
- Better first-class Open Responses rendering.
- Better in-client preview for generated UI descriptors.

### 8. Have you interacted with and helped the API Dash community? (GitHub/Discord links)

Yes.
- API Dash PRs: https://github.com/foss42/apidash/pull/1492, https://github.com/foss42/apidash/pull/1499.
- Discord handle: `warewolf13`.
- GitHub: https://github.com/dhairyajangir

---

## Project Proposal Information

### 1. Proposal Title

Open Responses and Generative UI Dashboard for API Dash

### 2. Abstract

Modern AI APIs return structured, multi-item outputs that include reasoning traces, tool invocations, tool outputs, and UI descriptors. In most API debugging workflows, this output is still consumed as raw JSON. This increases cognitive load, slows debugging, and weakens confidence during iterative development.

This project introduces a production-focused Open Responses and Generative UI Dashboard in API Dash. The solution adds:
- schema-aware response detection
- typed parsing for core Open Responses item families
- call-output correlation rendering
- streaming-aware timeline updates
- MVP in-client GenUI preview with safe fallback behavior

Expected outcome: faster debugging loops, higher observability, and better developer confidence when testing AI APIs.

### 3. Detailed Description

#### 3.1 Problem Definition

AI responses are no longer simple text completions. They are heterogeneous and stateful payloads that may include:
- reasoning summaries
- function calls
- function call outputs
- final assistant messages
- streaming deltas
- generated UI descriptors

The core challenge is interpretability, not data availability.

#### Problem Visuals

Figure 1 - Raw Open Responses payload in current debugging flow:

![Raw Open Responses payload in current debugging flow](./images/dhairya%20application%20images/fig1.png)

Figure 2 - Raw A2UI payload without in-client preview:

![Raw A2UI payload without in-client preview](./images/dhairya%20application%20images/fig2.png)

Figure 3 - Pain-point comparison:

![Pain-point comparison](./images/dhairya%20application%20images/fig3.png)

Figure 4 - Observability gap framing:

![Observability gap framing](./images/dhairya%20application%20images/fig4.png)

Figure 5 - Better observability direction:

![Better observability direction](./images/dhairya%20application%20images/fig5.png)

#### Pain Point Table

| Pain Point | Current Behavior | Engineering Impact | DX Impact |
|---|---|---|---|
| Structured output visibility | Rendered as raw JSON | Hard semantic interpretation | Slow manual inspection |
| Tool call correlation | function_call and output are manually matched | Difficult root-cause analysis | High debugging friction |
| Streaming inspection | Delta fragments shown without state context | Loss of temporal coherence | Poor in-flight confidence |
| GenUI preview | Requires external runtime/app | Longer iteration loop | Slower prototype cycles |

#### Current Landscape

Most popular API clients (Postman, Insomnia, Hoppscotch, etc.) still render modern AI outputs - especially OpenAI's Responses API (with reasoning traces, tool calls, and structured outputs) and similar Anthropic payloads - as raw or syntax-highlighted JSON. Tool-call correlation is manual, streaming deltas lack temporal context, and there is almost no in-client preview for generated UI descriptors (GenUI / A2UI). This proposal positions API Dash as one of the first lightweight, beautiful, cross-platform clients with first-class, visual support for these emerging agentic and generative AI workflows, strengthening its 'AI-powered' identity.

#### 3.2 Proposed Solution

I propose a schema-aware response intelligence layer inside API Dash that converts raw Open Responses and GenUI payloads into interpretable, stream-aware visual workflows.

#### Target UX Visuals

Figure 6 - Target structured Open Responses view:

![Target structured Open Responses view](./images/dhairya%20application%20images/fig6.png)

Figure 7 - Target rendered GenUI dashboard:

![Target rendered GenUI dashboard](./images/dhairya%20application%20images/fig7.png)

#### 3.3 Architecture

##### 3.3.1 Current-State Debug Architecture

Figure 9 - Current-state debug architecture diagram:

![Current-state debug architecture diagram](./images/dhairya%20application%20images/3.3.1.png)

##### 3.3.1.1 Integration Points with Existing Codebase

The current response rendering pipeline is primarily handled in lib/features/home/widgets/response_pane/, particularly through components that manage ResponseBodyView, ResponseBodySuccess, and various previewers (JSON syntax highlighting, multimedia, HTML via flutter_inappwebview, etc.). Response models (HttpResponseModel, etc.) and core data structures live in the packages/apidash_core package. Streaming/SSE handling is already supported and can be found in the request execution and response processing layers. I plan to introduce:

- An OpenResponsesDetector (to differentiate Open Responses / GenUI payloads from standard JSON or SSE responses)
- A typed OpenResponsesParser (placed in a new packages/apidash_core/lib/parsers/ai_responses/ or similar module)

These will plug into the existing ResponseBodyView via a content-type/schema-based router. This approach keeps the integration additive - no breakage to current non-AI, multimedia, or standard JSON rendering paths.

##### 3.3.2 Proposed Runtime Architecture

Figure 10 - Proposed runtime architecture diagram:

![Proposed runtime architecture diagram](./images/dhairya%20application%20images/3.3.2.png)

##### 3.3.3 Architecture Decision Flow

Figure 11 - Architecture decision flow diagram:

![Architecture decision flow diagram](./images/dhairya%20application%20images/3.3.3.png)

##### 3.3.4 Streaming Event Processing

Figure 12 - Streaming event processing diagram:

![Streaming event processing diagram](./images/dhairya%20application%20images/3.3.4.png)

#### 3.4 Data Contract Strategy

The parser uses typed item dispatch. Each output family has explicit parse, render, and failure semantics.

| Output Item Type | Parse Strategy | Render Strategy | Failure Strategy |
|---|---|---|---|
| message | Validate role and content blocks | Message card | Raw segment fallback |
| reasoning | Parse summary and details | Collapsible reasoning card | Text fallback |
| function_call | Parse call id, name, args | Tool-call card with status | Unknown-call card |
| function_call_output | Parse call id and output | Linked output card | Raw payload card |
| unknown | Preserve raw node and metadata | Unsupported-type card | Non-blocking fallback |
| streaming_delta | Accumulate into current item | Incremental timeline update | Safe partial rendering |

#### 3.5 Feature Breakdown with Priorities and Dependencies

| Priority | Feature | Dependency | Why Priority |
|---|---|---|---|
| P0 | Detection + typed parser + fallback | None | Foundation for all downstream features |
| P0 | Structured non-streaming rendering | Parser | Immediate user value |
| P0 | Call-output correlation | Parser | Essential for tool debugging |
| P1 | Streaming reducer and timeline | P0 features | High-value in-flight observability |
| P1 | Integration routing and regression guard | P0/P1 | Release safety |
| P2 | GenUI MVP renderer | P1 baseline | Differentiator feature |

Dependency policy:
- P0 must be complete before P1.
- P1 must stabilize before broadening P2.
- If schedule risk appears, P2 breadth is reduced first.

#### 3.6 Scope, Deliverables, and Non-Goals

Deliverables:
- Open Responses format detector.
- Typed parser and domain model for core item families.
- Structured card-based response view with call correlation.
- Streaming reducer and timeline renderer.
- GenUI MVP component registry renderer with fallback.
- Tests (unit, reducer, widget, integration, regression).
- User and contributor documentation.

Non-Goals for 90-Hour Integrity:
- Full A2UI component parity.
- Full application code generation workflows.
- Large refactor outside response interpretation and visualization path.

#### 3.7 Implementation Strategy and Engineering Approach

Engineering Principles:
- Deterministic state updates over implicit UI mutation.
- Fallback-first rendering to avoid data loss.
- Additive integration to preserve existing behavior.
- Small PRs with scoped review surface.
- Test-gated phase completion.

PR Slicing Strategy:

| PR | Scope | Validation |
|---|---|---|
| PR-1 | Detection and parser contracts | Unit fixtures |
| PR-2 | Core structured cards | Widget tests |
| PR-3 | Call correlation and metadata rendering | Widget + unit tests |
| PR-4 | Streaming reducer and timeline rendering | Reducer tests + stream fixtures |
| PR-5 | GenUI MVP + fallback cards | Widget tests |
| PR-6 | Hardening, docs, integration checks | Integration and regression checks |

#### 3.8 Testing and Validation Strategy

| Test Layer | Scope | Example Coverage |
|---|---|---|
| Unit tests | Detection and parser correctness | Valid fixtures, malformed fixtures, unknown types |
| Reducer tests | Stream event transitions | Delta ordering, finalization, partial stream recovery |
| Widget tests | Structured cards and GenUI components | Reasoning/tool cards, fallback cards |
| Integration tests | Request-to-render flow | View routing, timeline continuity |
| Regression tests | Existing renderer stability | No breakage to current non-AI views |

Validation Gates:
- Parser Gate: core item fixtures pass, fallback deterministic.
- UI Gate: structured rendering stable for core item families.
- Streaming Gate: no crash across defined stream fixtures.
- GenUI Gate: supported components render and unsupported fallback safe.
- Release Gate: integration and regression suites green.

#### 3.9 Timeline and Milestones (90 Hours)

Weekly Timeline

Week 1: Foundation and Contracts (15 hours)

Goal: Establish the detection and parsing foundation that all downstream features depend on.

- Map the full Open Responses payload structure across OpenAI, Anthropic, and other supported providers to identify all item types (message, reasoning, function_call, function_call_output, unknown).
- Define the typed domain model and parser contract interfaces: each item type gets explicit parse, render, and failure semantics.
- Build the fixture matrix with valid, malformed, and edge-case payloads for each item family.
- Implement the schema-aware detection layer that identifies Open Responses vs. standard API responses.
- Write unit tests for the detection and contract layers.

Deliverables: Short architecture mapping document (added to doc/dev_guide/ or proposal folder), fixture matrix, parser contract interfaces, detection unit tests passing.

Verification Gate: Contract checklist complete; all detection and parser contract unit tests green.

Week 2: Parser Core Implementation (15 hours)

Goal: Implement the typed parsing engine that transforms raw response payloads into structured domain objects.

- Implement parsers for each core item type: message, reasoning, function_call, function_call_output.
- Implement the unknown/fallback parser that preserves raw nodes and metadata without crashing.
- Add call-ID extraction and indexing logic to support downstream call-output correlation.
- Validate all parsers against the fixture matrix, including malformed input and graceful degradation cases.
- Submit PR-1 (Detection and parser contracts) for mentor review.

Deliverables: Typed parsers for all core item families, fallback parser, call-ID indexing, comprehensive unit tests.

Verification Gate: Parser unit tests passing across all fixture families; deterministic fallback on invalid input.

Week 3: Structured UI and Call Correlation (15 hours)

Goal: Build the card-based visual rendering layer and implement tool call-output correlation.

- Implement structured card widgets for each item type: message cards, collapsible reasoning cards, tool-call cards with status indicators, and linked output cards.
- Build the call-output correlation renderer that visually links function_call items to their corresponding function_call_output items using shared call IDs.
- Implement the unsupported-type fallback card for unknown item types.
- Add metadata rendering (timestamps, token usage, model info) to card headers.
- Write widget tests for all card components and correlation rendering.
- Submit PR-2 (Core structured cards) and PR-3 (Call correlation and metadata rendering) for review.

Deliverables: Card-based structured view, call-output visual correlation, widget tests for all card types.

Verification Gate: Widget tests passing; structured rendering stable for all core item families.

Week 4: Streaming Timeline and Reducer (15 hours)

Goal: Add real-time streaming awareness with a deterministic state reducer and incremental timeline updates.

- Implement the streaming event reducer that processes SSE delta fragments and maintains coherent accumulated state.
- Build the incremental timeline renderer that shows in-flight streaming progress with temporal ordering.
- Handle streaming edge cases: partial deltas, out-of-order events, interrupted streams, and finalization transitions.
- Add stream state indicators (in-progress, completed, error) to the timeline UI.
- Write reducer tests with stream fixture sequences covering normal, edge-case, and error scenarios.
- Submit PR-4 (Streaming reducer and timeline rendering) for review.

Deliverables: Streaming reducer, incremental timeline renderer, stream state indicators, reducer tests with stream fixtures.

Verification Gate: Reducer tests passing; no crash across all defined stream fixtures; timeline renders correctly during active streams.

Week 5: GenUI MVP Renderer (15 hours)

Goal: Implement the MVP Generative UI preview with a component registry, safe rendering, and fallback handling.

- Design and implement the GenUI component registry that maps UI descriptor types to Flutter widget renderers.
- Build renderers for the MVP-scoped component set (text, buttons, cards, inputs, layout containers).
- Implement safe fallback cards for unsupported or malformed UI descriptors, ensuring no crash and clear developer feedback.
- Add a preview panel that renders GenUI payloads in-client without requiring an external runtime.
- Write widget tests for all supported components and fallback behavior.
- Submit PR-5 (GenUI MVP + fallback cards) for review.

Deliverables: GenUI component registry, MVP component renderers, fallback handling, in-client preview panel, widget tests.

Verification Gate: Supported components render correctly; unsupported descriptors fallback safely; widget tests green.

Week 6: Hardening, Integration, and Documentation (15 hours)

Goal: Harden the full feature set, run integration and regression suites, and complete documentation.

- Run full integration tests across the request-to-render pipeline to verify view routing and timeline continuity.
- Execute regression tests against existing non-AI response renderers to confirm zero breakage.
- Fix edge cases, polish UI details, and address any issues from mentor review feedback on earlier PRs.
- Write user-facing documentation covering the new Open Responses view, GenUI preview, and streaming timeline features.
- Write contributor documentation with architecture overview and extension guide for adding new item types or GenUI components.
- Submit PR-6 (Hardening, docs, integration checks) as the final PR.

Deliverables: Integration and regression tests passing, edge-case fixes, user documentation, contributor extension guide, final polish.

Verification Gate: End-to-end and regression checks green; documentation reviewed and merged; all prior PRs approved.

Milestone Gates:

| Milestone | Objective | Exit Criteria |
|---|---|---|
| M1 | Contract baseline | Parser contracts and fixture matrix finalized |
| M2 | Parser readiness | Core parse tests and fallback tests pass |
| M3 | Structured UI readiness | Core cards and call correlation stable |
| M4 | Streaming readiness | Reducer deterministic on stream fixtures |
| M5 | GenUI MVP readiness | Supported render + unsupported fallback safe |
| M6 | Release readiness | Integration, regression, and docs complete |

Figure 8 - Weekly timeline plan visual:

![Week-wise timeline](./images/dhairya%20application%20images/timeline.png)

#### 3.10 Risks and Mitigation Plan

| Risk | Prob. | Impact | Mitigation | Contingency |
|---|---|---|---|---|
| Spec ambiguity or evolution | Medium | Medium | Version-aware parser and unknown fallback | Defer new types while preserving core behavior |
| Streaming edge-case instability | Medium | High | Deterministic reducer + fixture-driven tests | Freeze to stable non-streaming path if needed |
| GenUI scope creep | High | Medium | Strict MVP matrix and non-goals | Reduce P2 breadth before touching P0/P1 |
| Existing view regressions | Low | High | Additive integration + regression suite | Roll back selector branch and keep parser progress |
| Timeline compression | Medium | High | Weekly scope review and hard priorities | Ship P0/P1 fully and defer non-critical P2 |

#### 3.11 Success Metrics

| Metric | Target |
|---|---|
| Parser correctness on fixture suite | 100% on all valid fixtures + deterministic, non-crashing fallback on malformed/unknown input |
| Structured rendering coverage | All core item families (message, reasoning, function_call, function_call_output) fully rendered with correlation |
| Streaming stability | No crashes across defined stream fixtures; coherent state accumulation |
| GenUI reliability | All MVP components render correctly; unsupported descriptors fallback safely with clear feedback |
| Documentation readiness | Complete user flows + contributor extension guide for new item types and GenUI components |

#### 3.12 Expected Impact on API Dash and Community

Product Impact:
- Faster interpretation of AI-native responses.
- Better confidence in tool-chaining and streaming behavior.
- Faster prototype iteration for GenUI payloads.
- Stronger AI observability positioning for API Dash.

Community Impact:
- Cleaner extension path for future output types and components.
- Reusable fixture and testing strategy for new contributors.
- Better onboarding through practical docs and architecture clarity.

#### 3.13 Why I am a Strong Fit for This Project

I bring active contributions to API Dash (PRs #1499 and #1492) along with hands-on experience across multiple open-source projects. Having worked in the response pane and related preview areas, I am already familiar with the existing previewer architecture, the emphasis on rich, fallback-safe rendering (e.g., multimedia and HTML previewers), and the project's commitment to clean, maintainable Flutter code. I follow an architecture-first approach, ensuring every feature is designed with scalability, backward compatibility, and clarity before implementation. I deliver work in small, review-friendly PRs with strong test coverage. I proactively communicate blockers, trade-offs, and design decisions early to stay aligned with mentors. This project is a natural extension of the response rendering foundations I have already touched. It directly builds on the existing AI-aware direction of API Dash while advancing its positioning as the best client for modern agentic and generative AI workflows. My focus remains on reliable, production-grade delivery rather than superficial feature expansion.

#### 3.14 Post-GSoC Commitment

I plan to continue contributing beyond GSoC by gradually expanding GenUI component support in a structured and stable manner. I will also enhance timeline introspection to better handle complex agentic workflows, making debugging and analysis more intuitive. Additionally, I aim to actively support follow-up issues, improve documentation, and help onboard new contributors. My focus is on ensuring the features evolve into a robust, maintainable, and widely usable part of the project.

## Thank You

Thank you for the opportunity to apply. I have taken time to understand API Dash's codebase, study previous GSoC proposals, and thoughtfully design an approach to implement this feature in a way that feels native to the project. I am ready to get started right away and fully committed to delivering a solution that the community will genuinely value.
