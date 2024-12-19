import 'package:hurl_parser/hurl_parser.dart';

class Response {
  final String version;
  final int status;
  final List<Header> headers;
  final List<ResponseSection> sections;
  final Body? body;

  Response({
    required this.version,
    required this.status,
    this.headers = const [],
    this.sections = const [],
    this.body,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      version: json['version'],
      status: json['status'],
      headers: (json['headers'] as List?)
          ?.map((e) => Header.fromJson(e))
          .toList() ?? [],
      sections: (json['sections'] as List?)
          ?.map((e) => ResponseSection.fromJson(e))
          .toList() ?? [],
      body: json['body'] != null ? Body.fromJson(json['body']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'status': status,
    'headers': headers.map((e) => e.toJson()).toList(),
    'sections': sections.map((e) => e.toJson()).toList(),
    if (body != null) 'body': body!.toJson(),
  };
}
