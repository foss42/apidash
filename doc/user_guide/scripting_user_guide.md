# APIDash Scripting: Using the `ad` Object

APIDash allows you to write JavaScript code that runs either **before** a request is sent (pre-request script) or **after** a response is received (post-response script). These scripts give you powerful control over the request/response lifecycle and allow for automation, dynamic data manipulation, and basic testing.

The primary way to interact with APIDash data and functionality within these scripts is through the global `ad` object. This object provides structured access to request data, response data, environment variables, and logging utilities.


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

## Scripting Assertions

APIDash provides a comprehensive assertion library for validating API responses in your post-response scripts. Assertions help you verify that your API behaves as expected by checking status codes, headers, response times, data types, and more.

The `assert()` function creates an assertion chain that allows you to perform fluent, chainable validations. When an assertion fails, it throws an error that is captured by APIDash and displayed in the terminal.

### Basic Assertion Syntax

```javascript
assert(value).method(expected);
```

All assertion methods return the assertion chain, allowing you to chain multiple checks:

```javascript
assert(value).isNumber().greaterThan(0).lessThan(100);
```

---

### A. Status Code Assertions

Validate HTTP status codes to ensure your API returns the expected response status.

#### Examples

**Check for successful response (200):**

```javascript
assert(ad.response.status).equals(200);
```

**Verify status is not an error:**

```javascript
assert(ad.response.status).notEquals(500);
assert(ad.response.status).notEquals(404);
```

**Check status is in success range (2xx):**

```javascript
assert(ad.response.status).greaterThan(199);
assert(ad.response.status).lessThan(300);
```

**Ensure created status (201):**

```javascript
assert(ad.response.status).equals(201);
ad.console.log("Resource created successfully!");
```

**Verify redirect status (3xx  range):**

```javascript
assert(ad.response.status).greaterThanOrEqual(300);
assert(ad.response.status).lessThan(400);
```

---

### B. Header Assertions

Validate response headers to ensure proper content types, authentication tokens, caching directives, and more.

#### Examples

**Check if header exists:**

```javascript
const contentType = ad.response.getHeader("content-type");
assert(contentType).isString();
```

**Verify header contains expected value:**

```javascript
const contentType = ad.response.getHeader("content-type");
assert(contentType).contains("application/json");
```

**Check exact header value:**

```javascript
const cacheControl = ad.response.getHeader("cache-control");
assert(cacheControl).equals("no-cache");
```

**Validate authentication header exists:**

```javascript
const authHeader = ad.response.getHeader("x-auth-token");
assert(authHeader).isString();
ad.environment.set("sessionToken", authHeader);
```

**Verify CORS header:**

```javascript
const corsHeader = ad.response.getHeader("access-control-allow-origin");
assert(corsHeader).contains("*");
```

---

### C. Performance Assertions

Monitor API performance by validating response times to ensure your endpoints meet performance requirements.

#### Examples

**Ensure response time is under threshold:**

```javascript
assert(ad.response.time).lessThan(500);
ad.console.log(`Response time: ${ad.response.time}ms - within acceptable range`);
```

**Check for fast response:**

```javascript
assert(ad.response.time).lessThan(100);
ad.console.log("Lightning fast response!");
```

**Track performance across requests:**

```javascript
const currentTime = ad.response.time;
const lastTime = parseFloat(ad.environment.get("lastResponseTime") || "0");

if (lastTime > 0) {
  const difference = currentTime - lastTime;
  ad.console.log(`Performance change: ${difference > 0 ? '+' : ''}${difference}ms`);
}

ad.environment.set("lastResponseTime", currentTime.toString());
assert(currentTime).lessThan(1000);
```

**Verify consistent performance:**

```javascript
const maxResponseTime = 300;
assert(ad.response.time).lessThanOrEqual(maxResponseTime);
ad.console.log(`Response completed in ${ad.response.time}ms (target: <${maxResponseTime}ms)`);
```

---

### D. Required Field Assertions

Ensure that required fields exist in JSON responses, validating the structure of your API responses.

#### Examples

**Check for required top-level keys:**

```javascript
const response = ad.response.json();
assert(response).hasKey("data");
assert(response).hasKey("status");
assert(response).hasKey("message");
```

**Validate nested object structure:**

```javascript
const response = ad.response.json();
assert(response).hasKey("data");
assert(response.data).hasKey("user");
assert(response.data.user).hasKey("id");
assert(response.data.user).hasKey("email");
```

**Verify array response structure:**

```javascript
const response = ad.response.json();
assert(response).hasKey("results");
assert(response.results).isArray();
assert(response.results).hasLength(10);
```

**Check pagination fields:**

```javascript
const response = ad.response.json();
assert(response).hasKey("pagination");
assert(response.pagination).hasKey("page");
assert(response.pagination).hasKey("total");
assert(response.pagination).hasKey("limit");
```

**Validate error response structure:**

```javascript
if (ad.response.status >= 400) {
  const response = ad.response.json();
  assert(response).hasKey("error");
  assert(response.error).hasKey("code");
  assert(response.error).hasKey("message");
}
```

---

### E. Data Type Assertions

Verify that response values match expected data types to ensure data consistency and prevent type-related bugs.

#### Examples

**Validate numeric fields:**

```javascript
const response = ad.response.json();
assert(response.id).isNumber();
assert(response.count).isNumber();
assert(response.price).isNumber();
```

**Check string fields:**

```javascript
const response = ad.response.json();
assert(response.name).isString();
assert(response.email).isString();
assert(response.description).isString();
```

**Verify boolean flags:**

