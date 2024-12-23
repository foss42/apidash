import 'package:freezed_annotation/freezed_annotation.dart';
import '../consts.dart';

part 'graphql_variable_model.freezed.dart';
part 'graphql_variable_model.g.dart';

@freezed
class GraphqlVariableModel with _$GraphqlVariableModel {
  const factory GraphqlVariableModel({
    required String name,
    required String value,
  }) = _GraphqlVariableModel;

  factory GraphqlVariableModel.fromJson(Map<String, Object?> json) =>
      _$GraphqlVariableModelFromJson(json);
}

const kFormDataEmptyModel = GraphqlVariableModel(
  name: "",
  value: "",
);
