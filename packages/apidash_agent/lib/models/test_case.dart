import 'assertion.dart';

enum TestCategory { happyPath, edgeCase, security, performance }

enum TestStatus { pending, passed, failed, skipped }

class TestCase {
  final String id;
  final String description;
  final TestCategory category;

  // Complete independent request — original is NEVER touched
  final String method;
  final String url;
  final Map<String, String> headers;
  final String? body;

  final List<Assertion> assertions;
  final bool isSelected; // user controls via checklist

  TestCase({
    required this.id,
    required this.description,
    required this.category,
    required this.method,
    required this.url,
    required this.headers,
    this.body,
    required this.assertions,
    this.isSelected = true,
  });

  TestCase copyWith({
    String? id,
    String? description,
    TestCategory? category,
    String? method,
    String? url,
    Map<String, String>? headers,
    String? body,
    List<Assertion>? assertions,
    bool? isSelected,
  }) => TestCase(
        id: id ?? this.id,
        description: description ?? this.description,
        category: category ?? this.category,
        method: method ?? this.method,
        url: url ?? this.url,
        headers: headers ?? this.headers,
        body: body ?? this.body,
        assertions: assertions ?? this.assertions,
        isSelected: isSelected ?? this.isSelected,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'category': category.name,
        'method': method,
        'url': url,
        'headers': headers,
        'body': body,
        'assertions': assertions.map((a) => a.toJson()).toList(),
        'isSelected': isSelected,
      };

  factory TestCase.fromJson(Map<String, dynamic> json) => TestCase(
        id: json['id'] as String,
        description: json['description'] as String,
        category: TestCategory.values.byName(json['category'] as String),
        method: json['method'] as String,
        url: json['url'] as String,
        headers: Map<String, String>.from(json['headers'] as Map),
        body: json['body'] as String?,
        assertions: (json['assertions'] as List)
            .map((a) => Assertion.fromJson(a as Map<String, dynamic>))
            .toList(),
        isSelected: json['isSelected'] as bool? ?? true,
      );
}