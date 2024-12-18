import 'package:hurl_parser/src/models/misc_model.dart';

class QueryStringParams {
  final List<KeyValue> params;

  QueryStringParams({required this.params});

  factory QueryStringParams.fromJson(Map<String, dynamic> json) {
    return QueryStringParams(
      params: (json['params'] as List)
          .map((e) => KeyValue.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'params': params.map((e) => e.toJson()).toList(),
  };
}
