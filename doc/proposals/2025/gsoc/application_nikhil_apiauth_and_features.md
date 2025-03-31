# APIDash GSoC Proposal

## About Me

**Full Name:** Nikhil Ludder  
**Contact Info:**

- **Email:** [nikhilljatt@gmail.com](mailto:nikhilljatt@gmail.com)
- **Contact No.** - +918708200907
- **Discord Handle:** @badnikhil
- **GitHub:** [badnikhil](https://github.com/badnikhil)
- **LINKEDIN:** [NIKHIL LUDDER](www.linkedin.com/in/nikhil-ludder-ba631216b)
- **Time Zone:** UTC+5:30 (IST)

---

## Skills

- **Flutter & Dart Development:** Advanced knowledge in Flutter app development, with a strong focus on API clients, network communication, and performance optimizations.
- **API Development & Integration:** Deep experience working with REST APIs, GraphQL, WebSockets, authentication methods and network protocols.
- **Programming Languages:** Currently Proficient in C++, Dart, and x86 Assembly but adaptable to any(worked with 10+ languages) with a strong grasp of low-level computing concepts.
- **Low-Level System Knowledge:** Understanding of computer architecture, memory management, operating systems, and system performance optimizations.
- **Problem-Solving & Competitive Coding:** Rated 5-star @CodeChef and 1600+ on LeetCode.
- **Collaboration & Open Source Contributions:** Actively contributing to APIDash, with multiple PRs :
  
  [**PR #693**](https://github.com/foss42/apidash/pull/693) – Fixed code generation for Swift  
  [**PR #681**](https://github.com/foss42/apidash/pull/681) – *In Progress:* Adding support for multiple params in requests and the code generation feature  
  [**PR #670**](https://github.com/foss42/apidash/pull/670) – Added onboarding screen  
  [**PR #654**](https://github.com/foss42/apidash/pull/654) – Fixed a video player crash bug and an error occurring during tests  
  [**PR #649**](https://github.com/foss42/apidash/pull/649) – Updated a link in the README file  


---

## University Information

- **University:** KIET Group of Institutions, Ghaziabad  
- **Program:** B.Tech in Computer Science with AI/ML  
- **Year:** 2024  
- **Expected Graduation Date:** 2028  
---



---

## Motivation & Experience
Short answers to the following questions (Add relevant links wherever you can):

**1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

I’ve been actively contributing to APIDash, submitting multiple PRs and raising issues. I have studied the codebase in depth and will begin implementation immediately after the initial discussions with mentors.


**2. What is your one project/achievement that you are most proud of? Why?**

Leading a college hackathon team to build an API client under a strict deadline. This experience strengthened my problem-solving skills and ability to work efficiently under pressure.

**3. What interests you the most about API Dash?**

APIDash is fascinating because of its fully Flutter-based architecture, which ensures a seamless and consistent cross-platform experience. Its efficient approach to  request management and response visualization makes it a powerful yet lightweight tool. The way it streamlines code generation further enhances its usability for developers working with APIs.


**4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**

I will be working on GSoC full-time, dedicating 7+ hours per day, especially in the early stages, to ensure smooth progress. My vacations align perfectly with GSoC Timeline and my institute is very supportive for such opportunitites (if needed leave will be granted but i am sure it won't be necessary).

**5. Do you mind regularly syncing up with the project mentors?**

Not at all! Regular sync-ups with the mentors will help me stay on track, get valuable feedback, and ensure the project progresses smoothly.

---

## Project Proposal

### **Title:** Adding Authentication Support & Enhance/Update Code Generation feature in APIDash  

### **Abstract:**  
This project aims to expand APIDash by implementing multiple authentication methods  and improving its code generation capabilities Alongside adding relevant tests. With prior experience in the codebase, I have already mapped out the necessary changes and will begin work right after mentor discussions.

---

## Weekly Timeline

| Week | Task |
|------|------|
| **Week 1** | Finalize implementation plan, initial setup, mentor discussions |
| **Week 2** | Implement Basic Authentication, API Key authentication |
| **Week 3** | Add Bearer Token & JWT authentication |
| **Week 4** | Implement Digest Authentication |
| **Week 5** | OAuth 1.0 & OAuth 2.0 implementation |
| **Week 6-7** | Expand code generation support to new languages() |
| **Week 8** | Refine code generation templates & improve output quality |
| **Week 9** | Increase test coverage, add integration tests |
| **Week 10** | Finalize features, conduct additional testing |
| **Week 11** | Documentation, bug fixes, and final refinements |
| **Week 12** | Submit final deliverables, address mentor feedback |

---
# Authentication Integration 
## Frontend Images
![image](https://github.com/user-attachments/assets/7e1471a0-86ca-469a-a765-41799246d720)
![image](https://github.com/user-attachments/assets/538a4b3a-7bf2-4f9c-8396-17f5a4ddb87d)



**A dropdown to select the authentication type, along with an icon to open a dialog box where users can enter their credentials for seamless integration into their workflow.  I will ensure minimal changes to the existing codebase(only a line or two ).*

## Authentication Methods to be Implemented 
1. **Basic Authentication** - Username & Password
2. **API Key Authentication** - Key-Value pair in headers or query
3. **Bearer Token Authentication** - JWT-based authentication
4. **JWT Bearer Authentication** - Generating and sending JWT tokens
5. **Digest Authentication** - Nonce-based authentication
6. **OAuth 1.0** - Legacy token-based authentication
7. **OAuth 2.0** - Modern token-based authentication

#### 1. Basic Authentication

Basic authentication requires sending a username and password in the HTTP request headers. I will implement this with proper encoding and security measures:

```
Future<http.Response> basicAuth(String url, String username, String password) async {
  // Encode credentials properly with UTF-8 and Base64
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  
  // Create a secure HTTP client with proper timeout and SSL configuration
  final client = http.Client();
  try {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
    
    // Handle different response codes 
    if (response.statusCode == 401) {
      throw Exception('Authentication failed. Please check credentials.');
    }
    
    return response;
  } catch (e) {
    
    throw Exception('Authentication request failed: $e');
  } finally {
    client.close();
  }
}
```

Generated Code (Dart):
```
final client = http.Client();
try {
  final response = await client.get(
    Uri.parse('https://api.example.com/data'),
    headers: {
      'Authorization': 'Basic base64encoded(username:password)',
      'Content-Type': 'application/json',
    },
  ).timeout(const Duration(seconds: 10));
  
  if (response.statusCode >= 200 && response.statusCode < 300) {
   
    print(response.body);
  } else {
  
    print('Error: ${response.statusCode}');
  }
} finally {
  client.close();
}
```

#### 2. API Key Authentication

API Key authentication can be implemented in headers or query parameters, and I'll support both approaches with proper error handling:

```
Future<http.Response> fetchDataWithApiKey(String url, String apiKey, {bool useQueryParam = false}) async {
  final client = http.Client();
  try {
    Uri uri = Uri.parse(url);
    
    // Support both header-based and query parameter-based API keys
    if (useQueryParam) {
      // For query parameter approach, append the API key to the URL
      final queryParams = Map<String, dynamic>.from(uri.queryParameters);
      queryParams['api_key'] = apiKey;
      uri = uri.replace(queryParameters: queryParams);
      
      return await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
    } else {
      // For header-based approach, include the API key in the headers
      return await client.get(
        uri,
        headers: {
          'X-API-KEY': apiKey,
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
    }
  } catch (e) {
    throw Exception('API Key authentication failed: $e');
  } finally {
    client.close();
  }
}
```

Generated Code (Dart):
```
// APIDash-generated API Key request (header method)
final client = http.Client();
try {
  final response = await client.get(
    Uri.parse('https://api.example.com/data'),
    headers: {
      'X-API-KEY': 'your_api_key',
      'Content-Type': 'application/json',
    },
  ).timeout(const Duration(seconds: 10));
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // Process data
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
} finally {
  client.close();
}
```

#### 3. Bearer Token Authentication

Bearer token authentication uses an access token in the Authorization header. I'll implement proper token handling and error management:

```
Future<http.Response> fetchDataWithBearerToken(String url, String token) async {
  final client = http.Client();
  try {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 15));
    
    // Handle token expiration and other common auth issues
    if (response.statusCode == 401) {
      // Token might be expired, trigger refresh mechanism
      throw Exception('Token expired or invalid');
    } else if (response.statusCode == 403) {
      throw Exception('Token does not have sufficient permissions');
    }
    
    return response;
  } catch (e) {
    throw Exception('Bearer token authentication failed: $e');
  } finally {
    client.close();
  }
}
```

Generated Code (Dart):
```
final client = http.Client();
try {
  final response = await client.get(
    Uri.parse('https://api.example.com/data'),
    headers: {
      'Authorization': 'Bearer your_access_token',
      'Content-Type': 'application/json',
    },
  ).timeout(const Duration(seconds: 15));
  
  if (response.statusCode >= 200 && response.statusCode < 300) {
    final responseData = jsonDecode(response.body);
    // Process response data
  } else if (response.statusCode == 401) {
    // Handle token expiration
    print('Token expired. Please refresh authentication.');
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
} finally {
  client.close();
}
```

#### 4. JWT Bearer Authentication

JWT Bearer authentication will include proper token generation, validation, and expiration handling:

```
String generateJwt(String secretKey, Map<String, dynamic> claims, {String algorithm = 'HS256'}) {
  // Set standard claims if not provided
  final fullClaims = {
    'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000, // Issued at
    'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000, // Expiration
    ...claims,
  };

  final header = {
    'alg': algorithm,
    'typ': 'JWT',
  };

  // Encode header and payload
  final encodedHeader = base64Url.encode(utf8.encode(jsonEncode(header)));
  final encodedPayload = base64Url.encode(utf8.encode(jsonEncode(fullClaims)));

  // Create signature
  final dataToSign = '$encodedHeader.$encodedPayload';
  final hmac = Hmac(sha256, utf8.encode(secretKey));
  final digest = hmac.convert(utf8.encode(dataToSign));
  final signature = base64Url.encode(digest.bytes);

  // Combine all parts to create JWT
  return '$encodedHeader.$encodedPayload.$signature';
}

Future<http.Response> fetchDataWithJwtBearer(String url, String token) async {
  final client = http.Client();
  try {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    
    return response;
  } catch (e) {
    throw Exception('JWT authentication failed: $e');
  } finally {
    client.close();
  }
}
```

Generated Code (Dart):
```
import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateJwt(String secretKey, Map<String, dynamic> payload) {
  final header = {'alg': 'HS256', 'typ': 'JWT'};
  
  // Encode header and payload
  final encodedHeader = base64Url.encode(utf8.encode(jsonEncode(header)));
  final encodedPayload = base64Url.encode(utf8.encode(jsonEncode(payload)));
  
  // Create signature
  final dataToSign = '$encodedHeader.$encodedPayload';
  final hmac = Hmac(sha256, utf8.encode(secretKey));
  final digest = hmac.convert(utf8.encode(dataToSign));
  final signature = base64Url.encode(digest.bytes);
  
  return '$encodedHeader.$encodedPayload.$signature';
}

// Generate and use JWT token
final claims = {
  'sub': 'user123',
  'name': 'John Doe',
  'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
  'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000
};

final jwt = generateJwt('your_secret_key', claims);

final response = await http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Authorization': 'Bearer $jwt',
    'Content-Type': 'application/json',
  },
);
```

#### 5. Digest Authentication

Digest authentication requires a challenge-response mechanism with proper nonce handling:

```
Future<http.Response> fetchDataWithDigestAuth(String url, String username, String password) async {
  final client = http.Client();
  try {
    // First request to get the challenge
    final initialResponse = await client.get(Uri.parse(url));
    
    if (initialResponse.statusCode != 401 || !initialResponse.headers.containsKey('www-authenticate')) {
      throw Exception('Server did not respond with digest challenge');
    }
    
    // Parse the WWW-Authenticate header
    final authHeader = initialResponse.headers['www-authenticate'] ?? '';
    if (!authHeader.toLowerCase().startsWith('digest ')) {
      throw Exception('Server did not provide digest authentication challenge');
    }
    
    // Extract digest params (realm, nonce, qop, etc.)
    final Map<String, String> digestParams = {};
    final paramRegex = RegExp(r'(\w+)="([^"]*)"');
    paramRegex.allMatches(authHeader).forEach((match) {
      digestParams[match.group(1)!] = match.group(2)!;
    });
    
    // Required params for digest auth
    final String realm = digestParams['realm'] ?? '';
    final String nonce = digestParams['nonce'] ?? '';
    final String opaque = digestParams['opaque'] ?? '';
    final String algorithm = digestParams['algorithm'] ?? 'MD5';
    final String qop = digestParams['qop'] ?? '';
    
    // Generate cnonce and response
    final String cnonce = _generateCnonce();
    final String nc = '00000001';
    final String method = 'GET';
    
    // Calculate digest response according to RFC 2617
    String ha1 = md5.convert(utf8.encode('$username:$realm:$password')).toString();
    String ha2 = md5.convert(utf8.encode('$method:$url')).toString();
    
    String response;
    if (qop.isNotEmpty) {
      response = md5.convert(utf8.encode('$ha1:$nonce:$nc:$cnonce:$qop:$ha2')).toString();
    } else {
      response = md5.convert(utf8.encode('$ha1:$nonce:$ha2')).toString();
    }
    
    // Build the Authorization header
    String digestHeader = 'Digest username="$username", realm="$realm", '
        'nonce="$nonce", uri="$url", algorithm=$algorithm, '
        'response="$response"';
        
    if (qop.isNotEmpty) {
      digestHeader += ', qop=$qop, nc=$nc, cnonce="$cnonce"';
    }
    
    if (opaque.isNotEmpty) {
      digestHeader += ', opaque="$opaque"';
    }
    
    // Make authenticated request
    final authenticatedResponse = await client.get(
      Uri.parse(url),
      headers: {
        'Authorization': digestHeader,
        'Content-Type': 'application/json',
      },
    );
    
    return authenticatedResponse;
  } catch (e) {
    throw Exception('Digest authentication failed: $e');
  } finally {
    client.close();
  }
}

String _generateCnonce() {
  final random = Random();
  final values = List<int>.generate(16, (i) => random.nextInt(256));
  return base64Url.encode(values).substring(0, 16);
}
```

Generated Code (Dart):
This is a simplified example of the generated code
```
// First request to get the challenge
final client = http.Client();
try {
  // Initial request to get the challenge
  final initialResponse = await client.get(Uri.parse('https://api.example.com/data'));
  if (initialResponse.statusCode != 401) {
    print('Server did not request authentication');
    return;
  }
  
  // Parse the WWW-Authenticate header
  final authHeader = initialResponse.headers['www-authenticate'] ?? '';
  if (!authHeader.toLowerCase().startsWith('digest ')) {
    print('Server does not support digest authentication');
    return;
  }
  
  // Extract digest parameters (simplified)
  final realm = _extractParam(authHeader, 'realm');
  final nonce = _extractParam(authHeader, 'nonce');
  final qop = _extractParam(authHeader, 'qop');
  
  // Generate cnonce and other required values
  final cnonce = _generateCnonce();
  final nc = '00000001';
  
  // Calculate response (simplified)
  // In a real implementation, this would follow RFC 2617 algorithm
  final digestResponse = 'generated_digest_response_here';
  
  // Make authenticated request
  final response = await client.get(
    Uri.parse('https://api.example.com/data'),
    headers: {
      'Authorization': 'Digest username="your_username", realm="$realm", '
          'nonce="$nonce", uri="/data", response="$digestResponse", '
          'qop=$qop, nc=$nc, cnonce="$cnonce"',
      'Content-Type': 'application/json',
    },
  );
  
  if (response.statusCode == 200) {
    // Process successful response
  } else {
    print('Authentication failed: ${response.statusCode}');
  }
} finally {
  client.close();
}
```

#### 6. OAuth 1.0

OAuth 1.0 implementation will include proper signature generation and token handling:

```
Future<http.Response> fetchDataWithOAuth1(
    String url, 
    String consumerKey, 
    String consumerSecret,
    {String? token, String? tokenSecret}
) async {
  final client = http.Client();
  try {
    // Generate OAuth parameters
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final nonce = _generateNonce();
    
    // Create parameter map for signature base string
    final Map<String, String> params = {
      'oauth_consumer_key': consumerKey,
      'oauth_nonce': nonce,
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_timestamp': timestamp,
      'oauth_version': '1.0',
    };
    
    // Add token if available
    if (token != null) {
      params['oauth_token'] = token;
    }
    
    // Extract URL components
    final uri = Uri.parse(url);
    final baseUrl = '${uri.scheme}://${uri.host}${uri.path}';
    
    // Add query parameters to signature parameters
    if (uri.queryParameters.isNotEmpty) {
      params.addAll(uri.queryParameters);
    }
    
    // Create signature base string
    final List<String> paramPairs = [];
    final sortedParams = SplayTreeMap<String, String>.from(params);
    sortedParams.forEach((key, value) {
      paramPairs.add('${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}');
    });
    
    final paramString = paramPairs.join('&');
    final signatureBaseString = 'GET&${Uri.encodeComponent(baseUrl)}&${Uri.encodeComponent(paramString)}';
    
    // Create signing key
    final signingKey = tokenSecret != null 
        ? '${Uri.encodeComponent(consumerSecret)}&${Uri.encodeComponent(tokenSecret)}'
        : '${Uri.encodeComponent(consumerSecret)}&';
    
    // Generate signature
    final hmac = Hmac(sha1, utf8.encode(signingKey));
    final digest = hmac.convert(utf8.encode(signatureBaseString));
    final signature = base64.encode(digest.bytes);
    
    // Add signature to OAuth parameters
    params['oauth_signature'] = signature;
    
    // Create Authorization header
    final List<String> authHeaderParts = [];
    final oauthParams = params.entries.where((entry) => entry.key.startsWith('oauth_'));
    oauthParams.forEach((entry) {
      authHeaderParts.add('${entry.key}="${Uri.encodeComponent(entry.value)}"');
    });
    
    final authHeader = 'OAuth ${authHeaderParts.join(', ')}';
    
    // Make request with OAuth header
    final response = await client.get(
      uri,
      headers: {
        'Authorization': authHeader,
        'Content-Type': 'application/json',
      },
    );
    
    return response;
  } catch (e) {
    throw Exception('OAuth 1.0 authentication failed: $e');
  } finally {
    client.close();
  }
}

String _generateNonce() {
  final random = Random();
  final values = List<int>.generate(16, (i) => random.nextInt(256));
  return base64Url.encode(values).substring(0, 16);
}
```

Generated Code (Dart):
```
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

// Generate OAuth 1.0 signature and make request
final String consumerKey = 'your_consumer_key';
final String consumerSecret = 'your_consumer_secret';
final String token = 'your_access_token'; // If available
final String tokenSecret = 'your_token_secret'; // If available

// Generate OAuth parameters
final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
final nonce = base64Url.encode(List<int>.generate(16, (_) => Random().nextInt(256))).substring(0, 16);

// Create parameter map
final params = SplayTreeMap<String, String>.from({
  'oauth_consumer_key': consumerKey,
  'oauth_nonce': nonce,
  'oauth_signature_method': 'HMAC-SHA1',
  'oauth_timestamp': timestamp,
  'oauth_token': token, // Include only if available
  'oauth_version': '1.0',
});

// Create signature (simplified)
final signatureBaseString = 'GET&${Uri.encodeComponent('https://api.example.com/data')}&parameter_string_here';
final signingKey = '$consumerSecret&$tokenSecret';
final signature = base64.encode(Hmac(sha1, utf8.encode(signingKey))
    .convert(utf8.encode(signatureBaseString))
    .bytes);

// Create Authorization header
final authHeader = 'OAuth oauth_consumer_key="$consumerKey", '
    'oauth_nonce="$nonce", oauth_signature="$signature", '
    'oauth_signature_method="HMAC-SHA1", oauth_timestamp="$timestamp", '
    'oauth_token="$token", oauth_version="1.0"';

// Make authenticated request
final response = await http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Authorization': authHeader,
    'Content-Type': 'application/json',
  },
);
```

#### 7. OAuth 2.0

OAuth 2.0 implementation will support multiple grant types and proper token management:

```
// Client Credentials Grant
Future<Map<String, dynamic>> getOAuth2TokenClientCredentials(
  String tokenUrl, 
  String clientId, 
  String clientSecret,
  {Map<String, String>? additionalParams}
) async {
  final client = http.Client();
  try {
    // Prepare request body
    final Map<String, String> body = {
      'grant_type': 'client_credentials',
      'client_id': clientId,
      'client_secret': clientSecret,
    };
    
    // Add any additional parameters
    if (additionalParams != null) {
      body.addAll(additionalParams);
    }
    
    // Request access token
    final response = await client.post(
      Uri.parse(tokenUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to get OAuth2 token: ${response.body}');
    }
    
    // Parse token response
    final Map<String, dynamic> tokenData = jsonDecode(response.body);
    if (!tokenData.containsKey('access_token')) {
      throw Exception('Invalid OAuth2 response: access_token missing');
    }
    
    return tokenData;
  } catch (e) {
    throw Exception('OAuth2 authentication failed: $e');
  } finally {
    client.close();
  }
}

// Authorization Code Grant
Future<Map<String, dynamic>> getOAuth2TokenAuthCode(
  String tokenUrl,
  String code,
  String redirectUri,
  String clientId,
  String clientSecret,
  {String? codeVerifier}
) async {
  final client = http.Client();
  try {
    // Prepare request body
    final Map<String, String> body = {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': redirectUri,
      'client_id': clientId,
      'client_secret': clientSecret,
    };
    
    // Add PKCE code verifier if available (for public clients)
    if (codeVerifier != null) {
      body['code_verifier'] = codeVerifier;
    }
    
    // Request access token
    final response = await client.post(
      Uri.parse(tokenUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to get OAuth2 token: ${response.body}');
    }
    
    // Parse token response
    final Map<String, dynamic> tokenData = jsonDecode(response.body);
    if (!tokenData.containsKey('access_token')) {
      throw Exception('Invalid OAuth2 response: access_token missing');
    }
    
    return tokenData;
  } catch (e) {
    throw Exception('OAuth2 authentication failed: $e');
  } finally {
    client.close();
  }
}

// Use OAuth2 token to make a request
Future<http.Response> fetchDataWithOAuth2(String url, String accessToken) async {
  final client = http.Client();
  try {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    
    return response;
  } catch (e) {
    throw Exception('OAuth2 request failed: $e');
  } finally {
    client.close();
  }
}
```




### 1. **Languages to be Added (Codegen feature)**

  - **Elixir** (Using HTTPoison)
  - **TypeScript** (Axios & Fetch APIs)
  - **Haskell** (http-client)
  - **Perl** (LWP::UserAgent)
  - **Scala** (sttp & Akka HTTP)
  - **R** (httr)
  - **Lua** (LuaSocket)
  - **Erlang** (httpc)
  - **Shell** (Wget)

The generated code will strictly follow best practices for each language while maintaining a consistent structure across implementations. API requests in each language/package will go thorough manual tests.

---

## Generated API Request Code

## Elixir (Using HTTPoison)
```
HTTPoison.get!("https://api.example.com/data")
```

## TypeScript (Axios)
```
import axios from "axios";
axios.get("https://api.example.com/data");
```

## TypeScript (fetch)
```
fetch("https://api.example.com/data");
```

## Haskell (http-client)
```
import Network.HTTP.Client
import Network.HTTP.Client.TLS

main :: IO ()
main = do
  manager <- newManager tlsManagerSettings
  request <- parseRequest "https://api.example.com/data"
  response <- httpLbs request manager
  print $ responseBody response
```

## Perl (LWP::UserAgent)
```
use LWP::UserAgent;
my $ua = LWP::UserAgent->new;
my $res = $ua->get("https://api.example.com/data");
print $res->decoded_content;
```

## Scala (sttp)
```
import sttp.client3._
val request = basicRequest.get(uri"https://api.example.com/data")
val backend = HttpURLConnectionBackend()
val response = request.send(backend)
```

## Scala (Akka HTTP)
```
import akka.http.scaladsl.Http
import akka.http.scaladsl.model._
Http().singleRequest(HttpRequest(uri = "https://api.example.com/data"))
```

## R (httr)
```
library(httr)
res <- GET("https://api.example.com/data")
content(res, "text")
```

## Lua (LuaSocket)
```
local http = require("socket.http")
local response = http.request("https://api.example.com/data")
print(response)
```

## Erlang (httpc)
```
httpc:request(get, {"https://api.example.com/data", []}, [], []).
```

## Shell (Wget)
```
wget "https://api.example.com/data"
```



## Conclusion

This provides a brief breakdown of implementing authentication in APIDash. Each method has been explained with corresponding code generation snippet. Further enhancements will be made by updating Code generation to handle authentication requests for all other lanugages and adding relevant tests.
This contribution will significantly expand the APIDash's capabilities by enabling support for multiple programming languages, making the CodeGen feature more robust and widely usable. By following a structured development, testing, and validation approach, the enhancements will ensure reliable and maintainable code generation.

## Final Thoughts

I am fully committed to delivering high-quality contributions to APIDash, leveraging my expertise in Flutter, API development, and low-level systems understanding. I will actively collaborate with mentors and ensure the successful implementation of these improvements.
