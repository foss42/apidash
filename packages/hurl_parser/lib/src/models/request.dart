
import 'package:hurl_parser/hurl_parser.dart';

class Request {
  final String method;
  final String url;
  final List<Header> headers;
  final List<RequestSection> sections;
  final Body? body;


  Request({
    required this.method,
    required this.url,
    this.headers = const [],
    this.sections = const [],
    this.body,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      method: json['method'],
      url: json['url'],
      headers: (json['headers'] as List?)
          ?.map((e) => Header.fromJson(e))
          .toList() ?? [],
      sections: (json['sections'] as List?)
          ?.map((e) => RequestSection.fromJson(e))
          .toList() ?? [],
      body: json['body'] != null ? Body.fromJson(json['body']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'method': method,
    'url': url,
    'headers': headers.map((e) => e.toJson()).toList(),
    'sections': sections.map((e) => e.toJson()).toList(),
    if (body != null) 'body': body!.toJson(),
  };
}
