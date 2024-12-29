// form_param.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_param.freezed.dart';
part 'form_param.g.dart';

@freezed
class FormParam with _$FormParam {
  const factory FormParam({
    required String name,
    required String value,
  }) = _FormParam;

  factory FormParam.fromJson(Map<String, dynamic> json) =>
      _$FormParamFromJson(json);
}
