# Security Remediation Guide

This guide provides practical solutions and code examples to fix the identified security vulnerabilities in API Dash.

---

## 1. Fix Critical: Encrypted Credential Storage

### Current Implementation (Vulnerable)
```dart
// lib/services/hive_services.dart
Future<void> setEnvironment(String id, Map<String, dynamic>? environmentJson) =>
    environmentBox.put(id, environmentJson);
```

### Recommended Solution

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class SecureHiveHandler {
  static const String _encryptionKeyName = 'hive_encryption_key';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Get or create encryption key
  Future<encrypt.Key> _getEncryptionKey() async {
    String? keyString = await _secureStorage.read(key: _encryptionKeyName);
    
    if (keyString == null) {
      // Generate new key
      final key = encrypt.Key.fromSecureRandom(32);
      await _secureStorage.write(
        key: _encryptionKeyName,
        value: base64.encode(key.bytes),
      );
      return key;
    }
    
    return encrypt.Key(base64.decode(keyString));
  }
  
  // Encrypt sensitive data before storage
  Future<String> _encryptData(String plaintext) async {
    final key = await _getEncryptionKey();
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    
    // Store IV with encrypted data
    return '${base64.encode(iv.bytes)}:${encrypted.base64}';
  }
  
  // Decrypt data when reading
  Future<String> _decryptData(String ciphertext) async {
    final key = await _getEncryptionKey();
    final parts = ciphertext.split(':');
    
    if (parts.length != 2) {
      throw Exception('Invalid encrypted data format');
    }
    
    final iv = encrypt.IV(base64.decode(parts[0]));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    
    return encrypter.decrypt64(parts[1], iv: iv);
  }
  
  // Secure environment storage
  Future<void> setEnvironmentSecure(
    String id,
    Map<String, dynamic>? environmentJson,
  ) async {
    if (environmentJson == null) return;
    
    // Extract and encrypt sensitive fields
    final secureData = Map<String, dynamic>.from(environmentJson);
    
    if (secureData['values'] is List) {
      for (var i = 0; i < secureData['values'].length; i++) {
        final variable = secureData['values'][i];
        
        // Encrypt secret type variables
        if (variable['type'] == 'secret' && variable['value'] != null) {
          secureData['values'][i]['value'] = 
            await _encryptData(variable['value'].toString());
          secureData['values'][i]['encrypted'] = true;
        }
      }
    }
    
    await environmentBox.put(id, secureData);
  }
  
  // Secure environment retrieval
  Future<Map<String, dynamic>?> getEnvironmentSecure(String id) async {
    final data = environmentBox.get(id);
    if (data == null) return null;
    
    final secureData = Map<String, dynamic>.from(data);
    
    if (secureData['values'] is List) {
      for (var i = 0; i < secureData['values'].length; i++) {
        final variable = secureData['values'][i];
        
        // Decrypt encrypted variables
        if (variable['encrypted'] == true && variable['value'] != null) {
          secureData['values'][i]['value'] = 
            await _decryptData(variable['value'].toString());
          secureData['values'][i]['encrypted'] = false;
        }
      }
    }
    
    return secureData;
  }
}
```

**Dependencies to add in `pubspec.yaml`:**
```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
  encrypt: ^5.0.3
```

---

## 2. Fix Critical: JavaScript Sandbox Implementation

### Current Implementation (Vulnerable)
```dart
// lib/providers/js_runtime_notifier.dart
final res = _runtime.evaluate(fullScript);  // No validation!
```

### Recommended Solution

```dart
import 'package:flutter/foundation.dart';

class SecureJsRuntimeNotifier extends StateNotifier<JsRuntimeState> {
  // Script validation
  static const List<String> _dangerousPatterns = [
    r'eval\s*\(',
    r'Function\s*\(',
    r'require\s*\(',
    r'import\s*\(',
    r'__proto__',
    r'constructor\s*\[',
    r'process\.env',
    r'fs\.',
    r'child_process',
  ];
  
  static const int _maxScriptLength = 50000; // 50KB max
  static const Duration _maxExecutionTime = Duration(seconds: 5);
  
  // Validate user script before execution
  bool _validateScript(String script) {
    // Length check
    if (script.length > _maxScriptLength) {
      throw SecurityException(
        'Script exceeds maximum length of $_maxScriptLength characters'
      );
    }
    
    // Check for dangerous patterns
    for (final pattern in _dangerousPatterns) {
      final regex = RegExp(pattern, caseSensitive: false);
      if (regex.hasMatch(script)) {
        throw SecurityException(
          'Script contains forbidden pattern: $pattern'
        );
      }
    }
    
    return true;
  }
  
