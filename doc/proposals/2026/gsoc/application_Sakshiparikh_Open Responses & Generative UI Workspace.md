## About

- **Full Name:** Sakshi Parikh
- **Email:** sakshifm@gmail.com
- **Discord Handle:** sakshiparikh
- **Portfolio:** https://sakshi-parikh.vercel.app/
- **Blog:** N/A
- **GitHub:** https://github.com/sakshi2255
- **LinkedIn:** https://linkedin.com/in/sakshi-parikh-168b8431a
- **Other Socials:** N/A
- **Time Zone:** IST (India)
- **Resume:** https://drive.google.com/file/d/13ScpGy3QsYy-ul_5vYJ_J_O9b4qRlDlV/view?usp=drive_link

## 🎓 University Info

- **University:** Marwadi University
- **Program:** B.Tech in Computer Engineering
- **Year:** 3rd Year
- **Expected Graduation:** 2027

## 💡 Motivation & Past Experience

**1\. Have you worked on or contributed to a FOSS project before?**  
No, this is my first time contributing to open source as well as participating in GSoC. However, I am highly motivated to learn, contribute, and grow through this opportunity.

**2\. What is your proudest project/achievement? Why?**  
My proudest project is my **Event Management System**, where I explored full-stack development and worked in a team environment. I also took on the role of **project merger**, which helped me understand collaboration, integration challenges, and real-world development workflows.

**3\. What kind of problems motivate you?**  
I am most motivated by problems that improve **developer experience**, simplify complex workflows, and make systems more intuitive and user-friendly.

**4\. Will you be working on GSoC full-time?**  
I cannot fully guarantee full-time availability as I am currently applying for internships and working on multiple projects. However, I will ensure consistent progress and dedicate significant time to the project.

**5\. Do you mind regularly syncing with mentors?**  
Not at all. I am comfortable with regular communication and feedback sessions.

**6\. What interests you about API Dash?**  
API Dash focuses on improving how developers interact with APIs. The idea of transforming raw AI responses into a **visual and interactive debugging experience** strongly aligns with my interest in developer tools.

**7\. Areas where the project can be improved**

- Better visualization of AI responses instead of raw JSON
- Improved debugging tools for multi-step AI workflows
- Support for interactive UI rendering from responses
- Enhanced developer productivity features

**8\. Have you interacted with the API Dash community?**  
Not yet, but I am eager to start contributing and engaging actively.

## GSoC 2026 Proposal: Open Responses & Generative UI Workspace (idea 5)

**Project:** Open Responses Protocol Support & Generative UI Rendering Engine 

## 1\. Abstract

- **Problem**: Currently, testing AI APIs in API Dash results in a "wall of JSON". Developers must manually parse deeply nested structures to identify reasoning, tool calls, and final answers. This lack of visualization makes debugging multi-step agentic flows and A2UI component responses highly inefficient.
- **Aim**: To transform the response pane into a **Visual AI Debugging Workspace**. The goal is to provide a step-by-step visual timeline of AI actions and a live preview of interactive UI components directly within the app.
- **Solution**: I propose a modular system that detects Open Responses and A2UI formats, converts them into structured Dart models, and displays them via a new ResponseBodyView.structured mode. This includes a **Structured Flow View** for logic and an **Interactive Renderer** for Generative UI.

## 2\. Detailed Description (What will be done)

I will build an integrated pipeline that replaces raw JSON inspection with a human-readable interface. Key deliverables include:

- **Universal AI Parser**: A robust engine in packages/genai to handle Open Responses from multiple providers.
- **Structured Timeline**: A visual flow showing reasoning traces, function calls (with arguments), and final messages as themed cards.
- **A2UI Widget Renderer**: A registry-based system to render JSON component descriptors into interactive Flutter widgets.
- **Simulate Response Mode**: A "Sandbox" feature allowing developers to paste JSON and preview the UI without making live API calls.
- **Split Screen Debugger**: A side-by-side view for comparing raw data with the rendered UI.

