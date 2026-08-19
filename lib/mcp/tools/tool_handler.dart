import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:better_networking/better_networking.dart';
import 'package:hive_ce/hive.dart';

class ToolHandler {
  static Box get _agentHistory => Hive.box('agent_history');

  static Map<String, dynamic> listTools() {
    return {
      "tools": [
        {
          "name": "apidash_execute_request",
          "description": "Executes an HTTP request. You MUST run this tool.",
          "inputSchema": {
            "type": "object",
            "properties": {
              "url": {"type": "string"},
              "method": {"type": "string"},
              "headers": {"type": "object"},
              "body": {"type": "string"}
            },
            "required": ["url", "method"],
          },
          "_meta": {
            "ui": {
              "resourceUri": "ui://apidash-agentic-engine/dashboard/results"
            }
          },
        },
        {
          "name": "apidash_get_results",
          "description": "Fetches the results of an execution for the UI. If no execution_id is provided, fetches the latest.",
          "inputSchema": {
            "type": "object",
            "properties": {
              "execution_id": {
                "type": "string",
                "description": "The specific ID of the request history to fetch."
              }
            }
          },
          "_meta": {
            "ui": {
              "visibility": ["app"]
            }
          }
        },
        {
          "name": "apidash_list_history",
          "description": "Lists all past request execution IDs, URLs, and timestamps. Use this to find an ID to pass into apidash_get_results.",
          "inputSchema": {
            "type": "object",
            "properties": {
              "_cache_buster": {
                "type": "string",
                "description": "Optional timestamp to bypass cache."
              }
            },
          },
          "_meta": {
            "ui": {
              "resourceUri": "ui://apidash-agentic-engine/dashboard/history"
            }
          }
        },
        {
          "name": "apidash_delete_request",
          "description": "Deletes a specific request from history using its execution_id.",
          "inputSchema": {
            "type": "object",
            "properties": {
              "execution_id": {"type": "string"}
            },
            "required": ["execution_id"]
          },
          "_meta": {
            "ui": {
              "visibility": ["app"]
            }
          }
        }
      ],
    };
  }

  static Future<Map<String, dynamic>> executeTool(String name, Map<String, dynamic> args, String id) async {
    if (name == 'apidash_execute_request') {
      try {
        final methodStr = args['method'].toString().toUpperCase();
        final urlStr = args['url'].toString();

        final httpRequestModel = HttpRequestModel(
          url: urlStr,
          method: HTTPVerb.values.byName(args['method'].toString().toLowerCase()),
          headers: args['headers'] != null
              ? (args['headers'] as Map).entries
              .map((e) => NameValueModel(name: e.key.toString(), value: e.value.toString()))
              .toList()
              : null,
          body: args['body']?.toString(),
        );

        final (response, duration, err) = await sendHttpRequest(id, APIType.rest, httpRequestModel);
        if (err != null) throw Exception(err);

        final executionId = "req_${DateTime.now().millisecondsSinceEpoch}_$id";

        final resultData = {
          "execution_id": executionId,
          "status_code": response?.statusCode ?? 0,
          "response_body": response?.body ?? "No Body",
          "time_ms": duration?.inMilliseconds ?? 0,
          "method": methodStr,
          "url": urlStr,
          "timestamp": DateTime.now().toIso8601String(),
        };

        await _agentHistory.put(executionId, resultData);
        await _agentHistory.put('latest_execution_id', executionId);
        await _agentHistory.flush();

        return {
          "content": [
            {
              "type": "text",
              "text": "Request successfully executed. Execution ID: $executionId\nStatus: ${response?.statusCode}\nResponse Body:\n${response?.body}"
            }
          ],
          "_meta": {"ui": {"resourceUri": "ui://apidash-agentic-engine/dashboard/results"}}
        };
      } catch (e) {
        return {"isError": true, "content": [{"type": "text", "text": "Execution Engine Error: $e"}]};
      }
    }

    else if (name == 'apidash_get_results') {
      final requestedId = args['execution_id']?.toString();
      final targetId = requestedId ?? _agentHistory.get('latest_execution_id');

      if (targetId != null) {
        final executionData = _agentHistory.get(targetId);
        if (executionData != null) {
          final structuredContent = Map<String, dynamic>.from(executionData);
          return {
            "content": [{"type": "text", "text": "Results fetched successfully for ID: $targetId"}],
            "structuredContent": structuredContent,
          };
        }
      }

      return {
        "content": [{"type": "text", "text": "No recent requests found"}],
        "structuredContent": {
          "status_code": 500,
          "response_body": "ERROR: Requested history ID ($targetId) not found.",
          "time_ms": 0,
          "method": "ERROR",
          "url": "Hive Box Empty"
        }
      };
    }

    else if (name == 'apidash_list_history') {
      final historyList = [];

      for (var key in _agentHistory.keys) {
        if (key != 'latest_execution_id') {
          final data = _agentHistory.get(key);
          if (data != null) {
            final mapData = Map<String, dynamic>.from(data);
            historyList.add({
              "execution_id": key,
              "method": mapData["method"],
              "url": mapData["url"],
              "status": mapData["status_code"],
              "time_ms": mapData["time_ms"],
              "timestamp": mapData["timestamp"]
            });
          }
        }
      }

      historyList.sort((a, b) => (b["timestamp"] as String).compareTo(a["timestamp"] as String));

      return {
        "content": [
          {
            "type": "text",
            "text": "Found ${historyList.length} past requests:\n${const JsonEncoder.withIndent('  ').convert(historyList)}"
          }
        ],
        "structuredContent": historyList,
        "_meta": {
          "ui": {
            "resourceUri": "ui://apidash-agentic-engine/dashboard/history"
          }
        }
      };
    }

    else if (name == 'apidash_delete_request') {
      final targetId = args['execution_id']?.toString();

      if (targetId != null && _agentHistory.containsKey(targetId)) {
        await _agentHistory.delete(targetId);

        if (_agentHistory.get('latest_execution_id') == targetId) {
          await _agentHistory.delete('latest_execution_id');
        }

        await _agentHistory.flush();
        return {"content": [{"type": "text", "text": "Successfully deleted request: $targetId"}]};
      }
      return {"isError": true, "content": [{"type": "text", "text": "ID not found."}]};
    }

    return {"isError": true, "content": [{"type": "text", "text": "Tool not found: $name"}]};
  }
}