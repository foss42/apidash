/// Security utilities for code generation
/// Provides sanitization and validation for generated code to prevent injection attacks
class SecureCodeGenUtils {
  /// Maximum length for any user input field
  static const int _maxFieldLength = 10000;

  /// Validates if a field name is safe (alphanumeric and underscore only)
  static bool isValidFieldName(String name) {
    if (name.isEmpty || name.length > 255) {
      return false;
    }
    return RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(name);
  }

  /// Comprehensive JavaScript string escaping
  /// Prevents XSS and code injection in generated JavaScript code
  static String escapeJavaScript(String input) {
    if (input.length > _maxFieldLength) {
      throw SecurityException('Input exceeds maximum length');
    }

    return input
        .replaceAll('\\', '\\\\')      // Backslash
        .replaceAll('"', '\\"')         // Double quote
        .replaceAll("'", "\\'")         // Single quote
        .replaceAll('\n', '\\n')        // Newline
        .replaceAll('\r', '\\r')        // Carriage return
        .replaceAll('\t', '\\t')        // Tab
        .replaceAll('\b', '\\b')        // Backspace
        .replaceAll('\f', '\\f')        // Form feed
        .replaceAll('<', '\\x3C')       // Less than (XSS protection)
        .replaceAll('>', '\\x3E')       // Greater than
        .replaceAll('&', '\\x26')       // Ampersand
        .replaceAll('/', '\\/')         // Forward slash
        .replaceAll('\u2028', '\\u2028') // Line separator
        .replaceAll('\u2029', '\\u2029'); // Paragraph separator
  }

  /// HTML escaping for generated code comments
  static String escapeHtml(String input) {
    if (input.length > _maxFieldLength) {
      throw SecurityException('Input exceeds maximum length');
    }

    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  /// Python string escaping
  static String escapePython(String input) {
    if (input.length > _maxFieldLength) {
      throw SecurityException('Input exceeds maximum length');
    }

    return input
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll("'", "\\'")
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  /// Validate and sanitize URL
  /// Returns null if URL is invalid
  static String? sanitizeUrl(String url) {
    if (url.length > _maxFieldLength) {
      return null;
    }

    try {
      final uri = Uri.parse(url);

      // Only allow http and https schemes
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        return null;
      }

      // Validate host
      if (uri.host.isEmpty) {
        return null;
      }

      return uri.toString();
    } catch (e) {
      return null;
    }
  }

  /// Validate that input doesn't contain dangerous patterns
  static bool containsDangerousPattern(String input) {
    // Check for common injection patterns
    final dangerousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'onerror\s*=', caseSensitive: false),
      RegExp(r'onload\s*=', caseSensitive: false),
      RegExp(r'eval\s*\(', caseSensitive: false),
      RegExp(r'exec\s*\(', caseSensitive: false),
    ];

    for (final pattern in dangerousPatterns) {
      if (pattern.hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  /// Sanitize multiline string for code generation
  static String sanitizeMultiline(String input) {
    if (input.length > _maxFieldLength) {
      throw SecurityException('Input exceeds maximum length');
    }

    // Remove any null bytes
    return input.replaceAll('\x00', '');
  }
}

/// Exception thrown when a security validation fails
class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}
