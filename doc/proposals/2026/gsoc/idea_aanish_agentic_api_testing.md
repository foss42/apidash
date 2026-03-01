### Initial Idea Submission

**Full Name**: Aanish Bangre  
**University name**: Sardar Patel Institute Of Technology  
**Program you are enrolled in (Degree & Major/Minor)**: Btech in Computer Science
**Year**: 3rd 
**Expected graduation date**: August 2027

**Project Title**: Agentic API Test Suite Engine with Deterministic Execution Foundation

**Relevant issues**:
- https://github.com/foss42/apidash/issues/1158

**Idea description**:

API Dash currently enables sending and inspecting API requests, and DashBot supports AI-assisted test generation. However, there is no structured execution engine that:

- Generates deterministic test variations from a RequestModel
- Executes test cases as a cohesive suite
- Validates responses against structured expectations
- Aggregates results into a measurable test report
- Provides a reliable foundation for agentic/self-healing workflows

This project proposes building an Agentic API Test Suite Engine with a layered architecture.

### Architecture Overview

**Layer 1** – Deterministic Execution Foundation

This layer introduces a rule-based, non-AI execution engine that:

1. Generates test cases from an existing RequestModel using mutation rules:
   - Baseline valid request
   - Missing authentication
   - Malformed JSON body
   - Empty body
   - Missing query parameters
   - GraphQL-specific error scenarios

2. Uses structured models:
   - TestCase
   - TestExpectation
   - TestResult

3. Executes each test case using the existing `sendHttpRequest()` infrastructure.

4. Validates responses via a TestEvaluator:
   - Expected status codes
   - Body assertions (e.g., GraphQL "errors" presence/absence)
   - Optional performance thresholds

This provides:
- Deterministic, measurable API robustness testing
- Clean separation of execution and reasoning
- A baseline that does not depend on LLM outputs

**Layer 2** – Agentic / Self-Healing Augmentation

Once deterministic execution is stable, an AI layer can augment it by:

- Generating additional edge-case scenarios
- Dynamically mutating failed test cases
- Refining payloads after validation errors
- Creating stateful execution chains (e.g., login → use token → invalidate token)
- Suggesting security and boundary tests

The AI layer will consume structured TestResult outputs from Layer 1 rather than raw HTTP responses.

### Why This Approach?

1. Prevents over-reliance on LLM-generated logic.
2. Ensures reproducible and testable execution.
3. Maintains separation of concerns:
   - HTTP execution
   - Validation logic
   - AI reasoning
4. Scales cleanly for future UI integration and reporting.
5. Aligns directly with GSoC Idea 4.


### Implementation Plan (High-Level)

Phase 1:
- Implement deterministic RuleEngine
- Add TestOrchestratorService
- Add TestEvaluator
- Add structured models
- Write unit tests

Phase 2:
- Integrate AI-based scenario generation
- Add self-healing logic for failed cases
- Implement structured reporting
- Add optional UI integration


This project aims to transform API Dash from a request inspector into a structured API testing platform with intelligent augmentation.