  // Sanitize script output
  String _sanitizeOutput(String output) {
    // Remove potential sensitive data patterns
    return output
      .replaceAll(RegExp(r'password["\']?\s*[:=]\s*["\'][^"\']+["\']', 
                         caseSensitive: false), 'password:***')
      .replaceAll(RegExp(r'token["\']?\s*[:=]\s*["\'][^"\']+["\']',
                         caseSensitive: false), 'token:***')
      .replaceAll(RegExp(r'secret["\']?\s*[:=]\s*["\'][^"\']+["\']',
                         caseSensitive: false), 'secret:***');
  }
  
  // Execute with timeout and validation
  Future<JsEvalResult> evaluateSecure(String userScript) async {
    try {
      // Validate before execution
      _validateScript(userScript);
      
      final fullScript = '''
        (function() {
          try {
            // Disable dangerous globals
            delete globalThis.eval;
            delete globalThis.Function;
            
            // User script in isolated scope
            $userScript
          } catch (error) {
            return JSON.stringify({ error: error.message });
          }
        })();
      ''';
      
      // Execute with timeout
      final result = await Future.any([
        Future(() => _runtime.evaluate(fullScript)),
        Future.delayed(_maxExecutionTime, () => 
          throw TimeoutException('Script execution timeout')
        ),
      ]);
      
      // Sanitize output
      if (result.stringResult.isNotEmpty) {
        result.stringResult = _sanitizeOutput(result.stringResult);
      }
      
      return result;
    } on TimeoutException {
      throw SecurityException('Script execution exceeded time limit');
    } catch (e) {
      throw SecurityException('Script execution failed: $e');
    }
  }
  
  // Require user consent for sensitive operations
  Future<bool> _requestUserConsent(String operation) async {
    // Show dialog asking user permission
    // Return true if approved, false otherwise
    return false; // Implement actual UI dialog
  }
  
  // Execute with user consent
  Future<JsEvalResult> executeWithConsent({
    required String script,
    required String operation,
  }) async {
    final hasConsent = await _requestUserConsent(operation);
    
    if (!hasConsent) {
      throw SecurityException('User denied permission for: $operation');
    }
    
    return evaluateSecure(script);
  }
}

