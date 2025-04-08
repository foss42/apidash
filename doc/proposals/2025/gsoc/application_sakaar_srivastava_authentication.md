### About 

1. Full Name: **Sakaar Srivastava**
2. Contact info (email, phone, etc.): **sakaarsri1904@gmail.com**
3. Discord handle: **19doors**
4. GitHub profile link : **https://github.com/19Doors**
5. Twitter, LinkedIn, other socials: **linkedin.com/in/sakaar-srivastava19**
6. Time zone: **Indian Standard Time (IST)**
7. Link to a resume (PDF, publicly accessible via link and not behind any login-wall): **https://drive.google.com/file/d/1uWmwrELFEbITrrUJUCnnQkf6RQJUwvIt/view?usp=drive_link**

### University Info

1. University name: **Vellore Institute of Technology**
2. Program you are enrolled in (Degree & Major/Minor): **Bachelor of Technology, Computer Science and Engineering**
3. Year : **3rd year**
5. Expected graduation date: **June-2026**

### Motivation & Past Experience

Short answers to the following questions (Add relevant links wherever you can):
1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs? :
	**- Yes, I have worked on a FOSS project before. The project is about an AI-powered, cross platform search and command bar designed to make your workflow easier, an open source version of Apple’s Spotlight and better. Link: https://github.com/19Doors/Lumina**

2. What is your one project/achievement that you are most proud of? Why?
	**- One of my good achievements was when I participated in my first hackathon during my second year and won 1st prize among 40+ teams. My team was also ranked among the top 137 teams out of 1Lakh+ teams in Amazon Smbhav Hackathon. These experiences from various hackathons have given me the proper insights on how to function with team members and ensure high efficiency during my second year alone.** [Certificate](https://drive.google.com/file/d/1xpHJfCogZdXbXNs-wfowR_9G0G4tYVOz/view?usp=drive_link)
3. What kind of problems or challenges motivate you the most to solve them?
	**- Difficult problems motivate me the most as they challenge my innermost problem solving personality, which keeps me thinking and trying to find a solution for the problem for the whole day, and until I don’t get the solution, my brain never stops thinking.**

	**- Learning new things also motivates me as I like to think that the more skills you gain and apply in the practical world, the more you get to find new and better solutions to old problems.**
4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?
	**- No, I won't be able to work on GSoC full-time. I have a scheduled internship with Larsen & Toubro from May to July. However, I am deeply enthusiastic about this project and I'm committed to its success. I will dedicate as much time and effort as possible, effectively managing my schedule to ensure I meet all project milestones. I understand the importance of consistent progress and will do whatever I can to deliver exceptional results.**

5. Do you mind regularly syncing up with the project mentors?
	**- No, not at all! Actually, I would love to regularly sync up with the project mentors. Consistent communication and feedback are essential for a successful project, and I believe frequent check-ins will help me stay on track and ensure I'm contributing effectively.**

6. What interests you the most about API Dash?
	**- What I find most appealing about API Dash is its open-source accessibility. Being a student, I've witnessed firsthand the drawbacks of proprietary software such as Postman, most notably the cost restrictions to utilize advanced features. Learning about API Dash through FOSS and understanding its potential to offer a strong, free, and open-source alternative struck a chord with me. The prospect of being part of a project that enables developers, whether or not they have the financial resources, is really exciting. I love open source and think API Dash can become a go-to tool for the community.**
7. Can you mention some areas where the project can be improved?
	**- API Dash can be enhanced by adding more API authentication support, making request body options more refined, and making collection management more powerful. UI enhancement via customization and powerful testing features would also benefit greatly.**

### Project Proposal Information

1. Proposal Title: **API Authentication Support in API Dash**
2. Abstract: **API Dash currently does not have full support for different types of authentication, which prevents it from being able to communicate with many different APIs. This project rectifies this shortcoming by adding strong support for Basic Authentication, API Key Authentication, Bearer Token Authentication, JWT Bearer Token generation, Digest Auth, OAuth 1.0, and OAuth 2.0. These features will be added to API Dash in a secure and accessible way.**

***

## 3. Detailed Description

API Dash is a fantastic tool for interacting with APIs, but its current capabilities are somewhat limited when dealing with endpoints that require specific authentication methods. Many modern APIs rely on schemes beyond simple headers for security and authorization. This project aims to significantly enhance API Dash by integrating robust and user-friendly support for a wide range of standard authentication protocols. By implementing Basic Authentication, API Key handling, Bearer Tokens, JWT Bearer generation, Digest Auth, OAuth 1.0, and the versatile OAuth 2.0 framework, we will empower developers to securely and efficiently connect to a much broader spectrum of APIs directly within API Dash.

### Architectural Approach

To ensure maintainability, testability, and future extensibility, we'll adopt a modular architecture:

1.  **`AuthenticationStrategy` Interface:**
    At the core, we'll define a common Dart interface (let's call it `AuthenticationStrategy`). Every specific authentication method (Basic, API Key, OAuth, etc.) will implement this interface. This ensures consistency and allows API Dash to treat different auth methods polymorphically. Key methods in this interface might include:
    *   `Future<Map<String, String>> getHeaders(RequestDetails request)`: Responsible for generating any necessary HTTP headers (like `Authorization`).
    *   `Future<Map<String, String>> getQueryParams(RequestDetails request)`: For methods like API Key that might involve adding credentials to query parameters.
    *   `Future<void> prepareRequest(MutableRequest request)`: A flexible hook to modify the outgoing request object directly before it's sent. This could handle complex scenarios or pre-request token refreshes.
    *   `Widget buildConfigurationWidget(BuildContext context)`: Each strategy will provide its own specific Flutter widget for user configuration within the API Dash UI.

