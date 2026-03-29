import 'dart:convert';

sealed class OutputItem {
  const OutputItem();

  String get id;
  String get type;
  String get status;

  factory OutputItem.fromJson(Map<String, dynamic> json) {
    return switch (json['type'] as String? ?? '') {
      'message' => MessageOutputItem.fromJson(json),
      'function_call' => FunctionCallOutputItem.fromJson(json),
      'function_call_output' => FunctionCallResultItem.fromJson(json),
      'reasoning' => ReasoningOutputItem.fromJson(json),
      'web_search_call' => WebSearchCallOutputItem.fromJson(json),
      'file_search_call' => FileSearchCallOutputItem.fromJson(json),
      _ => UnknownOutputItem.fromJson(json),
    };
  }
}

class MessageOutputItem extends OutputItem {
  const MessageOutputItem({
    required this.id,
    required this.role,
    required this.status,
    required this.content,
  });

  @override
  final String id;
  @override
  final String type = 'message';
  @override
  final String status;
  final String role;
  final List<ContentPart> content;

  factory MessageOutputItem.fromJson(Map<String, dynamic> json) {
    final raw = json['content'];
    final parts = raw is List
        ? raw.map((c) => ContentPart.fromJson(c as Map<String, dynamic>)).toList()
        : <ContentPart>[];
    return MessageOutputItem(
      id: json['id'] as String? ?? '',
      role: json['role'] as String? ?? 'assistant',
      status: json['status'] as String? ?? 'completed',
      content: parts,
    );
  }

  String get text => content
      .whereType<OutputTextPart>()
      .map((p) => p.text)
      .join();
}

class FunctionCallOutputItem extends OutputItem {
  const FunctionCallOutputItem({
    required this.id,
    required this.callId,
    required this.name,
    required this.arguments,
    required this.status,
  });

  @override
  final String id;
  @override
  final String type = 'function_call';
  @override
  final String status;
  final String callId;
  final String name;
  final String arguments;

  factory FunctionCallOutputItem.fromJson(Map<String, dynamic> json) {
    return FunctionCallOutputItem(
      id: json['id'] as String? ?? '',
      callId: json['call_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      arguments: json['arguments'] as String? ?? '{}',
      status: json['status'] as String? ?? 'completed',
    );
  }
}

class FunctionCallResultItem extends OutputItem {
  const FunctionCallResultItem({
    required this.id,
    required this.callId,
    required this.output,
    required this.status,
  });

  @override
  final String id;
  @override
  final String type = 'function_call_output';
  @override
  final String status;
  final String callId;
  final String output;

  factory FunctionCallResultItem.fromJson(Map<String, dynamic> json) {
    final raw = json['output'];
    return FunctionCallResultItem(
      id: json['id'] as String? ?? '',
      callId: json['call_id'] as String? ?? '',
      output: raw is String ? raw : raw.toString(),
      status: json['status'] as String? ?? 'completed',
    );
  }
}

class ReasoningOutputItem extends OutputItem {
  const ReasoningOutputItem({
    required this.id,
    required this.status,
    this.summary,
    this.content,
  });

  @override
  final String id;
  @override
  final String type = 'reasoning';
  @override
  final String status;
  final String? summary;
  final String? content;

  factory ReasoningOutputItem.fromJson(Map<String, dynamic> json) {
    final summaryRaw = json['summary'];
    String? summaryText;
    if (summaryRaw is List && summaryRaw.isNotEmpty) {
      summaryText = summaryRaw.first['text'] as String?;
    } else if (summaryRaw is String) {
      summaryText = summaryRaw;
    }
    final contentRaw = json['content'];
    String? contentText;
    if (contentRaw is List && contentRaw.isNotEmpty) {
      contentText = contentRaw.first['text'] as String?;
    } else if (contentRaw is String) {
      contentText = contentRaw;
    }
    return ReasoningOutputItem(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? 'completed',
      summary: summaryText,
      content: contentText,
    );
  }
}

class WebSearchCallOutputItem extends OutputItem {
  const WebSearchCallOutputItem({
    required this.id,
    required this.status,
  });

