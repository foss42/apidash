import 'dart:convert';

class OpenResponsesAdapter {
  OpenResponsesAdapter._();

  /// Attempts to convert a known LLM response into OpenResponses.
  static Map<String, dynamic>? tryConvert(dynamic providerResponse) {
    if (providerResponse is! Map) return null;

    final map = Map<String, dynamic>.from(providerResponse);

    return _tryOpenAI(map) ?? _tryGemini(map) ?? _tryAnthropic(map);
  }

  static Map<String, dynamic>? _tryOpenAI(Map<String, dynamic> map) {
    // OpenAI responses contain a `choices` list with `message` objects.
    final choices = map['choices'];
    if (choices is! List || choices.isEmpty) return null;

    final firstChoice = choices[0];
    if (firstChoice is! Map) return null;
    final firstChoiceMap = Map<String, dynamic>.from(firstChoice);

    final message = firstChoiceMap['message'];
    if (message is! Map) return null;
    final messageMap = Map<String, dynamic>.from(message);

    final output = <Map<String, dynamic>>[];

    final reasoning = messageMap['reasoning'];
    if (reasoning != null) {
      final reasoningText = reasoning.toString();
      if (reasoningText.isNotEmpty) {
        output.add({'type': 'reasoning', 'content': reasoningText});
      }
    }

    final content = messageMap['content'];
    if (content != null) {
      final text = content is String ? content : content.toString();
      if (text.isNotEmpty) {
        output.addAll(
          List<Map<String, dynamic>>.from(
            _openResponsesMessage(text)['output'] as List,
          ),
        );
      }
    }

    final toolCalls = messageMap['tool_calls'];
    if (toolCalls is List) {
      for (final tc in toolCalls) {
        if (tc is! Map) continue;
        final tcMap = Map<String, dynamic>.from(tc);
        final fn = tcMap['function'];
        if (fn is! Map) continue;
        final fnMap = Map<String, dynamic>.from(fn);
        final name = fnMap['name']?.toString();
        if (name == null || name.isEmpty) continue;

        final argsRaw = fnMap['arguments'];
        dynamic arguments = argsRaw;

        if (argsRaw is String && argsRaw.trim().isNotEmpty) {
          try {
            arguments = jsonDecode(argsRaw);
          } catch (_) {
            arguments = <String, dynamic>{};
          }
        } else if (argsRaw is! Map && argsRaw is! List) {
          arguments = <String, dynamic>{};
        }

        output.add({
          'type': 'function_call',
          'name': name,
          'arguments': arguments,
        });
      }
    }

    if (output.isEmpty) return null;
    return {'output': output};
  }

  static Map<String, dynamic>? _tryGemini(Map<String, dynamic> map) {
    // Gemini responses have `candidates[0].content.parts` with text pieces.
    final candidates = map['candidates'];
    if (candidates is! List || candidates.isEmpty) return null;

    final firstCandidate = candidates[0];
    if (firstCandidate is! Map) return null;
    final firstCandidateMap = Map<String, dynamic>.from(firstCandidate);

    final content = firstCandidateMap['content'];
    if (content is! Map) return null;
    final contentMap = Map<String, dynamic>.from(content);

    final parts = contentMap['parts'];
    if (parts is! List) return null;

    final buffer = StringBuffer();
    for (final part in parts) {
      if (part is Map) {
        final text = part['text']?.toString();
        if (text != null && text.isNotEmpty) {
          if (buffer.isNotEmpty) buffer.writeln();
          buffer.write(text);
        }
      }
    }

    final combined = buffer.toString();
    if (combined.isEmpty) return null;
    return _openResponsesMessage(combined);
  }

  static Map<String, dynamic>? _tryAnthropic(Map<String, dynamic> map) {
    // Anthropic responses provide `content` as a list; first element contains text.
    final content = map['content'];
    if (content is! List || content.isEmpty) return null;

    final firstContent = content[0];
    if (firstContent is! Map) return null;
    final firstContentMap = Map<String, dynamic>.from(firstContent);

    final text = firstContentMap['text']?.toString();
    if (text == null || text.isEmpty) return null;

    return _openResponsesMessage(text);
  }

  static Map<String, dynamic> _openResponsesMessage(String text) {
    return {
      'output': [
        {
          'type': 'message',
          'role': 'assistant',
          'content': [
            {'type': 'output_text', 'text': text},
          ],
        },
      ],
    };
  }
}