2.  **Authentication Manager:**
    A central service, likely managed using Riverpod (`StateNotifierProvider` seems appropriate), will act as the orchestrator. Its responsibilities will include:
    *   Storing the currently selected `AuthenticationStrategy` and its associated configuration data for the active request or collection.
    *   Calling the relevant methods (`getHeaders`, `prepareRequest`, etc.) on the active strategy before an HTTP request is dispatched.
    *   Managing the state and flow for multi-step processes like OAuth handshakes.

3.  **User Interface Integration:**
    We'll introduce a dedicated "Authorization" section or tab within the existing request editor UI. This will feature:
    *   A clear dropdown or selection mechanism for choosing the desired authentication type.
    *   A dynamic area that displays the specific configuration widget (`buildConfigurationWidget`) provided by the selected `AuthenticationStrategy`.

### Detailed Implementation Plan for Each Method

We will tackle each authentication method systematically:

#### A. Basic Authentication (#610)

*   **How it Works:** Simple username and password, combined, Base64 encoded, and sent in the `Authorization: Basic <encoded>` header.
*   **Implementation:**
    *   **UI:** Input fields for "Username" and "Password" (masked).
    *   **Logic (`BasicAuthStrategy`):** Use `dart:convert` to perform UTF-8 encoding followed by Base64 encoding. Construct the header value.
    *   **Conceptual Snippet:**
        ```dart
        import 'dart:convert';

        class BasicAuthStrategy implements AuthenticationStrategy {
          final String username;
          final String password;
          // ... constructor ...

          @override
          Future<Map<String, String>> getHeaders(RequestDetails request) async {
            final credentials = '$username:$password';
            final encodedCredentials = base64Encode(utf8.encode(credentials));
            return {'Authorization': 'Basic $encodedCredentials'};
          }
          // ... other interface methods ...
        }
        ```
    *   **Security:** Emphasize secure storage for the password.

#### B. API Key Authentication (#611)

*   **How it Works:** A predefined key (and sometimes a value) is sent, either in a specific header or as a query parameter.
*   **Implementation:**
    *   **UI:** Fields for "Key Name" (e.g., `X-API-Key`, `api_key`) and "Key Value". A choice (radio buttons/dropdown) for "Add to Header" or "Add to Query Params".
    *   **Logic (`ApiKeyStrategy`):** Based on the user's choice, populate either the `getHeaders` or `getQueryParams` map.
    *   **Conceptual Snippet:**
        ```dart
        enum ApiKeyLocation { header, query }

        class ApiKeyStrategy implements AuthenticationStrategy {
          final String keyName;
          final String keyValue;
          final ApiKeyLocation addTo;
          // ... constructor ...

          @override
          Future<Map<String, String>> getHeaders(RequestDetails request) async {
            return (addTo == ApiKeyLocation.header) ? {keyName: keyValue} : {};
          }

          @override
          Future<Map<String, String>> getQueryParams(RequestDetails request) async {
             return (addTo == ApiKeyLocation.query) ? {keyName: keyValue} : {};
          }
          // ... other interface methods ...
        }
        ```
    *   **Security:** Securely store the API key value.