  @override
  final String id;
  @override
  final String type = 'web_search_call';
  @override
  final String status;

  factory WebSearchCallOutputItem.fromJson(Map<String, dynamic> json) {
    return WebSearchCallOutputItem(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? 'completed',
    );
  }
}

class FileSearchCallOutputItem extends OutputItem {
  const FileSearchCallOutputItem({
    required this.id,
    required this.status,
    this.queries = const [],
  });

  @override
  final String id;
  @override
  final String type = 'file_search_call';
  @override
  final String status;
  final List<String> queries;

  factory FileSearchCallOutputItem.fromJson(Map<String, dynamic> json) {
    final rawQueries = json['queries'];
    final queries = rawQueries is List
        ? rawQueries.whereType<String>().toList()
        : <String>[];
    return FileSearchCallOutputItem(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? 'completed',
      queries: queries,
    );
  }
}

class UnknownOutputItem extends OutputItem {
  const UnknownOutputItem({
    required this.id,
    required this.type,
    required this.status,
    required this.raw,
  });

  @override
  final String id;
  @override
  final String type;
  @override
  final String status;
  final Map<String, dynamic> raw;

  factory UnknownOutputItem.fromJson(Map<String, dynamic> json) {
    return UnknownOutputItem(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'unknown',
      status: json['status'] as String? ?? '',
      raw: json,
    );
  }
}

sealed class ContentPart {
  const ContentPart();

  factory ContentPart.fromJson(Map<String, dynamic> json) {
    return switch (json['type'] as String? ?? '') {
      'output_text' => OutputTextPart.fromJson(json),
      'refusal' => RefusalPart.fromJson(json),
      _ => OutputTextPart(text: json['text'] as String? ?? ''),
    };
  }
}

class OutputTextPart extends ContentPart {
  const OutputTextPart({required this.text});
  final String text;

  factory OutputTextPart.fromJson(Map<String, dynamic> json) {
    return OutputTextPart(text: json['text'] as String? ?? '');
  }
}

class RefusalPart extends ContentPart {
  const RefusalPart({required this.refusal});
  final String refusal;

  factory RefusalPart.fromJson(Map<String, dynamic> json) {
    return RefusalPart(refusal: json['refusal'] as String? ?? '');
  }
}

class OpenResponsesUsage {
  const OpenResponsesUsage({
    required this.inputTokens,
    required this.outputTokens,
    required this.totalTokens,
  });

  final int inputTokens;
  final int outputTokens;
  final int totalTokens;

  factory OpenResponsesUsage.fromJson(Map<String, dynamic> json) {
    return OpenResponsesUsage(
      inputTokens: json['input_tokens'] as int? ?? 0,
      outputTokens: json['output_tokens'] as int? ?? 0,
      totalTokens: json['total_tokens'] as int? ?? 0,
    );
  }
}

class OpenResponsesResult {
  const OpenResponsesResult({
    required this.id,
    required this.model,
    required this.status,
    required this.output,
    this.previousResponseId,
    this.usage,
  });

  final String id;
  final String model;
  final String status;
  final List<OutputItem> output;
  final String? previousResponseId;
  final OpenResponsesUsage? usage;

  static bool isOpenResponsesFormat(Map<String, dynamic> json) {
    return json['object'] == 'response' &&
        json['output'] is List &&
        json.containsKey('id');
  }

