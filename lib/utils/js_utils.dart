const String kJSSetupScript = r"""
// === APIDash Setup Script ===

// --- 1. Parse Injected Data ---
// These variables are expected to be populated by Dart before this script runs.
// Example: const injectedRequestJson = '{"method":"get", "url":"...", ...}';

let request = {}; // Will hold the RequestModel data
let response = {}; // Will hold the ResponseModel data (only for post-request)
let environment = {}; // Will hold the *active* environment variables as a simple {key: value} map

// Note: Using 'let' because environment might be completely cleared/reassigned by ad.environment.clear().

try {
    // 'injectedRequestJson' should always be provided
    if (typeof injectedRequestJson !== 'undefined' && injectedRequestJson) {
        request = JSON.parse(injectedRequestJson);
        // Ensure essential arrays exist if they are null/undefined after parsing
        request.headers = request.headers || [];
        request.params = request.params || [];
        request.formData = request.formData || [];
    } else {
        sendMessage('consoleError', JSON.stringify(['Setup Error: injectedRequestJson is missing or empty.']));
    }

    // 'injectedResponseJson' is only for post-response scripts
    if (typeof injectedResponseJson !== 'undefined' && injectedResponseJson) {
        response = JSON.parse(injectedResponseJson);
        // Ensure response headers map exists
        response.headers = response.headers || {};
        response.requestHeaders = response.requestHeaders || {};
    }

    // 'injectedEnvironmentJson' should always be provided
    if (typeof injectedEnvironmentJson !== 'undefined' && injectedEnvironmentJson) {
        const parsedEnvData = JSON.parse(injectedEnvironmentJson);

        environment = {}; // Initialize the target simple map

        if (parsedEnvData && Array.isArray(parsedEnvData.values)) {
            parsedEnvData.values.forEach(variable => {
                // Check if the variable object is valid and enabled
                if (variable && typeof variable === 'object' && variable.enabled === true && typeof variable.key === 'string') {
                    // Add the key-value pair to our simplified 'environment' map
                    environment[variable.key] = variable.value;
                }
            });
            // sendMessage('consoleLog', JSON.stringify(['Successfully parsed environment variables.']));
        } else {
            // Log a warning if the structure is not as expected, but continue with an empty env
            sendMessage('consoleWarn', JSON.stringify([
                'Setup Warning: injectedEnvironmentJson does not have the expected structure ({values: Array}). Using an empty environment.',
                'Received Data:', parsedEnvData // Log received data for debugging
            ]));
            environment = {}; // Ensure it's an empty object
        }

    } else {
        sendMessage('consoleError', JSON.stringify(['Setup Error: injectedEnvironmentJson is missing or empty.']));
        environment = {}; // Initialize to empty object to avoid errors later
    }

} catch (e) {
    // Send error back to Dart if parsing fails catastrophically
    sendMessage('fatalError', JSON.stringify({
        message: 'Failed to parse injected JSON data.',
        error: e.toString(),
        stack: e.stack
    }));
    // Optionally, re-throw to halt script execution immediately
    // throw new Error('Failed to parse injected JSON data: ' + e.toString());
}


// --- 2. Define APIDash Helper (`ad`) Object ---
// This object provides functions to interact with the request, response,
// environment, and the Dart host application.

const ad = {
    /**
     * Functions to modify the request object *before* it is sent.
     * Only available in pre-request scripts.
     * Changes are made directly to the 'request' JS object.
     */
    request: {
        /**
         * Access and modify request headers. Remember header names are case-insensitive in HTTP,
         * but comparisons here might be case-sensitive unless handled carefully.
         * Headers are represented as an array of objects: [{name: string, value: string}, ...]
         */
        headers: {
            /**
             * Adds or updates a header. If a header with the same name (case-sensitive)
             * already exists, it updates its value. Otherwise, adds a new header.
             * Also updates the isHeaderEnabledList to include {true} by default
             * @param {string} key The header name.
             * @param {string} value The header value.
             * @param {boolean} isHeaderEnabledList value.
             */
            set: (key, value) => {
                if (!request || typeof request !== 'object' || !Array.isArray(request.headers)) return;
                if (typeof key !== 'string') return;

                const stringValue = String(value);
                const existingHeaderIndex = request.headers.findIndex(
                    h => typeof h === 'object' && h.name === key
                );

                if (!Array.isArray(request.isHeaderEnabledList)) {
                    request.isHeaderEnabledList = [];
                }

                if (existingHeaderIndex > -1) {
                    request.headers[existingHeaderIndex].value = stringValue;
                    request.isHeaderEnabledList[existingHeaderIndex] = true;
                } else {
                    request.headers.push({
                        name: key,
                        value: stringValue
                    });
                    request.isHeaderEnabledList.push(true);
                }
            },
            /**
             * Gets the value of the first header matching the key (case-sensitive).
             * @param {string} key The header name.
             * @returns {string|undefined} The header value or undefined if not found.
             */

            get: (key) => {
                if (!request || typeof request !== 'object' || !Array.isArray(request.headers)) return undefined;
                const header = request.headers.find(h => typeof h === 'object' && h.name === key);
                return header ? header.value : undefined;
            },

            /**
             * Removes all headers with the given name (case-sensitive).
             * @param {string} key The header name to remove.
             */

            remove: (key) => {
                if (!request || typeof request !== 'object' || !Array.isArray(request.headers)) return;

                if (!Array.isArray(request.isHeaderEnabledList)) {
                    request.isHeaderEnabledList = [];
                }

                const indicesToRemove = [];
                request.headers.forEach((h, index) => {
                    if (typeof h === 'object' && h.name === key) {
                        indicesToRemove.push(index);
                    }
                });

                // Remove from end to start to prevent index shifting
                for (let i = indicesToRemove.length - 1; i >= 0; i--) {
                    const idx = indicesToRemove[i];
                    request.headers.splice(idx, 1);
                    request.isHeaderEnabledList.splice(idx, 1);
                }
            },
            /**
             * Checks if a header with the given name exists (case-sensitive).
             * @param {string} key The header name.
             * @returns {boolean} True if the header exists, false otherwise.
             */

            has: (key) => {
                if (!request || typeof request !== 'object' || !Array.isArray(request.headers)) return false;
                return request.headers.some(h => typeof h === 'object' && h.name === key);
            },
            /**
             * Clears all request headers along with isHeaderEnabledList.
             */

            clear: () => {
                if (!request || typeof request !== 'object') return;
                request.headers = [];
                request.isHeaderEnabledList = [];
            }
        },

        /**
         * Access and modify URL query parameters.
         * Params are represented as an array of objects: [{name: string, value: string}, ...]
         */
        params: {
            /**
             * Adds or updates a query parameter. If a param with the same name (case-sensitive)
             * already exists, it updates its value. Use multiple times for duplicate keys if needed by server.
             * Consider URL encoding implications - values should likely be pre-encoded if necessary.
             * @param {string} key The parameter name.
             * @param {string} value The parameter value.
             */
            set: (key, value) => {
                if (!request || typeof request !== 'object' || !Array.isArray(request.params)) return;
                if (typeof key !== 'string') return;

                const stringValue = String(value);

                if (!Array.isArray(request.isParamEnabledList)) {
                    request.isParamEnabledList = [];
                }

                const existingParamIndex = request.params.findIndex(p => typeof p === 'object' && p.name === key);

                if (existingParamIndex > -1) {
                    request.params[existingParamIndex].value = stringValue;
                    request.isParamEnabledList[existingParamIndex] = true;
                } else {
                    request.params.push({
                        name: key,
                        value: stringValue
                    });
                    request.isParamEnabledList.push(true);
                }
            },
            /**
             * Gets the value of the first query parameter matching the key (case-sensitive).
             * @param {string} key The parameter name.
             * @returns {string|undefined} The parameter value or undefined if not found.
             */
            get: (key) => {
                if (!request || typeof request !== 'object' || !Array.isArray(request.params)) return undefined; // Safety check
                const param = request.params.find(p => typeof p === 'object' && p.name === key);
                return param ? param.value : undefined;
            },
            /**
             * Removes all query parameters with the given name (case-sensitive).
             * @param {string} key The parameter name to remove.
             */
            remove: (key) => {
                if (!request || typeof request !== 'object' || !Array.isArray(request.params)) return;

                if (!Array.isArray(request.isParamEnabledList)) {
                    request.isParamEnabledList = [];
                }

                const indicesToRemove = [];
                request.params.forEach((p, index) => {
                    if (typeof p === 'object' && p.name === key) {
                        indicesToRemove.push(index);
                    }
                });

                for (let i = indicesToRemove.length - 1; i >= 0; i--) {
                    const idx = indicesToRemove[i];
                    request.params.splice(idx, 1);
                    request.isParamEnabledList.splice(idx, 1);
                }
            },
            /**
             * Checks if a query parameter with the given name exists (case-sensitive).
             * @param {string} key The parameter name.
             * @returns {boolean} True if the parameter exists, false otherwise.
             */
            has: (key) => {
                if (!request || typeof request !== 'object' || !Array.isArray(request.params)) return false; // Safety check
                return request.params.some(p => typeof p === 'object' && p.name === key);
            },
            /**
             * Clears all query parameters.
             */
            clear: () => {
                if (!request || typeof request !== 'object') return;
                request.params = [];
                request.isParamEnabledList = [];
            }
        },

        /**
         * Access or modify the request URL.
         */
        url: {
            /**
             * Gets the current request URL string.
             * @returns {string} The URL.
             */
            get: () => {
                return (request && typeof request === 'object') ? request.url : '';
            },
            /**
             * Sets the request URL string.
             * @param {string} newUrl The new URL.
             */
            set: (newUrl) => {
                if (request && typeof request === 'object' && typeof newUrl === 'string') {
                    request.url = newUrl;
                }
            }
            // Future: Could add methods to manipulate parts (host, path, query) if needed
        },

        /**
         * Access or modify the request body.
         */
        body: {
            /**
             * Gets the current request body content (string).
             * Note: For form-data, this returns the raw string body (if any), not the structured data. Use `ad.request.formData` for that.
             * @returns {string|null|undefined} The request body string.
             */
            get: () => {
                return (request && typeof request === 'object') ? request.body : undefined;
            },
            /**
             * Sets the request body content (string).
             * Important: Also updates the Content-Type if setting JSON/Text, unless a Content-Type header is already explicitly set.
             * Setting the body will clear form-data if the content type changes away from form-data.
             * @param {string|object} newBody The new body content. If an object is provided, it's stringified as JSON.
             * @param {string} [contentType] Optionally specify the Content-Type (e.g., 'application/json', 'text/plain'). If not set, defaults to 'text/plain' or 'application/json' if newBody is an object.
             */
            set: (newBody, contentType) => {
                if (!request || typeof request !== 'object') return; // Safety check fix: check !request or typeof !== object

                let finalBody = '';
                let finalContentType = contentType;

                if (typeof newBody === 'object' && newBody !== null) {
                    try {
                        finalBody = JSON.stringify(newBody);
                        finalContentType = contentType || 'application/json'; // Default to JSON if object
                        request.bodyContentType = 'json'; // Update internal model type
                    } catch (e) {
                        sendMessage('consoleError', JSON.stringify(['Error stringifying object for request body:', e.toString()]));
                        return; // Don't proceed if stringify fails
                    }
                } else {
                    finalBody = String(newBody); // Ensure it's a string
                    finalContentType = contentType || 'text/plain'; // Default to text
                    request.bodyContentType = 'text'; // Update internal model type
                }

                request.body = finalBody;

                // Clear form data if we are setting a string/json body
                request.formData = [];

                // Set Content-Type header if not already set by user explicitly in headers
                // Use case-insensitive check for existing Content-Type
                const hasContentTypeHeader = request.headers.some(h => typeof h === 'object' && h.name.toLowerCase() === 'content-type');
                if (!hasContentTypeHeader && finalContentType) {
                    ad.request.headers.set('Content-Type', finalContentType);
                }
            }
            // TODO: Add helpers for request.formData if needed (similar to headers/params)
        },

        
        /**
         * Access and modify GraphQL query string.
         * For GraphQL requests, this represents the query/mutation/subscription.
         */
        query: {
            /**
             * Gets the current GraphQL query string.
             * @returns {string} The GraphQL query.
             */
            get: () => {
                return (request && typeof request === 'object') ? (request.query || '') : '';
            },
            /**
             * Sets the GraphQL query string.
             * @param {string} newQuery The GraphQL query/mutation/subscription.
             */
            set: (newQuery) => {
                if (request && typeof request === 'object' && typeof newQuery === 'string') {
                    request.query = newQuery;
                    ad.request.headers.set('Content-Type', 'application/json');
                }
            },
            /**
             * Clears the GraphQL query.
             */
            clear: () => {
                if (request && typeof request === 'object') {
                    request.query = '';
                }
            }
        },

        /**
         * Access or modify the request method (e.g., 'GET', 'POST').
         */
        method: {
            /**
             * Gets the current request method.
             * @returns {string} The HTTP method (e.g., "get", "post").
             */
            get: () => {
                return (request && typeof request === 'object') ? request.method : '';
            },
            /**
             * Sets the request method.
             * @param {string} newMethod The new HTTP method (e.g., "POST", "put"). Case might matter for the Dart model enum.
             */
            set: (newMethod) => {
                if (request && typeof request === 'object' && typeof newMethod === 'string') {
                    // Consider converting to lowercase to match HTTPVerb enum likely usage
                    request.method = newMethod.toLowerCase();
                }
            }
        }
    },

    /**
     * Read-only access to the response data.
     * Only available in post-response scripts.
     */
    response: {
        /**
         * The HTTP status code of the response.
         * @type {number|undefined}
         */
        get status() {
            return (response && typeof response === 'object') ? response.statusCode : undefined;
        },

        /**
         * The response body as a string. If the response was binary, this might be decoded text
         * based on Content-Type or potentially garbled. Use `bodyBytes` for raw binary data access (if provided).
         * @type {string|undefined}
         */
        get body() {
            return (response && typeof response === 'object') ? response.body : undefined;
        },

        /**
         * The response body automatically formatted (e.g., pretty-printed JSON). Provided by Dart.
         * @type {string|undefined}
         */
        get formattedBody() {
            return (response && typeof response === 'object') ? response.formattedBody : undefined;
        },

        /**
         * The raw response body as an array of bytes (numbers).
         * Note: This relies on the Dart side serializing Uint8List correctly (e.g., as List<int>).
         * Accessing large byte arrays in JS might be memory-intensive.
         * @type {number[]|undefined}
         */
        get bodyBytes() {
            return (response && typeof response === 'object') ? response.bodyBytes : undefined;
        },


        /**
         * The approximate time taken for the request-response cycle. Provided by Dart.
         * Assumes Dart sends it as microseconds and converts it to milliseconds here.
         * @type {number|undefined} Time in milliseconds.
         */
        get time() {
            // Assuming response.time is in microseconds from Dart's DurationConverter
            return (response && typeof response === 'object' && typeof response.time === 'number') ? response.time / 1000 : undefined;
        },

        /**
         * An object containing the response headers (keys are header names, values are header values).
         * Header names are likely lowercase from the http package.
         * @type {object|undefined} e.g., {'content-type': 'application/json', ...}
         */
        get headers() {
            return (response && typeof response === 'object') ? response.headers : undefined;
        },

        /**
         * An object containing the request headers that were actually sent (useful for verification).
         * Header names are likely lowercase.
         * @type {object|undefined} e.g., {'user-agent': '...', ...}
         */
        get requestHeaders() {
            return (response && typeof response === 'object') ? response.requestHeaders : undefined;
        },


        /**
         * Attempts to parse the response body as JSON.
         * @returns {object|undefined} The parsed JSON object, or undefined if parsing fails or body is empty.
         */
        json: () => {
            const bodyContent = ad.response.body; // Assign to variable first
            if (!bodyContent) { // Check the variable
                return undefined;
            }
            try {
                return JSON.parse(bodyContent); // Parse the variable
            } catch (e) {
                ad.console.error("Failed to parse response body as JSON:", e.toString());
                return undefined;
            }
        },

        /**
         * Gets a specific response header value (case-insensitive key lookup).
         * @param {string} key The header name.
         * @returns {string|undefined} The header value or undefined if not found.
         */
        getHeader: (key) => {
            const headers = ad.response.headers;
            if (!headers || typeof key !== 'string') return undefined;
            const lowerKey = key.toLowerCase();
            // Find the key in the headers object case-insensitively
            const headerKey = Object.keys(headers).find(k => k.toLowerCase() === lowerKey);
            return headerKey ? headers[headerKey] : undefined; // Return the value using the found key
        }
    },

    /**
     * Access and modify environment variables for the active environment.
     * Changes are made to the 'environment' JS object (simple {key: value} map)
     * and sent back to Dart. Dart side will need to merge these changes back
     * into the original structured format if needed.
     */
    environment: {
        /**
         * Gets the value of an environment variable from the simplified map.
         * @param {string} key The variable name.
         * @returns {any} The variable value or undefined if not found.
         */
        get: (key) => {
            // Access the simplified 'environment' object directly
            return (environment && typeof environment === 'object') ? environment[key] : undefined;
        },
        /**
         * Sets the value of an environment variable in the simplified map.
         * @param {string} key The variable name.
         * @param {any} value The variable value. Should be JSON-serializable (string, number, boolean, object, array).
         */
        set: (key, value) => {
            if (environment && typeof environment === 'object' && typeof key === 'string') {
                // Modify the simplified 'environment' object
                environment[key] = value;
            }
        },
        /**
         * Removes an environment variable from the simplified map.
         * @param {string} key The variable name to remove.
         */
        unset: (key) => {
            if (environment && typeof environment === 'object') {
                // Modify the simplified 'environment' object
                delete environment[key];
            }
        },
        /**
         * Checks if an environment variable exists in the simplified map.
         * @param {string} key The variable name.
         * @returns {boolean} True if the variable exists, false otherwise.
         */
        has: (key) => {
            // Check the simplified 'environment' object
            return (environment && typeof environment === 'object') ? environment.hasOwnProperty(key) : false;
        },
        /**
         * Removes all variables from the simplified environment map scope.
         */
        clear: () => {
            if (environment && typeof environment === 'object') {
                // Clear the simplified 'environment' object
                for (const key in environment) {
                    if (environment.hasOwnProperty(key)) {
                        delete environment[key];
                    }
                }
                // Alternatively, just reassign: environment = {};
            }
        }
        // Note: A separate 'globals' object could be added here if global variables are implemented distinctly.
    },

    /**
     * Provides logging capabilities. Messages are sent back to Dart via the bridge.
     */
    console: {
        /**
         * Logs informational messages.
         * @param {...any} args Values to log. They will be JSON-stringified.
         */
        log: (...args) => {
            try {
                sendMessage('consoleLog', JSON.stringify(args));
            } catch (e) {
                /* Ignore stringify errors for console? Or maybe log the error itself? */
            }
        },
        /**
         * Logs warning messages.
         * @param {...any} args Values to log.
         */
        warn: (...args) => {
            try {
                sendMessage('consoleWarn', JSON.stringify(args));
            } catch (e) {
                /* Ignore */
            }
        },
        /**
         * Logs error messages.
         * @param {...any} args Values to log.
         */
        error: (...args) => {
            try {
                sendMessage('consoleError', JSON.stringify(args));
            } catch (e) {
                /* Ignore */
            }
        }
    },

};

// --- End of APIDash Setup Script ---

// User's script will be appended below this line by Dart.
// Dart will also append the final JSON.stringify() call to return results.
""";
