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
