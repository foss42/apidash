const String _redactedValue = '[REDACTED]';

const Set<String> _sensitiveQueryKeys = {
  'access_token',
  'api_key',
  'apikey',
  'auth',
  'authorization',
  'client_secret',
  'code',
  'id_token',
  'key',
  'password',
  'refresh_token',
  'secret',
  'session',
  'signature',
  'state',
  'token',
};

const Set<String> _sensitiveHeaderNames = {
  'authorization',
  'cookie',
  'proxy-authorization',
  'set-cookie',
  'x-api-key',
  'x-auth-token',
  'x-csrf-token',
};

/// Redacts common secrets before values are written to diagnostics or logs.
String redactSensitiveValue(
  Object? value, {
  String? name,
}) {
  if (value == null) {
    return '';
  }

  if (name != null && _isSensitiveName(name)) {
    return _redactedValue;
  }

  return value
      .toString()
      .replaceAllMapped(
        RegExp(
          r'(?i)\b(bearer|basic)\s+[A-Za-z0-9._~+/=-]+',
        ),
        (match) => '${match.group(1)} $_redactedValue',
      )
      .replaceAllMapped(
        RegExp(
          r'(?i)\b(access_token|api_?key|auth|authorization|client_secret|'
          r'id_token|password|refresh_token|secret|token)=([^&\s]+)',
        ),
        (match) => '${match.group(1)}=$_redactedValue',
      );
}

/// Redacts sensitive query parameters while preserving the non-secret URI shape.
String redactSensitiveUri(Uri uri) {
  if (!uri.hasQuery) {
    return uri.toString();
  }

  final redactedQueryParameters = uri.queryParametersAll.map(
    (key, values) {
      final nextValues = _isSensitiveName(key)
          ? List<String>.filled(values.length, _redactedValue)
          : values;
      return MapEntry(key, nextValues);
    },
  );

  return uri.replace(queryParameters: redactedQueryParameters).toString();
}

bool _isSensitiveName(String name) {
  final normalized = name.toLowerCase().replaceAll('-', '_');
  return _sensitiveQueryKeys.contains(normalized) ||
      _sensitiveHeaderNames.contains(name.toLowerCase());
}
