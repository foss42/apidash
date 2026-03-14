# Git Support Implementation Guide

This document provides a complete end-to-end implementation guide for adding GitHub-based version control to API Dash collections using the GitHub REST API and OAuth device flow.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [OAuth App Setup](#oauth-app-setup)
3. [Authentication Flow](#authentication-flow)
4. [Core API Operations](#core-api-operations)
5. [Data Models](#data-models)
6. [Complete Code Implementation](#complete-code-implementation)
7. [Testing with cURL](#testing-with-curl)

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              API Dash App                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────┐     ┌──────────────────┐     ┌─────────────────────────┐  │
│  │   Hive DB   │◄───►│  Serialization   │◄───►│   GitHubApiAdapter      │  │
│  │  (binary)   │     │  Layer (JSON)    │     │   (REST API calls)      │  │
│  └─────────────┘     └──────────────────┘     └───────────┬─────────────┘  │
│        ▲                                                   │                │
│        │                                                   │                │
│  ┌─────┴─────┐                                            │                │
│  │ Riverpod  │                                            │                │
│  │ Providers │                                            │                │
│  └───────────┘                                            │                │
│                                                           │                │
└───────────────────────────────────────────────────────────┼────────────────┘
                                                            │
                                                            ▼
                                              ┌─────────────────────────┐
                                              │     GitHub REST API     │
                                              │  api.github.com         │
                                              └─────────────────────────┘
```

### Design Principles

1. **Hive is the single source of truth** — No local git repos, no `.git` folders, no file watchers
2. **Everything over HTTPS** — Works on all platforms (macOS, Windows, Linux, Android, iOS, web)
3. **JSON serialization layer** — Hive's binary format → human-readable JSON for GitHub
4. **One-time authentication** — Device flow, token stored securely, never expires

---

## OAuth App Setup

### Step 1: Register OAuth App on GitHub

1. Go to **https://github.com/settings/developers**
2. Click **"New OAuth App"**
3. Fill in the form:

| Field | Value |
|-------|-------|
| **Application name** | `API Dash` |
| **Homepage URL** | `https://github.com/foss42/apidash` |
| **Authorization callback URL** | `https://github.com/login/device/callback` |

4. Click **"Register application"**
5. Copy the **Client ID** (e.g., `Ov23lisXbdRM4Sc4wwe1`)

### Step 2: Enable Device Flow

1. On the OAuth App settings page, scroll down
2. Find **"Enable Device Flow"** checkbox
3. **Check it** ✓
4. Click **"Update application"**

### Important Notes

- **Client ID is public** — Safe to embed in source code, commit to GitHub, ship in DMG/installer
- **Client Secret is NOT needed** — Device flow doesn't require it
- **Same Client ID for all users** — Every copy of API Dash uses the same Client ID
- **Each user gets their own token** — Token grants access to that user's repos only

---

## Authentication Flow

### OAuth Device Flow Sequence

```
┌──────────────┐                              ┌──────────────┐
│   API Dash   │                              │    GitHub    │
└──────┬───────┘                              └──────┬───────┘
       │                                             │
       │  1. POST /login/device/code                 │
       │    { client_id, scope: "repo" }             │
       │────────────────────────────────────────────►│
       │                                             │
       │  2. Response:                               │
       │    { user_code: "ABCD-1234",                │
       │      device_code: "xyz...",                 │
       │      verification_uri }                     │
       │◄────────────────────────────────────────────│
       │                                             │
       │  3. Display to user:                        │
       │     "Go to github.com/login/device          │
       │      and enter code ABCD-1234"              │
       │                                             │
       │  4. Open system browser                     │
       │                                             │
       │         ┌─────────────────────────┐         │
       │         │  User enters code in    │         │
       │         │  browser, clicks        │         │
       │         │  "Authorize"            │         │
       │         └─────────────────────────┘         │
       │                                             │
       │  5. Poll: POST /login/oauth/access_token    │
       │    { client_id, device_code, grant_type }   │
       │────────────────────────────────────────────►│
       │                                             │
       │  6. (repeat until authorized)               │
       │                                             │
       │  7. Response:                               │
       │    { access_token: "gho_xxx..." }           │
       │◄────────────────────────────────────────────│
       │                                             │
       │  8. Store token in flutter_secure_storage   │
       │                                             │
       ▼                                             ▼
```

### Why Device Flow?

| Requirement | Device Flow | WebView OAuth | Personal Access Token |
|-------------|-------------|---------------|----------------------|
| No backend server | ✅ | ❌ (needs redirect server) | ✅ |
| No secrets in app | ✅ | ❌ (needs client_secret) | ✅ |
| Works on all platforms | ✅ | ⚠️ (WebView quirks) | ✅ |
| Professional UX | ✅ | ✅ | ❌ (manual copy-paste) |
| GitHub recommended | ✅ | ❌ | ❌ |

---

## Core API Operations

### Repository Operations

| Operation | Endpoint | Method |
|-----------|----------|--------|
| Create repo | `/user/repos` | POST |
| Get repo info | `/repos/{owner}/{repo}` | GET |
| Delete repo | `/repos/{owner}/{repo}` | DELETE |
| Create/update file | `PUT /repos/{owner}/{repo}/contents/{path}` | PUT |

### ⚠️ Important: Empty Repository Problem

**Problem:** When you create a new repo with `auto_init: false`, the Git Data API (blobs, trees, commits) will fail with:

```json
{
  "message": "Git Repository is empty.",
  "status": "409"
}
```

**Why:** The Git Data API requires at least one commit to exist. An empty repo has no commits, no branches, no refs.

**Solution:** Use the **Contents API** for the first commit:

```bash
# First commit MUST use Contents API (not Git Data API)
curl -X PUT "https://api.github.com/repos/{owner}/{repo}/contents/requests/first_request.json" \
  -H "Authorization: Bearer TOKEN" \
  -d '{
    "message": "Initial commit from API Dash",
    "content": "BASE64_ENCODED_JSON_CONTENT"
  }'
```

**After the first commit**, you can use the Git Data API (blobs → trees → commits → refs) for all subsequent pushes.

**Alternative:** Create repo with `auto_init: true` to get a README commit automatically, then use Git Data API immediately.

| Approach | Pros | Cons |
|----------|------|------|
| Contents API for first commit | Clean repo, no README | Extra code path |
| `auto_init: true` | Simpler code | Unwanted README file |

**Recommended:** Use Contents API for first commit to keep the repo clean.

### Git Data API (Low-level)

| Operation | Endpoint | Method |
|-----------|----------|--------|
| Create blob | `/repos/{owner}/{repo}/git/blobs` | POST |
| Create tree | `/repos/{owner}/{repo}/git/trees` | POST |
| Create commit | `/repos/{owner}/{repo}/git/commits` | POST |
| Update branch ref | `/repos/{owner}/{repo}/git/refs/heads/{branch}` | PATCH |
| Get tree | `/repos/{owner}/{repo}/git/trees/{sha}?recursive=1` | GET |
| Get blob | `/repos/{owner}/{repo}/git/blobs/{sha}` | GET |

### Branch Operations

| Operation | Endpoint | Method |
|-----------|----------|--------|
| List branches | `/repos/{owner}/{repo}/branches` | GET |
| Create branch | `/repos/{owner}/{repo}/git/refs` | POST |
| Delete branch | `/repos/{owner}/{repo}/git/refs/heads/{branch}` | DELETE |

### Commit History

| Operation | Endpoint | Method |
|-----------|----------|--------|
| List commits | `/repos/{owner}/{repo}/commits?sha={branch}` | GET |
| Get commit | `/repos/{owner}/{repo}/commits/{sha}` | GET |

---

## Data Models

### CollectionModel

```dart
@freezed
class CollectionModel with _$CollectionModel {
  const factory CollectionModel({
    required String id,
    required String name,
    @Default([]) List<String> requestIds,
    GitHubConnection? gitHub,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CollectionModel;

  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionModelFromJson(json);
}
```

### GitHubConnection

```dart
@freezed
class GitHubConnection with _$GitHubConnection {
  const factory GitHubConnection({
    required String owner,
    required String repo,
    required String branch,
    String? lastCommitSha,
    DateTime? lastPushedAt,
    DateTime? lastPulledAt,
  }) = _GitHubConnection;

  factory GitHubConnection.fromJson(Map<String, dynamic> json) =>
      _$GitHubConnectionFromJson(json);
}
```

### Request JSON Schema (for GitHub)

```json
{
  "id": "req_abc123",
  "name": "Get User Profile",
  "method": "GET",
  "url": "https://api.example.com/users/me",
  "headers": [
    { "name": "Authorization", "value": "Bearer {{token}}" }
  ],
  "queryParams": [],
  "body": null,
  "bodyType": "none"
}
```

---

## Complete Code Implementation

### GitHubApiAdapter

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubApiAdapter {
  // ═══════════════════════════════════════════════════════════════════════════
  // CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Public client ID from GitHub OAuth App registration
  /// Safe to embed in source code — device flow doesn't need client_secret
  static const _clientId = 'Ov23lisXbdRM4Sc4wwe1';
  
  static const _baseUrl = 'https://api.github.com';
  static const _authUrl = 'https://github.com';
  static const _tokenKey = 'github_access_token';
  
  final _storage = const FlutterSecureStorage();
  String? _accessToken;

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTHENTICATION — OAuth Device Flow
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    _accessToken ??= await _storage.read(key: _tokenKey);
    return _accessToken != null;
  }

  /// Get stored token
  Future<String?> getToken() async {
    _accessToken ??= await _storage.read(key: _tokenKey);
    return _accessToken;
  }

  /// Start OAuth device flow
  /// Returns the user code and verification URI for display
  Future<DeviceFlowResponse> startDeviceFlow() async {
    final response = await http.post(
      Uri.parse('$_authUrl/login/device/code'),
      headers: {'Accept': 'application/json'},
      body: {
        'client_id': _clientId,
        'scope': 'repo', // Full repo access
      },
    );

    if (response.statusCode != 200) {
      throw GitHubException('Failed to start device flow: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return DeviceFlowResponse(
      deviceCode: data['device_code'],
      userCode: data['user_code'],
      verificationUri: data['verification_uri'],
      expiresIn: data['expires_in'],
      interval: data['interval'],
    );
  }

  /// Open verification URL in system browser
  Future<void> openVerificationUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Poll for access token after user authorizes
  /// Call this in a loop with the interval from DeviceFlowResponse
  Future<String?> pollForToken(String deviceCode) async {
    final response = await http.post(
      Uri.parse('$_authUrl/login/oauth/access_token'),
      headers: {'Accept': 'application/json'},
      body: {
        'client_id': _clientId,
        'device_code': deviceCode,
        'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
      },
    );

    final data = jsonDecode(response.body);

    if (data['error'] == 'authorization_pending') {
      return null; // Keep polling
    }

    if (data['error'] == 'slow_down') {
      return null; // Keep polling, but slower
    }

    if (data['error'] == 'expired_token') {
      throw GitHubException('Authorization expired. Please try again.');
    }

    if (data['error'] == 'access_denied') {
      throw GitHubException('Authorization denied by user.');
    }

    if (data['access_token'] != null) {
      _accessToken = data['access_token'];
      await _storage.write(key: _tokenKey, value: _accessToken);
      return _accessToken;
    }

    throw GitHubException('Unexpected response: ${response.body}');
  }

  /// Complete device flow with automatic polling
  Future<String> authenticateWithDeviceFlow({
    required Function(String userCode, String verificationUri) onShowCode,
  }) async {
    final deviceFlow = await startDeviceFlow();
    
    // Show code to user
    onShowCode(deviceFlow.userCode, deviceFlow.verificationUri);
    
    // Open browser
    await openVerificationUrl(deviceFlow.verificationUri);
    
    // Poll for token
    final interval = Duration(seconds: deviceFlow.interval + 1);
    final expiry = DateTime.now().add(Duration(seconds: deviceFlow.expiresIn));
    
    while (DateTime.now().isBefore(expiry)) {
      await Future.delayed(interval);
      
      final token = await pollForToken(deviceFlow.deviceCode);
      if (token != null) {
        return token;
      }
    }
    
    throw GitHubException('Authorization timed out');
  }

  /// Logout — clear stored token
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    _accessToken = null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REPOSITORY OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create a new repository under the authenticated user's account
  Future<RepoInfo> createRepository(
    String name, {
    String? description,
    bool private = true,
  }) async {
    final response = await _authenticatedRequest(
      'POST',
      '/user/repos',
      body: {
        'name': name,
        'description': description ?? 'API Dash collection',
        'private': private,
        'auto_init': false, // We'll create the first commit ourselves
      },
    );

    return RepoInfo(
      owner: response['owner']['login'],
      name: response['name'],
      fullName: response['full_name'],
      defaultBranch: response['default_branch'] ?? 'main',
      private: response['private'],
    );
  }

  /// Get repository info
  Future<RepoInfo> getRepository(String owner, String repo) async {
    final response = await _authenticatedRequest('GET', '/repos/$owner/$repo');
    
    return RepoInfo(
      owner: response['owner']['login'],
      name: response['name'],
      fullName: response['full_name'],
      defaultBranch: response['default_branch'],
      private: response['private'],
    );
  }

  /// Delete a repository
  Future<void> deleteRepository(String owner, String repo) async {
    await _authenticatedRequest('DELETE', '/repos/$owner/$repo');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PUSH — Atomic Multi-File Commit
  // ═══════════════════════════════════════════════════════════════════════════

  /// Push a collection to GitHub as an atomic commit
  /// 
  /// Flow:
  /// 1. Create blobs for each file
  /// 2. Create tree with all blobs
  /// 3. Create commit pointing to tree
  /// 4. Update branch ref to new commit
  Future<String> pushCollection({
    required String owner,
    required String repo,
    required String branch,
    required Map<String, String> files, // path -> JSON content
    required String commitMessage,
    String? parentCommitSha,
  }) async {
    // Step 1: Get current branch HEAD (if exists)
    String? baseTreeSha;
    String? parentSha = parentCommitSha;
    
    if (parentSha == null) {
      try {
        final refData = await _authenticatedRequest(
          'GET',
          '/repos/$owner/$repo/git/refs/heads/$branch',
        );
        parentSha = refData['object']['sha'];
        
        final commitData = await _authenticatedRequest(
          'GET',
          '/repos/$owner/$repo/git/commits/$parentSha',
        );
        baseTreeSha = commitData['tree']['sha'];
      } catch (e) {
        // Branch doesn't exist yet — first commit
        parentSha = null;
        baseTreeSha = null;
      }
    }

    // Step 2: Create blobs for each file
    final treeItems = <Map<String, dynamic>>[];
    
    for (final entry in files.entries) {
      final blobResponse = await _authenticatedRequest(
        'POST',
        '/repos/$owner/$repo/git/blobs',
        body: {
          'content': entry.value,
          'encoding': 'utf-8',
        },
      );
      
      treeItems.add({
        'path': entry.key,
        'mode': '100644', // Regular file
        'type': 'blob',
        'sha': blobResponse['sha'],
      });
    }

    // Step 3: Create tree
    final treeBody = <String, dynamic>{'tree': treeItems};
    if (baseTreeSha != null) {
      treeBody['base_tree'] = baseTreeSha;
    }
    
    final treeResponse = await _authenticatedRequest(
      'POST',
      '/repos/$owner/$repo/git/trees',
      body: treeBody,
    );
    final newTreeSha = treeResponse['sha'];

    // Step 4: Create commit
    final commitBody = <String, dynamic>{
      'message': commitMessage,
      'tree': newTreeSha,
    };
    if (parentSha != null) {
      commitBody['parents'] = [parentSha];
    }
    
    final commitResponse = await _authenticatedRequest(
      'POST',
      '/repos/$owner/$repo/git/commits',
      body: commitBody,
    );
    final newCommitSha = commitResponse['sha'];

    // Step 5: Update branch ref (or create if first commit)
    if (parentSha != null) {
      await _authenticatedRequest(
        'PATCH',
        '/repos/$owner/$repo/git/refs/heads/$branch',
        body: {'sha': newCommitSha},
      );
    } else {
      await _authenticatedRequest(
        'POST',
        '/repos/$owner/$repo/git/refs',
        body: {
          'ref': 'refs/heads/$branch',
          'sha': newCommitSha,
        },
      );
    }

    return newCommitSha;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PULL — Fetch Tree and Deserialize
  // ═══════════════════════════════════════════════════════════════════════════

  /// Pull all files from a specific commit/tree
  /// Returns map of path -> file content
  Future<Map<String, String>> pullCollection({
    required String owner,
    required String repo,
    required String commitSha,
  }) async {
    // Get commit to find tree SHA
    final commitData = await _authenticatedRequest(
      'GET',
      '/repos/$owner/$repo/git/commits/$commitSha',
    );
    final treeSha = commitData['tree']['sha'];

    // Get full tree recursively
    final treeData = await _authenticatedRequest(
      'GET',
      '/repos/$owner/$repo/git/trees/$treeSha?recursive=1',
    );

    // Fetch each blob
    final files = <String, String>{};
    
    for (final item in treeData['tree']) {
      if (item['type'] == 'blob' && item['path'].endsWith('.json')) {
        final blobData = await _authenticatedRequest(
          'GET',
          '/repos/$owner/$repo/git/blobs/${item['sha']}',
        );
        
        final content = blobData['encoding'] == 'base64'
            ? utf8.decode(base64Decode(blobData['content'].replaceAll('\n', '')))
            : blobData['content'];
        
        files[item['path']] = content;
      }
    }

    return files;
  }

  /// Pull latest from a branch
  Future<PullResult> pullBranch({
    required String owner,
    required String repo,
    required String branch,
  }) async {
    final refData = await _authenticatedRequest(
      'GET',
      '/repos/$owner/$repo/git/refs/heads/$branch',
    );
    final commitSha = refData['object']['sha'];
    
    final files = await pullCollection(
      owner: owner,
      repo: repo,
      commitSha: commitSha,
    );
    
    return PullResult(commitSha: commitSha, files: files);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMMIT HISTORY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get commit history for a branch
  Future<List<CommitInfo>> getCommitHistory({
    required String owner,
    required String repo,
    required String branch,
    int perPage = 30,
  }) async {
    final response = await _authenticatedRequest(
      'GET',
      '/repos/$owner/$repo/commits?sha=$branch&per_page=$perPage',
    );

    return (response as List).map((c) => CommitInfo(
      sha: c['sha'],
      message: c['commit']['message'],
      author: c['commit']['author']['name'],
      email: c['commit']['author']['email'],
      date: DateTime.parse(c['commit']['author']['date']),
      treeSha: c['commit']['tree']['sha'],
    )).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BRANCH OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// List all branches
  Future<List<BranchInfo>> listBranches(String owner, String repo) async {
    final response = await _authenticatedRequest(
      'GET',
      '/repos/$owner/$repo/branches',
    );

    return (response as List).map((b) => BranchInfo(
      name: b['name'],
      sha: b['commit']['sha'],
      protected: b['protected'] ?? false,
    )).toList();
  }

  /// Create a new branch from a commit
  Future<void> createBranch({
    required String owner,
    required String repo,
    required String branchName,
    required String fromSha,
  }) async {
    await _authenticatedRequest(
      'POST',
      '/repos/$owner/$repo/git/refs',
      body: {
        'ref': 'refs/heads/$branchName',
        'sha': fromSha,
      },
    );
  }

  /// Delete a branch
  Future<void> deleteBranch({
    required String owner,
    required String repo,
    required String branchName,
  }) async {
    await _authenticatedRequest(
      'DELETE',
      '/repos/$owner/$repo/git/refs/heads/$branchName',
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<dynamic> _authenticatedRequest(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final token = await getToken();
    if (token == null) {
      throw GitHubException('Not authenticated');
    }

    final uri = Uri.parse('$_baseUrl$path');
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    };

    http.Response response;

    switch (method) {
      case 'GET':
        response = await http.get(uri, headers: headers);
        break;
      case 'POST':
        headers['Content-Type'] = 'application/json';
        response = await http.post(uri, headers: headers, body: jsonEncode(body));
        break;
      case 'PATCH':
        headers['Content-Type'] = 'application/json';
        response = await http.patch(uri, headers: headers, body: jsonEncode(body));
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: headers);
        break;
      default:
        throw GitHubException('Unknown HTTP method: $method');
    }

    if (response.statusCode == 204) {
      return null; // No content (e.g., DELETE success)
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw GitHubException(
      'GitHub API error (${response.statusCode}): ${response.body}',
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════════════════════════════

class DeviceFlowResponse {
  final String deviceCode;
  final String userCode;
  final String verificationUri;
  final int expiresIn;
  final int interval;

  DeviceFlowResponse({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.expiresIn,
    required this.interval,
  });
}

class RepoInfo {
  final String owner;
  final String name;
  final String fullName;
  final String defaultBranch;
  final bool private;

  RepoInfo({
    required this.owner,
    required this.name,
    required this.fullName,
    required this.defaultBranch,
    required this.private,
  });
}

class CommitInfo {
  final String sha;
  final String message;
  final String author;
  final String email;
  final DateTime date;
  final String treeSha;

  CommitInfo({
    required this.sha,
    required this.message,
    required this.author,
    required this.email,
    required this.date,
    required this.treeSha,
  });
}

class BranchInfo {
  final String name;
  final String sha;
  final bool protected;

  BranchInfo({
    required this.name,
    required this.sha,
    required this.protected,
  });
}

class PullResult {
  final String commitSha;
  final Map<String, String> files;

  PullResult({required this.commitSha, required this.files});
}

class GitHubException implements Exception {
  final String message;
  GitHubException(this.message);

  @override
  String toString() => 'GitHubException: $message';
}
```

---

## Testing with cURL

### Prerequisites

1. OAuth App registered with Device Flow enabled
2. Client ID: `Ov23lisXbdRM4Sc4wwe1` (replace with yours)

### Step 1: Get Device Code

```bash
curl -X POST "https://github.com/login/device/code" \
  -H "Accept: application/json" \
  -d "client_id=Ov23lisXbdRM4Sc4wwe1&scope=repo"
```

**Response:**
```json
{
  "device_code": "3584d83530557fdd1f46af8289938c8ef79f9dc5",
  "user_code": "WDJB-MJHT",
  "verification_uri": "https://github.com/login/device",
  "expires_in": 899,
  "interval": 5
}
```

### Step 2: Authorize

1. Open https://github.com/login/device in browser
2. Enter the `user_code` (e.g., `WDJB-MJHT`)
3. Click **Authorize**

### Step 3: Poll for Token

```bash
curl -X POST "https://github.com/login/oauth/access_token" \
  -H "Accept: application/json" \
  -d "client_id=Ov23lisXbdRM4Sc4wwe1&device_code=YOUR_DEVICE_CODE&grant_type=urn:ietf:params:oauth:grant-type:device_code"
```

**Response:**
```json
{
  "access_token": "gho_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "token_type": "bearer",
  "scope": "repo"
}
```

### Step 4: Create Repository

```bash
curl -X POST "https://api.github.com/user/repos" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d '{"name": "my-api-collection", "private": true}'
```

### Step 5: Create a Blob

```bash
curl -X POST "https://api.github.com/repos/YOUR_USERNAME/my-api-collection/git/blobs" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d '{
    "content": "{\"id\": \"req_001\", \"name\": \"Get Users\", \"method\": \"GET\", \"url\": \"https://api.example.com/users\"}",
    "encoding": "utf-8"
  }'
```

**Response:**
```json
{
  "sha": "abc123...",
  "url": "..."
}
```

### Step 6: Create a Tree

```bash
curl -X POST "https://api.github.com/repos/YOUR_USERNAME/my-api-collection/git/trees" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d '{
    "tree": [
      {
        "path": "requests/get_users.json",
        "mode": "100644",
        "type": "blob",
        "sha": "BLOB_SHA_FROM_STEP_5"
      }
    ]
  }'
```

### Step 7: Create a Commit

```bash
curl -X POST "https://api.github.com/repos/YOUR_USERNAME/my-api-collection/git/commits" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d '{
    "message": "Initial commit from API Dash",
    "tree": "TREE_SHA_FROM_STEP_6"
  }'
```

### Step 8: Create Branch Reference

```bash
curl -X POST "https://api.github.com/repos/YOUR_USERNAME/my-api-collection/git/refs" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d '{
    "ref": "refs/heads/main",
    "sha": "COMMIT_SHA_FROM_STEP_7"
  }'
```

### Step 9: Verify

Visit `https://github.com/YOUR_USERNAME/my-api-collection` — you should see your repo with the JSON file!

---

## Summary

| Component | Implementation |
|-----------|----------------|
| **Auth** | OAuth device flow — user enters code at github.com/login/device |
| **Token Storage** | `flutter_secure_storage` (Keychain on macOS/iOS, EncryptedSharedPreferences on Android) |
| **Push** | Create blobs → Create tree → Create commit → Update ref |
| **Pull** | Fetch ref → Get commit → Get tree recursively → Fetch blobs |
| **Rollback** | Same as pull, but with a specific commit SHA |
| **Branches** | List/create/delete via `/git/refs` endpoints |

The user never thinks about Git internals — they just click a button to share, version, or roll back their collection.
