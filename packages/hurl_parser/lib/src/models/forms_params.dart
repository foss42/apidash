
import 'package:hurl_parser/src/models/misc_model.dart';

class FormParams {
  final List<KeyValue> params;

  FormParams({required this.params});

  factory FormParams.fromJson(Map<String, dynamic> json) {
    return FormParams(
      params: (json['params'] as List)
          .map((e) => KeyValue.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'params': params.map((e) => e.toJson()).toList(),
  };
}
