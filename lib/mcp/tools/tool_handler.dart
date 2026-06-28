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
              "resourceUri": "ui://apidash-agentic-engine/workbench/studio"
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
              "visibility": ["app"],
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
        },
        {
          "name": "apidash_launch_workbench",
          "description": "Opens the main API Dash interactive studio UI. You MUST call this tool whenever the user asks to view workspace,open apidash, open, see, or use the UI.",
          "inputSchema": {
            "type": "object",
            "properties": {}
          },
          // THIS is the magic hook the client was missing:
          "_meta": {
            "ui": {
              "resourceUri": "ui://apidash-agentic-engine/workbench/studio"
            }
          }
        },
        {   //TO DO
          "name": "apidash_btn_new",
          "description": "UI Button: Triggered when the '+ New' request button is clicked.",
          "inputSchema": {
            "type": "object",
            "properties": {
              "type": {"type": "string", "default": "HTTP"}
            }
          }
        },
        {  //TO DO
          "name": "apidash_btn_save",
          "description": "UI Button: Triggered when the 'Save' button is clicked.",
          "inputSchema": {
            "type": "object",
            "properties": {
              "target": {"type": "string"}
            }
          }
        },
        {
          "name": "apidash_btn_send",
          "description": "UI Button: Triggered when the 'Send' button is clicked. Acts as an agentic pre-flight sanity check.",
          "inputSchema": {
            "type": "object",
            "properties": {
              "url": {"type": "string"},
              "method": {"type": "string", "default": "GET"},
              "headers": {"type": "object"},
              "body": {"type": "string"}
            },
            "required": ["url"]
          }
        },
        {  //TO DO
          "name": "apidash_btn_view_code",
          "description": "UI Button: Triggered when the '<> View Code' button is clicked.",
          "inputSchema": {
            "type": "object",
            "properties": {}
          }
        },
        {  //TO DO
          "name": "apidash_btn_add_param",
          "description": "UI Button: Triggered when the '+ Add Param' button is clicked.",
          "inputSchema": {
            "type": "object",
            "properties": {}
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
          "structuredContent": resultData,
          "_meta": {"ui": {"resourceUri": "ui://apidash-agentic-engine/workbench/studio"}}
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
    if (name == 'apidash_launch_workbench') {
      return {
        "content": [
          {
            "type": "text",
            "text": "API Dash Workbench opened successfully."
          }
        ],
        "_meta": {
          "ui": {
            "resourceUri": "ui://apidash-agentic-engine/workbench/studio"
          }
        }
      };
    }
    else if (name == 'apidash_btn_send') {
      final draftUrl = args['url']?.toString().trim() ?? '';
      final draftMethod = args['method']?.toString().toUpperCase() ?? 'GET';
      final draftHeaders = args['headers'] ?? {};
      final draftBody = args['body']?.toString() ?? '';

      return {
        "content": [
          {
            "type": "text",
            "text": "The user clicked 'Send' in the API Dash Workbench. They assembled this draft request:\n"
                "- URL: $draftUrl\n"
                "- Method: $draftMethod\n"
                "- Headers: ${jsonEncode(draftHeaders)}\n"
                "- Body: $draftBody\n\n"
                "AGENTIC PRE-FLIGHT INSTRUCTIONS:\n"
                "You are an expert API middleware inspector. Review the draft above before putting it on the wire:\n"
                "1. Protocol Check: If the URL lacks 'http://' or 'https://', safely attach 'https://' (or 'http://' if localhost).\n"
                "2. Auth Check: Does this specific endpoint require an API key, Bearer token, or specific Auth header? If it is missing, check your conversation history/context to see if the user previously provided it, and attach it automatically.\n"
                "3. Body Sanity: If this is a POST/PUT/PATCH, verify the body looks like valid JSON or matches expected API schemas.\n\n"
                "DECISION TREE:\n"
                "- IF 100% VALID & SAFE: Immediately invoke the 'apidash_execute_request' tool using the cleaned up URL, Method, Headers, and Body. Do not ask the user for permission.\n"
                "- IF CRITICAL DATA IS MISSING (e.g., an unknown API key): Stop. Explain what is missing in the chat window and ask the user to provide it."
          }
        ]
      };
    }
    else if (name == 'apidash_btn_new') {
      //TO DO
      return {"content": [{"type": "text", "text": "TODO: Implement [+ New] button logic"}]};
    }
    else if (name == 'apidash_btn_save') {
      //TO DO
      return {"content": [{"type": "text", "text": "TODO: Implement [Save] button logic"}]};
    }
    else if (name == 'apidash_btn_view_code') {
      //TO DO
      return {"content": [{"type": "text", "text": "TODO: Implement [View Code] modal logic"}]};
    }
    else if (name == 'apidash_btn_add_param') {
      //TO DO
      return {"content": [{"type": "text", "text": "TODO: Implement [+ Add Param] row injection"}]};
    }

    return {"isError": true, "content": [{"type": "text", "text": "Tool not found: $name"}]};
  }
}