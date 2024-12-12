class Body {
  final String type;
  final dynamic content;

  Body({required this.type, required this.content});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      type: json['type'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'content': content,
  };
}
