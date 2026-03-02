# APIDash Scripting: Using the `ad` Object

APIDash allows you to write JavaScript code that runs either **before** a request is sent (pre-request script) or **after** a response is received (post-response script). These scripts give you powerful control over the request/response lifecycle and allow for automation, dynamic data manipulation, and basic testing.

The primary way to interact with APIDash data and functionality within these scripts is through the global `ad` object. This object provides structured access to request data, response data, environment variables, and logging utilities.

> [!NOTE]
> When you first open the **Pre-request** or **Post-response** script tabs, the editor might appear completely empty without any placeholder or hint text (this is a known UI limitation). To get started quickly, you can use the following example to verify it's working:
> ```javascript
> // Use JavaScript to modify this request dynamically
> ad.console.log("Hello from APIDash Scripting!");
> ```


## `ad.request` (Available in Pre-request Scripts Only)

Use `ad.request` to inspect and modify the request *before* it is sent.

### `ad.request.headers`

Manage request headers. Headers are stored internally as an array of objects: `[{name: "Header-Name", value: "HeaderValue"}, ...]`. Note that header name comparisons in these helper methods are **case-sensitive**.

*   **`ad.request.headers.set(key: string, value: string)`**
    *   Adds a new header or updates the value of the *first* existing header with the exact same `key`. Ensures the `value` is converted to a string.
    *   Example:
        ```javascript
        // Set an Authorization header
        let token = ad.environment.get("authToken");
        if (token) {
          ad.request.headers.set("Authorization", "Bearer " + token);
        }

        // Update User-Agent
        ad.request.headers.set("User-Agent", "APIDash-Script/1.0");
        ```

*   **`ad.request.headers.get(key: string): string | undefined`**
    *   Retrieves the value of the *first* header matching the `key`. Returns `undefined` if not found.
    *   Example:
        ```javascript
        let contentType = ad.request.headers.get("Content-Type");
        if (!contentType) {
          ad.console.log("Content-Type header is not set yet.");
        }
        ```

*   **`ad.request.headers.remove(key: string)`**
    *   Removes *all* headers matching the exact `key`.
    *   Example:
        ```javascript
        // Remove default Accept header if it exists
        ad.request.headers.remove("Accept");
        ```

*   **`ad.request.headers.has(key: string): boolean`**
    *   Checks if at least one header with the exact `key` exists.
    *   Example:
        ```javascript
        if (!ad.request.headers.has("X-Request-ID")) {
          ad.request.headers.set("X-Request-ID", Date.now()); // Simple example ID
        }
        ```

*   **`ad.request.headers.clear()`**
    *   Removes all request headers.
    *   Example:
        ```javascript
        // Start with a clean slate for headers (use with caution)
        // ad.request.headers.clear();
        // ad.request.headers.set("Authorization", "..."); // Add back essential ones
        ```

### `ad.request.params`

Manage URL query parameters. Parameters are stored internally as an array of objects: `[{name: "paramName", value: "paramValue"}, ...]`. Parameter name comparisons are **case-sensitive**.

*   **`ad.request.params.set(key: string, value: string)`**
    *   Adds a new query parameter or updates the value of the *first* existing parameter with the exact same `key`. Ensures the `value` is converted to a string.
    *   *Note:* HTTP allows duplicate query parameter keys. This `set` method replaces the first match or adds a new one. If you need duplicates, you might need to manipulate the underlying `request.params` array directly (use with care) or call `set` multiple times if the backend handles updates correctly.
    *   Example:
        ```javascript
        // Add or update a timestamp parameter
        ad.request.params.set("ts", Date.now().toString());

        // Set a user ID from the environment
        let userId = ad.environment.get("activeUserId");
        if (userId) {
            ad.request.params.set("userId", userId);
        }
        ```

*   **`ad.request.params.get(key: string): string | undefined`**
    *   Retrieves the value of the *first* parameter matching the `key`. Returns `undefined` if not found.
    *   Example:
        ```javascript
        let existingFilter = ad.request.params.get("filter");
        ad.console.log("Current filter:", existingFilter);
        ```

*   **`ad.request.params.remove(key: string)`**
    *   Removes *all* parameters matching the exact `key`.
    *   Example:
        ```javascript
        // Remove any debug flags before sending
        ad.request.params.remove("debug");
        ```

*   **`ad.request.params.has(key: string): boolean`**
    *   Checks if at least one parameter with the exact `key` exists.
    *   Example:
        ```javascript
        if (!ad.request.params.has("page")) {
          ad.request.params.set("page", "1");
        }
        ```

*   **`ad.request.params.clear()`**
    *   Removes all query parameters.
    *   Example:
        ```javascript
        // Clear existing params if rebuilding the query string
        // ad.request.params.clear();
        // ad.request.params.set("newParam", "value");
        ```

### `ad.request.url`

Access or modify the entire request URL.

*   **`ad.request.url.get(): string`**
    *   Returns the current request URL string.
    *   Example:
        ```javascript
        let currentUrl = ad.request.url.get();
        ad.console.log("Request URL before modification:", currentUrl);
        ```

*   **`ad.request.url.set(newUrl: string)`**
    *   Sets the request URL to the provided `newUrl` string.
    *   Example:
        ```javascript
        let baseUrl = ad.environment.get("apiBaseUrl");
        let resourcePath = "/users/me";
        if (baseUrl) {
          ad.request.url.set(baseUrl + resourcePath);
        }
        ```

