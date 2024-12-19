class Filter {
  final String type;
  final dynamic value;

  Filter({required this.type, this.value});

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    if (value != null) 'value': value,
  };
}
