import 'codegen_intro.dart';
import 'curl_insights.dart';
import 'debug_api_error.dart';
import 'explain_api_response.dart';
import 'general_interaction.dart';
import 'generate_code.dart';
import 'generate_documentation.dart';
import 'generate_test_cases.dart';
import 'openapi_insights.dart';

class DashbotPrompts {
// ACTION SCHEMA
// Dashbot must return:
// { "explanation": string, "actions": [ { ... }, { ... } ] }
// If only one action is needed, return a single-element actions array.
// Each action object shape:
// {
//   "action": "update_field" | "add_header" | "update_header" | "delete_header" | "update_body" |
//              "update_url" | "update_method" | "show_languages" | "upload_asset" | "other" | "no_action",
//   "target": "httpRequestModel" | "codegen" | "test" | "code" | "attachment",
//   "field":  string (optional, e.g. "url", "method", "headers", "body", "params"),
//   "path":   string | null (header key, language name, etc.),
//   "value":  string | object | array | null (new value / code / list of languages)
// }
// IMPORTANT: If no actionable changes: set "actions": [] (empty array).
// EXAMPLE MULTI-ACTION (debugging):
// {
//   "explanation": "...details...",
//   "actions": [
//     {"action":"add_header","target":"httpRequestModel","field":"headers","path":"Authorization","value":"Bearer your_api_token"},
//     {"action":"update_field","target":"httpRequestModel","field":"url","path":null,"value":"https://api.example.com/v2/users"}
//   ]
// }
// EXAMPLE CODEGEN LANGUAGE PICKER:
// {"explanation":"Choose a language","actions":[{"action":"show_languages","target":"codegen","path":null,"value":["JavaScript (fetch)","Python (requests)"]}]}

  /// General user interaction prompt enforcing strict JSON-only output and off-topic refusal.
  String generalInteractionPrompt() {
    return buildGeneralInteractionPrompt();
  }

  String explainApiResponsePrompt({
    String? url,
    String? method,
    int? responseStatus,
    String? bodyContentType,
    String? message,
    Map<String, String>? headersMap,
    String? body,
  }) {
    return buildExplainApiResponsePrompt(
      url: url,
      method: method,
      responseStatus: responseStatus,
      bodyContentType: bodyContentType,
      message: message,
      headersMap: headersMap,
      body: body,
    );
  }

  String debugApiErrorPrompt({
    String? url,
    String? method,
    int? responseStatus,
    String? bodyContentType,
    String? message,
    Map<String, String>? headersMap,
    String? body,
  }) {
    return buildDebugApiErrorPrompt(
      url: url,
      method: method,
      responseStatus: responseStatus,
      bodyContentType: bodyContentType,
      message: message,
      headersMap: headersMap,
      body: body,
    );
  }

  String generateTestCasesPrompt({
    String? url,
    String? method,
    Map<String, String>? headersMap,
    String? body,
  }) {
    return buildGenerateTestCasesPrompt(
      url: url,
      method: method,
      headersMap: headersMap,
      body: body,
    );
  }

  String generateDocumentationPrompt({
    String? url,
    String? method,
    int? responseStatus,
    String? bodyContentType,
    String? message,
    Map<String, String>? headersMap,
    String? body,
  }) {
    return buildGenerateDocumentationPrompt(
      url: url,
      method: method,
      responseStatus: responseStatus,
      bodyContentType: bodyContentType,
      message: message,
      headersMap: headersMap,
      body: body,
    );
  }

  // Ask for language with common options
  String codeGenerationIntroPrompt({
    String? url,
    String? method,
    Map<String, String>? headersMap,
    String? body,
    String? bodyContentType,
    Map<String, String>? paramsMap,
    String? authType,
  }) {
    return buildCodeGenerationIntroPrompt(
      url: url,
      method: method,
      headersMap: headersMap,
      body: body,
      bodyContentType: bodyContentType,
      paramsMap: paramsMap,
      authType: authType,
    );
  }

  // Generate code in the requested language
  String generateCodePrompt({
    String? url,
    String? method,
    Map<String, String>? headersMap,
    String? body,
    String? bodyContentType,
    Map<String, String>? paramsMap,
    String? authType,
    String? language,
  }) {
    return buildGenerateCodePrompt(
      url: url,
      method: method,
      headersMap: headersMap,
      body: body,
      bodyContentType: bodyContentType,
      paramsMap: paramsMap,
      authType: authType,
      language: language,
    );
  }

  // Provide insights and suggestions after importing an OpenAPI spec
  String openApiInsightsPrompt({
    required String specSummary,
    Map<String, dynamic>? specMeta,
  }) {
    return buildOpenApiInsightsPrompt(
      specSummary: specSummary,
      specMeta: specMeta,
    );
  }

  // Provide insights after parsing a cURL command
  String curlInsightsPrompt({
    String? diff,
    Map<String, dynamic>? newReq,
  }) {
    return buildCurlInsightsPrompt(
      diff: diff,
      newReq: newReq,
    );
  }
}
