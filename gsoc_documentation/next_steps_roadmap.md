# GSoC 2026: Roadmap & Next Procedures

Now that the core WebSocket features are implemented and tested, here is the procedural roadmap to maximize your chances for GSoC success.

## Phase 1: Feature Hardening (Current Week)
1.  **Binary Data Support**: Update the `WebSocketMessageModel` to handle `Uint8List` for binary payloads.
2.  **Ping/Pong Mechanism**: Implement a heartbeat check to detect "Ghost Connections" (connections that are open but dead).
3.  **Subprotocol support**: UI and code-gen support for the `Sec-WebSocket-Protocol` header.

## Phase 2: Testing & Documentation (Next 2 Weeks)
1.  **Automated Unit Tests**:
    *   Test `WebSocketService` using a mock server.
    *   Test `Codegen` for both Python and JS with complex URLs.
2.  **User Documentation**:
    *   Create a "How to test WebSockets with API Dash" guide.
    *   Include a troubleshooting section for common errors (like CORS or self-signed certs).
3.  **Developer Documentation**:
    *   Document the platform-specific implementation in `gsoc_documentation/`.

## Phase 3: Community & Submission (Procuedure)
1.  **Open a Draft Pull Request (DPR)**:
    *   Push your branch to your fork.
    *   Link it to **Issue #15**.
    *   Label it as `GSoC 2026` and `Draft`.
2.  **Request Feedback**:
    *   Message the maintainers on Discord or in the PR comments.
    *   Specifically ask: *"I've implemented the core handler and codegen; are there specific UI patterns you'd like me to follow for message history?"*
3.  **Address Review Comments**:
    *   Be prompt and professional. Every commit after feedback shows your agility.

## Phase 4: Extreme Testing (Backend Engineer POV)
1.  **Stress Test**: Try connecting to a server that pushes 1000 messages/second.
2.  **Concurrency**: Open multiple WebSocket tabs and ensure no state "cross-talk".
3.  **Malicious Payloads**: Send massive JSON blobs (>10MB) and ensure the app doesn't freeze.

---
**Key Tip**: MAINTAINERS value **documentation** and **testing** as much as features. A PR with 100% test coverage is 5x more likely to be merged than a "feature-complete" but untested one.
