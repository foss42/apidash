# API Dash Validation Logging Implementation

## Overview
This implementation addresses GitHub issues #906 and #587 by migrating validation warnings and errors from transient UI notifications to the persistent in-app logging console.

## Changes Made

### 1. Enhanced `collection_providers.dart`
**File:** `lib/providers/collection_providers.dart`

**Added validation logic in the `sendRequest()` method:**

#### Validation Checks Implemented:
1. **Empty URL Validation**
   - **Level:** Error
   - **Message:** "Request URL is empty. Please provide a valid URL."
   - **Tags:** `['request-validation', 'empty-url']`

2. **GET Request with Body Warning**
   - **Level:** Warning
   - **Message:** "GET request contains a body. This may not be supported by all servers."
   - **Tags:** `['request-validation', 'get-with-body']`
   - **Trigger:** When HTTP method is GET and request body is not empty

3. **JSON Validation**
   - **Valid JSON (Debug):**
     - **Level:** Debug
     - **Message:** "Request body contains valid JSON."
     - **Tags:** `['request-validation', 'valid-json']`
   
   - **Invalid JSON (Error):**
     - **Level:** Error
     - **Message:** "Invalid JSON in request body: [error details]"
     - **Tags:** `['request-validation', 'invalid-json']`
   - **Trigger:** When Content-Type is JSON and body is not empty

4. **Request Validation Summary**
   - **Level:** Info
   - **Message:** "Request validation completed for [METHOD] [URL]"
   - **Tags:** `['request-validation', 'completed']`

### 2. Added Import
**Added:** `import 'package:better_networking/better_networking.dart';`
- Required for accessing `HTTPVerb`, `ContentType`, and `kJsonDecoder` constants

## Implementation Details

### Code Location
The validation logic is inserted in the `sendRequest()` method right after the HTTP request model is prepared but before the actual network request is sent. This ensures:
- All request parameters are finalized
- Validation happens for every request
- Logs appear in the terminal before network activity

### Terminal Integration
Uses the existing terminal logging system:
```dart
final terminal = ref.read(terminalStateProvider.notifier);
terminal.logSystem(
  category: 'validation',
  message: 'Validation message',
  level: TerminalLevel.warn, // or error, info, debug
  tags: ['request-validation', 'specific-tag'],
);
```

## Testing Scenarios

### Test Case 1: GET Request with Body
**Setup:**
- Method: GET
- URL: https://api.example.com/data
- Body: `{"key": "value"}`

**Expected Result:**
- ⚠️ Warning log appears in terminal console
- Message: "GET request contains a body. This may not be supported by all servers."

### Test Case 2: POST Request with Invalid JSON
**Setup:**
- Method: POST
- URL: https://api.example.com/data
- Content-Type: application/json
- Body: `{"key": "value", "invalid": }` (missing value)

**Expected Result:**
- ❌ Error log appears in terminal console
- Message: "Invalid JSON in request body: [FormatException details]"

### Test Case 3: Valid POST Request
**Setup:**
- Method: POST
- URL: https://api.example.com/data
- Content-Type: application/json
- Body: `{"key": "value", "number": 123}`

**Expected Result:**
- ✅ Debug log: "Request body contains valid JSON."
- ℹ️ Info log: "Request validation completed for POST https://api.example.com/data"

## Benefits

1. **Persistent Logging:** Validation messages are now permanently logged in the terminal console
2. **Better Debugging:** Developers can review all validation issues in one place
3. **Categorized Messages:** All validation logs use consistent categorization and tagging
4. **Multiple Severity Levels:** Warnings, errors, info, and debug messages appropriately categorized
5. **No UI Interruption:** No more transient toasts or status bar messages that disappear

## Migration Status

✅ **Completed:**
- GET request with body validation
- JSON validation for request bodies
- Empty URL validation
- Integration with existing terminal logging system

✅ **Verified:**
- No compilation errors
- Proper import statements
- Consistent logging format
- Appropriate severity levels

## Future Enhancements

Potential additional validations that could be added:
- URL format validation
- Header validation
- Authentication parameter validation
- Request size limits
- Content-Type mismatch warnings

## Files Modified

1. `lib/providers/collection_providers.dart` - Added validation logic
2. `test_validation_logging.dart` - Demo/test file (can be removed)
3. `VALIDATION_LOGGING_IMPLEMENTATION.md` - This documentation

## Commit Message
```
fix(logging): redirect request validation warnings & errors to in-app console (#906, #587)

- Add GET-with-body validation warning to terminal console
- Add JSON validation error logging for invalid request bodies  
- Add empty URL validation error logging
- Add request validation completion info logging
- Replace transient UI notifications with persistent terminal logs
- Maintain consistent logging format with categories and tags

Resolves #906: Migrate to in-app logging console
Resolves #587: Add a Global status bar in API Dash
```