import 'dart:convert';
import 'dart:io';

import 'apidash_mcp_service.dart';

class ApiDashMcpServer {
  ApiDashMcpServer({ApiDashMcpService? service})
      : _service = service ?? ApiDashMcpService();

  final ApiDashMcpService _service;

  bool _initialized = false;

  Future<void> serve() async {
    await _service.initialize();

    await for (final line
        in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        continue;
      }

      Object? decoded;
      try {
        decoded = jsonDecode(trimmed);
      } catch (_) {
        _sendError(
          id: null,
          code: -32700,
          message: 'Parse error: invalid JSON input',
        );
        continue;
      }

      if (decoded is! Map<String, Object?>) {
        _sendError(
          id: null,
          code: -32600,
          message: 'Invalid Request: JSON-RPC object expected',
        );
        continue;
      }

      await _handleMessage(decoded);
    }
  }

  Future<void> _handleMessage(Map<String, Object?> msg) async {
    final method = msg['method'];
    final id = msg['id'];

    if (method is! String || method.isEmpty) {
      _sendError(
        id: id,
        code: -32600,
        message: 'Invalid Request: missing method',
      );
      return;
    }

    if (id == null) {
      _handleNotification(method, msg['params']);
      return;
    }

    final params = _asMap(msg['params']) ?? const <String, Object?>{};

    try {
      switch (method) {
        case 'initialize':
          _sendResult(
            id: id,
            result: {
              'protocolVersion': '2024-11-05',
              'capabilities': {
                'tools': {
                  'listChanged': false,
                },
              },
              'serverInfo': {
                'name': 'apidash-mcp',
                'version': '0.1.0',
              },
            },
          );
          return;
        case 'ping':
          _sendResult(id: id, result: <String, Object?>{});
          return;
        case 'tools/list':
          if (!_initialized) {
            _sendError(
              id: id,
              code: -32002,
              message: 'Server not initialized',
            );
            return;
          }
          _sendResult(
            id: id,
            result: {
              'tools': _toolDefinitions(),
            },
          );
          return;
        case 'tools/call':
          if (!_initialized) {
            _sendError(
              id: id,
              code: -32002,
              message: 'Server not initialized',
            );
            return;
          }
          await _handleToolCall(id: id, params: params);
          return;
        default:
          _sendError(
            id: id,
            code: -32601,
            message: 'Method not found: $method',
          );
      }
    } catch (e) {
      _sendError(
        id: id,
        code: -32000,
        message: 'Internal server error: $e',
      );
    }
  }

  void _handleNotification(String method, Object? rawParams) {
    if (method == 'notifications/initialized' || method == 'initialized') {
      _initialized = true;
    }
  }

  Future<void> _handleToolCall({
    required Object id,
    required Map<String, Object?> params,
  }) async {
    final name = params['name'];
    final args = _asMap(params['arguments']) ?? const <String, Object?>{};

    if (name is! String || name.isEmpty) {
      _sendError(
        id: id,
        code: -32602,
        message: 'Invalid params: tool name is required',
      );
      return;
    }

    try {
      late final Map<String, Object?> data;

      switch (name) {
        case 'apidash_status':
          data = _service.status();
          break;
        case 'apidash_run_request':
          data = await _service.runRequest(args);
          break;
        case 'apidash_rerun_history':
          data = await _service.rerunHistory(args);
          break;
        case 'apidash_search_requests':
          data = await _service.searchRequests(args);
          break;
        case 'apidash_list_history':
          data = await _service.listHistory(args);
          break;
        case 'apidash_get_history_entry':
          data = await _service.getHistoryEntry(args);
          break;
        default:
          _sendError(
            id: id,
            code: -32601,
            message: 'Tool not found: $name',
          );
          return;
      }

      _sendResult(
        id: id,
        result: {
          'content': [
            {
              'type': 'text',
              'text': jsonEncode(data),
            },
          ],
          'structuredContent': data,
          'isError': false,
        },
      );
    } catch (e) {
      _sendResult(
        id: id,
        result: {
          'content': [
            {
              'type': 'text',
              'text': e.toString(),
            },
          ],
          'isError': true,
        },
      );
    }
  }

  List<Map<String, Object?>> _toolDefinitions() {
    return [
      {
        'name': 'apidash_status',
        'description':
            'Get API Dash MCP server status and storage readiness details.',
        'inputSchema': {
          'type': 'object',
          'properties': {},
          'additionalProperties': false,
        },
      },
      {
        'name': 'apidash_run_request',
        'description':
            'Run a saved request by requestId/requestName or run a direct URL request.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'requestId': {
              'type': 'string',
              'description': 'Exact request ID from API Dash saved requests.',
            },
            'requestName': {
              'type': 'string',
              'description':
                  'Partial saved request name. Use requestId if multiple match.',
            },
            'url': {
              'type': 'string',
              'description':
                  'Direct URL to execute without requiring a saved request.',
            },
            'method': {
              'type': 'string',
              'description':
                  'HTTP method for direct URL mode (GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS).',
            },
            'headers': {
              'type': 'object',
              'description': 'Headers map, e.g. {"Authorization": "Bearer x"}.',
              'additionalProperties': {'type': 'string'},
            },
            'data': {
              'type': 'string',
              'description': 'Request body payload for direct URL mode.',
            },
            'label': {
              'type': 'string',
              'description': 'Optional display name for direct URL runs.',
            },
          },
          'additionalProperties': false,
        },
      },
      {
        'name': 'apidash_rerun_history',
        'description':
            'Rerun an existing history entry, with optional request overrides.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'historyId': {
              'type': 'string',
              'description': 'History entry ID to rerun.',
            },
            'url': {
              'type': 'string',
              'description': 'Optional URL override.',
            },
            'method': {
              'type': 'string',
              'description': 'Optional HTTP method override.',
            },
            'headers': {
              'type': 'object',
              'description': 'Optional headers map override.',
              'additionalProperties': {'type': 'string'},
            },
            'data': {
              'type': 'string',
              'description': 'Optional request body override.',
            },
            'label': {
              'type': 'string',
              'description': 'Optional request name override.',
            },
          },
          'required': ['historyId'],
          'additionalProperties': false,
        },
      },
      {
        'name': 'apidash_search_requests',
        'description':
            'Search saved API Dash requests by query and/or HTTP method.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'query': {
              'type': 'string',
              'description': 'Search text applied to request name and URL.',
            },
            'method': {
              'type': 'string',
              'description': 'HTTP method filter (GET, POST, etc).',
            },
            'limit': {
              'type': 'integer',
              'description': 'Maximum number of rows to return. Default is 50.',
              'minimum': 1,
            },
          },
          'additionalProperties': false,
        },
      },
      {
        'name': 'apidash_list_history',
        'description': 'List API Dash request history entries.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'last': {
              'type': 'integer',
              'description': 'Number of latest entries to return. Default is 10.',
              'minimum': 1,
            },
            'query': {
              'type': 'string',
              'description': 'Optional search text filter on name and URL.',
            },
            'method': {
              'type': 'string',
              'description': 'Optional HTTP method filter.',
            },
            'includeBodyPreview': {
              'type': 'boolean',
              'description':
                  'Include truncated response body previews in each row.',
            },
          },
          'additionalProperties': false,
        },
      },
      {
        'name': 'apidash_get_history_entry',
        'description': 'Fetch full details for a single history entry by ID.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'historyId': {
              'type': 'string',
              'description': 'History entry ID.',
            },
          },
          'required': ['historyId'],
          'additionalProperties': false,
        },
      },
    ];
  }

  void _sendResult({required Object id, required Map<String, Object?> result}) {
    final response = {
      'jsonrpc': '2.0',
      'id': id,
      'result': result,
    };
    stdout.writeln(jsonEncode(response));
  }

  void _sendError({
    required Object? id,
    required int code,
    required String message,
  }) {
    final response = {
      'jsonrpc': '2.0',
      'id': id,
      'error': {
        'code': code,
        'message': message,
      },
    };
    stdout.writeln(jsonEncode(response));
  }

  Map<String, Object?>? _asMap(Object? raw) {
    if (raw is Map) {
      return Map<String, Object?>.from(raw);
    }
    return null;
  }
}