```javascript
const response = ad.response.json();
assert(response.isActive).isBoolean();
assert(response.verified).isBoolean();
```

**Validate object type:**

```javascript
const response = ad.response.json();
assert(response.user).isObject();
assert(response.settings).isObject();
```

**Check array type:**

```javascript
const response = ad.response.json();
assert(response.items).isArray();
assert(response.tags).isArray();
```

**Validate null values:**

```javascript
const response = ad.response.json();
assert(response.deletedAt).isNull();
```

**Combined type and value checks:**

```javascript
const response = ad.response.json();
assert(response.id).isNumber().greaterThan(0);
assert(response.status).isString().equals("active");
assert(response.items).isArray().hasLength(5);
```

---

### F. Complete Assertion Examples

Here are comprehensive examples demonstrating how to use assertions in real-world scenarios.

#### Example 1: User Creation Validation

```javascript
// Validate user creation response
assert(ad.response.status).equals(201);

const response = ad.response.json();
assert(response).hasKey("user");
assert(response.user).hasKey("id");
assert(response.user).hasKey("email");
assert(response.user).hasKey("createdAt");

assert(response.user.id).isNumber().greaterThan(0);
assert(response.user.email).isString().contains("@");
assert(response.user.createdAt).isString();

ad.console.log("User creation validated successfully!");
ad.environment.set("newUserId", response.user.id.toString());
```

#### Example 2: API List Response Validation

```javascript
// Validate paginated list response
assert(ad.response.status).equals(200);
assert(ad.response.time).lessThan(500);

const contentType = ad.response.getHeader("content-type");
assert(contentType).contains("application/json");

const response = ad.response.json();
assert(response).hasKey("data");
assert(response).hasKey("pagination");

assert(response.data).isArray();
assert(response.pagination).hasKey("page");
assert(response.pagination).hasKey("total");

assert(response.pagination.page).isNumber();
assert(response.pagination.total).isNumber();

ad.console.log(`Validated ${response.data.length} items on page ${response.pagination.page}`);
```

#### Example 3: Error Response Validation

```javascript
// Validate error handling
assert(ad.response.status).equals(400);

const response = ad.response.json();
assert(response).hasKey("error");
assert(response.error).hasKey("code");
assert(response.error).hasKey("message");

assert(response.error.code).isString();
assert(response.error.message).isString().contains("invalid");

ad.console.log("Error response structure validated");
```

#### Example 4: Performance and Data Quality Check

```javascript
// Combined performance and data validation
assert(ad.response.status).equals(200);
assert(ad.response.time).lessThan(300);

const response = ad.response.json();
assert(response).hasKey("items");
assert(response.items).isArray();

response.items.forEach(function(item, index) {
  assert(item).hasKey("id");
  assert(item).hasKey("name");
  assert(item.id).isNumber().greaterThan(0);
  assert(item.name).isString();
});

ad.console.log(`Validated ${response.items.length} items in ${ad.response.time}ms`);
```

---

### Available Assertion Methods

Here's a complete reference of all available assertion methods:

#### Equality Assertions
- **`equals(expected)`** - Asserts that the value equals the expected value
- **`notEquals(expected)`** - Asserts that the value does not equal the expected value

#### Numeric Comparisons
- **`greaterThan(expected)`** - Asserts that the value is greater than expected (requires numbers)
- **`lessThan(expected)`** - Asserts that the value is less than expected (requires numbers)
- **`greaterThanOrEqual(expected)`** - Asserts that the value is ≥ expected
- **`lessThanOrEqual(expected)`** - Asserts that the value is ≤ expected

#### String Assertions
- **`contains(substring)`** - Asserts that the string contains the substring

#### Object/Array Assertions
- **`hasKey(key)`** - Asserts that the object has the specified key
- **`hasLength(expected)`** - Asserts that the array or string has the expected length

#### Type Assertions
- **`isNumber()`** - Asserts that the value is a number
- **`isString()`** - Asserts that the value is a string
- **`isBoolean()`** - Asserts that the value is a boolean
- **`isObject()`** - Asserts that the value is an object (not array or null)
- **`isArray()`** - Asserts that the value is an array
- **`isNull()`** - Asserts that the value is null
- **`isUndefined()`** - Asserts that the value is undefined

#### Truthy/Falsy Assertions
- **`isTruthy()`** - Asserts that the value is truthy
- **`isFalsy()`** - Asserts that the value is falsy

---

### Best Practices

1. **Start with critical assertions**: Always validate status codes and response structure first
2. **Use descriptive console logs**: Add `ad.console.log()` statements to track successful validations
3. **Chain related assertions**: Keep related checks together for better readability
4. **Handle errors gracefully**: Consider checking conditions before asserting if you need custom error messages
5. **Test performance consistently**: Track response times across multiple runs to identify trends
6. **Validate data types**: Always check types before performing operations on values
7. **Store validated data**: After successful assertions, store important values in environment variables for use in subsequent requests

---

### Error Handling

When an assertion fails, it throws an error that APIDash captures and displays in the terminal. The error message clearly indicates what was expected versus what was received.

Example error output:
```
Assertion failed: expected 404 to equal 200
Assertion failed: expected "text/html" to contain "application/json"
Assertion failed: expected 1524 to be less than 500
```

You can catch assertion errors manually if you need custom behavior:

```javascript
try {
  assert(ad.response.status).equals(200);
  ad.console.log("Status check passed!");
} catch (error) {
  ad.console.error("Status check failed:", error.message);
  // Optionally do something else, like set a flag
  ad.environment.set("lastRequestFailed", "true");
}
```

---

