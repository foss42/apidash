
import 'package:hurl_parser/src/models/multipart_param.dart';

class MultipartFormData {
  final List<MultipartParam> params;

  MultipartFormData({required this.params});

  factory MultipartFormData.fromJson(Map<String, dynamic> json) {
    return MultipartFormData(
      params: (json['params'] as List)
          .map((e) => MultipartParam.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'params': params.map((e) => e.toJson()).toList(),
  };
}