class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);
  
  @override
  String toString() => 'SecurityException: $message';
}
```

---

## 3. Fix Critical: Encrypted OAuth2 Token Storage

### Current Implementation (Vulnerable)
```dart
// oauth2_utils.dart
if (credentialsFile != null) {
  await credentialsFile.writeAsString(client.credentials.toJson());
}
```

### Recommended Solution

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

class SecureOAuth2Storage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Generate key from client credentials
  String _generateStorageKey(String clientId, String tokenUrl) {
    final combined = '$clientId:$tokenUrl';
    final bytes = utf8.encode(combined);
    final hash = sha256.convert(bytes);
    return 'oauth2_${hash.toString().substring(0, 16)}';
  }
  
  // Store credentials securely
  Future<void> storeCredentials({
    required String clientId,
    required String tokenUrl,
    required String credentialsJson,
  }) async {
    final key = _generateStorageKey(clientId, tokenUrl);
    
    // Encrypt the credentials
    final encryptionKey = encrypt.Key.fromSecureRandom(32);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(encryptionKey));
    
    final encrypted = encrypter.encrypt(credentialsJson, iv: iv);
    
    // Store encryption key separately
    await _secureStorage.write(
      key: '${key}_key',
      value: base64.encode(encryptionKey.bytes),
    );
    
    // Store IV separately
    await _secureStorage.write(
      key: '${key}_iv',
      value: base64.encode(iv.bytes),
    );
    
    // Store encrypted data
    await _secureStorage.write(
      key: key,
      value: encrypted.base64,
    );
  }
  
  // Retrieve credentials securely
  Future<String?> retrieveCredentials({
    required String clientId,
    required String tokenUrl,
  }) async {
    final key = _generateStorageKey(clientId, tokenUrl);
    
    // Read all components
    final encryptedData = await _secureStorage.read(key: key);
    final keyData = await _secureStorage.read(key: '${key}_key');
    final ivData = await _secureStorage.read(key: '${key}_iv');
    
    if (encryptedData == null || keyData == null || ivData == null) {
      return null;
    }
    
    // Decrypt
    final encryptionKey = encrypt.Key(base64.decode(keyData));
    final iv = encrypt.IV(base64.decode(ivData));
    final encrypter = encrypt.Encrypter(encrypt.AES(encryptionKey));
    
    return encrypter.decrypt64(encryptedData, iv: iv);
  }
  
  // Delete credentials
  Future<void> deleteCredentials({
    required String clientId,
    required String tokenUrl,
  }) async {
    final key = _generateStorageKey(clientId, tokenUrl);
    
    await _secureStorage.delete(key: key);
    await _secureStorage.delete(key: '${key}_key');
    await _secureStorage.delete(key: '${key}_iv');
  }
  
  // Clear all OAuth credentials
  Future<void> clearAllCredentials() async {
    final allKeys = await _secureStorage.readAll();
    
    for (final key in allKeys.keys) {
      if (key.startsWith('oauth2_')) {
        await _secureStorage.delete(key: key);
      }
    }
  }
}

// Updated OAuth2 handler with secure storage
Future<oauth2.Client> secureOAuth2ClientCredentialsGrant({
  required AuthOAuth2Model oauth2Model,
}) async {
  final secureStorage = SecureOAuth2Storage();
  
  // Try to retrieve saved credentials
  final savedCredentials = await secureStorage.retrieveCredentials(
    clientId: oauth2Model.clientId,
    tokenUrl: oauth2Model.accessTokenUrl,
  );
  
  if (savedCredentials != null) {
    try {
      final credentials = oauth2.Credentials.fromJson(savedCredentials);
      
      if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
        return oauth2.Client(
          credentials,
          identifier: oauth2Model.clientId,
          secret: oauth2Model.clientSecret,
        );
      }
    } catch (e) {
      // Invalid credentials, continue with fresh authentication
    }
  }
  
  // Perform fresh authentication
  final client = await oauth2.clientCredentialsGrant(
    Uri.parse(oauth2Model.accessTokenUrl),
    oauth2Model.clientId,
    oauth2Model.clientSecret,
    scopes: oauth2Model.scope != null ? [oauth2Model.scope!] : null,
  );
  
  // Store encrypted credentials
  await secureStorage.storeCredentials(
    clientId: oauth2Model.clientId,
    tokenUrl: oauth2Model.accessTokenUrl,
    credentialsJson: client.credentials.toJson(),
  );
  
  return client;
}
```

---

## 4. Fix High: Input Validation for Code Generation

### Current Implementation (Vulnerable)
```dart
// lib/codegen/js/axios.dart
var sanitizedJSObject = sanitzeJSObject(kJsonEncoder.convert(formParams));
```

### Recommended Solution

