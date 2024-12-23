class Query {
  final String type;
  final dynamic value;

  Query({required this.type, this.value});

  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    if (value != null) 'value': value,
  };
}
