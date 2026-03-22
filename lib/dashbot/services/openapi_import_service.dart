import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';

/// Service to parse OpenAPI specifications and produce
/// a standard action message map understood by Dashbot.
class OpenApiImportService {
  /// Produce a concise, human-readable summary for a spec.
  static String summaryForSpec(OpenApi spec) {
    final servers = spec.servers ?? const [];
    int endpointsCount = 0;
    final methods = <String>{};
    (spec.paths ?? const {}).forEach((_, item) {
      final ops = <String, Operation?>{
        'GET': item.get,
        'POST': item.post,
        'PUT': item.put,
        'DELETE': item.delete,
        'PATCH': item.patch,
        'HEAD': item.head,
        'OPTIONS': item.options,
        'TRACE': item.trace,
      };
      ops.forEach((m, op) {
        if (op == null) return;
        endpointsCount += 1;
        methods.add(m);
      });
    });

    final title = spec.info.title.isNotEmpty ? spec.info.title : 'Untitled API';
    final version = spec.info.version;
    final server = servers.isNotEmpty ? servers.first.url : null;
    final summary = StringBuffer()
      ..writeln('- Title: $title (v$version)')
      ..writeln('- Server: ${server ?? '/'}')
      ..writeln('- Endpoints discovered: $endpointsCount')
      ..writeln('- Methods: ${methods.join(', ')}');
    return summary.toString();
  }

  /// Extract structured metadata from an OpenAPI spec for analytics/insights.
  /// Returns a JSON-serializable map capturing key details like title, version,
  /// servers, total endpoints, methods, tags and a concise list of routes.
  static Map<String, dynamic> extractSpecMeta(OpenApi spec,
      {int maxRoutes = 40}) {
    final servers = (spec.servers ?? const [])
        .map((s) => s.url)
        .where((u) => (u ?? '').trim().isNotEmpty)
        .map((u) => u!)
        .toList(growable: false);
    final title = spec.info.title.isNotEmpty ? spec.info.title : 'Untitled API';
    final version = spec.info.version;

    int endpointsCount = 0;
    final methods = <String>{};
    final tags = <String>{};
    final routes = <Map<String, dynamic>>[];
    final reqContentTypes = <String>{};
    final respContentTypes = <String>{};

    (spec.paths ?? const {}).forEach((path, item) {
      final ops = <String, Operation?>{
        'GET': item.get,
        'POST': item.post,
        'PUT': item.put,
        'DELETE': item.delete,
        'PATCH': item.patch,
        'HEAD': item.head,
        'OPTIONS': item.options,
        'TRACE': item.trace,
      };
      final presentMethods = <String>[];
      ops.forEach((method, op) {
        if (op == null) return;
        endpointsCount += 1;
        methods.add(method);
        presentMethods.add(method);
        // tags
        for (final t in op.tags ?? const []) {
          final tt = t?.trim() ?? '';
          if (tt.isNotEmpty) tags.add(tt);
        }
        // content types
        final reqCts = op.requestBody?.content?.keys;
        if (reqCts != null) reqContentTypes.addAll(reqCts);
        final resps = op.responses ?? const {};
        for (final r in resps.values) {
          final ct = r.content?.keys;
          if (ct != null) respContentTypes.addAll(ct);
        }
      });
      if (presentMethods.isNotEmpty) {
        routes.add({
          'path': path,
          'methods': presentMethods,
        });
      }
    });

    // Heuristic noteworthy route detection
    final noteworthy = routes
        .where((r) {
          final p = (r['path'] as String).toLowerCase();
          return p.contains('auth') ||
              p.contains('login') ||
              p.contains('status') ||
              p.contains('health') ||
              p.contains('user') ||
              p.contains('search');
        })
        .take(10)
        .toList();

    // Trim routes list to keep payload light
    final trimmedRoutes =
        routes.length > maxRoutes ? routes.take(maxRoutes).toList() : routes;

    return {
      'title': title,
      'version': version,
      'servers': servers,
      'baseUrl': servers.isNotEmpty ? servers.first : null,
      'endpointsCount': endpointsCount,
      'methods': methods.toList()..sort(),
      'tags': tags.toList()..sort(),
      'routes': trimmedRoutes,
      'noteworthyRoutes': noteworthy,
      'requestContentTypes': reqContentTypes.toList()..sort(),
      'responseContentTypes': respContentTypes.toList()..sort(),
    };
  }

  /// Try to parse a JSON or YAML OpenAPI spec string.
  /// Returns null if parsing fails.
  ///
  /// NOTE: There's a known issue with the openapi_spec package where
  /// security fields containing empty arrays (e.g., "security": [[]])
  /// cause parsing failures. This method includes a workaround.
  static OpenApi? tryParseSpec(String source) {
    try {
      return OpenApi.fromString(source: source, format: null);
    } catch (e) {
      // Try workaround for security field parsing issues
      try {
        final processedSource = _removeProblematicSecurityField(source);
        if (processedSource != source) {
          return OpenApi.fromString(source: processedSource, format: null);
        }
      } catch (_) {
        // Workaround failed, fall through to return null
      }
      return null;
    }
  }

