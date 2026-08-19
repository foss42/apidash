import 'dart:convert';
import 'dart:io';
import 'package:apidash_core/apidash_core.dart';
import 'package:hive_ce/hive.dart';

class ToolExecutor {
  static Box get _agentHistory => Hive.box('agent_history');

  // 1. EXECUTE REQUEST
  static Future<Map<String, dynamic>> executeRequest(Map<String, dynamic> args) async {
    try {
      stderr.writeln("[ToolExecutor] Firing HTTP request to wire...");
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

      final (response, duration, err) = await sendHttpRequest('headless_agent', APIType.rest, httpRequestModel);

      if (err != null) {
        stderr.writeln("[ToolExecutor] Network Error: $err");
        throw Exception(err);
      }

      final executionId = "req_${DateTime.now().millisecondsSinceEpoch}";
      final resultData = {
        "execution_id": executionId,
        "status_code": response?.statusCode ?? 0,
        "response_body": response?.body ?? "No Body",
        "time_ms": duration?.inMilliseconds ?? 0,
        "method": methodStr,
        "url": urlStr,
        "timestamp": DateTime.now().toIso8601String(),
      };

      // Synchronous Isolate disk flush
      await _agentHistory.put(executionId, resultData);
      await _agentHistory.put('latest_execution_id', executionId);
      await _agentHistory.flush();

      stderr.writeln("✅ [ToolExecutor] Saved run $executionId to disk successfully.");
      return resultData;
    } catch (e, stack) {
      stderr.writeln("[ToolExecutor Fatal Crash]: $e\n$stack");
      rethrow;
    }
  }
  // 2. GET RESULTS (For UI Hydration)
  static Map<String, dynamic> getResults(String? requestedId) {
    final targetId = requestedId ?? _agentHistory.get('latest_execution_id');

    if (targetId != null) {
      final data = _agentHistory.get(targetId);
      if (data != null) return Map<String, dynamic>.from(data);
    }

    return {
      "status_code": 404,
      "response_body": "ERROR: Execution ID ($targetId) not found in Hive.",
      "time_ms": 0,
      "method": "ERROR",
      "url": "Hive Empty"
    };
  }

  // 3. LIST HISTORY
  static List<Map<String, dynamic>> listHistory() {
    final list = <Map<String, dynamic>>[];

    for (var key in _agentHistory.keys) {
      if (key != 'latest_execution_id') {
        final data = _agentHistory.get(key);
        if (data != null) {
          final m = Map<String, dynamic>.from(data);
          list.add({
            "execution_id": key,
            "method": m["method"],
            "url": m["url"],
            "status": m["status_code"],
            "time_ms": m["time_ms"],
            "timestamp": m["timestamp"]
          });
        }
      }
    }
    list.sort((a, b) => (b["timestamp"] as String).compareTo(a["timestamp"] as String));
    return list;
  }

  // 4. DELETE REQUEST
  static Future<bool> deleteRequest(String id) async {
    if (_agentHistory.containsKey(id)) {
      await _agentHistory.delete(id);
      if (_agentHistory.get('latest_execution_id') == id) {
        await _agentHistory.delete('latest_execution_id');
      }
      await _agentHistory.flush();
      return true;
    }
    return false;
  }
  // 5. send button preflight prompt
  static String buildSendPreFlightPrompt(Map<String, dynamic> args) {
    final draftUrl = args['url']?.toString().trim() ?? '';
    final draftMethod = args['method']?.toString().toUpperCase() ?? 'GET';
    final draftHeaders = args['headers'] ?? {};
    final draftBody = args['body']?.toString() ?? '';

    return """The user clicked 'Send' in the API Dash Workbench. They assembled this draft request:
- URL: $draftUrl
- Method: $draftMethod
- Headers: ${jsonEncode(draftHeaders)}
- Body: $draftBody

AGENTIC PRE-FLIGHT INSTRUCTIONS:
You are an expert API middleware inspector. Review the draft above before putting it on the wire:
1. Protocol Check: If the URL lacks 'http://' or 'https://', safely attach 'https://' (or 'http://' if localhost).
2. Auth Check: Does this specific endpoint require an API key, Bearer token, or specific Auth header? If it is missing, check your conversation history/context to see if the user previously provided it, and attach it automatically.
3. Body Sanity: If this is a POST/PUT/PATCH, verify the body looks like valid JSON or matches expected API schemas.

DECISION TREE:
- IF 100% VALID & SAFE: Immediately invoke the 'apidash_execute_request' tool using the cleaned up URL, Method, Headers, and Body. Do not ask the user for permission.
- IF CRITICAL DATA IS MISSING (e.g., an unknown API key): Stop. Explain what is missing in the chat window and ask the user to provide it.""";
  }
}