  factory OpenResponsesResult.fromJson(Map<String, dynamic> json) {
    final rawOutput = json['output'] as List? ?? [];
    return OpenResponsesResult(
      id: json['id'] as String? ?? '',
      model: json['model'] as String? ?? '',
      status: json['status'] as String? ?? '',
      output: rawOutput
          .map((e) => OutputItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      previousResponseId: json['previous_response_id'] as String?,
      usage: json['usage'] != null
          ? OpenResponsesUsage.fromJson(json['usage'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Parses Open Responses SSE stream events into a live list of [OutputItem]s.
///
/// The Open Responses streaming protocol sends typed events:
///   response.output_item.added        — new item started (with index)
///   response.output_text.delta        — text delta for a message item
///   response.reasoning_summary_text.delta — reasoning summary delta
///   response.function_call_arguments.delta — function call args delta
///   response.output_item.done         — item fully received
///   response.completed                — full response object available
class OpenResponsesStreamParser {
  /// Returns true if [sseOutput] contains Open Responses stream events.
  static bool isOpenResponsesStream(List<String> sseOutput) {
    for (final line in sseOutput) {
      final t = line.trim();
      if (!t.startsWith('data: ')) continue;
      final data = t.substring(6).trim();
      if (data.isEmpty || data == '[DONE]') continue;
      try {
        final json = jsonDecode(data);
        if (json is Map<String, dynamic>) {
          final type = json['type'] as String? ?? '';
          if (type.startsWith('response.output_item') ||
              type == 'response.completed' ||
              type == 'response.created') {
            return true;
          }
        }
      } catch (_) {}
    }
    return false;
  }

  /// Parses [sseOutput] into the current list of [OutputItem]s.
  ///
  /// If a `response.completed` event is present the final full result is used.
  /// Otherwise items are built incrementally from in-progress events.
  static List<OutputItem> parse(List<String> sseOutput) {
    // index → mutable item JSON
    final Map<int, Map<String, dynamic>> items = {};
    final Map<int, StringBuffer> textBuf = {};
    final Map<int, StringBuffer> reasoningBuf = {};
    final Map<int, StringBuffer> argsBuf = {};
    OpenResponsesResult? completed;

    for (final line in sseOutput) {
      final t = line.trim();
      if (!t.startsWith('data: ')) continue;
      final data = t.substring(6).trim();
      if (data.isEmpty || data == '[DONE]') continue;

      Map<String, dynamic> json;
      try {
        json = jsonDecode(data) as Map<String, dynamic>;
      } catch (_) {
        continue;
      }

      final type = json['type'] as String? ?? '';

      switch (type) {
        case 'response.output_item.added':
          final idx = json['output_index'] as int? ?? 0;
          final item =
              Map<String, dynamic>.from(json['item'] as Map? ?? {});
          items[idx] = item;
          final itemType = item['type'] as String? ?? '';
          if (itemType == 'message') textBuf[idx] = StringBuffer();
          if (itemType == 'reasoning') reasoningBuf[idx] = StringBuffer();
          if (itemType == 'function_call') argsBuf[idx] = StringBuffer();

        case 'response.output_text.delta':
          final idx = json['output_index'] as int? ?? 0;
          textBuf[idx]?.write(json['delta'] as String? ?? '');
          if (items.containsKey(idx)) {
            items[idx] = {
              ...items[idx]!,
              'content': [
                {'type': 'output_text', 'text': textBuf[idx]!.toString()}
              ],
            };
          }

        case 'response.reasoning_summary_text.delta':
          final idx = json['output_index'] as int? ?? 0;
          reasoningBuf[idx]?.write(json['delta'] as String? ?? '');
          if (items.containsKey(idx)) {
            items[idx] = {
              ...items[idx]!,
              'summary': [
                {'text': reasoningBuf[idx]!.toString()}
              ],
            };
          }

        case 'response.function_call_arguments.delta':
          final idx = json['output_index'] as int? ?? 0;
          argsBuf[idx]?.write(json['delta'] as String? ?? '');
          if (items.containsKey(idx)) {
            items[idx] = {
              ...items[idx]!,
              'arguments': argsBuf[idx]!.toString(),
            };
          }

        case 'response.output_item.done':
          final idx = json['output_index'] as int? ?? 0;
          final item = json['item'] as Map<String, dynamic>?;
          if (item != null) items[idx] = item;

        case 'response.completed':
          final response = json['response'] as Map<String, dynamic>?;
          if (response != null) {
            try {
              completed = OpenResponsesResult.fromJson(response);
            } catch (_) {}
          }
      }
    }

    if (completed != null) return completed.output;

    final sorted = items.keys.toList()..sort();
    final result = <OutputItem>[];
    for (final k in sorted) {
      try {
        result.add(OutputItem.fromJson(items[k]!));
      } catch (_) {}
    }
    return result;
  }
}
