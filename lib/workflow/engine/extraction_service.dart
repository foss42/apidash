import 'dart:convert';

import 'package:apidash_core/apidash_core.dart';

class WorkflowExtractionService {
  const WorkflowExtractionService();

  String? extract({
    required String source,
    required String jsonPath,
    required HttpResponseModel? response,
    required int? statusCode,
  }) {
    if (source == 'response.status') {
      return statusCode?.toString();
    }
    if (response == null) {
      return null;
    }
    if (source == 'response.body') {
      return _extractJsonPath(response.body, jsonPath);
    }
    if (source.startsWith('header.')) {
      final headerName = source.substring('header.'.length).toLowerCase();
      final headers = response.headers;
      if (headers == null) {
        return null;
      }
      for (final entry in headers.entries) {
        if (entry.key.toLowerCase() == headerName) {
          return entry.value;
        }
      }
      return null;
    }
    return null;
  }

  String? _extractJsonPath(String? body, String jsonPath) {
    if (body == null || body.isEmpty || jsonPath.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(body);
      var path = jsonPath.startsWith(r'$') ? jsonPath.substring(1) : jsonPath;
      if (path.startsWith('.')) {
        path = path.substring(1);
      }
      path = normalizeExtractionPath(path);
      final segments = path
          .split('.')
          .where((segment) => segment.isNotEmpty)
          .toList();
      dynamic current = decoded;
      for (final segment in segments) {
        if (current is Map) {
          current = current[segment];
        } else if (current is List) {
          final index = int.tryParse(segment);
          if (index == null || index < 0 || index >= current.length) {
            return null;
          }
          current = current[index];
        } else {
          return null;
        }
      }
      if (current == null) {
        return null;
      }
      return current is String ? current : jsonEncode(current);
    } catch (_) {
      return null;
    }
  }
}

/// Accepts `data.0.id`, `data[0].id`, and `$data[0].id`.
String normalizeExtractionPath(String path) {
  var out = path.trim();
  out = out.replaceAllMapped(
    RegExp(r'\["([^"]+)"\]'),
    (m) => '.${m.group(1)}',
  );
  out = out.replaceAllMapped(
    RegExp(r"\['([^']+)'\]"),
    (m) => '.${m.group(1)}',
  );
  out = out.replaceAllMapped(
    RegExp(r'\[(\d+)\]'),
    (m) => '.${m.group(1)}',
  );
  out = out.replaceAll(RegExp(r'\.+'), '.');
  if (out.startsWith('.')) {
    out = out.substring(1);
  }
  if (out.endsWith('.')) {
    out = out.substring(0, out.length - 1);
  }
  return out;
}
