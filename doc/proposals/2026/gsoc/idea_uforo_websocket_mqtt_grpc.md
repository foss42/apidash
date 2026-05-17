Uforo Ekong
University of the People (UOP) 
Computer Science, BSc
First year 
July 2029

WebSocket, MQTT & gRPC Support in API Dash

 
- #15 (WebSocket)  
- #115 (MQTT)  
- #14 (gRPC)  
- Discussion: #772



I propose to implement support for testing, visualization, and integration code generation for WebSocket, MQTT, and gRPC protocols in API Dash.

Approach:

- Design a modular core library architecture that can handle multiple real-time protocols with clean connection management and message handling.
- Focus primarily on WebSocket support first. I have already built a working `ProfileableWebSocket` wrapper that intercepts outgoing and incoming frames, logging timestamp, direction, size, type, and preview.
- Build rich real-time visualization UI (timeline of messages, expandable details, filtering, syntax highlighting) similar to the existing HTTP request/response views.
- Extend to MQTT (pub/sub, topics, QoS levels) and gRPC (protobuf support, bi-directional streaming) as stretch goals.
- Add basic code generation for easy Flutter/Dart integration.

Secret Gist:  https://gist.github.com/Hackathonwave/812c6f9984f4f5d2e453b1e426d3766f
Github Username: Hackathonwave

This feature will make API Dash much stronger for developers working with real-time applications, IoT devices, and microservices.

I have gone through the project walkthrough video, developer docs, and the CONTRIBUTING guide. I am active on Discord in the #gsoc-foss-apidash channel and have already submitted my formal proposal on the GSoC portal.

I look forward to mentor feedback on the architecture and implementation plan.
