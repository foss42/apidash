### Initial Idea Submission

Full Name:   Sabith Fulail
University name:   Informatics Institute of Technology (IIT | Colombo, Sri Lanka)
Program you are enrolled in (Degree & Major/Minor):   BSc (Hons) Computer Science (Data Science)
Year:  3rd Year
Expected graduation date:  May, 2026

Project Title: Adding Support for API Authentication Methods

Relevant issues:
    [#557](https://github.com/foss42/apidash/issues/557) – Pre-request and post-request scripts
    [#121](https://github.com/foss42/apidash/issues/121) – Importing from/Exporting to OpenAPI/Swagger specification
    [#337](https://github.com/foss42/apidash/issues/337) – Support for application/x-www-form-urlencoded
    [#352](https://github.com/foss42/apidash/issues/352) – Support file as request body
    [#22](https://github.com/foss42/apidash/issues/22)   – JSON body syntax highlighting, beautification, validation
    [#581](https://github.com/foss42/apidash/issues/581) – Beautify JSON request body (Closed)
    [#582](https://github.com/foss42/apidash/issues/582) – Syntax highlighting for JSON request body (Closed)
    [#583](https://github.com/foss42/apidash/issues/583) – Validation for JSON request body
    [#590](https://github.com/foss42/apidash/issues/590) – Environment variable support in request body
    [#591](https://github.com/foss42/apidash/issues/591) – Environment variable support for text request body
    [#592](https://github.com/foss42/apidash/issues/592) – Environment variable support for JSON request body
    [#593](https://github.com/foss42/apidash/issues/593) – Environment variable support for form request body
    [#599](https://github.com/foss42/apidash/issues/599) – Support for comments in JSON request body
    [#600](https://github.com/foss42/apidash/issues/600) – Reading environment variables from OS environment
    [#601](https://github.com/foss42/apidash/issues/601) – Adding color support for environments
    [#373](https://github.com/foss42/apidash/issues/373) – In-app update notifications

Idea description:
    This project will streamline API testing in API Dash by introducing pre/post-request scripting, robust OpenAPI/Swagger interoperability, 
    and enhanced JSON/GraphQL editing. These changes will reduce manual effort in API debugging and improve workflow efficiency.


Implementation Plan
Phase 1: Research & Planning (Week 1-2)
    Study existing API Dash architecture and feature requests.
    Prioritize features based on complexity and impact.
    Research best practices for JSON syntax validation, GraphQL handling, and API import/export.

Phase 2: Core Feature Development (Week 3-10)
 1. Pre-Request & Post-Request Scripts (#557)
    Enable users to modify requests and responses dynamically before sending. 
    This includes automating tasks such as adding authentication tokens, handling environment variables, 
    chaining API requests, and transforming request/response data.

 2. OpenAPI/Swagger Import & Export (#121)
    Allow importing API requests from OpenAPI/Swagger JSON/YAML files.
    Implement API export functionality to generate valid OpenAPI specifications.

 3. JSON Body Enhancements (#22)
    Add syntax highlighting, beautification, and validation for JSON request bodies.
    Provide auto-formatting and error detection for malformed JSON.

 4. GraphQL Editor Improvements
    Add expand/collapse feature for GraphQL queries.
    Implement support for GraphQL fragments, mutations, and subscriptions.
    Improve GraphQL schema inspection.

 5. Support for More Content Types (#337)
    Add support for application/x-www-form-urlencoded and file upload as request body.

Phase 3: Enhancements & Testing (Week 11-14)
 6. Environment Variable & UI Improvements (#600, #601)
    Allow reading OS environment variables directly.
    Introduce color-coded environments (e.g., RED for Prod, GREEN for Dev).

 7. In-App Update Notifications (#373)
    Notify users when a new version of API Dash is available.
    Provide an update button to quickly navigate to the latest release.

 8. Increase Test Coverage
    Write more widget & integration tests to improve code coverage.
    Ensure major UI and backend features are fully tested before release.

Tech Stack & Tools
        Feature	            |       Tech/Tools

    Frontend	            |     Flutter (Dart)
    API Parsing             |     OpenAPI, Swagger
    JSON Enhancements       |     CodeMirror, Ace Editor
    GraphQL	                |     GraphQL Parser (Dart)
    Testing	                |     Widget Testing, Integration Testing
    Environment Handling    |     OS Environment Variables (Dart)


Why This Project?
 Enhances Developer Productivity – Improves usability with better request handling, scripting, and JSON validation.
 Better GraphQL Support – Adds crucial missing features to enhance GraphQL development.
 Improves API Import/Export – Makes API Dash more interoperable with OpenAPI and Swagger.
 Strengthens Stability & Testing – Increases test coverage and enhances debugging efficiency.

These improvements will help make API Dash more competitive with other API tools by adding support for advanced 
use cases such as authentication management, JSON syntax validation, and seamless GraphQL integration

Future Scope
    Implement gRPC support to expand API Dash's capabilities.
    Improve UI/UX for better user experience.
    Add VS Code & JetBrains integration for a seamless developer workflow.
    
This project will provide meaningful improvements to API Dash and enhance the overall user experience.
I am excited to work on these features and contribute to making API Dash a more powerful tool!

