class MultipartParam {
  final String name;
  final dynamic value;
  final String? filename;
  final String? contentType;

  MultipartParam({
    required this.name,
    required this.value,
    this.filename,
    this.contentType,
  });

  factory MultipartParam.fromJson(Map<String, dynamic> json) {
    return MultipartParam(
      name: json['name'],
      value: json['value'],
      filename: json['filename'],
      contentType: json['contentType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
    if (filename != null) 'filename': filename,
    if (contentType != null) 'contentType': contentType,
  };
}