### `ad.request.body`

Access or modify the request body.

*   **`ad.request.body.get(): string | null | undefined`**
    *   Returns the current request body as a string. For `multipart/form-data`, this might return an empty or non-representative string; use `request.formData` (accessed directly for now, potential future `ad.request.formData` helpers) for structured form data.
    *   Example:
        ```javascript
        let bodyContent = ad.request.body.get();
        ad.console.log("Current body:", bodyContent);
        ```

*   **`ad.request.body.set(newBody: string | object, contentType?: string)`**
    *   Sets the request body.
    *   If `newBody` is an object, it's automatically `JSON.stringify`-ed.
    *   If `newBody` is not an object, it's converted to a string.
    *   **Content-Type Handling:**
        *   If you provide the optional `contentType` argument (e.g., 'application/xml'), that value is used.
        *   If `contentType` is *not* provided:
            *   Defaults to `application/json` if `newBody` was an object.
            *   Defaults to `text/plain` otherwise.
        *   The calculated `Content-Type` is automatically added as a request header *unless* a `Content-Type` header already exists (case-insensitive check).
    *   **Side Effect:** Setting the body via this method will clear any existing `request.formData` entries, as they are mutually exclusive with a raw string/JSON body in the APIDash model. It also updates the internal `request.bodyContentType`.
    *   Example:
        ```javascript
        // Set a JSON body
        let userData = { name: "Test User", email: "test@example.com" };
        ad.request.body.set(userData); // Automatically sets Content-Type: application/json if not already set

        // Set a plain text body
        ad.request.body.set("This is plain text content.", "text/plain");

        // Set an XML body (Content-Type needed)
        let xmlString = "<user><name>Test</name></user>";
        ad.request.body.set(xmlString, "application/xml");
        ```
### `ad.request.query`

  * Access or modify the GraphQL query string. This applies specifically to GraphQL requests, where the body typically includes a `query`, `variables`, and optionally `operationName`.

* **`ad.request.query.get(): string`**

  * Returns the current GraphQL query string (query, mutation, or subscription). If not set, returns an empty string.
  * Example:

    ```javascript
    let gqlQuery = ad.request.query.get();
    ad.console.log("Current GraphQL query:", gqlQuery);
    ```

* **`ad.request.query.set(newQuery: string)`**

  * Sets the GraphQL query string.
  * Automatically sets the `Content-Type` header to `application/json` unless it's already set, ensuring correct handling by GraphQL servers.
  * Does **not** set the entire request body, it is up to the user to include the full GraphQL payload inside the query. (e.g., `{ query, variables, operationName }`).
  * Example:

    ```javascript
    let newQuery = `
      query {
         user(id: 1) {
            id
            username
            email
            address {
              geo {
                lat
                lng
              }
            } 
        }
    }`;
    ad.request.query.set(newQuery);
    ```

* **`ad.request.query.clear()`**

  * Clears the current GraphQL query string by setting it to an empty string.
  * Example:

    ```javascript
    ad.request.query.clear();
    ```

### `ad.request.method`

Access or modify the HTTP request method (verb).

*   **`ad.request.method.get(): string`**
    *   Returns the current request method (e.g., "get", "post"). Usually lowercase.
    *   Example:
        ```javascript
        let method = ad.request.method.get();
        ad.console.log("Request method:", method);
        ```

*   **`ad.request.method.set(newMethod: string)`**
    *   Sets the request method. The provided `newMethod` string will be converted to lowercase (e.g., "PUT" becomes "put").
    *   Example:
        ```javascript
        // Change method based on environment setting
        let usePatch = ad.environment.get("usePatchForUpdates");
        if (ad.request.method.get() === "put" && usePatch) {
          ad.request.method.set("PATCH");
        }
        ```

## `ad.response` (Available in Post-response Scripts Only)

Use `ad.response` to access details of the response received from the server. This object is **read-only**.

*   **`ad.response.status: number | undefined`**
    *   The HTTP status code (e.g., `200`, `404`).
    *   Example:
        ```javascript
        if (ad.response.status === 201) {
          ad.console.log("Resource created successfully!");
        } else if (ad.response.status >= 400) {
          ad.console.error("Request failed with status:", ad.response.status);
        }
        ```

*   **`ad.response.body: string | undefined`**
    *   The response body as a string. For binary responses, this might be decoded text or potentially garbled data depending on the Content-Type and encoding. Use `bodyBytes` for raw data.
    *   Example:
        ```javascript
        let responseText = ad.response.body;
        if (responseText && responseText.includes("error")) {
          ad.console.warn("Response body might contain an error message.");
        }
        ```

*   **`ad.response.formattedBody: string | undefined`**
    *   The response body pre-formatted by APIDash (e.g., pretty-printed JSON). Useful for logging structured data clearly.
    *   Example:
        ```javascript
        ad.console.log("Formatted Response Body:\n", ad.response.formattedBody);
        ```

