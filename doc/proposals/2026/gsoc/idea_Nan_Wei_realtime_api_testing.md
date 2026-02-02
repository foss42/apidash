# Initial Idea Submission
```
Full Name: Nan Wei
University name: Monash University
Program you are enrolled in (Degree & Major/Minor): Master of information technology
Year: 2
Expected graduation date: 2027
```
## Project Title: 
Add realtime api testing support
## Relevant issues: 
https://github.com/foss42/apidash/issues/1051
https://github.com/foss42/apidash/issues/115
https://github.com/foss42/apidash/issues/15
https://github.com/foss42/apidash/issues/14
## Idea description:
To implement support for Real-Time API Testing protocols — WebSocket, SSE (Server-Sent Events), Grpc and MQTT — in API Dash. This will allow users to test, visualize, and generate client code for real-time APIs directly from the app.
### Why this matters:
Real-time communication protocols like WebSockets, SSE, and MQTT are widely used in chat apps, data dashboards, IoT communication, and other domains where live updates are crucial. Adding built-in testing and visualization for them will significantly enhance API Dash’s utility and make it more competitive as a developer tool.
This feature was proposed as a GSoC idea by the community and mentors.
### Detailed Objectives & Deliverables
1. Research & Design (Weeks 1–2)
•	Study the specifications for WebSocket, SSE, and MQTT protocols.
•	Review how API Dash currently handles HTTP and GraphQL.
•	Design a modular architecture to integrate these real-time protocols within the existing Flutter codebase.
Deliverables:
Architecture design docs and planned API interfaces.
________________________________________
2. Implementation (Weeks 3–9)
•	WebSocket Support
o	Add UI for initiating, sending messages, and receiving live WebSocket messages.
o	Integrate visual streams for event logs.
•	SSE Support
o	Implement client subscription and real-time event feeds in the UI.
•	MQTT Support
o	Add connection configuration for brokers, topic subscriptions, and message publishing.
Deliverables:
Working features for the three protocol types with respective test cases.
________________________________________
3. Testing & Documentation (Weeks 10–12)
•	Write unit and integration tests to ensure stability.
•	Update developer docs and user guide on how to use the new features.
Deliverables:
Comprehensive tests + documentation contributions to the repo.
________________________________________
4. Final Polishing & Integration (Weeks 13–14)
•	UI/UX improvements based on feedback.
•	Performance optimization for streaming updates.
Deliverables:
Merged PR, demo videos (if applicable), and user/mentor feedback incorporated.





