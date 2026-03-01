### Initial Idea Submission

Full Name: Anish Shrestha
University name: UCSI University
Program you are enrolled in (Degree & Major/Minor): Bachelor of Computer Science and Information Technology (Hons) in Software Engineering
Year: Graduated
Expected graduation date: 2021

Project Title: Comprehensive gRPC and ConnectRPC Support
Relevant issues: https://github.com/foss42/apidash/issues/14

Idea description:

**The Problem & Motivation**
While building and scaling high-performance backends—particularly in ecosystems like Go—developers are increasingly adopting gRPC and ConnectRPC for efficient, type-safe communication. However, testing these endpoints remains a significant friction point. Standard REST clients aren't equipped for it, and existing gRPC GUI tools often lack cross-platform polish or fail to support the newer, web-friendly Connect protocol. My goal is to solve this workflow bottleneck by bringing native gRPC and ConnectRPC support to API Dash.
Basically, I am trying to solve problem I am facing while building my own backend.

**Implementation Approach**

To integrate these protocols seamlessly into API Dash's existing Flutter architecture, I plan to break the implementation into four core technical pillars:

1. Protocol Selection & UI Integration
Currently, API Dash defaults to standard HTTP methods. I will introduce a protocol selector (HTTP, gRPC, ConnectRPC) at the workspace level. When gRPC or Connect is selected, the UI will adapt to accept standard RPC parameters (Package, Service, Method) instead of standard URL paths.

![gRPC UI Mockup](images/grpc_demo_ai.png)

2. Schema Management & Reflection
RPC clients require an understanding of the data structure. I will implement a two-pronged approach:
* **File Upload:** Allow users to upload local `.proto` files. We will use a Dart protobuf compiler/parser to extract services and messages.
* **Server Reflection:** Implement the standard gRPC Server Reflection Protocol, allowing API Dash to automatically query a running server for its services and methods, drastically improving the developer UX.

3. Core Networking Engine (Dart)

* **gRPC:** I will utilize the official `grpc` Dart package. The initial focus will be strictly on Unary RPC calls (single request, single response) to ensure stability, with the architecture designed to be extensible for Server/Client/Bidirectional streaming in the future.
* **ConnectRPC:** Because ConnectRPC operates over standard HTTP/1.1 or HTTP/2 using simple POST requests, it can heavily leverage API Dash's existing HTTP client infrastructure. The core work here involves setting the correct headers (e.g., `Content-Type: application/connect+json` or `application/connect+proto`) and handling the specific Connect payload serialization.

4. Dynamic Payload Generation
To make the tool truly useful, API Dash should dynamically generate input forms or JSON templates based on the parsed Protobuf message definitions. This saves developers from context-switching to read their `.proto` files just to construct a test request.

**Why this approach?**
By starting with Unary calls and supporting Connect alongside gRPC, we immediately deliver high value to modern API developers while keeping the scope manageable for the GSoC timeline. Leveraging API Dash's existing HTTP backbone for ConnectRPC ensures a cleaner, less intrusive codebase update.