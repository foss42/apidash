import 'dart:math' as math;

/// Security utility for environment variable substitution
/// Protects against ReDoS (Regular Expression Denial of Service) attacks
class SecureEnvVarUtils {
  // Maximum input length to prevent DoS attacks
  static const int _maxInputLength = 10000;
  
  // Maximum number of variables before switching to alternative algorithm
  static const int _maxRegexComplexity = 1000;

  /// Validates if a variable name is safe (alphanumeric, underscore, dash only)
  static bool isValidVariableName(String name) {
    if (name.isEmpty || name.length > 100) {
      return false;
    }
    return RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(name);
  }

  /// Escapes special regex characters in a string
  static String escapeRegex(String input) {
    return input.replaceAllMapped(
      RegExp(r'[.*+?^${}()|[\]\\]'),
      (match) => '\\${match.group(0)}',
    );
  }

  /// Safely substitute environment variables without ReDoS vulnerability
  /// 
  /// Validates input length and complexity before processing
  /// Uses alternative string matching for large variable sets
  static String? substituteVariablesSafe(
    String? input,
    Map<String, String> envVarMap,
  ) {
    if (input == null) return null;
    if (envVarMap.keys.isEmpty) return input;

    // Check input length to prevent DoS
    if (input.length > _maxInputLength) {
      throw SecurityException(
        'Input exceeds maximum length of $_maxInputLength characters'
      );
    }

    // Validate all variable names before processing
    final invalidNames = envVarMap.keys.where((key) => !isValidVariableName(key));
    if (invalidNames.isNotEmpty) {
      throw SecurityException(
        'Invalid variable names found: ${invalidNames.join(', ')}'
      );
    }

    // For large variable sets, use direct string replacement to avoid ReDoS
    if (envVarMap.keys.length > _maxRegexComplexity) {
      return _substituteWithoutRegex(input, envVarMap);
    }

    // For reasonable sets, use regex with escaped keys
    try {
      final escapedKeys = envVarMap.keys.map(escapeRegex).join('|');
      final regex = RegExp(r'\{\{(' + escapedKeys + r')\}\}');
      
      return input.replaceAllMapped(regex, (match) {
        final key = match.group(1)?.trim() ?? '';
        return envVarMap[key] ?? '{{$key}}';
      });
    } catch (e) {
      // Fallback to safe method on any error
      return _substituteWithoutRegex(input, envVarMap);
    }
  }

  /// Alternative substitution method that doesn't use regex
  /// Safe for large variable sets
  static String _substituteWithoutRegex(
    String input,
    Map<String, String> envVarMap,
  ) {
    var result = input;
    
    // Sort by length descending to handle overlapping keys correctly
    final sortedEntries = envVarMap.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    
    for (var entry in sortedEntries) {
      final pattern = '{{${entry.key}}}';
      result = result.replaceAll(pattern, entry.value);
    }
    
    return result;
  }
}

/// Exception thrown when a security validation fails
class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}
