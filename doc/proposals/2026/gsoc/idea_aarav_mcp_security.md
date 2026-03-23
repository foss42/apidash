### Initial Idea Submission

Full Name: Aarav Dudeja
University name: Thapar Institute of Engineering and Technology
Program you are enrolled in (Degree & Major/Minor): Bachelors of Engineering
Year: 2027
Expected graduation date: May 2027

Project Title: Automated Red-Teaming & Policy Synthesis for MCP Security
Relevant issues: [GSoC 2026: List of Ideas · foss42/apidash · Discussion #1054](https://github.com/foss42/apidash/discussions/1054)

Idea description:

This project proposes a MCP security layer for API Dash's agentic workflows that automatically discovers unsafe tool-use behavior and converts those findings into enforceable runtime policies. The system introduces two collaborating agents: a Red Agent that generates schema-aware adversarial attacks from each tool's API description, and a Defender Agent that synthesizes human-readable policies from observed failures.

The core pipeline is attack generation -> vulnerability logging -> policy synthesis -> policy verification. After policy generation, the same attacks are re-run to verify risk reduction. Alongside this, an intent alignment check is added before AI-invoked tool execution to ensure the action remains consistent with the user's original objective.

Expected deliverables include: structured attack and policy models, a policy enforcement engine with BLOCK/WARN/LOG modes, an intent-alignment guard in the DashBot tool-call path, and a Security Dashboard UI (risk score, policy editor, and vulnerability log viewer) with test coverage and documentation.

## Detailed Proposal

---

## Abstract

As API Dash evolves into an AI-powered agentic client capable of executing multi-step API workflows, a critical safety gap emerges: LLM-based agents with tool access can be exploited to perform harmful actions—leaking sensitive data, invoking unintended endpoints, or being manipulated through adversarial inputs. This project introduces an **Automated Red-Teaming & Policy Synthesis** layer directly into API Dash that:

1. Uses a **Red Agent** to automatically generate adversarial attacks tailored to each tool's API description.
2. Records attack outcomes (successes and failures) in a structured **vulnerability log**.
3. Deploys a **Defender Agent** that analyzes those logs and autonomously writes usage policies for each tool.
4. Re-runs tests post-policy to **verify** that the fix actually works.
5. Adds an **Intent Alignment Layer** that continuously checks whether every AI-invoked action truly matches the user's original goal.

The result is an API Dash that graduates from being "blindly helpful" to being **careful, secure, and intent-aligned**—suitable for production agentic deployments.

---

## Problem Statement

Current API clients, including API Dash, treat tools as passive executors of user-or-AI commands. When LLMs drive these tools, three major vulnerability classes emerge (as documented in the research literature):

- **Direct adversarial input attacks** — crafted prompts trick the agent into calling harmful endpoints.
- **Sycophancy exploitation** — agents that are overly helpful comply with subtly malicious requests without questioning intent.
- **Outcome-driven constraint violations** — agents optimizing for a KPI (e.g., "complete this API workflow fast") bypass ethical, legal, or safety constraints over multi-step tasks.

Existing red-teaming frameworks (AgentHarm, AgentDojo) use static hardcoded toolsets and cannot adapt to custom API schemas—exactly the use case API Dash serves. There is no automated pipeline that goes from _attack discovery_ → _policy generation_ → _policy verification_ within an API client context.

---

## Proposed Solution

### Architecture Overview

![Architecture Diagram](./images/mcp_security_arch_aarav.png)

### Component Details

#### 1. Red Agent (Attack Generation)

- Ingests the **tool description / OpenAPI spec** from API Dash's existing request models.
- Generates adversarial prompts across risk categories (data leakage, privilege escalation, unauthorized modification, PII exposure) using an LLM-driven iterative refinement loop.
- Implements a **multi-stage prompting strategy**: baseline direct attempt → reflection on failure → progressively more sophisticated adversarial variants.
- Outputs structured attack records: `{ tool_id, attack_prompt, attack_type, outcome, severity }`.

#### 2. Vulnerability Log

- A local SQLite (or JSON) store within API Dash's data layer.
- Captures: attack attempts (successful + failed), response behavior, tool invocation patterns.
- Provides aggregated statistics for the UI: attack success rate per tool, risk category breakdown.

#### 3. Defender Agent (Policy Synthesis)

- Reads the vulnerability log and clusters attack patterns.
- Autonomously drafts **tool usage policies** in a structured format:
  ```yaml
  tool: send_email
  policies:
    - deny_if: "recipient contains external domain AND sender is automated agent"
    - require_confirmation: "when body contains financial data"
    - rate_limit: "max 5 calls per minute"
  ```
- Policies are human-readable, editable by users, and enforced at runtime.

#### 4. Policy Verification Loop

- After the Defender writes a policy, the Red Agent re-runs the same attacks.
- A pass/fail verification report is generated.
- Policies iterate until all known attack vectors are blocked or the risk score falls below a configurable threshold.

#### 5. Intent Alignment Layer

- At runtime, before executing any AI-suggested tool call, a lightweight check verifies:
  - Does this action's parameters match the semantic intent of the original user request?
  - Does this action fall within the scope defined in the active tool policy?
- If misaligned: the action is blocked, the user is notified, and the event is logged.

---

## Research Foundation

This proposal is grounded in three peer-reviewed works:

| Paper                                                                                                                                                         | Key Insight Applied                                                                                                          |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| [Agent vs. Agent: Automated Data Generation and Red-Teaming for Custom Agentic Workflows (EMNLP 2025)](https://aclanthology.org/2025.emnlp-industry.62.pdf)   | The dual-agent (AgentHarm-Gen + Red-Agent-Reflect) framework architecture; iterative attack refinement using self-reflection |
| [Securing MCP-based Agent Workflows(SOSP '25: ACM SIGOPS 31st Symposium on Operating Systems Principles)](https://dl.acm.org/doi/pdf/10.1145/3766882.3767177) | Policy formalization via safety requirements derived from tool hazard analysis; enforceable specifications on data flows     |
| [A Benchmark for Evaluating Outcome-Driven Constraint Violations in Autonomous AI Agents (arXiv 2512.20798)](https://arxiv.org/abs/2512.20798)                | Intent alignment and KPI-pressure violations; the need to check agent actions against original user goals                    |

---

## Integration with API Dash

API Dash already has:

- A structured `RequestModel` with full API spec information — this directly feeds the Red Agent.
- DashBot for AI-driven prompt generation — this can be extended to run attacks and generate policies.
- A local data persistence layer (Hive) — ideal for the Vulnerability Log.
- A Flutter UI — the new **Security Dashboard** panel fits naturally alongside the existing request/response panels.

### New UI Components

- **Security Tab** on the request panel: shows risk score, active policies, and "Run Red-Team Scan" button.
- **Vulnerability Log Viewer**: filterable table of recorded attacks with severity tags.
- **Policy Editor**: YAML/JSON editor with live validation for per-tool policies.
- **Alignment Indicator**: a small badge in the DashBot response that shows "Intent: ✅ Aligned" or "⚠️ Deviation detected."

---

## Improvements Over the Base Idea

Based on my analysis of the research papers and API Dash's current architecture, I propose the following enhancements to the original ideation:

1. **Schema-Aware Attack Generation**: Instead of generic adversarial prompts, attacks are seeded with the actual parameter names, data types, and example values from the API spec. This produces far more realistic and tool-specific attacks, closing the main gap identified in the EMNLP 2025 paper with hardcoded toolsets.

2. **Incremental Policy Learning**: Policies aren't rewritten from scratch on each run—they are incrementally patched, maintaining a version history. This allows users to track how their tool's security posture improved over time.

3. **Severity-Tiered Response**: Instead of a binary block/allow, the Intent Alignment Layer supports three response modes:
   - `BLOCK` (high severity): action is stopped immediately.
   - `WARN` (medium): user is prompted to confirm before execution.
   - `LOG` (low): action proceeds but is flagged for post-hoc review.

4. **Explainable Policy Reasoning**: The Defender Agent not only writes policies but also outputs a human-readable rationale: _"This policy was added because 3 of 7 attacks successfully exfiltrated data via the `export_csv` parameter."_ This addresses a key criticism of automated policy systems—opacity.

5. **MCP Server Integration (Future Extension)**: The policy store can be exposed as an MCP server, letting external tools and other agents query whether an action is permissible before calling it—creating a shared safety layer across all MCP-connected tools in API Dash.

---

## Implementation Plan

### Phase 1 — Core Infrastructure (Weeks 1–4)

- Define the `AttackRecord` and `ToolPolicy` data models.
- Build the Red Agent: prompt templates, LLM API calls, result parsing.
- Write unit tests for attack record generation and storage.

### Phase 2 — Defender Agent & Policy Engine (Weeks 5–8)

- Implement the Defender Agent: attack clustering, policy synthesis, YAML output.
- Build the Policy Enforcement runtime: parse policies, evaluate at tool-call time.
- Implement the Policy Verification loop (re-test after policy application).
- Write tests for policy enforcement logic.

### Phase 3 — Intent Alignment Layer (Weeks 9–10)

- Implement the Intent Alignment checker (semantic comparison of user goal vs. agent action).
- Integrate the alignment check into DashBot's tool-call pipeline.
- Handle the three response modes (BLOCK / WARN / LOG).

### Phase 4 — UI & Integration (Weeks 11–12)

- Build the Security Tab, Vulnerability Log Viewer, and Policy Editor in Flutter.
- Add the Alignment Indicator badge to DashBot responses.
- End-to-end integration testing across the full pipeline.
- Documentation and demo video.

---

## Expected Outcomes

- A fully functional automated red-teaming pipeline integrated into API Dash.
- A policy engine that autonomously generates and enforces tool usage policies.
- An intent alignment layer that prevents AI agents from drifting beyond user goals.
- Comprehensive test coverage (unit + integration) for all safety components.

---

## References

1. Kulkarni, N., Wu, X. C., Varia, S., & Bespalov, D. (2025). _Agent vs. Agent: Automated Data Generation and Red-Teaming for Custom Agentic Workflows_. EMNLP 2025 Industry Track. https://aclanthology.org/2025.emnlp-industry.62.pdf

2. _Securing MCP-based Agent Workflows_ SOSP '25: ACM SIGOPS 31st Symposium
   on Operating Systems Principles https://dl.acm.org/doi/pdf/10.1145/3766882.3767177

3. _Towards Verifiably Safe Tool Use for LLM Agents_ (2025). arXiv:2512.13860. https://arxiv.org/abs/2512.13860

4. _A Benchmark for Evaluating Outcome-Driven Constraint Violations in Autonomous AI Agents_ (2025). arXiv:2512.20798. https://arxiv.org/abs/2512.20798

5. Andriushchenko, M., et al. (2024). _AgentHarm: A Benchmark for Measuring Attacks on LLM Agents_. https://arxiv.org/abs/2410.09024

6. Debenedetti, E., et al. (2024). _AgentDojo: A Dynamic Environment to Evaluate Prompt Injection Attacks and Defenses for LLM Agents_. https://arxiv.org/abs/2406.13352