```dart
class SecureCodeGenerator {
  // Comprehensive JavaScript string escaping
  static String escapeJavaScript(String input) {
    return input
      .replaceAll('\\', '\\\\')  // Backslash
      .replaceAll('"', '\\"')     // Double quote
      .replaceAll("'", "\\'")     // Single quote
      .replaceAll('\n', '\\n')    // Newline
      .replaceAll('\r', '\\r')    // Carriage return
      .replaceAll('\t', '\\t')    // Tab
      .replaceAll('\b', '\\b')    // Backspace
      .replaceAll('\f', '\\f')    // Form feed
      .replaceAll('<', '\\x3C')   // Less than (XSS protection)
      .replaceAll('>', '\\x3E')   // Greater than
      .replaceAll('&', '\\x26')   // Ampersand
      .replaceAll('/', '\\/')     // Forward slash
      .replaceAll('\u2028', '\\u2028')  // Line separator
      .replaceAll('\u2029', '\\u2029'); // Paragraph separator
  }
  
  // HTML escaping for generated code comments
  static String escapeHtml(String input) {
    return input
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#x27;')
      .replaceAll('/', '&#x2F;');
  }
  
  // Validate and sanitize URL
  static String? sanitizeUrl(String url) {
    try {
      final uri = Uri.parse(url);
      
      // Only allow http and https
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        throw FormatException('Invalid URL scheme');
      }
      
      // Validate host
      if (uri.host.isEmpty) {
        throw FormatException('Invalid host');
      }
      
      return uri.toString();
    } catch (e) {
      return null;
    }
  }
  
  // Validate field names (alphanumeric and underscore only)
  static bool isValidFieldName(String name) {
    return RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(name);
  }
  
  // Generate secure Axios code
  static String? generateSecureAxiosCode(HttpRequestModel requestModel) {
    try {
      final url = sanitizeUrl(requestModel.url);
      if (url == null) {
        throw SecurityException('Invalid URL');
      }
      
      final code = StringBuffer();
      
      // Add security notice
      code.writeln('// Generated by API Dash - Security Notice:');
      code.writeln('// Please review and validate all parameters before use');
      code.writeln('// in production environments.');
      code.writeln();
      
      code.writeln("import axios from 'axios';");
      code.writeln();
      
      code.writeln('const config = {');
      code.writeln('  url: "${escapeJavaScript(url)}",');
      code.writeln('  method: "${requestModel.method.name.toLowerCase()}",');
      
      // Add headers with validation
      if (requestModel.headers != null && requestModel.headers!.isNotEmpty) {
        code.writeln('  headers: {');
        for (var header in requestModel.headers!) {
          if (!isValidFieldName(header.name)) {
            throw SecurityException('Invalid header name: ${header.name}');
          }
          code.writeln('    "${escapeJavaScript(header.name)}": ' +
                       '"${escapeJavaScript(header.value ?? '')}",');
        }
        code.writeln('  },');
      }
      
      // Add params with validation
      if (requestModel.params != null && requestModel.params!.isNotEmpty) {
        code.writeln('  params: {');
        for (var param in requestModel.params!) {
          if (!isValidFieldName(param.name)) {
            throw SecurityException('Invalid parameter name: ${param.name}');
          }
          code.writeln('    "${escapeJavaScript(param.name)}": ' +
                       '"${escapeJavaScript(param.value ?? '')}",');
        }
        code.writeln('  },');
      }
      
      code.writeln('};');
      code.writeln();
      
      code.writeln('axios(config)');
      code.writeln('  .then(res => {');
      code.writeln('    console.log(res.status);');
      code.writeln('    console.log(res.data);');
      code.writeln('  })');
      code.writeln('  .catch(err => {');
      code.writeln('    console.error(err.message);');
      code.writeln('  });');
      
      return code.toString();
    } catch (e) {
      return null;
    }
  }
}
```

---

## 5. Fix High: ReDoS Protection

### Current Implementation (Vulnerable)
```dart
// lib/utils/envvar_utils.dart
final regex = RegExp("{{(${envVarMap.keys.join('|')})}}");
```

### Recommended Solution

```dart
class SecureEnvVarUtils {
  static const int _maxRegexComplexity = 1000;
  static const int _maxInputLength = 10000;
  
  // Safe variable substitution without ReDoS
  static String? substituteVariablesSafe(
    String? input,
    Map<String, String> envVarMap,
  ) {
    if (input == null) return null;
    if (envVarMap.keys.isEmpty) return input;
    
    // Length check to prevent DoS
    if (input.length > _maxInputLength) {
      throw SecurityException(
        'Input exceeds maximum length of $_maxInputLength'
      );
    }
    
    // Complexity check
    if (envVarMap.keys.length > _maxRegexComplexity) {
      // Use alternative algorithm for large maps
      return _substituteWithoutRegex(input, envVarMap);
    }
    
    // Validate variable names before joining
    final safeKeys = envVarMap.keys
      .where((key) => _isValidVariableName(key))
      .toList();
    
    if (safeKeys.isEmpty) return input;
    
    // Escape special regex characters in keys
    final escapedKeys = safeKeys.map(_escapeRegex).join('|');
    
    // Use non-capturing group and limit backtracking
    final regex = RegExp(
      r'\{\{(' + escapedKeys + r')\}\}',
      caseSensitive: true,
    );
    
    try {
      return input.replaceAllMapped(regex, (match) {
        final key = match.group(1)?.trim() ?? '';
        return envVarMap[key] ?? '{{$key}}';
      });
    } catch (e) {
      // Fallback to safe method on any error
      return _substituteWithoutRegex(input, envVarMap);
    }
  }
  
  // Alternative algorithm without regex
  static String _substituteWithoutRegex(
    String input,
    Map<String, String> envVarMap,
  ) {
    var result = input;
    
    for (var entry in envVarMap.entries) {
      final pattern = '{{${entry.key}}}';
      result = result.replaceAll(pattern, entry.value);
    }
    
    return result;
  }
  
  // Validate variable name
  static bool _isValidVariableName(String name) {
    // Only alphanumeric, underscore, and dash
    return RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(name) && 
           name.length <= 100;
  }
  
  // Escape regex special characters
  static String _escapeRegex(String input) {
    return input.replaceAllMapped(
      RegExp(r'[.*+?^${}()|[\]\\]'),
      (match) => '\\${match.group(0)}',
    );
  }
}
```