*   **`ad.response.bodyBytes: number[] | undefined`**
    *   The raw response body as an array of byte values (integers 0-255). Useful for binary data, but be mindful of potential performance/memory impact for very large responses. Depends on Dart correctly serializing `Uint8List` to `List<int>`.
    *   Example:
        ```javascript
        let bytes = ad.response.bodyBytes;
        if (bytes) {
          ad.console.log(`Received ${bytes.length} bytes.`);
          // You might perform checks on byte sequences, e.g., magic numbers for file types
          // if (bytes[0] === 0x89 && bytes[1] === 0x50 && bytes[2] === 0x4E && bytes[3] === 0x47) {
          //    ad.console.log("Looks like a PNG file.");
          // }
        }
        ```

*   **`ad.response.time: number | undefined`**
    *   The approximate time taken for the request-response cycle, in **milliseconds**.
    *   Example:
        ```javascript
        let duration = ad.response.time;
        if (duration !== undefined) {
          ad.console.log(`Request took ${duration.toFixed(2)} ms.`);
          if (duration > 1000) {
            ad.console.warn("Request took longer than 1 second.");
          }
        }
        ```

*   **`ad.response.headers: object | undefined`**
    *   An object containing the response headers. Header names are typically **lowercase** (due to processing by the underlying HTTP client). Values are strings.
    *   Example:
        ```javascript
        let headers = ad.response.headers;
        if (headers) {
          ad.console.log("Response Content-Type:", headers['content-type']); // Access using lowercase key
          ad.console.log("Response Date Header:", headers.date);
        }
        ```

*   **`ad.response.requestHeaders: object | undefined`**
    *   An object containing the headers that were actually *sent* with the request. Useful for debugging or verification. Header names are typically **lowercase**.
    *   Example:
        ```javascript
        let sentHeaders = ad.response.requestHeaders;
        if (sentHeaders) {
            ad.console.log("Sent User-Agent:", sentHeaders['user-agent']);
        }
        ```

*   **`ad.response.json(): object | undefined`**
    *   Attempts to parse the `ad.response.body` as JSON.
    *   Returns the parsed JavaScript object/array if successful.
    *   Returns `undefined` if the body is empty or parsing fails (an error message is automatically logged to the APIDash console via `ad.console.error` in case of failure).
    *   Example:
        ```javascript
        let jsonData = ad.response.json();
        if (jsonData && jsonData.data && jsonData.data.token) {
          ad.console.log("Found token in response.");
          ad.environment.set("sessionToken", jsonData.data.token);
        } else if (jsonData) {
          ad.console.log("Parsed JSON, but expected structure not found.");
        }
        ```

*   **`ad.response.getHeader(key: string): string | undefined`**
    *   Retrieves a specific response header's value. The lookup is **case-insensitive**.
    *   Example:
        ```javascript
        // These are equivalent because of case-insensitivity:
        let contentType = ad.response.getHeader("Content-Type");
        let contentTypeLower = ad.response.getHeader("content-type");
        ad.console.log("Response Content-Type (case-insensitive get):", contentType);

        let correlationId = ad.response.getHeader("X-Correlation-ID");
        if (correlationId) {
            ad.environment.set("lastCorrelationId", correlationId);
        }
        ```

## `ad.environment` (Available in Pre & Post-response Scripts)

Use `ad.environment` to get, set, or remove variables within the currently active APIDash environment. Changes made here persist after the script runs and can be used by subsequent requests or other scripts using the same environment.

*   **`ad.environment.get(key: string): any`**
    *   Retrieves the value of the environment variable named `key`. Returns `undefined` if not found.
    *   Example:
        ```javascript
        let apiUrl = ad.environment.get("baseUrl");
        let apiKey = ad.environment.get("apiKey");
        ad.console.log("Using API URL:", apiUrl);
        ```

*   **`ad.environment.set(key: string, value: any)`**
    *   Sets an environment variable named `key` to the given `value`. The `value` should be JSON-serializable (string, number, boolean, object, array, null).
    *   Example:
        ```javascript
        // In a post-response script after login:
        let responseData = ad.response.json();
        if (responseData && responseData.access_token) {
          ad.environment.set("oauthToken", responseData.access_token);
          ad.environment.set("tokenExpiry", Date.now() + (responseData.expires_in * 1000));
          ad.console.log("OAuth token saved to environment.");
        }

        // Store complex object
        ad.environment.set("userProfile", { id: 123, name: "Default User"});
        ```

*   **`ad.environment.unset(key: string)`**
    *   Removes the environment variable named `key`.
    *   Example:
        ```javascript
        // Clear temporary token after use or logout
        ad.environment.unset("sessionToken");
        ad.console.log("Session token cleared.");
        ```

*   **`ad.environment.has(key: string): boolean`**
    *   Checks if an environment variable named `key` exists.
    *   Example:
        ```javascript
        if (!ad.environment.has("userId")) {
          ad.console.warn("Environment variable 'userId' is not set.");
          // Maybe set a default or fetch it?
          // ad.environment.set("userId", "default-001");
        }
        ```

*   **`ad.environment.clear()`**
    *   Removes *all* variables from the active environment. Use with extreme caution!
    *   Example:
        ```javascript
        // Usually used for resetting state during testing, careful!
        // ad.environment.clear();
        // ad.console.warn("Cleared all variables in the active environment!");
        ```

## `ad.console` (Available in Pre & Post-response Scripts)

