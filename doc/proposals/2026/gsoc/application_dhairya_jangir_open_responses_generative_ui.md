### About

1. Full Name: Dhairya Jangir
2. Contact info (public email): dhairya.collegeacc@gmail.com
3. Discord handle in our server (mandatory): warewolf13
4. Home page: https://dhairya.me
5. Blog: https://dhairya.me
6. GitHub profile link: https://github.com/dhairyajangir
7. Twitter, LinkedIn, other socials:
   - X: https://x.com/DhairyaJangir
   - LinkedIn: https://www.linkedin.com/in/dhairya-jangir-163aaa318/
8. Time zone: IST (UTC+5:30)
9. Link to a resume (PDF, publicly accessible via link and not behind any login-wall):
   - https://docs.google.com/document/d/1hPoIfmYNvNgIJq1lOUieqaezoFRFExbA0B5TDw-nzug/edit?usp=sharing

### University Info

1. University name: MIT Art Design and Technology University
2. Program you are enrolled in (Degree and Major/Minor): B.Tech in Computer Science Engineering
3. Year: Second Year
4. Expected graduation date: September 2028

### Motivation and Past Experience

1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?

Yes. I am actively contributing to API Dash and other open source projects.

API Dash contributions:
- https://github.com/foss42/apidash/pull/1499
- https://github.com/foss42/apidash/pull/1492

Other open source contributions:
- Automagik (Spain):
  - https://github.com/automagik-dev/genie/pull/378
  - https://github.com/automagik-dev/genie/pull/383
  - https://github.com/automagik-dev/genie/pull/402
- Nextcloud Mail:
  - https://github.com/nextcloud/mail/pull/11943
  - https://github.com/nextcloud/mail/pull/11980

I have also built and worked on a Flutter application named SAKHI:
- https://github.com/dhairyajangir/sakhi

SAKHI is relevant to this proposal because it gave me practical experience in the same areas this project needs:
- Building production Flutter UI with reusable widgets and clean state flow.
- Handling real-world JSON payloads and converting them into reliable user-facing interfaces.
- Designing UX for clarity so users can understand complex data quickly.
- Iterating features through feedback and shipping improvements in small, stable steps.

I have also made many additional contributions during the past year, especially around AI-integrated workflows, frontend behavior improvements, and reliability fixes.

2. What is your one project/achievement that you are most proud of? Why?

I am most proud of my recent open source work where I delivered production-quality fixes across active repositories with strict review standards, along with building SAKHI in Flutter. The main reason is not only writing code but understanding each codebase quickly, discussing tradeoffs clearly, and getting changes merged with maintainable quality. This reflects the same skills required for GSoC: architecture understanding, communication, UI implementation discipline, and reliable execution.

3. What kind of problems or challenges motivate you the most to solve them?

I am most motivated by developer-experience problems where users are blocked by poor visibility. In AI API tooling, the biggest pain is that complex model outputs are shown as raw JSON. I enjoy converting such complexity into clean, understandable interfaces and robust parsing flows. Problems that combine specification reading, UI design, and reliability testing are where I do my best work.

4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?

I will prioritize GSoC as my primary commitment during the coding period. I am a university student, so I will continue lightweight academic work, but I have planned my schedule to consistently deliver the required workload for this 90-hour project with buffer time for reviews and fixes.

5. Do you mind regularly syncing up with the project mentors?

Not at all. I prefer regular syncs and frequent async updates. I am comfortable with weekly calls and status updates through GitHub and Discord, and I actively incorporate mentor feedback quickly.

To keep execution predictable for mentors, I follow a simple discipline:
- Break work into small PRs with clear scope and test coverage.
- Share progress early with demo notes and blockers before deadlines.
- Respond quickly to review comments and push follow-up fixes with traceable commits.

6. What interests you the most about API Dash?

API Dash is one of the few open source API clients that is already AI-aware and cross-platform. It has the right foundation to become the best place to test modern AI APIs, especially multi-provider responses and agentic workflows. Idea 5 directly matches my interests: parse structured AI outputs and transform them into useful visual interfaces.

7. Can you mention some areas where the project can be improved?

- Better AI response observability: make reasoning, tool calls, and final messages easy to inspect.
- Better streaming UX: show progressive updates clearly during long-running responses.
- Better structured response rendering: map Open Responses output to meaningful cards/timelines instead of raw JSON.
- Better portability for end users: help developers bridge response visualization to UI integration in Flutter and web apps.

8. Have you interacted with and helped API Dash community? (GitHub/Discord links)

Yes. I have contributed through PRs and discussion.
- API Dash PRs:
  - https://github.com/foss42/apidash/pull/1499
  - https://github.com/foss42/apidash/pull/1492
- Discord handle in server: warewolf13

### Project Proposal Information

1. Proposal Title

Open Responses and Generative UI Dashboard for API Dash

2. Abstract

Modern LLM responses are no longer plain text. They often include structured outputs such as reasoning blocks, tool calls, tool outputs, and UI descriptors. Today these responses are usually viewed as raw JSON, which makes debugging and product integration slow.