## 3\. Approached Solution (Technical Implementation)

This approach highlights my understanding of the **API Dash** codebase, specifically the genai package and ResponseBodySuccess widget tree.

#### A. Architecture Overview

The system will follow this flow to ensure minimal architectural impact:

|     |     |     |
| --- | --- | --- |
| **Layer** | **Responsibility** | **API Dash Integration Point** |
| **Detection** | Identify Open Responses vs. A2UI vs. Standard JSON. | ResponseBody model. |
| **Modeling** | Convert JSON to Type-safe Sealed Classes. | packages/genai/lib/models. |
| **Logic** | Track previous_response_id for conversation chaining. | ModelProvider interface. |
| **UI** | Render cards and A2UI widgets. | ResponseBodySuccess switch case. |

#### B. Technical Logic Details

- **Sealed Classes (Freezed)**: I will implement ParsedItem as a sealed class to handle MessageItem, ReasoningItem, FunctionCallItem, and ToolOutputItem. This mirrors the pattern used in AIRequestModel.
- **Registry-Based Rendering**: For A2UI, I will create a ComponentRegistry map. This allows for O(1) lookup of widget builders, making the system easily extensible for future components.
- **Streaming SSE State Machine**: I will modify the stream listener to handle typed events like response.output_text.delta. This ensures text updates progressively in the UI without re-rendering the entire card.

## 4\. Roadmap towards Achieving the Solution

This roadmap is designed to transition the **API Dash** response pane from a raw JSON viewer into a **Visual AI Debugging Workspace** over a 10-week period. It is broken down into specific technical milestones and sub-tasks to ensure measurable progress.

## Phase 1: Foundation & Data Modeling (Weeks 1-2)

**Goal:** Establish the underlying data structures and detection logic in the genai package.

- **Week 1: Architectural Audit & Research**
    - Audit packages/genai to understand existing ModelProvider and outputFormatter patterns.
    - Study Open Responses and A2UI v0.10 specifications to map all required JSON fields.
    - Draft the final architecture for the ParsedItem sealed classes.
- **Week 2: Detection & Base Modeling**
    - Implement isOpenResponsesFormat() and isA2UIFormat() structural check utilities in the ResponseBody model.
    - Build base **Freezed** models for MessageItem, ReasoningItem, FunctionCallItem, and ToolOutputItem.
    - Implement initial unit tests for the detection logic using JSON fixture data.

## Phase 2: Structured Flow View (Weeks 3-4)

**Goal:** Create the visual "timeline" for AI reasoning and tool calls.

1.  **Week 3: Core Parsing Logic**
    - Develop the OpenResponsesParser to extract reasoning traces and function arguments from raw JSON.
    - Integrate the parser into the packages/genai utility layer.
    - Extend unit tests to cover nested and complex tool-calling scenarios.
2.  **Week 4: Structured Tab Implementation**
    - Add the structured view mode to the ResponseBodyView enum.
    - Design and build the StepCard and ReasoningCard widgets using the app's existing theme.
    - Implement the switch-case in ResponseBodySuccess to render the new timeline.

## Phase 3: Real-time Streaming & Chaining (Weeks 5-6)

**Goal:** Enable live updates and multi-turn conversation visualization.

- **Week 5: SSE Streaming Support**
    - Modify the stream listener to handle typed SSE events (e.g., output_text.delta).
    - Implement a state machine to append deltas to active ReasoningItem or MessageItem cards progressively.
    - Handle edge cases for streaming interruptions and partial JSON payloads.
- **Week 6: Conversation Chaining**
    - Implement logic to track previous_response_id across multiple requests.
    - Build a vertical "Conversation Timeline" that stitches together sequential AI responses into a single scrollable view.

## Phase 4: Generative UI Engine (Weeks 7-8)

**Goal:** Build the registry-based A2UI renderer.

- **Week 7: A2UI Core Registry**
    - Create the ComponentRegistry map to link JSON strings to Flutter WidgetBuilder functions.
    - Implement core component builders: text, button, card, row, and column.