Use `ad.console` to log messages to the APIDash console tab for the corresponding request. This is essential for debugging your scripts.

*   **`ad.console.log(...args: any[])`**
    *   Logs informational messages. Accepts multiple arguments, which will be JSON-stringified and displayed in the console.
    *   Example:
        ```javascript
        ad.console.log("Starting pre-request script...");
        let user = ad.environment.get("currentUser");
        ad.console.log("Current user from environment:", user);
        ad.console.log("Request URL is:", ad.request.url.get(), "Method:", ad.request.method.get());
        ```

*   **`ad.console.warn(...args: any[])`**
    *   Logs warning messages. Typically displayed differently (e.g., yellow background) in the console.
    *   Example:
        ```javascript
        if (!ad.environment.has("apiKey")) {
          ad.console.warn("API Key environment variable is missing!");
        }
        let responseTime = ad.response.time;
        if (responseTime && responseTime > 2000) {
            ad.console.warn("Request took over 2 seconds:", responseTime, "ms");
        }
        ```

*   **`ad.console.error(...args: any[])`**
    *   Logs error messages. Typically displayed prominently (e.g., red background) in the console. Also used internally by methods like `ad.response.json()` on failure.
    *   Example:
        ```javascript
        if (ad.response.status >= 500) {
          ad.console.error("Server error detected!", "Status:", ad.response.status);
          ad.console.error("Response Body:", ad.response.body);
        }
        try {
          // Some operation that might fail
          let criticalValue = ad.response.json().mustExist;
        } catch (e) {
          ad.console.error("Script failed to process response:", e.toString(), e.stack);
        }
        ```

### Key Notes:
1. **Pre/Post Script Context**
   - Request manipulation only works in pre-request scripts
   - Response access only works in post-response scripts

2. **Environment Variables**
   - Use `{{VAR_NAME}}` syntax in values for automatic substitution
   - Changes to environment variables persist for subsequent requests

3. **Data Types**
   - All values are converted to strings when set in headers/params
   - Use `ad.request.body.set()` with objects for proper JSON handling

4. **Error Handling**
   ```javascript
   try {
     // Potentially error-prone operations
   } catch(e) {
     ad.console.error('Operation failed:', e.message)
     // Optionally re-throw to abort request
     throw e
   }
   ```

5. **Best Practices**
   - Always check for existence before accessing values
   - Use environment variables for sensitive data
   - Clean up temporary variables with `ad.environment.unset()`
   - Use logging strategically to track script execution

### Example Workflow

### Example 1: Post-request - Extract Data and Check Status

```javascript
// Post-response Script

// Set URL: https://api.apidash.dev/auth/login
// 1. Check response status
if (ad.response.status < 200 || ad.response.status >= 300) {
  ad.console.error(`Request failed with status ${ad.response.status}.`);
  ad.console.error("Response:", ad.response.body);
  // Optional: Could clear a related environment variable on failure
  // ad.environment.unset("last_successful_item_id");
  return; // Stop processing if status indicates failure
}

ad.console.log(`Request successful with status ${ad.response.status}.`);
ad.console.log(`Took ${ad.response.time} ms.`);

// 2. Try to parse JSON response
const data = ad.response.json();

// 3. Extract and store data if available
if (data && data.access_token) {
  ad.environment.set("current_session_id", data.access_token);
  ad.console.log("Session ID saved to environment.");
} else {
  ad.console.warn("Could not find 'access_token' in the response JSON.");
}
```

### Example 2: Pre-request - Set Auth Header

```javascript
// Pre-request Script

// Set URL : https://api.apidash.dev/profile
// 1. Get Auth token from environment
const token = ad.environment.get("access_token");
if (token) {
  ad.request.headers.set("Authorization", `Bearer ${token}`);
  ad.console.log("Authorization header set.");
} else {
  ad.console.warn("API token not found in environment!");
}

// 2. Try to parse JSON response
const data = ad.response.json();

// 3. Extract and store final User if available
if (data && data.user && data.user.id) {
    ad.environment.set("logged_in_user_id", data.user.id);
    ad.console.log(`User ID ${data.user.id} saved to environment.`);
}
```

### Example 3: Cookie Management (Login & Session)

APIDash does not have a separate "Cookies" tab. However, you can easily manage cookies using scripts by extracting them from a response and passing them to subsequent requests via environment variables.

**Post-response Script (e.g., on a Login request):**

```javascript
// 1. Extract the Set-Cookie header from the response
// The lookup is case-insensitive
const setCookieHeader = ad.response.getHeader("Set-Cookie");

if (setCookieHeader) {
  // 2. Save the cookie to an environment variable
  // Note: Depending on the server, you might need to parse this string
  // if you only want a specific cookie (e.g., "session_id=123; HttpOnly" -> "session_id=123")
  ad.environment.set("session_cookie", setCookieHeader.split(';')[0]);
  ad.console.log("Session cookie saved to environment:", ad.environment.get("session_cookie"));
} else {
  ad.console.warn("No Set-Cookie header found in the response.");
}
```

**Pre-request Script (for subsequent authenticated requests):**

