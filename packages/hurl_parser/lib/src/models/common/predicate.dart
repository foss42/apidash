class Predicate {
  final String type;
  final dynamic value;
  final bool not;

  Predicate({
    required this.type,
    this.value,
    this.not = false,
  });

  factory Predicate.fromJson(Map<String, dynamic> json) {
    return Predicate(
      type: json['type'],
      value: json['value'],
      not: json['not'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    if (value != null) 'value': value,
    if (not) 'not': not,
  };
}
