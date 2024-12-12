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
}
