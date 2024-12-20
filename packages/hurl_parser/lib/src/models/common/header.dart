class Header {
  final String key;
  final String value;

  Header({required this.key, required this.value});

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Header && key == other.key && value == other.value;

  @override
  int get hashCode => key.hashCode ^ value.hashCode;

  @override
  String toString() => '{key: $key, value: $value}';
}
