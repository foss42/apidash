enum AssertionType { statusCode, bodyContains, responseTimeUnder }

class Assertion {
  final String id;
  final AssertionType type;
  final dynamic expected; // int for statusCode, String for bodyContains, int ms for responseTime
  bool isSelected;

  Assertion({
    required this.id,
    required this.type,
    required this.expected,
    this.isSelected = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'expected': expected,
        'isSelected': isSelected,
      };

  factory Assertion.fromJson(Map<String, dynamic> json) => Assertion(
      // LLM output may omit id; synthesize a stable fallback.
      id: (json['id'] as String?) ?? 'assertion-${json['type']}',
        type: AssertionType.values.byName(json['type'] as String),
        expected: json['expected'],
        isSelected: json['isSelected'] as bool? ?? true,
      );
}