#### C. Bearer Token Authentication (#612)

*   **How it Works:** Sends an opaque access token (often, but not always, a JWT) prefixed with "Bearer " in the `Authorization` header.
*   **Implementation:**
    *   **UI:** A primary field for the "Token". An optional field for "Prefix" (defaulting to `Bearer`).
    *   **Logic (`BearerTokenStrategy`):** Construct the `Authorization` header string.
    *   **Conceptual Snippet:**
        ```dart
        class BearerTokenStrategy implements AuthenticationStrategy {
          final String token;
          final String prefix; // Defaults to 'Bearer'
          // ... constructor ...

           @override
          Future<Map<String, String>> getHeaders(RequestDetails request) async {
            return {'Authorization': '$prefix $token'};
          }
          // ... other interface methods ...
        }
        ```
    *   **Security:** Securely store the token. This strategy often works in conjunction with OAuth 2.0 flows which *obtain* the token.

#### D. JWT Bearer Token Generation (#613)

*   **How it Works:** Generates a JWT locally based on user configuration, signs it, and then typically sends it using the Bearer Token mechanism.
*   **Implementation:**
    *   **UI:** Fields for "Signing Algorithm" (e.g., HS256, RS256), "Secret" (for HMAC) or "Private Key" (for RSA/ECDSA), JSON editors for "Header Claims" and "Payload Claims", optional "Expiry" duration.
    *   **Logic (`JwtBearerStrategy`):**
        *   Integrate a reliable Dart JWT library (e.g., `dart_jsonwebtoken`).
        *   Parse the JSON claims from the UI.
        *   Securely retrieve the secret or private key.
        *   Use the library to sign the JWT with the specified algorithm.
        *   The generated token will then likely be passed to the `BearerTokenStrategy` for header inclusion.
    *   **Conceptual Snippet (Illustrative):**
        ```dart
        import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart'; // Example library

        // Inside JwtBearerStrategy or a dedicated service
        String generateAndSignToken(Map<String, dynamic> payload, Map<String, dynamic> header, String secretOrKey, SigningAlgorithm alg) {
          try {
            final jwt = JWT(payload, header: header);
            final key = (alg == SigningAlgorithm.HS256) ? SecretKey(secretOrKey) : RsaPrivateKey(secretOrKey); // Simplified example
            final token = jwt.sign(key, algorithm: alg, expiresIn: Duration(hours: 1)); // Add expiry logic
            return token;
          } catch (e) {
             // Handle signing errors
             print("JWT Signing Error: $e");
             return '';
          }
        }
        ```
    *   **Security:** Secure storage and handling of secrets/private keys are critical. Support for various key formats might be needed.

#### E. Digest Authentication (#614)

*   **How it Works:** A more secure challenge-response alternative to Basic Auth. Requires two requests. The server challenges with a `nonce`; the client computes a hash using username, password, nonce, realm, URI, etc., and sends it back.
*   **Implementation:**
    *   **UI:** Fields for "Username" and "Password". Algorithm choice might be needed if servers support multiple (e.g., MD5, SHA-256).
    *   **Logic (`DigestAuthStrategy`):** This requires state management between requests.
        1.  Make the initial request.
        2.  If a 401 response with `WWW-Authenticate: Digest ...` is received, parse the challenge parameters (nonce, realm, qop, algorithm).
        3.  Securely retrieve username/password.
        4.  Calculate required hashes (HA1, HA2, response) using `dart:crypto` based on the digest algorithm and parameters provided by the server.
        5.  Construct the `Authorization: Digest ...` header containing username, realm, nonce, uri, response hash, cnonce, nc, qop, etc.
        6.  The `AuthenticationManager` would need to coordinate resending the *original* request but with the *newly generated* Digest header. This likely involves modifying the request *after* the first attempt fails with a 401 Digest challenge.

#### F. OAuth 1.0 (#615)

