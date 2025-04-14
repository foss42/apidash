# **Personal Information**

 **Full Name:** Kushagra Dwivedi

 **Contact Information:**

**Phone:** \+91 9953739392  
**LinkedIn:** [https://www.linkedin.com/in/kushagradwi/](https://www.linkedin.com/in/kushagradwi/)  
**GitHub:** [https://github.com/kushagradwi](https://github.com/kushagradwi)

**Time Zone:** GMT+5:30  
 **Resume Link:** [Kush Resume 2025.pdf](https://drive.google.com/file/d/1MBwwEBDIX8gvIRCl3g08f9umrbp8mj_z/view?usp=drive_link)

---

# **University Information**

**University Name:** JSSATEN  
 **Program:** B.Tech in Electrical and Electronics Engineering (E.E.E.)  
 **Year:** 2016-2020  
 **Graduation Date:** 2020

---

# 

# 

# 

# 

# 

# **Motivation & Past Experience**

1. **Have you worked on or contributed to a FOSS project before?**  
    Yes, I have submitted a PR.

2. **What is your one project/achievement that you are most proud of? Why?**  
   I cleared the Infosys Power Programmer Exam on my first attempt with a perfect 100% score. It was a significant turning point in my career, especially since I came from a non-computer science background and started as a support engineer with limited coding experience. Preparing for the exam required a lot of hard work and dedication, but it also helped me realize my passion for coding and software development. With an acceptance rate of less than 5%, successfully passing the exam gave me a sense of accomplishment and boosted my confidence to pursue a career in software development.

3. **What kind of problems or challenges motivate you the most to solve them?**  
   I enjoy working with complex systems and figuring out the most efficient solutions. I’m always curious about new technologies and frameworks – lately, I’ve been getting into Flutter – because I want to build a more well-rounded understanding of software development. What really gets me excited, though, are backend challenges, especially when it comes to scaling and designing robust architectures.

4. **Will you be working on GSoC full-time?**  
   I am currently a full-time employee at a firm called Tredence, but my working hours are flexible. I am quite passionate about this program, and therefore I will be able to dedicate 3-4 hours on weekdays and up to 10-12 hours on weekends.

5. **Do you mind regularly syncing up with the project mentors?**  
   Regularly syncing up with the project mentors is perfectly fine with me. Any form of digital communication works for me. I can also ensure transparency in my work by updating a shared public progress document that shows the mentors exactly how much progress has been made and provides resources for future documentation of the feature.

6. **What interests you the most about API Dash?**  
   I am really impressed by how simple and straightforward API Dash is. I think the implementation is very intuitive and uncomplicated, which is great for new developers and really gravitates me towards choosing to work on it. The user-friendly interface makes it easy to work with APIs, which is especially valuable when managing and testing API requests efficiently. It’s a tool that genuinely streamlines the process without overwhelming the user with complexity, and I believe it will make a significant impact once it becomes more mature.

7. **Can you mention some areas where the project can be improved?**  
   I believe it would really help to move away from using the `http` library. I was looking into this issue on GitHub ([issue \#630](https://github.com/foss42/apidash/issues/630)), and I found out that the current API testing setup heavily relies on the Dart `http` library. The problem with this library is that it automatically adds `charset=utf-8` to the `Content-Type` header. This can be a big issue when interacting with APIs that specifically reject headers with that charset, causing compatibility problems and unexpected errors.  
   What’s even more frustrating is that the `http` package doesn’t let us override this behavior. It’s been a long-standing problem—people have been requesting a fix or an option to disable this since mid-2018. But the maintainers have been hesitant to make any changes because a lot of existing applications depend on it working this way, and changing it could potentially break them.  
   After researching a bit more, I realized that Dio could be a way better choice. It’s just more powerful and flexible. With Dio, we get way more control over headers, so we wouldn’t have to worry about that annoying charset issue. Plus, it has some other really useful features, like interceptors, better error handling, and built-in support for things like file uploading and downloading. It’s becoming more popular in other projects too, which makes me think that switching to Dio could make the project more robust and future-proof.  
   

# **Migration to ‘Dio’ and Extending API Testing Support for \- WebSocket, SSE, MQTT & gRPC**

**Abstract: A brief summary about the problem that you will be tackling & how.**

The current API testing setup primarily relies on the Dart http library, which has inherent limitations, especially regarding the automatic addition of the **charset=utf-8** parameter to the **Content-Type header**. This behavior often causes issues when interacting with APIs that explicitly reject such headers, leading to compatibility challenges and unexpected errors. Additionally, **Dio is more powerful and offers greater control over headers, making it a more suitable choice for API testing, and there is increasing adaptation in other projects. In parallel, the testing framework currently lacks support for WebSocket, Server-Sent Events (SSE), MQTT, and gRPC—protocols vital for modern**, real-time applications in IoT, financial markets, and distributed microservices. Migrating to Dio opens the door to these capabilities. This proposal details the step-by-step transition from http to Dio, ensuring backward compatibility while enhancing the project to include streamlined testing and code-generation for real-time protocols. By the end of the project, developers will be able to test traditional REST APIs alongside bi-directional streams (WebSocket), one-way server push (SSE), publish-subscribe models (MQTT), and high-performance RPC (gRPC with Protocol Buffers).

**Detailed Description**

 	This section explores:

* Current Challenges and Criticisms of http

  * Proposed Migration Plan to Dio

  * Extension to Real-Time Protocols (WebSocket, SSE, MQTT, and gRPC)

  * How gRPC Relies on Protocol Buffers

  **Current Challenges with http**

     **Limited Control Over Requests**  
     The major criticism is that the http package forcibly appends charset=utf-8 to the Content-Type header and does not allow overriding it—hindering developers who need exact MIME types (e.g., strict application/json without the charset). Despite community requests since mid-2018 to fix or remove this behavior, the maintainers have been reluctant because a large number of applications depend on that exact behavior and might break if it changes.

     **No Built-In Interceptors & Error Handling**  
     Out of the box, http does not provide a clean way to intercept requests or responses for logging, retries, or token refresh. Developers must manually check status codes and customize each request, resulting in repetitive code.

     **No Real-Time Protocol Support**  
     While http suffices for basic REST calls, it lacks straightforward features for bi-directional messaging (WebSocket), one-way streaming (SSE), or publish-subscribe (MQTT)—capabilities crucial to modern applications and IoT devices.

     **Limited Flexibility for Advanced Use Cases**  
     The library focuses on simple request/response functionality. Features like dynamic cancellation tokens, sophisticated error transformations, or code injection via interceptors typically require external wrappers or significant manual effort, making the development experience cumbersome for complex scenarios.

     —------------------------------------------------------------------------------------------------------


  **Why Dio?**

    **Flexibility & Control**

  * Developers can freely modify request headers, query parameters, and options—enabling fine-grained control over network requests.

  * Timeouts, response parsing, and other advanced configurations are managed centrally in a single Dio instance.

  **Future Protocol Support**

  * Dio’s roadmap outlines improved integration for WebSocket, SSE, and other streaming mechanisms.

  * This makes it significantly more conducive to real-time application requirements than the http package, which lacks built-in features for such protocols.

  **Interceptors**

  * Request Interceptors allow insertion of auth tokens, logging, or dynamic headers without manually modifying each request.

  * Response Interceptors unify error handling, promoting consistent reporting and data transformations across the entire codebase.

  **Error Handling & Cancellation**

  * Cancellation Tokens enable a robust approach to abort in-flight requests, especially useful for mobile or large-scale apps where some requests may become stale.

  * Dio automatically throws exceptions for non-2xx status codes, reducing repetitive boilerplate by consolidating error management in a single, consistent pathway.

—-----------------------------------------------------------------------------------------------------------------

**Proposed Migration Plan**

 We will transition all existing networking code from http to Dio while preserving backward compatibility where possible. Below are the primary steps:

 **Centralized Dio Client**

* Instantiate a single Dio object configured with interceptors for logging, custom headers, and error handling.

  * This singleton ensures consistent behaviors—like timeout settings, authentication tokens, or debug logs—across the entire codebase.

  **Refactor http Calls to Dio**

  * Replace calls to http.get/post/etc. with dio.get/post/etc., mirroring existing endpoints and payloads.

  * Adjust error handling to align with Dio’s exception-driven approach, ensuring a user-friendly experience.

  **Interceptors & Enhanced Error Handling**

  * Implement a global request interceptor to manage authentication tokens, logging, or dynamic headers.

  * A global response interceptor can standardize how we manage status codes (e.g., showing an alert for 401), parse JSON, or log relevant data for debugging.

  **Testing & Validation**

  * Conduct thorough regression tests to confirm existing features—like file uploads and custom request flows—operate correctly under Dio.

  * Validate that any APIs affected by previous request constraints now work smoothly with enhanced control over headers and timeouts.

**—----------------------------------------------------------------------------------------------**

**Real-Time Protocol Support**

 Once Dio is integrated, we can seamlessly integrate WebSocket, SSE, MQTT, and gRPC:

 **Core Protocol Handling Design**  
 At the core, we will design a Protocol Handler abstraction to encapsulate logic for each new protocol. Each protocol (WebSocket, SSE, MQTT, gRPC) will implement a common interface (e.g., a Dart abstract class) that defines:

* connect() / disconnect()

  * send() (if applicable)

  * receive() or a Stream for incoming data

  This clean separation of concerns allows:

  * **Extensibility:** Adding a new protocol (e.g., AMQP or GraphQL Subscriptions) later just means writing another handler class.

  * **Generic UI Interactions:** A Riverpod provider could hold a ConnectionManager referencing a WebSocketHandler, MQTTHandler, etc., depending on the request type.

  Where possible, we will leverage well-tested Dart packages for each protocol to avoid reinventing the wheel:

  * **WebSocket:** Use dart:io’s built-in WebSocket (for desktop/mobile). It provides a Stream for incoming messages and a WebSocket.add() method for sending.

  * **SSE:** Rely on Dio for making a streaming GET request with `Accept: text/event-stream` headers, then parse incoming data as Server-Sent Events.

  * **MQTT:** Integrate an existing Dart MQTT client library (e.g., mqtt\_client), which supports connecting, subscribing, and publishing to a broker.

  * **gRPC:** Use the official grpc Dart package (package:grpc). We’ll handle .proto definitions either through precompiled stubs or server reflection.

  All protocol handlers will reside in API Dash’s core library, decoupled from the UI. Each will provide:

  * A Stream of events/messages (for SSE, MQTT, or a listening WebSocket).

  * State variables for connection status (connected, disconnected, error, etc.).

  By using an event-driven approach, the handlers can push updates to the UI layer via Riverpod providers or controllers.

     **Integration with Flutter & Riverpod**  
     Flutter supplies the reactive UI framework. Riverpod manages and provides global state across the application. The plan:

  * **State Representation**

    * Connection Status: An enum for each protocol (connecting, connected, disconnected, error).

    * Streams of Messages: For protocols that yield ongoing data (WebSocket, SSE, MQTT, gRPC streaming). Riverpod’s StreamProvider can watch the handler’s Stream and rebuild the UI when new data arrives.

    * Form Inputs: For request parameters (like MQTT topic, SSE URL, gRPC method), we can use StateProvider or Notifier classes to keep track.

  * **UI Binding**

    * The Flutter UI will consume these providers. For instance, a Consumer widget listens to the connection status provider to display “Connected” or “Disconnected.”

    * Another Consumer might watch the message stream to append new messages to a scrollable log in real time.

  * **Connection Lifecycle Management**

    * Using Riverpod’s disposal mechanisms (autoDispose), we ensure that if a user closes a request tab or navigates away, the handler is properly closed (e.g., WebSocket or MQTT disconnect).

    * If the user returns, we can reconnect automatically or keep the existing connection active, depending on user preference.

  * **Error Propagation**

    * If any error occurs (e.g., SSE parse error, MQTT broker failure), the handler catches it, updates an error state, and the UI can display a user-friendly message (snackbar, banner, or log).

  * **Flutter Platform Considerations**

    * WebSocket from dart:io works on mobile/desktop. On web, we might use dart:html instead, but API Dash typically targets desktop/mobile environments.

    * MQTT and gRPC are pure Dart, so they should run across platforms without extra platform channels.

—----------------------------------------------------------------------------------------------------------------

**Protocol-Specific Implementation Details**

 While the architecture is unified, each protocol needs specific handling.

 **WebSocket Support**

* **UI/UX**: A “WebSocket Request” option in the UI. The user enters a wss:// URL, optional subprotocols, then presses “Connect”. An input field lets them send messages, and all inbound messages appear in a log.

  * **Connection**: We use WebSocket.connect() under the hood, track connection status in a provider. On success, status becomes connected; on error, we revert to disconnected and inform the user.

  * **Messaging**: The handler’s sendMessage() method transmits user-provided text (or binary, if we add that). Inbound messages arrive via a Dart Stream. We’ll categorize them as “Server” vs. “Client” messages for clarity in the log.

  * **Closing**: A “Disconnect” button stops the socket, or if the server closes it, we detect the done event and update status.

  * **Code Generation**: After testing, we generate example code in Node.js (using ws or Socket.IO), Python (websockets), or Go (gorilla/websocket) for easy integration.

  **Server-Sent Events (SSE) Support**

  * **UI/UX**: A “Server-Sent Events (SSE) Request” option. The user enters a URL, and we start reading the stream via Dio with headers like Accept: text/event-stream. There’s no “Send” here, as SSE is one-way from server to client.

  * **Implementation**: Dio will open a persistent HTTP connection. As lines come in, we parse them into SSE events. If the connection drops unexpectedly, we can attempt reconnection (per SSE guidelines) or let the user manually reconnect.

  * **Error Handling**: If the endpoint isn’t actually SSE or returns a non-2xx code, we catch and display an error. Malformed events still show raw data for debugging.

  * **Code Generation**: Snippets might include `curl -N <URL>`, JavaScript’s `EventSource`, or a Python approach with streaming requests.

  **MQTT Support**

  * **UI/UX**: A “MQTT Client” section. Users configure broker URL (tcp:// or ws://), port, credentials if needed, and a client ID. They can then subscribe to topics and publish messages.

  * **Connection**: The mqtt\_client library handles connecting and orchestrating keep-alive pings. On connect, status changes to connected. Subscriptions are acknowledged by the broker (CONNACK), which we track.

  * **Messages**: Inbound messages are fed to the UI with topic labels. We store them in a provider for easy display. Outbound publishing is also logged for clarity.

  * **Edge Cases**: We handle clean disconnects if the user logs off or if the network fails, in which case we can optionally reconnect.

  * **Code Generation**: Provide snippet templates in Python (paho-mqtt), Node.js (mqtt), or even C++ for IoT boards, reflecting the tested topics and broker settings.


  

  **gRPC Support**

  * **UI/UX**: A “gRPC Request” type with an interface to select a service method, enter request data, and see unary/streaming responses. Reflection-enabled servers can auto-populate method definitions; otherwise, we require .proto imports.

  * **Service Definition Handling**: We can compile .proto files offline or, if reflection is supported, query the server dynamically to build a method list.

  * **Implementation**: We create a ClientChannel with optional TLS. Each call is either a simple unary (request → response) or a streaming call (server-streaming or bidirectional). The UI shows inbound messages in real-time.

  * **Authentication & Metadata**: For many gRPC services, we set custom metadata (like tokens) or use TLS for encryption. We also handle advanced errors like UNAUTHENTICATED, NOT\_FOUND, etc.

  * **Code Generation**: Show sample stubs in Python, Go, or Java. We assume the user has the matching .proto in those languages. 

**UI/UX Considerations**

* **Discoverability**: The user can pick from HTTP, GraphQL, WebSocket, SSE, MQTT, or gRPC in a dropdown. Each protocol’s request panel is tailored to its needs.

  * **Consistency**: Maintain the same look and feel across protocols—request config on the left, response/log area on the right. Possibly add features like “clear messages” or “pause auto scroll” in the log.

  * **State Persistence**: We may keep a connection open if the user only switches tabs. This is done via Riverpod’s providers, allowing multiple concurrent real-time connections if desired.

  * **Performance**: Large message volumes can slow the UI. We’ll impose sensible limits (like truncating after 1,000 messages) or using list virtualization so the app remains responsive.

**Error Handling and Extensibility**

* **Exception Safety**: All network operations catch exceptions. Protocol parse errors or server disconnects update an error provider, which the UI displays non-intrusively.

  * **Open-Closed Principle**: Separate handler classes \+ an abstract interface make the system easy to extend (e.g., adding Socket.IO or AMQP without major refactoring).

  * **Documentation**: Thoroughly comment the code and handler interfaces so maintainers can evolve the system post-GSoC.

  * **Reusing Components**: For example, code generation builds on API Dash’s existing framework for snippet generation, simply adding new templates for each protocol.

**Testing Strategy**

* **Unit Tests**  
   Each protocol handler is tested with realistic scenarios. For SSE, feed mock event lines. For MQTT, connect to a test broker or a local mock. For WebSocket, use an echo server. For gRPC, spin up a local server or connect to public test services.

  * **Integration Tests (Widget Tests)**  
     Simulate user flows in Flutter’s testing environment (e.g., the user enters a WebSocket URL, hits connect, sees messages).

  * **Manual & Cross-Platform Testing**  
     Validate that code runs smoothly on multiple platforms (Windows, Linux, Android).  
     Use known public endpoints (e.g., wss://echo.websocket.org, test.mosquitto.org for MQTT) to confirm real-world stability.

  * **Performance & Load Testing**  
     Monitor CPU/memory usage with large volumes of messages in SSE/WebSocket. Ensure Riverpod’s autoDispose or state teardown prevents memory leaks.

  * **User Feedback & Iteration**  
     Share early builds or screenshots with mentors and the API Dash community, collecting UI/UX feedback to refine features (e.g., advanced filtering for MQTT logs, toggles for gRPC streaming options).

  **Summary**

     By migrating to Dio (for SSE streaming and advanced request management) and adopting specialized libraries for WebSocket, MQTT, and gRPC, we establish a unified architecture within API Dash. This includes:

  * A Protocol Handler interface for consistent handling of connection, messaging, and error states.

  * Riverpod for reactive state management, enabling a smooth UI that automatically updates with real-time data.

  * Thorough testing and documentation, ensuring each protocol is robust, extensible, and well understood.

  **Result**: API Dash will offer first-class support for real-time protocols—making it a one-stop solution for developers who need to test, debug, and generate code for anything from simple REST endpoints to advanced streaming or RPC services. This positions API Dash competitively among modern API clients, while also preserving the open-source spirit and a flexible architecture for future expansions.

**Timeframe**

| Phase | Timeframe | Objectives & Tasks |
| ----- | ----- | ----- |
|  |  |  |
| **Community Bonding & Planning** | Pre-coding (Weeks \-1 to 0\) | \- Review API Dash architecture and current usage of http. \- Discuss approach with mentors. \- Research libraries for WebSocket, SSE, MQTT, gRPC. \- Draft final design doc for Protocol Handlers and Riverpod state management. |
| **Phase 1: Dio Migration (Part 1\)** | Week 1 – Week 2 | \- Create a centralized Dio client with basic interceptors. \- Replace simple HTTP calls (GET, POST) with Dio equivalents. \- Implement tests to confirm basic REST call functionality. |
| **Phase 2: Dio Migration (Part 2\)** | Week 3 – Week 4 | \- Handle complex HTTP flows (multipart uploads, chunked requests). \- Add global request/response interceptors for auth and error logging. \- Run regression tests. \- Document changes for future contributors. |
| **Phase 3: Core Architecture Setup** | Week 5 | \- Establish Protocol Handler interface for different protocols. \- Define Riverpod providers for state management. \- Start drafting UI changes for new protocols (WebSocket, SSE, MQTT, gRPC). |
| **Phase 4: WebSocket Implementation** | Week 6 | \- Create WebSocket handler using dart:io WebSocket. \- Develop UI panel for WebSocket (URL input, connect/disconnect, message log). \- Write unit tests with mock/echo servers. |
| **Phase 5: SSE \+ MQTT Integration** | Week 7 – Week 8 | \- Implement SSE handler using Dio for streaming GET. \- Integrate mqtt\_client library for MQTT. \- Develop UI for MQTT topic management. \- Add unit tests and manual tests against a public broker. \- Code generation templates. |
| **Midterm Review** | End of Week 8 | \- Demonstrate Dio-based REST calls and working WebSocket, SSE, MQTT integration. \- Address any UI/UX feedback from mentors. |
| **Phase 6: gRPC Support (Base)** | Week 9 – Week 10 | \- Implement gRPC handler (unary calls) with ClientChannel. \- Integrate Riverpod for gRPC status and error handling. \- Write code generation for gRPC in one language (e.g., Python or Go). |
| **Phase 7: gRPC Advanced Features** | Week 11 | \- Add support for server-streaming and bidirectional streaming calls. \- Experiment with reflection-based service discovery. \- Expand gRPC code generation to multiple languages. |
| **Phase 8: Polishing & Final Testing** | Week 12 | \- Fix remaining bugs and edge cases. \- Conduct cross-platform tests (Windows, Linux, macOS, Android). \- Optimize performance (e.g., message handling, memory management). \- Finalize documentation and prepare demos/screenshots. |

