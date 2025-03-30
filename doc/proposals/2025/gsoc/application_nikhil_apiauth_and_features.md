# APIDash GSoC Proposal

## About Me

**Full Name:** Nikhil Ludder  
**Contact Info:**

- **Email:** [nikhilljatt@gmail.com](mailto:nikhilljatt@gmail.com)
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
- **Problem-Solving & Competitive Coding:** Rated 5-star @CodeChef and 1600+ on LeetCode, with a solid grasp of algorithms and data structures.
- **Collaboration & Open Source Contributions:** Actively contributing to APIDash, with multiple PRs :
  - [PR 1](https://github.com/foss42/apidash/pull/693)
  - [PR 2 (WORKING ON IT)](https://github.com/foss42/apidash/pull/681)
  - [PR 3](https://github.com/foss42/apidash/pull/670)
  - [PR 4](https://github.com/foss42/apidash/pull/654)
  - [PR 5](https://github.com/foss42/apidash/pull/649)

---

## University Information

- **University:** Indian Institute of Technology (IIT) Madras  
- **Program:** BS in Data Science  
- **Year:** 2024  
- **Expected Graduation Date:** 2028  

---

## Second Institution Information

- **University:** KIET Group of Institutions, Ghaziabad  
- **Program:** B.Tech in Computer Science with AI/ML  
- **Year:** 2024  
- **Expected Graduation Date:** 2028  

---

## Motivation & Experience

**FOSS Contributions:**  
I’ve been actively contributing to APIDash, submitting multiple PRs and raising issues. I have studied the codebase in depth and will begin implementation immediately after the initial discussions with mentors.

**Proudest Achievement:**  
Leading a college hackathon team to build an API client under a strict deadline. This experience strengthened my problem-solving skills and ability to work efficiently under pressure.

**Interest in APIDash:**

APIDash is fascinating because of its fully Flutter-based architecture, which ensures a seamless and consistent cross-platform experience. Its efficient approach to  request management and response visualization makes it a powerful yet lightweight tool. The way it streamlines code generation further enhances its usability for developers working with APIs.

**Time Commitment:**  
I will be working on GSoC full-time, dedicating 7+ hours per day, especially in the early stages, to ensure smooth progress.

---

## Project Proposal

### **Title:** Adding Authentication Support & Enhance/Update Code Generation feature in APIDash  

### **Abstract:**  
This project aims to expand APIDash by implementing multiple authentication methods (Basic Auth, OAuth 2.0, JWT, Digest Auth, API Keys) and improving its code generation capabilities. With prior experience in the codebase, I have already mapped out the necessary changes and will begin work right after mentor discussions.

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
# APIDash Authentication Integration and Code Generation

## Overview
This document provides a detailed approach to implementing authentication mechanisms in APIDash, covering API client integration and code generation updates.

## Authentication Methods to be Implemented 
1. **Basic Authentication** - Username & Password
2. **API Key Authentication** - Key-Value pair in headers or query
3. **Bearer Token Authentication** - JWT-based authentication
4. **JWT Bearer Authentication** - Generating and sending JWT tokens
5. **Digest Authentication** - Nonce-based authentication
6. **OAuth 1.0** - Legacy token-based authentication
7. **OAuth 2.0** - Modern token-based authentication

## 1. Basic Authentication
Basic authentication requires sending a username and password in the HTTP request headers.

```dart

Future<http.Response> fetchDataWithBasicAuth(String url, String username, String password) async {
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': basicAuth,
    },
  );
  return response;
}
```

Generated Code (Dart)
```
http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Authorization': 'Basic base64encoded(username:password)',
  },
);
```

## 2. API Key Authentication
API Key is sent either in headers or query parameters.

```
Future<http.Response> fetchDataWithApiKey(String url, String apiKey) async {
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'X-API-KEY': apiKey,
    },
  );
  return response;
}
```

### Generated Code(Dart)
```dart
http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'X-API-KEY': 'your_api_key',
  },
);
```

## 3. Bearer Token Authentication
Bearer token-based authentication requires an access token in the `Authorization` header.
```
Future<http.Response> fetchDataWithBearerToken(String url, String token) async {
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  return response;
}
```

 Generated Code (Dart)
```
http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Authorization': 'Bearer your_access_token',
  },
);
```

## 4. JWT Bearer Authentication
In JWT authentication, the client generates a JWT and sends it with requests.

```

String generateJwt(String secretKey, Map<String, dynamic> claims) {
  final builder = JsonWebSignatureBuilder()
    ..jsonContent = claims
    ..addRecipient(JsonWebKey.fromPem(secretKey), algorithm: 'RS256');

  return builder.build().toCompactSerialization();
}
```

Generated Code(Dart)
```
http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Authorization': 'Bearer generated_jwt_token',
  },
);
```

## 5. Digest Authentication
Digest authentication requires a challenge-response mechanism.

```
Future<http.Response> fetchDataWithDigestAuth(String url, String username, String password) async {

  final response1 = await http.get(Uri.parse(url));
  String nonce = response1.headers['www-authenticate'] ?? '';

  // Generate digest response (simplified, needs hashing implementation)
  String digestResponse = generateDigestResponse(username, password, nonce);

  final response2 = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Digest $digestResponse',
    },
  );
  return response2;
}
```

Generated Code (Dart)
```
http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Authorization': 'Digest generated_digest_token',
  },
);
```

## 6. OAuth 1.0
OAuth 1.0 uses a consumer key and secret to obtain a request token.

```
Future<http.Response> fetchDataWithOAuth1(String url, String consumerKey, String consumerSecret) async {
  String authHeader = generateOAuth1Signature(url, consumerKey, consumerSecret);

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': authHeader,
    },
  );
  return response;
}
```
Generated Code (Dart)
```
http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Authorization': 'OAuth oauth_signature',
  },
);
```

## 7. OAuth 2.0
OAuth 2.0 allows for token-based authentication.

```
Future<String> fetchOAuth2Token(String tokenUrl, String clientId, String clientSecret) async {
  final response = await http.post(
    Uri.parse(tokenUrl),
    body: {
      'client_id': clientId,
      'client_secret': clientSecret,
      'grant_type': 'client_credentials',
    },
  );
  return jsonDecode(response.body)['access_token'];
}
```
Generated Code (Dart)
```
http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Authorization': 'Bearer your_access_token',
  },
);
```

---

#### Languages in Codegen

Elixir - Using HTTPoison

TypeScript - Separate from JavaScript, using Axios and fetch

Haskell - Using http-client

Perl - Using LWP::UserAgent

Scala - Using sttp and Akka HTTP

R - Using httr

Lua - Using LuaSocket

Erlang - Using httpc

Shell (Wget) - Alternative to cURL for CLI-based requests


---


## Conclusion
This document provides a detailed breakdown of implementing authentication in APIDash. Each method has been explained with API client implementation and corresponding code generation snippets. Further enhancements will be made by updating Code generation to handle authentication requests.

## Final Thoughts

I am fully committed to delivering high-quality contributions to APIDash, leveraging my expertise in Flutter, API development, and low-level systems understanding. I will actively collaborate with mentors and ensure the successful implementation of these improvements.