```javascript
// 1. Retrieve the saved cookie from the environment
const sessionCookie = ad.environment.get("session_cookie");

if (sessionCookie) {
  // 2. Set it as the Cookie header for the outgoing request
  ad.request.headers.set("Cookie", sessionCookie);
  ad.console.log("Cookie header set for request.");
} else {
  ad.console.warn("No session cookie found in environment.");
}
```

*Tip: Instead of a pre-request script, you can also simply add a header in the UI with the name `Cookie` and the value `{{session_cookie}}` to achieve the same result.*

---

## Testing and Assertions

You can use post-response scripts to test your APIs automatically. Check status codes, validate response structures, and verify your endpoints behave as expected.

### Basic Assertions

#### Example 1: Check Status Codes

```javascript
// Simple status check
if (ad.response.status !== 200) {
  ad.console.error(`Expected 200, got ${ad.response.status}`);
  ad.environment.set("test_status", "FAILED");
  return;
}

ad.console.log("Status check passed");
ad.environment.set("test_status", "PASSED");
```

#### Example 2: Verify Headers

```javascript
// Check for expected headers
const contentType = ad.response.getHeader("Content-Type");
if (!contentType || !contentType.includes("application/json")) {
  ad.console.error("Missing or wrong Content-Type header");
}

const corsHeader = ad.response.getHeader("Access-Control-Allow-Origin");
if (!corsHeader) {
  ad.console.warn("CORS header not found");
}

ad.console.log("Header checks complete");
```

#### Example 3: Performance Checks

```javascript
// Make sure response is fast enough
const maxTime = 500; // milliseconds

if (ad.response.time > maxTime) {
  ad.console.warn(`Slow response: ${ad.response.time}ms`);
} else {
  ad.console.log(`Response time OK: ${ad.response.time}ms`);
}

// Save for tracking
ad.environment.set("last_response_time", ad.response.time);
```

### Checking JSON Responses

#### Example 4: Verify Required Fields

```javascript
// Check response has the fields we need
const data = ad.response.json();

if (!data) {
  ad.console.error("Failed to parse JSON");
  return;
}

const required = ["id", "name", "email", "createdAt"];
const missing = required.filter(field => !(field in data));

if (missing.length > 0) {
  ad.console.error(`Missing fields: ${missing.join(", ")}`);
} else {
  ad.console.log("All required fields found");
}
```

#### Example 5: Check Data Types

```javascript
// Verify data types are correct
const data = ad.response.json();

if (typeof data.id !== "number") {
  ad.console.error("id should be a number");
}

if (typeof data.name !== "string") {
  ad.console.error("name should be a string");
}

if (!Array.isArray(data.tags)) {
  ad.console.error("tags should be an array");
}

ad.console.log("Type validation complete");
```

#### Example 6: Validate Values

```javascript
// Check data values make sense
const data = ad.response.json();

if (data.age && (data.age < 0 || data.age > 150)) {
  ad.console.error("Age looks wrong: " + data.age);
}

if (data.price && data.price < 0) {
  ad.console.error("Price can't be negative");
}

// Verify email format
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
if (data.email && !emailRegex.test(data.email)) {
  ad.console.error("Invalid email: " + data.email);
}
```

### Running Multiple Tests

#### Example 7: Complete Test for an Endpoint

```javascript
// Test a user creation endpoint thoroughly
const data = ad.response.json();
let passed = 0;
let failed = 0;

function check(name, condition) {
  if (condition) {
    ad.console.log("✓ " + name);
    passed++;
  } else {
    ad.console.error("✗ " + name);
    failed++;
  }
}

// Run all checks
check("Status is 201", ad.response.status === 201);
check("Response under 1s", ad.response.time < 1000);
check("Content-Type is JSON", 
  ad.response.getHeader("Content-Type")?.includes("application/json"));

if (data) {
  check("Has id field", "id" in data);
  check("Has username field", "username" in data);
  check("Has email field", "email" in data);
  check("id is string", typeof data.id === "string");
  check("email format valid", /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email));
  check("password not exposed", !("password" in data));
  
  // Save the ID for next request
  if (data.id) {
    ad.environment.set("user_id", data.id);
  }
}

// Summary
const total = passed + failed;
const rate = total > 0 ? Math.round((passed / total) * 100) : 0;
ad.console.log(`\n${passed}/${total} tests passed (${rate}%)`);
ad.environment.set("test_result", failed === 0 ? "PASSED" : "FAILED");
```

### Chaining Requests

#### Example 8: Multi-Step Test Flow

```javascript
// Test flow: login -> fetch user -> update user
const step = ad.environment.get("test_step") || "login";

if (step === "login") {
  if (ad.response.status === 200) {
    const data = ad.response.json();
    if (data?.token) {
      ad.environment.set("auth_token", data.token);
      ad.environment.set("test_step", "fetch_user");
      ad.console.log("Login OK, moving to next step");
    }
  }
} 
else if (step === "fetch_user") {
  if (ad.response.status === 200) {
    const data = ad.response.json();
    if (data?.id) {
      ad.environment.set("user_id", data.id);
      ad.environment.set("test_step", "update_user");
      ad.console.log("User fetched, moving to update");
    }
  }
} 
else if (step === "update_user") {
  if (ad.response.status === 200) {
    ad.environment.set("test_step", "complete");
    ad.console.log("All steps passed!");
  }
}
```

### Advanced Testing

These patterns help with contract testing, regression detection, and integration with AI tools.

