import 'package:apidash/models/models.dart';
import '../../constants.dart';
import '../../models/models.dart';
import '../../prompts/prompts.dart' as dash;

class PromptBuilder {
  String buildSystemPrompt(
    RequestModel? req,
    ChatMessageType type, {
    String? overrideLanguage,
    List<ChatMessage> history = const [],
  }) {
    final historyBlock = buildHistoryBlock(history);
    final contextBlock = buildContextBlock(req);
    final task = buildTaskPrompt(
      req,
      type,
      overrideLanguage: overrideLanguage,
    );
    return [
      if (task != null) task,
      if (contextBlock != null) contextBlock,
      if (historyBlock.isNotEmpty) historyBlock,
    ].join('\n\n');
  }

  String buildHistoryBlock(List<ChatMessage> messages, {int maxTurns = 8}) {
    if (messages.isEmpty) return '';
    final start = messages.length > maxTurns ? messages.length - maxTurns : 0;
    final recent = messages.sublist(start);
    final buf = StringBuffer('''<conversation_context>
\tOnly use the following short chat history to maintain continuity. Do not repeat it back.
\t''');
    for (final m in recent) {
      final role = m.role == MessageRole.user ? 'user' : 'assistant';
      buf.writeln('- $role: ${m.content}');
    }
    buf.writeln('</conversation_context>');
    return buf.toString();
  }

  String? buildContextBlock(RequestModel? req) {
    final http = req?.httpRequestModel;
    if (req == null || http == null) return null;
    final headers = http.headersMap.entries
        .map((e) => '"${e.key}": "${e.value}"')
        .join(', ');
    return '''<request_context>
  Request Name: ${req.name}
\tURL: ${http.url}
\tMethod: ${http.method.name.toUpperCase()}
  Status: ${req.responseStatus ?? ''}
\tContent-Type: ${http.bodyContentType.name}
\tHeaders: { $headers }
\tBody: ${http.body ?? ''}
  Response: ${req.httpResponseModel?.body ?? ''}
\t</request_context>''';
  }

  String? buildTaskPrompt(
    RequestModel? req,
    ChatMessageType type, {
    String? overrideLanguage,
  }) {
    if (req == null) return null;
    final http = req.httpRequestModel;
    final resp = req.httpResponseModel;
    final prompts = dash.DashbotPrompts();
    switch (type) {
      case ChatMessageType.explainResponse:
        return prompts.explainApiResponsePrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: req.responseStatus,
          bodyContentType: http?.bodyContentType.name,
          message: resp?.body,
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.debugError:
        return prompts.debugApiErrorPrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: req.responseStatus,
          bodyContentType: http?.bodyContentType.name,
          message: resp?.body,
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.generateTest:
        return prompts.generateTestCasesPrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.generateDoc:
        return prompts.generateDocumentationPrompt(
          url: http?.url,
          method: http?.method.name.toUpperCase(),
          responseStatus: req.responseStatus,
          bodyContentType: http?.bodyContentType.name,
          message: resp?.body,
          headersMap: http?.headersMap,
          body: http?.body,
        );
      case ChatMessageType.generateCode:
        if (overrideLanguage == null || overrideLanguage.isEmpty) {
          return prompts.codeGenerationIntroPrompt(
            url: http?.url,
            method: http?.method.name.toUpperCase(),
            headersMap: http?.headersMap,
            body: http?.body,
            bodyContentType: http?.bodyContentType.name,
            paramsMap: http?.paramsMap,
            authType: http?.authModel?.type.name,
          );
        } else {
          return prompts.generateCodePrompt(
            url: http?.url,
            method: http?.method.name.toUpperCase(),
            headersMap: http?.headersMap,
            body: http?.body,
            bodyContentType: http?.bodyContentType.name,
            paramsMap: http?.paramsMap,
            authType: http?.authModel?.type.name,
            language: overrideLanguage,
          );
        }
      case ChatMessageType.importCurl:
        return null;
      case ChatMessageType.importOpenApi:
        return null;
      case ChatMessageType.general:
        return prompts.generalInteractionPrompt();
    }
  }

  String? detectLanguage(String text) {
    final t = text.toLowerCase();
    if (t.contains('python')) return 'Python (requests)';
    if (t.contains('dart')) return 'Dart (http)';
    if (t.contains('golang') || t.contains('go ')) return 'Go (net/http)';
    if (t.contains('javascript') || t.contains('js') || t.contains('fetch')) {
      return 'JavaScript (fetch)';
    }
    if (t.contains('curl')) return 'cURL';
    return null;
  }

  /// Generates appropriate user message text for different task types
  String getUserMessageForTask(ChatMessageType type) {
    switch (type) {
      case ChatMessageType.explainResponse:
        return "Can you explain this response for me?";
      case ChatMessageType.debugError:
        return "Can you help me debug this error?";
      case ChatMessageType.generateDoc:
        return "Can you generate documentation for this request?";
      case ChatMessageType.generateTest:
        return "Can you generate tests for this request?";
      case ChatMessageType.generateCode:
        return "Can you generate code for this request?";
      case ChatMessageType.importCurl:
        return "I'd like to import a cURL command";
      case ChatMessageType.importOpenApi:
        return "I'd like to import an OpenAPI specification";
      case ChatMessageType.general:
        return "Hello";
    }
  }
}
