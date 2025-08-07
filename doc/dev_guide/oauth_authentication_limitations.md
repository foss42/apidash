# OAuth Authentication Limitations

This document outlines the current limitations and implementation details of OAuth authentication in API Dash.

## Table of Contents

1. [OAuth2 Limitations](#oauth2-limitations)
2. [OAuth1 Limitations](#oauth1-limitations)
3. [Platform-Specific Behavior](#platform-specific-behavior)
4. [Technical Implementation Details](#technical-implementation-details)
5. [Workarounds](#workarounds)
6. [Future Improvements](#future-improvements)

## OAuth2 Limitations

### Response Format Restriction

**Limitation**: OAuth2 implementation only supports `application/json` response format as specified in [RFC 6749, Section 5.1](https://tools.ietf.org/html/rfc6749#section-5.1).

**Details**:
- The OAuth2 client automatically sets the `Accept: application/json` header for token requests
- Servers that return token responses in other formats (e.g., `application/x-www-form-urlencoded`, `text/plain`) are not supported
- This is enforced by the `_JsonAcceptClient` wrapper in the HTTP client manager

**Impact**:
- Some legacy OAuth2 providers that don't return JSON responses will fail
- Non-standard OAuth2 implementations may not work correctly

**Code Reference**:
```dart
// In HttpClientManager.createClientWithJsonAccept()
class _JsonAcceptClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _inner.send(request);
  }
}
```

### Port Range Limitation (Desktop Only)

**Limitation**: For desktop platforms, the OAuth2 callback server requires at least one free port in the range 8080-8090.

**Details**:
- The callback server attempts to bind to ports starting from 8080
- If all ports in the range (8080-8090) are occupied, the OAuth flow will fail
- This only affects desktop platforms (macOS, Windows, Linux)

**Impact**:
- Users running other services on these ports may experience OAuth failures
- Development environments with multiple applications may conflict

**Code Reference**:
```dart
// In OAuthCallbackServer.start()
for (int port = 8080; port <= 8090; port++) {
  try {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    _port = port;
    break;
  } catch (e) {
    if (port == 8090) {
      throw Exception('Unable to find available port for OAuth callback server');
    }
  }
}
```

## OAuth1 Limitations

### Incomplete Flow Implementation

**Limitation**: OAuth1 implementation does not handle the complete OAuth1 authorization flow.

**Details**:
- The implementation assumes that the necessary steps to obtain the access token have already been performed manually or through a backend service
- Users must provide pre-obtained access tokens and token secrets
- The three-legged OAuth1 flow (request token → user authorization → access token) is not implemented
- This aligns with the behavior in other API clients such as Postman and Insomnia

**Impact**:
- Users cannot complete OAuth1 authentication entirely within API Dash
- External tools or manual processes are required to obtain tokens
- Limited to scenarios where tokens are already available

**Workaround**:
Users need to:
1. Obtain request tokens from the OAuth1 provider
2. Complete user authorization outside of API Dash
3. Exchange the authorized request token for an access token
4. Manually enter the access token and token secret in API Dash

## Platform-Specific Behavior

### Redirect URI Handling

**Mobile Platforms (iOS, Android)**:
- **Default Redirect URI**: `apidash://oauth2`
- **Mechanism**: Uses `flutter_web_auth_2` with custom URL scheme
- **User Experience**: Opens authorization in a WebView within the app

**Desktop Platforms (macOS, Windows, Linux)**:
- **Default Redirect URI**: `http://localhost:{port}/callback`
- **Port Range**: 8080-8090 (automatically selects first available port)
- **Mechanism**: Opens authorization in the system's default browser
- **User Experience**: External browser window with automatic callback handling

**Code Reference**:
```dart
// Platform detection logic
static bool get shouldUseLocalhostCallback => isDesktop;

// Redirect URL determination
if (PlatformUtils.shouldUseLocalhostCallback) {
  callbackServer = OAuthCallbackServer();
  final localhostUrl = await callbackServer.start();
  actualRedirectUrl = Uri.parse(localhostUrl);
} else {
  // Use custom scheme for mobile
  actualRedirectUrl = redirectUrl; // apidash://oauth2
}
```

## Technical Implementation Details

### Grant Types Supported

**OAuth2**:
- ✅ Authorization Code Grant
- ✅ Client Credentials Grant  
- ✅ Resource Owner Password Grant
- ❌ Implicit Grant (deprecated by OAuth2.1)
- ❌ Device Authorization Grant

**OAuth1**:
- ✅ Manual token entry (post-authorization)
- ❌ Automated three-legged flow

### PKCE Support

**Status**: ✅ Supported for Authorization Code Grant
- Code Challenge Method: SHA-256 or Plaintext
- Automatically generates code verifier and challenge
- Configurable through the UI

### Token Storage

**Mechanism**: File-based credential storage
- **Location**: `{workspaceFolderPath}/oauth2_credentials.json`
- **Format**: JSON with access token, refresh token, expiration time
- **Security**: Stored as plain text (limitation for local development tool)

**Auto-refresh**: ✅ Supported
- Automatically refreshes expired tokens using refresh tokens
- Updates stored credentials file

## Workarounds

### For Non-JSON OAuth2 Responses

If you encounter an OAuth2 provider that doesn't return JSON responses:

1. **Contact the provider** to request JSON support (recommended)
2. **Use a proxy server** to convert the response format
3. **Consider alternative authentication methods** if available

### For Port Conflicts on Desktop

If ports 8080-8090 are occupied:

1. **Stop conflicting services** temporarily during OAuth flow
2. **Use mobile platform** for OAuth authentication if possible
3. **Configure OAuth provider** to use a different callback URL (if supported)

## Related Documentation

- [Setup and Run Guide](setup_run.md)
- [Platform-Specific Instructions](platform_specific_instructions.md)
- [Testing Guide](testing.md)
- [OAuth2 RFC 6749](https://tools.ietf.org/html/rfc6749)
- [OAuth1 RFC 5849](https://tools.ietf.org/html/rfc5849)
