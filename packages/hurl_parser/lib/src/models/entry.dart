


import 'package:hurl_parser/hurl_parser.dart';

class Entry {
  final Request request;
  final Response? response;

  Entry({required this.request, this.response});

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      request: Request.fromJson(json['request']),
      response: json['response'] != null
          ? Response.fromJson(json['response'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'request': request.toJson(),
    'response': response?.toJson(),
  };
}
