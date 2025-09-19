import 'dart:convert';
import 'package:openapi_spec/openapi_spec.dart';

/// Service to parse OpenAPI specifications and produce
/// a standard action message map understood by Dashbot.
class OpenApiImportService {
  /// Try to parse a JSON or YAML OpenAPI spec string.
  /// Returns null if parsing fails.
  static OpenApi? tryParseSpec(String source) {
    try {
      // Let the library infer JSON/YAML
      return OpenApi.fromString(source: source, format: null);
    } catch (_) {
      return null;
    }
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
      'headers': headers,
      'body': body,
      'form': isForm,
      'formData': formData,
    };
  }

  /// Build an action message asking whether to apply to selected/new
  /// for a single chosen operation.
  static Map<String, dynamic> buildActionMessageFromPayload(
      Map<String, dynamic> actionPayload,
      {String? title}) {
    final buf = StringBuffer(
        title ?? 'Parsed the OpenAPI operation. Where should I apply it?');
    return {
      'explnation': buf.toString(),
      'actions': [
        {
          'action': 'apply_openapi',
          'target': 'httpRequestModel',
          'field': 'apply_to_selected',
          'path': null,
          'value': actionPayload,
        },
        {
          'action': 'apply_openapi',
          'target': 'httpRequestModel',
          'field': 'apply_to_new',
          'path': null,
          'value': actionPayload,
        }
      ]
    };
  }

  /// Build a list of operations from the spec, and if multiple are found,
  /// return a JSON with explnation and an actions array of type "other"
  /// where each action value holds an actionPayload for that operation and
  /// path/method in the path field for UI display. The Chat model will emit
  /// a follow-up message once the user picks one.
  static Map<String, dynamic> buildOperationPicker(OpenApi spec) {
    final servers = spec.servers ?? const [];
    final baseUrl = servers.isNotEmpty ? (servers.first.url ?? '/') : '/';
    final actions = <Map<String, dynamic>>[];

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
        final payload = _payloadForOperation(
          baseUrl: baseUrl,
          path: path,
          method: method,
          op: op,
        );
        actions.add({
          'action': 'other',
          'target': 'httpRequestModel',
          'field': 'select_operation',
          'path': '$method $path',
          'value': payload,
        });
      });
    });

    if (actions.isEmpty) {
      return {
        'explnation':
            'No operations found in the OpenAPI spec. Please check the file.',
        'actions': []
      };
    }

    return {
      'explnation':
          'OpenAPI parsed. Select an operation to import as a request:',
      'actions': actions,
    };
  }
}
