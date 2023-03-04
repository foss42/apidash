import 'package:flutter/material.dart';
import '../consts.dart';

@immutable
class RequestModel {
  const RequestModel({
    required this.id,
    this.method = DEFAULT_METHOD,
    this.url = "",
  });

  final String id;
  final HTTPVerb method;
  final String url;

  RequestModel duplicate({
    required String id,
  }) {
    return RequestModel(
      id: id,
      method: method,
      url: url,
    );
  }

  RequestModel copyWith({
    String? id,
    HTTPVerb? method,
    String? url,
  }) {
    return RequestModel(
      id: id ?? this.id,
      method: method ?? this.method,
      url: url ?? this.url,
    );
  }

  @override
  String toString() {
    return [
      id,
      method.name,
      "URL: $url",
    ].join("\n");
  }
}
