// query_param.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'query_param.freezed.dart';
part 'query_param.g.dart';

@freezed
class QueryParam with _$QueryParam {
  const factory QueryParam({
    required String name,
    required String value,
  }) = _QueryParam;

  factory QueryParam.fromJson(Map<String, dynamic> json) =>
      _$QueryParamFromJson(json);
}