*   **How it Works:** An older, complex protocol involving request signing and multiple steps to obtain access tokens.
*   **Implementation:**
    *   **UI:** Fields for "Consumer Key", "Consumer Secret", "Signature Method" (e.g., HMAC-SHA1), "Callback URL", "Request Token URL", "Authorize URL", "Access Token URL". Potentially fields for storing obtained "Token" and "Token Secret".
    *   **Logic (`OAuth1Strategy`):**
        *   Utilize a Dart OAuth 1.0 library if a well-maintained one exists (e.g., `package:oauth1`), otherwise implement the core signing logic.
        *   Handle the 3-legged flow: Request temporary credentials -> Redirect user for authorization -> Handle callback -> Exchange for access tokens.
        *   Implement request signing: Construct the base string, generate the signature using the appropriate keys and method, and add the `Authorization: OAuth ...` header with all required parameters (consumer key, token, signature method, signature, timestamp, nonce, version).

#### G. OAuth 2.0 (#481)

*   **How it Works:** The modern standard, offering various "grant types" for different scenarios.
*   **Implementation:**
    *   **UI:**
        *   Dropdown for "Grant Type" (Authorization Code, Client Credentials, Resource Owner Password Credentials are common; Implicit is less secure).
        *   Conditional fields based on grant type:
            *   *All:* "Access Token URL", "Client ID", "Client Secret", "Scope".
            *   *Auth Code:* "Authorization URL", "Redirect URI". Add PKCE options (Code Challenge Method: S256/plain, Code Verifier).
            *   *Password:* "Username", "Password".
        *   Button: "Get New Access Token" / "Request Authorization".
        *   Display area for received Access Token, Refresh Token, Expiry.
    *   **Logic (`OAuth2Strategy` & Manager):**
        *   **Authorization Code (with PKCE):**
            1.  Generate `code_verifier` and `code_challenge`.
            2.  Construct Authorization URL (including `response_type=code`, client ID, redirect URI, scope, state, `code_challenge`, `code_challenge_method`).
            3.  Launch embedded webview (using `package:webview_flutter` or similar) or external browser to the Authorization URL.
            4.  Intercept the redirect to the specified `redirect_uri` to capture the `code` (and `state`).
            5.  Make a secure backend POST request to the Access Token URL (`grant_type=authorization_code`, `code`, `redirect_uri`, client ID, client secret, `code_verifier`).
            6.  Parse the JSON response for `access_token`, `refresh_token`, `expires_in`. Securely store them.
        *   **Client Credentials:** Direct POST to Access Token URL (`grant_type=client_credentials`, client ID, client secret, scope).
        *   **Password Credentials:** Direct POST to Access Token URL (`grant_type=password`, username, password, client ID, client secret, scope). *Use sparingly due to security risks.*
        *   **Token Handling:** Automatically attach the stored `access_token` (usually as a Bearer token) to subsequent requests. Implement automatic token refresh using the `refresh_token` when an API call returns a 401/unauthorized error potentially due to expiry.
    *   **Libraries:** Consider using libraries like `package:oauth2_client` or platform-specific interaction packages (`flutter_appauth`) to handle the browser/webview interaction part of the Authorization Code flow.

### User Interface Design

The user experience will be streamlined:

*   A distinct "Authorization" tab will be added to the request editing panel.
*   A primary dropdown will list all supported authentication types, starting with "No Auth".
*   Selecting an auth type will dynamically reveal a tailored configuration panel below it, containing only the necessary fields for that specific method.
*   Visual cues will clearly indicate which authentication method is currently active for the request.
*   OAuth flows will have dedicated buttons ("Get New Access Token", "Refresh Token") with clear feedback (loading states, success/error messages) during the process.

### Secure Credential Management

Security is paramount when handling credentials:

*   We will utilize `package:flutter_secure_storage` as the primary mechanism. This package leverages native secure storage: Keychain on iOS/macOS, Keystore on Android, libsecret on Linux, and Credential Vault on Windows.
*   No sensitive information (passwords, secrets, tokens) will ever be stored in plain text in less secure storage like Hive's regular boxes or SharedPreferences.
*   UI elements like password fields will be masked.
*   Care will be taken to prevent credentials from leaking into application logs during debugging or normal operation.

### Testing Strategy