#### Example 9: Verify API Contract

```javascript
// Make sure API matches expected contract
const data = ad.response.json();

// Check status
if (ad.response.status !== 200) {
  ad.console.error(`Wrong status: ${ad.response.status}`);
}

// Check content type
if (!ad.response.getHeader("Content-Type")?.includes("json")) {
  ad.console.error("Wrong content type");
}

// Check required fields
const required = ["id", "name", "status"];
required.forEach(field => {
  if (!(field in data)) {
    ad.console.error(`Missing field: ${field}`);
  }
});

// Check field types
if (typeof data.id !== "number") {
  ad.console.error("id should be number");
}

if (typeof data.name !== "string") {
  ad.console.error("name should be string");
}

// Check allowed values
const validStatuses = ["active", "inactive", "pending"];
if (!validStatuses.includes(data.status)) {
  ad.console.error(`Invalid status: ${data.status}`);
}
```

#### Example 10: Detect Changes

```javascript
// Compare with a previous baseline
const baseline = JSON.parse(ad.environment.get("baseline") || "{}");
const current = {
  status: ad.response.status,
  time: ad.response.time,
  fields: Object.keys(ad.response.json() || {}).sort()
};

// Check for differences
if (baseline.status && baseline.status !== current.status) {
  ad.console.warn(`Status changed: ${baseline.status} -> ${current.status}`);
}

if (baseline.time && current.time > baseline.time * 1.5) {
  ad.console.warn(`Response much slower: ${baseline.time}ms -> ${current.time}ms`);
}

if (baseline.fields) {
  const removed = baseline.fields.filter(f => !current.fields.includes(f));
  const added = current.fields.filter(f => !baseline.fields.includes(f));
  
  if (removed.length > 0) {
    ad.console.error(`Fields removed: ${removed.join(", ")}`);
  }
  if (added.length > 0) {
    ad.console.log(`New fields: ${added.join(", ")}`);
  }
}

// Save new baseline if needed
if (ad.environment.get("save_baseline") === "true") {
  ad.environment.set("baseline", JSON.stringify(current));
  ad.environment.unset("save_baseline");
  ad.console.log("Baseline updated");
}
```

### Tips for Testing

1. **Be specific with test names** - Clear descriptions make failures easy to understand and debug
2. **Use environment variables** - Store test results to chain tests, track state, or generate reports  
3. **Test one thing at a time** - Focused tests are easier to debug when they fail
4. **Always check for null/undefined** - Verify data exists before accessing properties to avoid script errors
5. **Track performance over time** - Monitor response times and set degradation alerts
6. **Include security checks** - Verify sensitive data (passwords, tokens) isn't leaked in responses
7. **Handle edge cases** - Test empty arrays, null values, missing fields, and error responses
8. **Use try-catch blocks** - Prevent one failing test from stopping all others
9. **Log meaningful messages** - Include actual vs expected values in error messages
10. **Document your tests** - Add comments explaining what each test validates and why it matters

### Error Handling

```javascript
// Handle missing data and errors
const data = ad.response.json();

if (!data) {
  ad.console.error("No response body");
  return;
}

if (data.error) {
  ad.console.error(`API error: ${data.error}`);
  return;
}

// Validate error status codes
if (ad.response.status >= 400) {
  if (data.stack_trace) {
    ad.console.error("Stack trace exposed - security issue!");
  }
  return;
}

// Handle arrays
if (Array.isArray(data) && data.length > 0) {
  ad.console.log(`Received ${data.length} items`);
}
```

### Security Testing

```javascript
// Check for exposed sensitive data
const data = ad.response.json();
const sensitive = ["password", "password_hash", "secret", "private_key"];

sensitive.forEach(field => {
  if (field in data) {
    ad.console.error(`SECURITY: ${field} exposed!`);
  }
});

// Validate token
if (data.token) {
  if (data.token.length < 20) {
    ad.console.warn("Token too short");
  }
  ad.environment.set("auth_token", data.token);
}

// Check security headers
const headers = ["Strict-Transport-Security", "X-Content-Type-Options"];
headers.forEach(h => {
  if (!ad.response.getHeader(h)) {
    ad.console.warn(`Missing security header: ${h}`);
  }
});
```

### Real-World Test Scenarios

#### Login Flow Testing

```javascript
// Complete login validation
const data = ad.response.json();

// Status check
if (ad.response.status !== 200) {
  ad.console.error(`Login failed with status ${ad.response.status}`);
  
  if (ad.response.status === 401) {
    ad.console.log("Invalid credentials");
  } else if (ad.response.status === 429) {
    ad.console.log("Rate limited - too many attempts");
  }
  
  return;
}

// Required fields
const required = ["access_token", "refresh_token", "expires_in"];
const missing = required.filter(field => !(field in data));

if (missing.length > 0) {
  ad.console.error(`Missing required fields: ${missing.join(", ")}`);
  return;
}

// Save tokens
ad.environment.set("access_token", data.access_token);
ad.environment.set("refresh_token", data.refresh_token);

// Calculate expiry
const expiresAt = Date.now() + (data.expires_in * 1000);
ad.environment.set("token_expires_at", expiresAt);

// Optional user info
if (data.user) {
  ad.environment.set("user_id", data.user.id);
  ad.environment.set("user_email", data.user.email);
  ad.console.log(`Logged in as ${data.user.email}`);
}

ad.console.log("✓ Login successful, tokens saved");
```

