import 'package:freezed_annotation/freezed_annotation.dart';

part 'graphql_request_model.freezed.dart';
part 'graphql_request_model.g.dart';

@freezed
class GraphqlRequestModel with _$GraphqlRequestModel {
  const factory GraphqlRequestModel({
    required String query,
    Map<String, dynamic>? variables,
  }) = _GraphqlRequestModel;

  factory GraphqlRequestModel.fromJson(Map<String, dynamic> json) => _$GraphqlRequestModelFromJson(json);
}