This project will add a production-ready Open Responses and Generative UI visualization layer in API Dash. It will detect and parse structured AI responses, render readable response cards and timelines, support streaming updates, and provide a practical pathway for users to integrate the same response contracts into their Flutter and web applications.

The outcome will be a better developer workflow: users can inspect complex AI responses quickly, validate behavior confidently, and export reusable structures for app integration.

3. Detailed Description

#### Problem Statement

AI developers increasingly rely on interoperable response formats. Open Responses defines a vendor-neutral response contract, and A2UI/GenUI provide direction for generative interface rendering. API Dash needs first-class support for these patterns to remain an effective client for AI-native APIs.

Current gap:
- Structured response payloads appear as raw JSON.
- Tool call flows are hard to follow.
- Streaming deltas are hard to inspect.
- There is limited visual guidance for integrating generated structures into apps.

#### Project Goals

- Add Open Responses format detection and robust parsing in API Dash response flow.
- Build structured visualization widgets for key response item types.
- Add streaming-aware rendering for incremental response updates.
- Add a Generative UI preview surface for supported component payloads.
- Provide documentation and integration examples for Flutter and web developers.

#### Scope and Deliverables

A. Open Responses Parser and Data Model
- Define stable models for response object, output items, and metadata.
- Parse core output item types (message, reasoning, function_call, function_call_output, unknown fallback).
- Add safe handling for malformed payloads.

B. Structured Response UI
- Add a dedicated structured response view in API Dash.
- Render item-level cards with clear hierarchy and status indicators.
- Pair tool calls with corresponding tool outputs using identifiers.
- Show usage metadata in compact summary panels.

C. Streaming and Timeline UX
- Process streamed events progressively.
- Update existing cards in place as deltas arrive.
- Show a lightweight timeline view so users can understand response flow.

D. Generative UI Preview (MVP)
- Detect supported generative UI payload shape.
- Render an MVP set of components in preview mode (layout/text/button/list/table where feasible).
- Provide graceful fallback for unsupported components.

E. Integration Path for End Users
- Add documentation showing how to map the same parsed schema in Flutter apps.
- Add documentation showing equivalent rendering approach for web apps.
- Include sample payload fixtures and expected visual output.

F. Testing and Quality
- Unit tests for parser and format detection.
- Widget tests for structured cards and key preview components.
- Integration checks for end-to-end response rendering.

#### Non-Goals (to keep 90-hour scope realistic)

- Full implementation of every A2UI component in one cycle.
- Full code generation system for complete production apps.
- Large architecture changes outside response visualization path.

#### Why this plan is realistic

From reviewing the 2026 proposal set and prior accepted-style proposals in this organization, successful applications are concrete, testable, and scoped by measurable deliverables. This proposal follows that pattern:
- Focuses on a narrow high-impact workflow.
- Includes implementation plus tests plus docs.
- Keeps advanced extras explicitly out of initial scope.

4. Weekly Timeline (90 Hours)

Total planned effort: 90 hours
Planned cadence: around 15 hours per week for 6 weeks

| Week | Hours | Plan |
|------|-------|------|
| Week 1 | 15h | Deep dive into existing response pipeline, finalize schema contract, prepare fixtures for Open Responses and generative payloads, design parser interfaces. |
| Week 2 | 15h | Implement parser and detection logic for Open Responses core structure, add fallback behavior, write unit tests for valid/invalid payloads. |
| Week 3 | 15h | Build structured response viewer (message/reasoning/tool-call/tool-output cards), usage panel, and view switching integration. |
| Week 4 | 15h | Implement streaming-aware update flow and timeline behavior, improve state handling and error boundaries for partial streams. |
| Week 5 | 15h | Implement Generative UI preview MVP components and fallback renderer, add widget tests and fixture-driven rendering checks. |
| Week 6 | 15h | Polish UX, optimize edge cases, complete documentation (user + developer), add integration examples for Flutter/web, submit final PR set and demo notes. |

### Risk Management

- Risk: specification changes or ambiguity in evolving formats.
  - Mitigation: parser designed with versioned fallback and unknown-item handling.
- Risk: streaming edge cases cause UI instability.
  - Mitigation: deterministic event-handling state model and fixture-based tests.
- Risk: scope creep due to many component types.
  - Mitigation: strict MVP component set and explicit non-goals.

### Communication Plan

- Weekly mentor sync with demo of completed milestones.
- Mid-week async updates on Discord and GitHub.
- Early draft PRs for architecture feedback before full implementation.
- Fast response loop for review comments and regressions.

### Why Mentors Can Trust My Execution

- I already have merged contributions in API Dash and active PR history in other mature open source projects.
- I have shipped a complete Flutter app (SAKHI), which demonstrates ownership from implementation to usability.
- I work in incremental milestones, so progress is visible and reviewable at every stage.
- I am comfortable taking feedback and adapting quickly without losing delivery momentum.
- I have scoped this proposal to a realistic 90-hour plan with explicit non-goals to avoid over-promising.

### Post-GSoC Commitment

I plan to continue contributing beyond the coding period by:
- Expanding Generative UI component coverage.
- Improving timeline debugging for complex agentic workflows.
- Supporting follow-up issues and onboarding future contributors in this area.