#### Pagination Testing

```javascript
// Test paginated API responses
const data = ad.response.json();

// Check pagination metadata
const pagination = {
  total: parseInt(ad.response.getHeader("X-Total-Count") || "0"),
  page: parseInt(ad.response.getHeader("X-Page") || "1"),
  perPage: parseInt(ad.response.getHeader("X-Per-Page") || "20")
};

if (pagination.total > 0) {
  const expectedPages = Math.ceil(pagination.total / pagination.perPage);
  ad.console.log(`Total items: ${pagination.total}, Pages: ${expectedPages}`);
  
  // Verify we're not on an invalid page
  if (pagination.page > expectedPages) {
    ad.console.error("Page number exceeds total pages");
  }
}

// Validate data array
if (!Array.isArray(data)) {
  ad.console.error("Response should be an array");
  return;
}

// Check expected page size
if (data.length > pagination.perPage) {
  ad.console.error(`Too many items: ${data.length} > ${pagination.perPage}`);
}

// Save next page info
if (pagination.page < Math.ceil(pagination.total / pagination.perPage)) {
  ad.environment.set("next_page", pagination.page + 1);
  ad.console.log(`Next page available: ${pagination.page + 1}`);
} else {
  ad.environment.unset("next_page");
  ad.console.log("Last page reached");
}
```

#### CRUD Operation Testing

```javascript
// Test POST/PUT responses for resource creation/update
const data = ad.response.json();

// Check appropriate status codes
const expectedStatus = ad.request.method.get() === "post" ? 201 : 200;
if (ad.response.status !== expectedStatus) {
  ad.console.error(`Expected ${expectedStatus}, got ${ad.response.status}`);
}

// Verify returned resource
if (!data.id) {
  ad.console.error("Response should include resource ID");
  return;
}

// For POST: Save the created resource ID
if (ad.request.method.get() === "post") {
  ad.environment.set("created_resource_id", data.id);
  ad.console.log(`Created resource with ID: ${data.id}`);
}

// Check timestamps
if (data.created_at) {
  const created = new Date(data.created_at);
  if (isNaN(created.getTime())) {
    ad.console.error("Invalid created_at timestamp");
  }
}

if (data.updated_at) {
  const updated = new Date(data.updated_at);
  if (isNaN(updated.getTime())) {
    ad.console.error("Invalid updated_at timestamp");
  }
  
  // For updates, updated_at should be recent
  const ageMinutes = (Date.now() - updated.getTime()) / (1000 * 60);
  if (ageMinutes > 5) {
    ad.console.warn("updated_at seems old - was resource actually updated?");
  }
}

ad.console.log("✓ CRUD operation validated");
```

### Working with AI Tools

AI agents like Dashbot can generate and execute these test scripts. Structure your output for easy parsing:

#### Structured Test Results

```javascript
// Comprehensive test result structure for AI agents
const testRun = {
  timestamp: new Date().toISOString(),
  endpoint: ad.request.url.get(),
  method: ad.request.method.get(),
  status: ad.response.status,
  responseTime: ad.response.time,
  tests: [],
  summary: {
    total: 0,
    passed: 0,
    failed: 0,
    warnings: 0
  }
};

function test(name, condition, severity = "error") {
  testRun.summary.total++;
  
  const result = {
    name: name,
    passed: condition,
    severity: severity
  };
  
  if (condition) {
    testRun.summary.passed++;
    ad.console.log(`✓ ${name}`);
  } else {
    if (severity === "warning") {
      testRun.summary.warnings++;
      ad.console.warn(`⚠ ${name}`);
    } else {
      testRun.summary.failed++;
      ad.console.error(`✗ ${name}`);
    }
  }
  
  testRun.tests.push(result);
  return condition;
}

// Run tests
test("Status is 200", ad.response.status === 200);
test("Response under 500ms", ad.response.time < 500, "warning");

const data = ad.response.json();
test("Valid JSON", data !== undefined);

if (data) {
  test("Has id field", "id" in data);
  test("Has name field", "name" in data);
  test("id is correct type", typeof data.id === "number");
}

// Calculate pass rate
testRun.summary.passRate = testRun.summary.total > 0 
  ? Math.round((testRun.summary.passed / testRun.summary.total) * 100)
  : 0;

// Save for AI agent
ad.environment.set("test_results", JSON.stringify(testRun));
ad.environment.set("last_test_passed", testRun.summary.passed);
ad.environment.set("last_test_failed", testRun.summary.failed);
ad.environment.set("last_pass_rate", testRun.summary.passRate);

// Log summary
ad.console.log(`\n📊 Summary: ${testRun.summary.passed}/${testRun.summary.total} passed (${testRun.summary.passRate}%)`);

if (testRun.summary.warnings > 0) {
  ad.console.log(`⚠ ${testRun.summary.warnings} warnings`);
}
```

#### Test Orchestration for AI Agents