Rigorous testing is essential for authentication features:

*   **Unit Tests:** Each `AuthenticationStrategy` class will have unit tests verifying its core logic (e.g., correct header formatting, Base64 encoding, hash calculations, basic JWT signing logic). Dependencies like secure storage will be mocked.
*   **Integration Tests:**
    *   Mock HTTP servers (using `package:http_mock_adapter` or similar) will simulate API endpoints requiring different authentication methods.
    *   Tests will cover the full workflow: selecting and configuring an auth method in the UI -> triggering a request -> verifying that the `AuthenticationManager` calls the correct strategy -> asserting that the mock server receives the request with the expected authentication credentials (headers/params).
    *   Specific integration tests will target the complexities of OAuth flows, mocking the authorization and token endpoints to simulate the handshake.

### Security Best Practices Adherence

Throughout development, we will adhere to security best practices:

*   Defaulting to and encouraging HTTPS.
*   Implementing secure storage correctly and consistently.
*   Sanitizing any user input that forms part of authentication credentials or requests.
*   Providing user guidance on secure practices.

### Documentation

Clear documentation is vital:

*   The API Dash User Guide will be updated with comprehensive sections explaining how to set up, configure, and use each new authentication method.
*   Developer-focused documentation within the codebase will explain the `AuthenticationStrategy` interface and the overall authentication architecture, facilitating future contributions.
*   Security recommendations will be included for users.

### Deliverables

Upon completion, this project will deliver:

1.  Fully implemented and tested Dart classes for Basic, API Key, Bearer Token, JWT Bearer, Digest Auth, OAuth 1.0, and OAuth 2.0 authentication.
2.  Seamlessly integrated UI components within API Dash for configuration.
3.  Secure credential storage implementation.
4.  A comprehensive suite of unit and integration tests.
5.  Updated and thorough user and developer documentation.

4. Weekly Timeline: A rough week-wise timeline of activities that you would undertake.

**4. Weekly Timeline:**
**(Coding Period - 12 Weeks)**

*   **Week 1: Foundation & Basic Auth**
    *   **Goal:** Implement the core authentication manager and the first simple method.
    *   **Activities:**
        *   Solidify the `AuthenticationManager` Riverpod provider.
        *   Integrate `flutter_secure_storage` for basic secure saving/loading of credentials (create helper functions/service).
        *   Implement the `BasicAuthStrategy` class and its logic.
        *   Develop the UI panel for configuring Basic Authentication (username, masked password fields).
        *   Integrate the Basic Auth UI into the main request editor's authorization section.
        *   Write unit tests for `BasicAuthStrategy` logic.

*   **Week 2: API Key & Bearer Token**
    *   **Goal:** Implement two more common and relatively straightforward methods.
    *   **Activities:**
        *   Implement the `ApiKeyStrategy` class (handling both header and query param options).
        *   Develop the UI panel for API Key configuration.
        *   Implement the `BearerTokenStrategy` class.
        *   Develop the UI panel for Bearer Token configuration.
        *   Write unit tests for both strategies.
        *   Start setting up basic integration tests using mock HTTP servers to verify header/param injection.

*   **Week 3: JWT Bearer Generation**
    *   **Goal:** Implement local JWT generation and signing.
    *   **Activities:**
        *   Integrate the chosen Dart JWT library (e.g., `dart_jsonwebtoken`).
        *   Implement the `JwtBearerStrategy` class, focusing on the token generation logic based on UI inputs.
        *   Develop the UI panel for JWT configuration (algorithms, claims editors, secret/key input - ensure secure handling in UI).
        *   Connect the generated JWT to the `BearerTokenStrategy` flow.
        *   Write unit tests for the JWT generation and signing logic.

*   **Week 4: Digest Auth - Part 1 (Challenge Parsing & Hashing)**
    *   **Goal:** Tackle the initial complexity of Digest Auth.
    *   **Activities:**
        *   Implement logic to parse the `WWW-Authenticate: Digest ...` header received in a 401 response.
        *   Implement the core hashing functions (HA1, HA2, response) using `dart:crypto` based on parsed parameters.
        *   Develop the UI panel for Digest Auth configuration (username, password).
        *   Structure the state management needed within the `AuthenticationManager` to handle the two-step process.