  /// Removes problematic security fields that cause parsing issues.
  /// TODO: Remove this workaround once openapi_spec package fixes
  /// the issue with security fields containing empty arrays.
  static String _removeProblematicSecurityField(String source) {
    try {
      final spec = jsonDecode(source) as Map<String, dynamic>;

      if (spec.containsKey('security')) {
        final security = spec['security'];
        if (security is List && _hasEmptySecurityArrays(security)) {
          spec.remove('security');
          return jsonEncode(spec);
        }
      }

      return source;
    } catch (e) {
      throw FormatException('Failed to preprocess OpenAPI spec: $e');
    }
  }

  /// Checks if security list contains empty arrays that cause parsing issues.
  static bool _hasEmptySecurityArrays(List<dynamic> security) {
    return security.any((item) => item is List && item.isEmpty);
  }

  /// Build a single request payload from a path + method operation.
  /// The payload mirrors CurlImportService payload shape for reuse.
  static Map<String, dynamic> _payloadForOperation({
    required String baseUrl,
    required String path,
    required String method,
    required Operation op,
  }) {
    // Resolve URL (server may include variables; keep as-is if any)
    final url = baseUrl.endsWith('/')
        ? '${baseUrl.substring(0, baseUrl.length - 1)}$path'
        : '$baseUrl$path';

    // Headers from parameters in header "in": "header"
    final headers = <String, String>{};
    for (final p in op.parameters ?? const []) {
      // Use direct type checking since the parameter objects are union types
      if (p is ParameterHeader && p.name != null) {
        headers[p.name!] = '';
      }
    }

    // Request body and content-type heuristic
    String? body;
    bool isForm = false;
    final formData = <Map<String, String>>[];
    if (op.requestBody != null) {
      final content = op.requestBody!.content;
      // Prefer application/json
      if (content != null && content.isNotEmpty) {
        if (content.containsKey('application/json')) {
          headers['Content-Type'] = 'application/json';
          // Use example if any
          final media = content['application/json'];
          final ex = media?.example;
          if (ex != null) {
            body = jsonEncode(ex);
          } else {
            // Try schema default/example
            // final schema = media?.schema;
            // final example = schema?.example;
            // if (example != null) {
            //   body = jsonEncode(example);
            // }
          }
        } else if (content.containsKey('application/x-www-form-urlencoded') ||
            content.containsKey('multipart/form-data')) {
          isForm = true;
          headers['Content-Type'] = content.containsKey('multipart/form-data')
              ? 'multipart/form-data'
              : 'application/x-www-form-urlencoded';
          // Populate fields from schema properties if available
          // final key = content.containsKey('multipart/form-data')
          //     ? 'multipart/form-data'
          //     : 'application/x-www-form-urlencoded';
          // TODO: Extract form field names from schema if available
          // if (props != null && props.isNotEmpty) {
          //   for (final entry in props.entries) {
          //     final n = entry.key;
          //     // Using empty placeholder values
          //     formData.add({'name': n, 'value': '', 'type': 'text'});
          //   }
          // }
        }
      }
    }

    return {
      'method': method.toUpperCase(),
      'url': url,
      'baseUrl': baseUrl,
      'headers': headers,
      'body': body,
      'form': isForm,
      'formData': formData,
    };
  }

  /// Public wrapper to build a request payload for a given operation.
  static Map<String, dynamic> payloadForOperation({
    required String baseUrl,
    required String path,
    required String method,
    required Operation op,
  }) =>
      _payloadForOperation(
        baseUrl: baseUrl,
        path: path,
        method: method,
        op: op,
      );

  static Map<String, dynamic> buildOperationPicker(OpenApi spec,
      {String? insights}) {
    final servers = spec.servers ?? const [];
    int endpointsCount = 0;
    final methods = <String>{};
    (spec.paths ?? const {}).forEach((path, item) {
      final ops = <String, Operation?>{
        'GET': item.get,
        'POST': item.post,
        'PUT': item.put,
        'DELETE': item.delete,
        'PATCH': item.patch,
        'HEAD': item.head,
        'OPTIONS': item.options,
        'TRACE': item.trace,
      };
      ops.forEach((method, op) {
        if (op == null) return;
        endpointsCount += 1;
        methods.add(method);
      });
    });

    if (endpointsCount == 0) {
      return {
        'explanation':
            'No operations found in the OpenAPI spec. Please check the file.',
        'actions': []
      };
    }

    final title = spec.info.title.isNotEmpty ? spec.info.title : 'Untitled API';
    final version = spec.info.version;
    final server = servers.isNotEmpty ? servers.first.url : null;
    final summary = StringBuffer()
      ..writeln('- Title: $title (v$version)')
      ..writeln('- Server: ${server ?? '/'}')
      ..writeln('- Endpoints discovered: $endpointsCount')
      ..writeln('- Methods: ${methods.join(', ')}');

    final explanation =
        StringBuffer('OpenAPI parsed. Click Import Now to choose operations.')
            .toString();
    return {
      'explanation': insights == null || insights.isEmpty
          ? '$explanation\n\n${summary.toString()}'
          : '$explanation\n\n${summary.toString()}\n $insights',
      'actions': [
        {
          'action': 'import_now_openapi',
          'target': 'httpRequestModel',
          'field': '',
          'path': null,
          'value': {
            'spec': spec,
            'sourceName': title,
          }
        }
      ],
      'meta': {
        'openapi_summary': summary.toString(),
        'openapi_meta': extractSpecMeta(spec),
      }
    };
  }
}