```javascript
// Multi-endpoint test orchestration
const testSuite = ad.environment.get("test_suite") || "start";

if (testSuite === "start") {
  // First test: Health check
  if (ad.response.status === 200) {
    ad.environment.set("test_suite", "auth");
    ad.environment.set("health_check", "PASSED");
    ad.console.log("✓ Health check passed, proceeding to auth");
  } else {
    ad.environment.set("test_suite", "failed");
    ad.console.error("✗ Health check failed, stopping test suite");
  }
}
else if (testSuite === "auth") {
  // Second test: Authentication
  const data = ad.response.json();
  if (data?.token) {
    ad.environment.set("auth_token", data.token);
    ad.environment.set("test_suite", "crud");
    ad.console.log("✓ Auth successful, proceeding to CRUD tests");
  } else {
    ad.environment.set("test_suite", "failed");
    ad.console.error("✗ Auth failed, stopping test suite");
  }
}
else if (testSuite === "crud") {
  // Third test: CRUD operations
  const data = ad.response.json();
  if (data?.id) {
    ad.environment.set("resource_id", data.id);
    ad.environment.set("test_suite", "cleanup");
    ad.console.log("✓ CRUD test passed, proceeding to cleanup");
  } else {
    ad.environment.set("test_suite", "failed");
    ad.console.error("✗ CRUD test failed");
  }
}
else if (testSuite === "cleanup") {
  // Final test: Cleanup
  if (ad.response.status === 204) {
    ad.environment.set("test_suite", "complete");
    ad.console.log("✓ All tests completed successfully!");
    
    // Generate final report
    const report = {
      suite: "complete",
      tests: ["health", "auth", "crud", "cleanup"],
      allPassed: true,
      completedAt: new Date().toISOString()
    };
    ad.environment.set("test_suite_report", JSON.stringify(report));
  }
}
```

#### Contract Validation for AI

```javascript
// AI-friendly contract validation with detailed reporting
function validateContract(response, contract) {
  const violations = [];
  
  // Validate status
  if (response.status !== contract.expectedStatus) {
    violations.push({
      type: "status",
      expected: contract.expectedStatus,
      actual: response.status
    });
  }
  
  // Validate headers
  if (contract.requiredHeaders) {
    contract.requiredHeaders.forEach(header => {
      const value = ad.response.getHeader(header);
      if (!value) {
        violations.push({
          type: "header",
          field: header,
          message: "Required header missing"
        });
      }
    });
  }
  
  // Validate body structure
  const data = ad.response.json();
  if (contract.requiredFields && data) {
    contract.requiredFields.forEach(field => {
      if (!(field in data)) {
        violations.push({
          type: "field",
          field: field,
          message: "Required field missing"
        });
      }
    });
  }
  
  // Validate types
  if (contract.fieldTypes && data) {
    Object.entries(contract.fieldTypes).forEach(([field, expectedType]) => {
      if (field in data) {
        const actualType = Array.isArray(data[field]) ? "array" : typeof data[field];
        if (actualType !== expectedType) {
          violations.push({
            type: "type",
            field: field,
            expected: expectedType,
            actual: actualType
          });
        }
      }
    });
  }
  
  return violations;
}

// Define contract (could be loaded from environment)
const contract = {
  expectedStatus: 200,
  requiredHeaders: ["Content-Type"],
  requiredFields: ["id", "name", "email"],
  fieldTypes: {
    id: "number",
    name: "string",
    email: "string",
    isActive: "boolean"
  }
};

// Run validation
const violations = validateContract(ad.response, contract);

if (violations.length === 0) {
  ad.console.log("✓ Contract validation passed");
  ad.environment.set("contract_status", "PASSED");
} else {
  ad.console.error(`✗ Contract validation failed with ${violations.length} violations`);
  violations.forEach(v => {
    ad.console.error(`  ${v.type}: ${v.field || "general"} - ${v.message || `expected ${v.expected}, got ${v.actual}`}`);
  });
  ad.environment.set("contract_status", "FAILED");
  ad.environment.set("contract_violations", JSON.stringify(violations));
}
```

#### AI Agent Patterns and Conventions

For best integration with AI tools, follow these conventions:

**Environment Variable Naming:**
- `test_status` - Overall test result ("PASSED" / "FAILED")
- `test_results` - JSON string with full test details
- `tests_passed` - Number of passed tests
- `tests_failed` - Number of failed tests
- `test_step` - Current step in multi-request flow
- `[feature]_test` - Specific test results (e.g., `auth_test`, `validation_test`)

**Standard Test Output:**
```javascript
// Minimal structure AI agents expect
const result = {
  passed: 0,
  failed: 0,
  status: "PASSED",  // or "FAILED"
  errors: []
};

// Always set these after tests
ad.environment.set("test_status", result.status);
ad.environment.set("tests_passed", result.passed);
ad.environment.set("tests_failed", result.failed);
```

**Error Reporting:**
```javascript
// Structured error reporting
const errors = [];

if (someCondition) {
  errors.push({
    test: "validation_check",
    message: "Expected value X, got Y",
    severity: "error",
    field: "email"
  });
}

if (errors.length > 0) {
  ad.environment.set("test_errors", JSON.stringify(errors));
  errors.forEach(e => ad.console.error(`${e.test}: ${e.message}`));
}
```

Use standard variable names like `test_status`, `tests_passed`, `tests_failed`, and `test_results` so AI agents know where to look for test outcomes and can make decisions based on them.