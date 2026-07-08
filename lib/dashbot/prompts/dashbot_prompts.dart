import 'codegen_intro.dart';
import 'curl_insights.dart';
import 'debug_api_error.dart';
import 'debug_mqtt_connection.dart';
import 'debug_ws_connection.dart';
import 'debug_ws_message.dart';
import 'explain_api_response.dart';
import 'explain_mqtt_connection.dart';
import 'explain_mqtt_lwt.dart';
import 'explain_mqtt_topics.dart';
import 'explain_mqtt_v5.dart';
import 'explain_ws_connection.dart';
import 'explain_ws_message.dart';
import 'find_in_mqtt_messages.dart';
import 'find_in_ws_messages.dart';
import 'why_no_mqtt_messages.dart';
import 'general_interaction.dart';
import 'generate_code.dart';
import 'generate_documentation.dart';
import 'generate_mqtt_code.dart';
import 'generate_test_cases.dart';
import 'generate_ws_code.dart';
import 'generate_ws_documentation.dart';
import 'generate_ws_tests.dart';
import 'mqtt_codegen_intro.dart';
import 'mqtt_session_advisor.dart';
import 'openapi_insights.dart';
import 'summarize_mqtt_messages.dart';
import 'summarize_ws_messages.dart';
import 'ws_codegen_intro.dart';
import 'ws_connection_health.dart';

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

  String explainWsConnectionPrompt({
    String? url,
    String? connectionStatus,
    Map<String, String>? headersMap,
    String? messageLog,
  }) {
    return buildExplainWsConnectionPrompt(
      url: url,
      connectionStatus: connectionStatus,
      headersMap: headersMap,
      messageLog: messageLog,
    );
  }

  String debugWsConnectionPrompt({
    String? url,
    String? connectionStatus,
    Map<String, String>? headersMap,
    String? messageLog,
  }) {
    return buildDebugWsConnectionPrompt(
      url: url,
      connectionStatus: connectionStatus,
      headersMap: headersMap,
      messageLog: messageLog,
    );
  }

  String findInWsMessagesPrompt({
    String? url,
    String? connectionStatus,
    Map<String, String>? headersMap,
    String? messageLog,
  }) {
    return buildFindInWsMessagesPrompt(
      url: url,
      connectionStatus: connectionStatus,
      headersMap: headersMap,
      messageLog: messageLog,
    );
  }

  // MQTT: plain-language explanation of the connection (post-office metaphor)
  String explainMqttConnectionPrompt({
    String? brokerUrl,
    String? connectionStatus,
    String? settingsSummary,
    String? topicsSummary,
    String? messageLog,
  }) {
    return buildExplainMqttConnectionPrompt(
      brokerUrl: brokerUrl,
      connectionStatus: connectionStatus,
      settingsSummary: settingsSummary,
      topicsSummary: topicsSummary,
      messageLog: messageLog,
    );
  }

  // MQTT: lifecycle debugging with a whitelist of mqttRequestModel fixes
  String debugMqttConnectionPrompt({
    String? brokerUrl,
    String? connectionStatus,
    String? settingsSummary,
    String? topicsSummary,
    String? messageLog,
  }) {
    return buildDebugMqttConnectionPrompt(
      brokerUrl: brokerUrl,
      connectionStatus: connectionStatus,
      settingsSummary: settingsSummary,
      topicsSummary: topicsSummary,
      messageLog: messageLog,
    );
  }

  // MQTT: connected but no messages arriving (topic/wildcard/QoS diagnosis)
  String whyNoMqttMessagesPrompt({
    String? brokerUrl,
    String? connectionStatus,
    String? settingsSummary,
    String? topicsSummary,
    String? messageLog,
  }) {
    return buildWhyNoMqttMessagesPrompt(
      brokerUrl: brokerUrl,
      connectionStatus: connectionStatus,
      settingsSummary: settingsSummary,
      topicsSummary: topicsSummary,
      messageLog: messageLog,
    );
  }

  // MQTT: summarize what has arrived, grouped by mailbox (topic)
  String summarizeMqttMessagesPrompt({
    String? brokerUrl,
    String? connectionStatus,
    String? settingsSummary,
    String? topicsSummary,
    String? messageLog,
  }) {
    return buildSummarizeMqttMessagesPrompt(
      brokerUrl: brokerUrl,
      connectionStatus: connectionStatus,
      settingsSummary: settingsSummary,
      topicsSummary: topicsSummary,
      messageLog: messageLog,
    );
  }

  // MQTT: teach the "+"/"#" wildcards and propose a subscription
  String explainMqttTopicsPrompt({
    String? brokerUrl,
    String? connectionStatus,
    String? settingsSummary,
    String? topicsSummary,
    String? messageLog,
  }) {
    return buildExplainMqttTopicsPrompt(
      brokerUrl: brokerUrl,
      connectionStatus: connectionStatus,
      settingsSummary: settingsSummary,
      topicsSummary: topicsSummary,
      messageLog: messageLog,
    );
  }

  // MQTT: advise on session persistence with a single whitelisted fix
  String mqttSessionAdvisorPrompt({
    String? brokerUrl,
    String? connectionStatus,
    String? settingsSummary,
    String? topicsSummary,
    String? messageLog,
  }) {
    return buildMqttSessionAdvisorPrompt(
      brokerUrl: brokerUrl,
      connectionStatus: connectionStatus,
      settingsSummary: settingsSummary,
      topicsSummary: topicsSummary,
      messageLog: messageLog,
    );
  }

  // MQTT: ask for a language before generating client code
  String mqttCodeGenIntroPrompt(
    String? brokerUrl,
    String? connectionStatus,
    String? settingsSummary,
  ) {
    return buildMqttCodeGenIntroPrompt(
      brokerUrl: brokerUrl,
      connectionStatus: connectionStatus,
      settingsSummary: settingsSummary,
    );
  }

  // MQTT: generate client code in the requested language
  String generateMqttCodePrompt({
    String? brokerUrl,
    String? settingsSummary,
    String? topicsSummary,
    String? messageLog,
    String? language,
  }) {
    return buildGenerateMqttCodePrompt(
      brokerUrl: brokerUrl,
      settingsSummary: settingsSummary,
      topicsSummary: topicsSummary,
      messageLog: messageLog,
      language: language,
    );
  }

  // MQTT: explain the Last Will (goodbye note) feature
  String explainMqttLwtPrompt({
    String? brokerUrl,
    String? connectionStatus,
    String? settingsSummary,
    String? topicsSummary,
    String? messageLog,
  }) {
    return buildExplainMqttLwtPrompt(
      brokerUrl: brokerUrl,
      connectionStatus: connectionStatus,
      settingsSummary: settingsSummary,
      topicsSummary: topicsSummary,
      messageLog: messageLog,
    );
  }

  // MQTT: explain the extra features MQTT v5 adds
  String explainMqttV5Prompt({
    String? brokerUrl,
    String? connectionStatus,
    String? settingsSummary,
    String? topicsSummary,
    String? messageLog,
  }) {
    return buildExplainMqttV5Prompt(
      brokerUrl: brokerUrl,
      connectionStatus: connectionStatus,
      settingsSummary: settingsSummary,
      topicsSummary: topicsSummary,
      messageLog: messageLog,
    );
  }

  // MQTT: search the message log by meaning for what the user asks
  String findInMqttMessagesPrompt({
    String? brokerUrl,
    String? connectionStatus,
    String? settingsSummary,
    String? topicsSummary,
    String? messageLog,
  }) {
    return buildFindInMqttMessagesPrompt(
      brokerUrl: brokerUrl,
      connectionStatus: connectionStatus,
      settingsSummary: settingsSummary,
      topicsSummary: topicsSummary,
      messageLog: messageLog,
    );
  }

  // Explain what the user's outgoing WS message asks the server to do
  String explainWsMessagePrompt({
    String? url,
    String? connectionStatus,
    Map<String, String>? headersMap,
    String? messageLog,
  }) {
    return buildExplainWsMessagePrompt(
      url: url,
      connectionStatus: connectionStatus,
      headersMap: headersMap,
      messageLog: messageLog,
    );
  }

  // Correlate a sent WS message with what followed and suggest a payload fix
  String debugWsMessagePrompt({
    String? url,
    String? connectionStatus,
    Map<String, String>? headersMap,
    String? messageLog,
  }) {
    return buildDebugWsMessagePrompt(
      url: url,
      connectionStatus: connectionStatus,
      headersMap: headersMap,
      messageLog: messageLog,
    );
  }

  String summarizeWsMessagesPrompt({
    String? url,
    String? connectionStatus,
    Map<String, String>? headersMap,
    String? messageLog,
  }) {
    return buildSummarizeWsMessagesPrompt(
      url: url,
      connectionStatus: connectionStatus,
      headersMap: headersMap,
      messageLog: messageLog,
    );
  }

  // Generate Markdown documentation for a WebSocket API
  String generateWsDocumentationPrompt({
    String? url,
    String? connectionStatus,
    Map<String, String>? headersMap,
    Map<String, String>? paramsMap,
    String? settingsSummary,
    String? messageLog,
  }) {
    return buildGenerateWsDocumentationPrompt(
      url: url,
      connectionStatus: connectionStatus,
      headersMap: headersMap,
      paramsMap: paramsMap,
      settingsSummary: settingsSummary,
      messageLog: messageLog,
    );
  }

  // Generate WebSocket test code with proper async/timeout patterns
  String generateWsTestsPrompt({
    String? url,
    String? connectionStatus,
    Map<String, String>? headersMap,
    Map<String, String>? paramsMap,
    String? settingsSummary,
    String? messageLog,
  }) {
    return buildGenerateWsTestsPrompt(
      url: url,
      connectionStatus: connectionStatus,
      headersMap: headersMap,
      paramsMap: paramsMap,
      settingsSummary: settingsSummary,
      messageLog: messageLog,
    );
  }

  // Render precomputed connection health stats as a plain-language report
  String wsConnectionHealthPrompt({
    String? url,
    String? connectionStatus,
    String? healthStats,
    String? messageLog,
  }) {
    return buildWsConnectionHealthPrompt(
      url: url,
      connectionStatus: connectionStatus,
      healthStats: healthStats,
      messageLog: messageLog,
    );
  }

  // Ask for language with common WebSocket client options
  String wsCodeGenIntroPrompt({
    String? url,
    String? connectionStatus,
    Map<String, String>? headersMap,
  }) {
    return buildWsCodeGenIntroPrompt(
      url: url,
      connectionStatus: connectionStatus,
      headersMap: headersMap,
    );
  }

  // Generate WebSocket client code in the requested language
  String generateWsCodePrompt({
    String? url,
    Map<String, String>? headersMap,
    Map<String, String>? paramsMap,
    String? settingsSummary,
    String? messageLog,
    String? language,
  }) {
    return buildGenerateWsCodePrompt(
      url: url,
      headersMap: headersMap,
      paramsMap: paramsMap,
      settingsSummary: settingsSummary,
      messageLog: messageLog,
      language: language,
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
  String curlInsightsPrompt({String? diff, Map<String, dynamic>? newReq}) {
    return buildCurlInsightsPrompt(diff: diff, newReq: newReq);
  }
}
