import 'package:hurl_parser/src/models/misc_model.dart';

class ResponseSection {
  final String type;
  final dynamic content;

  ResponseSection({required this.type, required this.content});

  factory ResponseSection.fromJson(Map<String, dynamic> json) {
    return ResponseSection(
      type: json['type'],
      content: switch (json['type']) {
        'Captures' => Captures.fromJson(json['content']),
        'Asserts' => Asserts.fromJson(json['content']),
        _ => json['content'],
      },
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'content': content is Map ? content : content.toJson(),
  };
}
