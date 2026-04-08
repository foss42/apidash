import 'gemini_client.dart';

// ---------------------------------------------------------------------------
// MCP Tool Manifest
// ---------------------------------------------------------------------------

/// Returned at GET /mcp — describes all available tools to the MCP client.
Map<String, dynamic> mcpManifest() => {
      'schema_version': '1.0',
      'name': 'apidash',
      'description': 'Agentic API testing tools powered by API Dash',
      'tools': [
        {
          'name': 'generate_unit_tests',
          'description':
              'Generate AI-powered unit tests for an API endpoint. '
              'Returns test cases covering happy path, edge cases, and error scenarios.',
          'parameters': {
            'type': 'object',
            'properties': {
              'endpoint_url': {
                'type': 'string',
                'description': 'The full URL of the API endpoint'
              },
              'method': {
                'type': 'string',
                'description': 'HTTP method: GET, POST, PUT, DELETE, PATCH'
              },
              'request_body': {
                'type': 'string',
                'description': 'JSON string of the request body (optional)'
              },
              'response_sample': {
                'type': 'string',
                'description': 'Sample JSON response from the endpoint (optional)'
              },
              'gemini_api_key': {
                'type': 'string',
                'description': 'Gemini API key for AI generation'
              },
            },
            'required': ['endpoint_url', 'method', 'gemini_api_key'],
          },
        },
        {
          'name': 'generate_workflow',
          'description':
              'Generate an agentic multi-step API workflow. '
              'Chains multiple API calls with data bindings between steps.',
          'parameters': {
            'type': 'object',
            'properties': {
              'goal': {
                'type': 'string',
                'description':
                    'Natural language description of what the workflow should accomplish'
              },
              'available_endpoints': {
                'type': 'string',
                'description':
                    'JSON array of available endpoint objects with url, method, description'
              },
              'gemini_api_key': {
                'type': 'string',
                'description': 'Gemini API key for AI generation'
              },
            },
            'required': ['goal', 'available_endpoints', 'gemini_api_key'],
          },
        },
        {
          'name': 'analyze_api_response',
          'description':
              'Analyze an API response for issues, anomalies, and suggestions.',
          'parameters': {
            'type': 'object',
            'properties': {
              'endpoint_url': {'type': 'string'},
              'status_code': {'type': 'number'},
              'response_body': {'type': 'string'},
              'response_headers': {'type': 'string'},
              'gemini_api_key': {'type': 'string'},
            },
            'required': [
              'endpoint_url',
              'status_code',
              'response_body',
              'gemini_api_key'
            ],
          },
        },
      ],
    };

// ---------------------------------------------------------------------------
// Tool Dispatcher
// ---------------------------------------------------------------------------

/// Routes a tool call by name to the correct handler.
Future<Map<String, dynamic>> dispatchTool(
  String toolName,
  Map<String, dynamic> args,
) async {
  switch (toolName) {
    case 'generate_unit_tests':
      return _generateUnitTests(args);
    case 'generate_workflow':
      return _generateWorkflow(args);
    case 'analyze_api_response':
      return _analyzeApiResponse(args);
    default:
      throw ArgumentError('Unknown tool: $toolName');
  }
}

// ---------------------------------------------------------------------------
// Tool Handlers
// ---------------------------------------------------------------------------

Future<Map<String, dynamic>> _generateUnitTests(
    Map<String, dynamic> args) async {
  final url = args['endpoint_url'] as String;
  final method = args['method'] as String;
  final requestBody = args['request_body'] as String? ?? 'none';
  final responseSample = args['response_sample'] as String? ?? 'not provided';
  final apiKey = args['gemini_api_key'] as String;

  final prompt = '''
You are an expert API testing engineer.

Generate a comprehensive set of unit test cases for the following API endpoint.

Endpoint: $method $url
Request Body: $requestBody
Sample Response: $responseSample

Return a JSON array of test cases. Each test case must have:
- "name": short descriptive test name
- "description": what this test validates
- "category": one of [happy_path, edge_case, error_scenario, security]
- "input": the request body or params to send
- "expected_status": expected HTTP status code
- "assertions": array of assertion objects with "field", "operator", "expected_value"

Return ONLY valid JSON. No markdown, no explanation.
''';

  final rawJson = await GeminiClient.generate(apiKey: apiKey, prompt: prompt);

  return {
    'endpoint': '$method $url',
    'test_cases_json': rawJson,
    'generated_at': DateTime.now().toIso8601String(),
  };
}

Future<Map<String, dynamic>> _generateWorkflow(
    Map<String, dynamic> args) async {
  final goal = args['goal'] as String;
  final endpoints = args['available_endpoints'] as String;
  final apiKey = args['gemini_api_key'] as String;

  final prompt = '''
You are an expert API integration engineer.

Design a multi-step API workflow to achieve this goal:
"$goal"

Available endpoints:
$endpoints

Return a JSON object with:
- "workflow_name": short name
- "description": what this workflow does
- "steps": array of steps, each with:
  - "step_id": unique string id (e.g. "step_1")
  - "name": human-readable step name
  - "endpoint_url": which endpoint to call
  - "method": HTTP method
  - "request_body": JSON body template (use {{step_id.field}} for data bindings from prior steps)
  - "data_bindings": array of {"source_step": "step_id", "source_field": "field.path", "target_field": "field_name"}
  - "expected_status": expected HTTP status

Return ONLY valid JSON. No markdown, no explanation.
''';

  final rawJson = await GeminiClient.generate(apiKey: apiKey, prompt: prompt);

  return {
    'goal': goal,
    'workflow_json': rawJson,
    'generated_at': DateTime.now().toIso8601String(),
  };
}

Future<Map<String, dynamic>> _analyzeApiResponse(
    Map<String, dynamic> args) async {
  final url = args['endpoint_url'] as String;
  final statusCode = args['status_code'];
  final responseBody = args['response_body'] as String;
  final responseHeaders = args['response_headers'] as String? ?? '{}';
  final apiKey = args['gemini_api_key'] as String;

  final prompt = '''
You are an expert API quality analyst.

Analyze this API response and identify issues, anomalies, and improvements.

Endpoint: $url
Status Code: $statusCode
Response Headers: $responseHeaders
Response Body:
$responseBody

Return a JSON object with:
- "status": "ok" | "warning" | "error"
- "summary": one sentence summary
- "issues": array of {"severity": "low|medium|high", "message": "...", "suggestion": "..."}
- "performance_notes": any observations about response structure or size
- "security_notes": any security concerns in the response

Return ONLY valid JSON. No markdown, no explanation.
''';

  final rawJson = await GeminiClient.generate(apiKey: apiKey, prompt: prompt);

  return {
    'endpoint': url,
    'status_code': statusCode,
    'analysis_json': rawJson,
    'analyzed_at': DateTime.now().toIso8601String(),
  };
}