*   **Week 5: Digest Auth - Part 2 (Completion & Testing)**
    *   **Goal:** Finalize Digest Auth flow and testing.
    *   **Activities:**
        *   Implement the logic to construct the `Authorization: Digest ...` header.
        *   Integrate the request resend mechanism (likely coordinated by the `AuthenticationManager`).
        *   Write unit tests covering hash calculations and state transitions.
        *   Write integration tests using a mock server that sends the 401 Digest challenge and expects the correct authorization header on the second request.

*   **Week 6: OAuth 1.0 - Initial Setup & Signing**
    *   **Goal:** Begin implementation of the complex OAuth 1.0 protocol.
    *   **Activities:**
        *   Evaluate/Integrate a suitable Dart OAuth 1.0 library or implement core request signing logic (base string, signature generation for HMAC-SHA1 initially).
        *   Implement the basic `OAuth1Strategy` structure.
        *   Develop the initial UI panel for OAuth 1.0 configuration (consumer keys, secrets, URLs, etc.).
        *   Write unit tests for the request signing mechanism.
        *   *Mid-term Checkpoint:* Consolidate progress, ensure existing features are stable, update documentation for completed parts.

*   **(Midterm Evaluation Period)**

*   **Week 7: OAuth 1.0 - Flow & Testing**
    *   **Goal:** Implement the multi-step OAuth 1.0 flow.
    *   **Activities:**
        *   Implement the logic for the 3-legged flow (requesting temporary credentials, handling authorization redirect simulation/mocking, exchanging for access tokens).
        *   Refine request signing to include access tokens.
        *   Write more comprehensive unit and integration tests for the flow.

*   **Week 8: OAuth 2.0 - Foundation & Simpler Grants**
    *   **Goal:** Set up OAuth 2.0 structure and implement non-interactive grant types.
    *   **Activities:**
        *   Implement the basic `OAuth2Strategy` structure and integrate with the `AuthenticationManager`.
        *   Develop the core UI panel for OAuth 2.0, including the Grant Type dropdown and conditional fields.
        *   Implement the **Client Credentials** grant type flow.
        *   Implement the **Resource Owner Password Credentials** grant type flow (with UI warnings).
        *   Write unit tests for these grant flows.

*   **Week 9: OAuth 2.0 - Authorization Code Flow (Part 1)**
    *   **Goal:** Implement the user-interactive part of the most common OAuth 2.0 flow.
    *   **Activities:**
        *   Implement PKCE (Proof Key for Code Exchange) helper functions (`code_verifier`, `code_challenge`).
        *   Integrate a webview or platform-specific browser launching mechanism.
        *   Implement logic to construct the Authorization URL and launch the webview/browser.
        *   Implement logic to intercept and parse the redirect URI to capture the authorization `code`.

*   **Week 10: OAuth 2.0 - Authorization Code Flow (Part 2) & Token Refresh**
    *   **Goal:** Complete the Auth Code flow and implement token management.
    *   **Activities:**
        *   Implement the backend request to exchange the authorization `code` for access/refresh tokens.
        *   Integrate secure storage for OAuth 2.0 tokens.
        *   Implement the automatic Refresh Token flow (detect 401, use refresh token, update stored tokens, retry original request).
        *   Thoroughly test the complete Authorization Code and Refresh Token flows using mock servers.

*   **Week 11: Comprehensive Testing & Refinement**
    *   **Goal:** Ensure robustness and address edge cases across all methods.
    *   **Activities:**
        *   Focus heavily on writing comprehensive integration tests for all implemented authentication flows.
        *   Test various scenarios: invalid credentials, expired tokens, network errors during OAuth flows, different server configurations.
        *   Refine the UI/UX based on testing and usability feedback. Address any inconsistencies.
        *   Review and improve error handling and user feedback messages.

*   **Week 12: Documentation, Polish & Final Submission Prep**
    *   **Goal:** Finalize the project deliverables.
    *   **Activities:**
        *   Write detailed user documentation for configuring and using each authentication method in the API Dash User Guide.
        *   Finalize developer documentation within the code (comments, explaining the architecture).
        *   Perform final code cleanup, refactoring, and address any remaining TODOs.
        *   Conduct a final round of testing.
        *   Prepare the final code submission and project summary report for GSoC.
