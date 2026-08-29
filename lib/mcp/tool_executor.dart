import 'dart:convert';
import 'dart:io';
import 'package:apidash_core/apidash_core.dart';
import 'package:hive_ce/hive.dart';
import '../utils/envvar_utils.dart';
import 'models/execution_record.dart';

class ToolExecutor {
  // Routes to 'internal_agent_history' for the GUI, or 'agent_history' for external MCP
  static Box _getHistoryBox(bool isInternal) => Hive.box(isInternal ? 'internal_agent_history' : 'agent_history');

  // Both modes use the native environments box
  static Box get _envBox => Hive.box('apidash-environments');

  static Future<Map<String, dynamic>> executeRequest(Map<String, dynamic> args, {bool isInternal = false}) async {
    try {
      stderr.writeln("[ToolExecutor] Firing HTTP request to wire...");
      final methodStr = args['method'].toString().toUpperCase();
      final urlStr = args['url'].toString();
      final titleStr = args['title']?.toString() ?? 'untitled';
      final activeEnvId = args['active_environment_id']?.toString() ?? 'global';

      var httpRequestModel = HttpRequestModel(
        url: urlStr,
        method: HTTPVerb.values.byName(args['method'].toString().toLowerCase()),
        headers: args['headers'] != null
            ? (args['headers'] as Map)
            .entries
            .map((e) => NameValueModel(name: e.key.toString(), value: e.value.toString()))
            .toList()
            : null,
        body: args['body']?.toString(),
      );

      final Map<String, List<EnvironmentVariableModel>> envMap = _buildEnvironmentVariableMap(activeEnvId);
      final substitutedModel = substituteHttpRequestModel(httpRequestModel, envMap, activeEnvId);

      final (response, duration, err) = await sendHttpRequest('headless_agent', APIType.rest, substitutedModel);

      if (err != null) {
        stderr.writeln("[ToolExecutor] Network Error: $err");
        throw Exception(err);
      }

      final record = ExecutionRecord(
        executionId: "req_${DateTime.now().millisecondsSinceEpoch}",
        statusCode: response?.statusCode ?? 0,
        method: methodStr,
        url: substitutedModel.url,
        timeMs: duration?.inMilliseconds ?? 0,
        responseBody: response?.body ?? "No Body",
        timestamp: DateTime.now(),
        headers: args['headers'] != null ? Map<String, dynamic>.from(args['headers'] as Map) : null,
        requestBody: args['body']?.toString(),
      );

      final recordMap = record.toMap();
      recordMap['title'] = titleStr;

      // Save to the correct routed history box
      await _getHistoryBox(isInternal).put(record.executionId, recordMap);
      await _getHistoryBox(isInternal).put('latest_execution_id', record.executionId);
      await _getHistoryBox(isInternal).flush();

      return recordMap;
    } catch (e, stack) {
      stderr.writeln("[ToolExecutor Fatal Crash]: $e\n$stack");
      rethrow;
    }
  }

  static Map<String, List<EnvironmentVariableModel>> _buildEnvironmentVariableMap(String activeEnvId) {
    final Map<String, List<EnvironmentVariableModel>> envMap = {};
    final allEnvs = getAllEnvironments();

    if (activeEnvId != 'global' && allEnvs.containsKey(activeEnvId)) {
      final rawValues = allEnvs[activeEnvId]['values'] as List? ?? [];
      envMap[activeEnvId] = rawValues
          .map((item) => EnvironmentVariableModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .where((element) => element.enabled)
          .toList();
    } else if (allEnvs.containsKey('global')) {
      final rawValues = allEnvs['global']['values'] as List? ?? [];
      envMap['global'] = rawValues
          .map((item) => EnvironmentVariableModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .where((element) => element.enabled)
          .toList();
    }

    return envMap;
  }

  // --- ENVIRONMENT CRUD & DUPLICATE HANDLING ---

  static Map<String, dynamic> getAllEnvironments() {
    final envIds = List<String>.from(_envBox.get('environmentIds', defaultValue: <String>['global']));
    final result = <String, dynamic>{};

    for (var id in envIds) {
      final envData = _envBox.get(id);
      if (envData != null) {
        result[id] = Map<String, dynamic>.from(envData as Map);
      }
    }
    if (!result.containsKey('global')) {
      result['global'] = {"id": "global", "name": "Global", "values": []};
    }
    return result;
  }

  static Future<bool> saveEnvironment(String id, String name, List<dynamic> rawValues) async {
    final valuesList = rawValues.map((item) {
      final m = Map<String, dynamic>.from(item as Map);
      return {
        "key": m["key"] ?? "",
        "value": m["value"] ?? "",
        "type": "variable",
        "enabled": m["enabled"] ?? true
      };
    }).toList();

    List<String> envIds = List<String>.from(_envBox.get('environmentIds', defaultValue: <String>['global']));
    if (!envIds.contains(id)) {
      envIds.add(id);
      await _envBox.put('environmentIds', envIds);
    }

    await _envBox.put(id, {"id": id, "name": name, "values": valuesList});
    await _envBox.flush();
    return true;
  }

  static Future<String> duplicateEnvironment(String id) async {
    final all = getAllEnvironments();
    final source = all[id] ?? {"name": "Environment", "values": []};
    final newId = "env_${DateTime.now().millisecondsSinceEpoch}";
    final newName = "${source['name']} Copy";

    await saveEnvironment(newId, newName, source['values'] as List? ?? []);
    return newId;
  }

  static Future<bool> deleteEnvironment(String id) async {
    if (id == 'global') return false;
    List<String> envIds = List<String>.from(_envBox.get('environmentIds', defaultValue: <String>[]));
    envIds.remove(id);
    await _envBox.put('environmentIds', envIds);
    await _envBox.delete(id);
    await _envBox.flush();
    return true;
  }

  static Future<bool> renameEnvironment(String id, String newName) async {
    final all = getAllEnvironments();
    if (!all.containsKey(id)) return false;
    final env = all[id];
    return await saveEnvironment(id, newName, env['values'] as List? ?? []);
  }

  // --- HISTORY MANAGEMENT ---

  static Map<String, dynamic> getResults(String? requestedId, {bool isInternal = false}) {
    final targetId = requestedId ?? _getHistoryBox(isInternal).get('latest_execution_id');

    if (targetId != null) {
      final data = _getHistoryBox(isInternal).get(targetId);
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

  static List<Map<String, dynamic>> listHistory({bool isInternal = false}) {
    final list = <Map<String, dynamic>>[];

    for (var key in _getHistoryBox(isInternal).keys) {
      if (key != 'latest_execution_id') {
        final data = _getHistoryBox(isInternal).get(key);
        if (data != null) {
          final m = Map<String, dynamic>.from(data);
          list.add({
            "execution_id": key,
            "title": m["title"] ?? "untitled",
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

  static Future<bool> deleteRequest(String id, {bool isInternal = false}) async {
    final box = _getHistoryBox(isInternal);
    if (box.containsKey(id)) {
      await box.delete(id);
      if (box.get('latest_execution_id') == id) {
        await box.delete('latest_execution_id');
      }
      await box.flush();
      return true;
    }
    return false;
  }

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

  static Future<bool> updateHistoryTitle(String id, String newTitle, {bool isInternal = false}) async {
    final box = _getHistoryBox(isInternal);
    if (box.containsKey(id)) {
      final data = box.get(id);
      if (data != null) {
        final map = Map<String, dynamic>.from(data as Map);
        map['title'] = newTitle;
        await box.put(id, map);
        await box.flush();
        return true;
      }
    }
    return false;
  }
}