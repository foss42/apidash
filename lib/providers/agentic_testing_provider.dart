import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:apidash_core/apidash_core.dart';

import '../models/agentic_dashboard_state.dart';
import '../models/request_model.dart';
import '../mcp/tool_executor.dart';
import 'agentic_providers.dart';

final agenticDashboardProvider = StateNotifierProvider<AgenticTestingNotifier, AgenticDashboardState>((ref) {
  return AgenticTestingNotifier(ref);
});

class AgenticTestingNotifier extends StateNotifier<AgenticDashboardState> {
  final Ref ref;

  AgenticTestingNotifier(this.ref) : super(AgenticDashboardState(
      dashboardData: {
        "suite_name": "Welcome to Agentic Testing",
        "explanation": "Configure your API key and target URL, then type a goal below to generate an intelligent test suite.",
        "tests": []
      }
  ));

  Future<void> generateTestPlan(String prompt, String apiKey, String targetUrl) async {
    state = state.copyWith(isAiThinking: true, error: null);

    try {
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

      String openApiSpec = "";
      try {
        final specResponse = await http.get(Uri.parse('$targetUrl/openapi.json'));
        if (specResponse.statusCode == 200) openApiSpec = specResponse.body;
      } catch (_) {}

      final envContextStr = jsonEncode(ToolExecutor.getAllEnvironments());

      final sysPrompt = '''
You are an embedded Agentic API Testing Co-Pilot inside API Dash. 
Base URL: "$targetUrl". 
User Goal: "$prompt".
Workspace Context: $envContextStr
OpenAPI: ${openApiSpec.isNotEmpty ? openApiSpec : "None"}

Generate a comprehensive test suite. Return ONLY a raw JSON object matching:
{"suite_name": "...", "explanation": "...", "tests": [{"title": "...", "expected": "...", "url": "$targetUrl/...", "method": "GET", "body": "...", "expected_status": 200}]}
''';

      final response = await model.generateContent([Content.text(sysPrompt)]);
      final String jsonStr = response.text?.replaceAll('```json', '').replaceAll('```', '').trim() ?? '{}';

      state = AgenticDashboardState(
        dashboardData: jsonDecode(jsonStr),
      );
    } catch (e) {
      state = state.copyWith(isAiThinking: false, error: "Error generating tests: $e");
    }
  }

  Future<void> runTests(String targetUrl) async {
    if (state.dashboardData == null) return;

    state = state.copyWith(isExecuting: true, testResults: [], isComplete: false);

    final List<dynamic> tests = state.dashboardData!['tests'] ?? [];
    final String suiteTag = state.dashboardData!['suite_name'] ?? 'AI Test Suite';
    List<Map<String, dynamic>> results = [];
    List<RequestModel> generatedHistory = [];

    for (int i = 0; i < tests.length; i++) {
      final test = tests[i];
      try {
        final payload = test['body'];
        final safeBody = (payload == null || payload.toString().isEmpty)
            ? null
            : (payload is String ? payload : jsonEncode(payload));

        String rawUrl = test['url']?.toString().replaceFirst('{{base_url}}', targetUrl) ?? '';
        if (rawUrl.startsWith('/')) rawUrl = '$targetUrl$rawUrl';

        final httpResult = await ToolExecutor.executeRequest({
          "title": test['title'],
          "url": rawUrl,
          "method": test['method'],
          "headers": {"Content-Type": "application/json", "Accept": "application/json"},
          "body": safeBody,
          "active_environment_id": "global"
        }, isInternal: true);

        final int actualStatusCode = httpResult['statusCode'] ?? httpResult['status_code'] ?? 200;
        final int expectedStatusCode = test['expected_status'];

        Map<String, String>? responseHeadersMap;
        if (httpResult['headers'] != null && httpResult['headers'] is Map) {
          responseHeadersMap = (httpResult['headers'] as Map).map(
                (key, value) => MapEntry(key.toString().toLowerCase(), value.toString()),
          );
        }

        dynamic rawResBody = httpResult['response_body'] ?? httpResult['responseBody'] ?? httpResult['body'];
        String rawString = (rawResBody != null && rawResBody.toString().isNotEmpty)
            ? (rawResBody is String ? rawResBody : jsonEncode(rawResBody))
            : "{}";

        // Performance Optimization: Isolate for heavy payload parsing
        final Uint8List finalBytes = await compute<String, Uint8List>(
              (body) => Uint8List.fromList(utf8.encode(body)),
          rawString,
        );

        String formatted = rawString;
        try { formatted = const JsonEncoder.withIndent('  ').convert(jsonDecode(rawString)); } catch (_) {}

        final newReqId = 'agentic_${DateTime.now().microsecondsSinceEpoch}_$i';

        final historyRequest = RequestModel(
          id: newReqId,
          name: "$suiteTag::${test['title'] ?? 'AI Test'}",
          apiType: APIType.rest,
          httpRequestModel: HttpRequestModel(
            url: rawUrl,
            method: HTTPVerb.values.byName(test['method'].toString().toLowerCase()),
            body: safeBody,
            headers: const [
              NameValueModel(name: 'Content-Type', value: 'application/json'),
              NameValueModel(name: 'Accept', value: 'application/json'),
            ],
          ),
          responseStatus: actualStatusCode,
          httpResponseModel: HttpResponseModel(
            statusCode: actualStatusCode,
            body: rawString,
            formattedBody: formatted,
            bodyBytes: finalBytes,
            headers: responseHeadersMap,
            time: Duration(milliseconds: (httpResult['time_ms'] ?? httpResult['timeMs'] ?? 150) as int),
          ),
        );

        generatedHistory.add(historyRequest);

        bool isSuccess = (expectedStatusCode >= 200 && expectedStatusCode < 300)
            ? (actualStatusCode >= 200 && actualStatusCode < 300)
            : (actualStatusCode == expectedStatusCode);

        results.add({
          'index': i,
          'passed': isSuccess,
          'message': 'Got $actualStatusCode (Expected $expectedStatusCode)',
          'request_id': newReqId,
        });

      } catch (e) {
        results.add({'index': i, 'passed': false, 'message': 'Failed: $e'});
      }
    }

    // Performance Optimization: Batch history writes
    ref.read(agenticCollectionStateNotifierProvider.notifier).addRequests(generatedHistory);

    state = state.copyWith(
      isExecuting: false,
      isComplete: true,
      testResults: results,
    );
  }
}