---

## 6. Remove Debug Logging of Sensitive Data

### Files to Update

1. **lib/services/hive_services.dart**
```dart
// REMOVE these lines:
debugPrint("ERROR OPEN HIVE BOXES: $e");
debugPrint("ERROR CLEAR HIVE BOXES: $e");
debugPrint("ERROR DELETE HIVE BOXES: $e");
debugPrint("Trying to open Hive boxes");

// REPLACE with:
import 'package:logging/logging.dart';

final _log = Logger('HiveServices');

Future<bool> openHiveBoxes() async {
  try {
    for (var box in kHiveBoxes) {
      if (box.$2 == HiveBoxType.normal) {
        await Hive.openBox(box.$1);
      } else if (box.$2 == HiveBoxType.lazy) {
        await Hive.openLazyBox(box.$1);
      }
    }
    return true;
  } catch (e) {
    _log.severe("Failed to open Hive boxes", e);  // No sensitive data
    return false;
  }
}
```

2. **packages/better_networking/lib/utils/auth/handle_auth.dart**
```dart
// REMOVE:
debugPrint(res.$1.credentials.accessToken);
debugPrint(client.credentials.accessToken);

// REPLACE with:
_log.info("OAuth2 authentication successful");  // No token logging!
```

---

## Testing Security Fixes

### Unit Tests for Encryption

```dart
// test/security/encryption_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Secure Storage Tests', () {
    test('Credentials are encrypted', () async {
      final handler = SecureHiveHandler();
      final testData = {'secret': 'my-api-key'};
      
      await handler.setEnvironmentSecure('test', testData);
      
      // Verify data is encrypted in storage
      final raw = environmentBox.get('test');
      expect(raw['values'][0]['value'], isNot(equals('my-api-key')));
      expect(raw['values'][0]['encrypted'], equals(true));
    });
    
    test('Decryption returns original data', () async {
      final handler = SecureHiveHandler();
      final testData = {
        'values': [
          {'key': 'API_KEY', 'value': 'secret-123', 'type': 'secret'}
        ]
      };
      
      await handler.setEnvironmentSecure('test', testData);
      final decrypted = await handler.getEnvironmentSecure('test');
      
      expect(decrypted!['values'][0]['value'], equals('secret-123'));
    });
  });
  
  group('JavaScript Security Tests', () {
    test('Dangerous patterns are blocked', () {
      final notifier = SecureJsRuntimeNotifier(ref);
      
      expect(
        () => notifier._validateScript('eval("alert(1)")'),
        throwsA(isA<SecurityException>()),
      );
    });
    
    test('Script length limit enforced', () {
      final notifier = SecureJsRuntimeNotifier(ref);
      final longScript = 'x' * 60000;
      
      expect(
        () => notifier._validateScript(longScript),
        throwsA(isA<SecurityException>()),
      );
    });
  });
}
```

---

## Migration Guide

### Step 1: Update Dependencies
```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
  encrypt: ^5.0.3
  logging: ^1.2.0
```

### Step 2: Migrate Existing Data
```dart
Future<void> migrateToEncryptedStorage() async {
  final oldHandler = HiveHandler();
  final newHandler = SecureHiveHandler();
  
  // Migrate environments
  final envIds = oldHandler.getEnvironmentIds() as List?;
  if (envIds != null) {
    for (final id in envIds) {
      final data = oldHandler.getEnvironment(id);
      await newHandler.setEnvironmentSecure(id, data);
    }
  }
  
  print('Migration complete. Please restart the application.');
}
```

### Step 3: Update UI Code
- Add loading indicators during decryption
- Show security indicators for encrypted data
- Add user warnings when downgrading security

---

## Additional Resources

- [OWASP Cryptographic Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html)
- [Flutter Security Best Practices](https://flutter.dev/docs/deployment/security)
- [OAuth 2.0 Security Best Current Practice](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-security-topics)
- [OWASP Input Validation Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)

---

**Last Updated:** 2025-10-11