- **Week 8: Expanded Widget Support**
    - Add builders for advanced components: table, progress_indicator, checkbox, and image.
    - Build a "Fallback Card" to safely display raw data for any unregistered or unknown component types.
    - Implement local event logging for interactive elements (e.g., button click logs).

## Phase 5: Developer Productivity Tools & Polish (Weeks 9-10)

**Goal:** Finalize debugging features and ensure production readiness.

- **Week 9: Simulation & Debugging Tools**
    - Build the **Simulate Response Mode** panel with an input field for manual JSON testing.
    - Implement the **Split Screen** toggle to allow side-by-side comparison of raw JSON and structured UI.
- **Week 10: Performance & Documentation**
    - Optimize rendering performance for large, multi-step JSON responses using RepaintBoundary.
    - Complete user documentation and developer guides for the new features.
    - Final code refactoring, cleanup, and PR submission for the 90-hour milestone.

## GSoC 2026 Project Timeline: 90-Hour Milestone

|     |     |     |     |
| --- | --- | --- | --- |
| **Phase & Week** | **Primary Focus** | **Technical Sub-Tasks** | **Expected Deliverable** |
| **P1: Week 1** | **Research & Architecture** | • Audit packages/genai to map ModelProvider and outputFormatter workflows.<br><br>• Study Open Responses and A2UI v0.10 specifications.<br><br>• Define the ParsedItem sealed class hierarchy. | **Architecture Specification Doc** |
| **P1: Week 2** | **Data Modeling & Detection** | • Build **Freezed** models for MessageItem, ReasoningItem, and ToolCallItem.<br><br>• Implement isOpenResponsesFormat() structural check in ResponseBody.<br><br>• Set up unit tests with JSON fixture data. | **Core Models & Detection PR** |
| **P2: Week 3** | **Open Responses Parser** | • Develop OpenResponsesParser logic to extract reasoning and function arguments.<br><br>• Integrate parser into the genai package utility layer.<br><br>• Validate parser against complex nested JSON structures. | **Functional Parser Utility** |
| **P2: Week 4** | **Structured Timeline UI** | • Add structured mode to ResponseBodyView enum.<br><br>• Design StepCard and ReasoningCard widgets with flutter_markdown support.<br><br>• Update ResponseBodySuccess switch-case for the new view. | **Initial Structured Tab View** |
| **P3: Week 5** | **Streaming SSE Support** | • Implement SSE delta handling for real-time output_text updates.<br><br>• Build state machine to append data to active cards without full re-renders.<br><br>• Add error handling for partial or malformed JSON streams. | **Real-time Streaming Support** |
| **P3: Week 6** | **Conversation Chaining** | • Implement logic to track previous_response_id across API calls.<br><br>• Build scrollable "Conversation Timeline" to stitch multiple turns together.<br><br>• Add visual connectors between chained response cards. | **Multi-turn Conversation View** |
| **P4: Week 7** | **A2UI Core Registry** | • Create ComponentRegistry map for JSON-to-Widget mapping.<br><br>• Implement core builders for text, button, row, and column.<br><br>• Ensure responsive layout handling for nested components. | **A2UI Core Renderer** |
| **P4: Week 8** | **Advanced Components** | • Add builders for table, progress_indicator, and checkbox.<br><br>• Build "Fallback Card" for unknown/unregistered component types.<br><br>• Implement local interaction logging (e.g., button click logs). | **Full A2UI Support** |
| **P5: Week 9** | **Productivity Features** | • Build **Simulate Response** sandbox panel for offline JSON testing.<br><br>• Implement **Split Screen** layout to view raw JSON and UI side-by-side.<br><br>• Ensure feature parity between Flutter Desktop and Web versions. | **Visual Debugger Toolset** |
| **P5: Week 10** | **Polish & Documentation** | • Optimize rendering for large responses using RepaintBoundary.<br><br>• Write user guides and technical documentation for the new workspace.<br><br>• Final code refactoring, cleanup, and PR submission. | **Final Feature Integration** |
