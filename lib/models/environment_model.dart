import 'package:apidash/consts.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'environment_model.freezed.dart';

part 'environment_model.g.dart';

@freezed
class EnvironmentModel with _$EnvironmentModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory EnvironmentModel({
    required String id,
    @Default("") String name,
    @Default([]) List<EnvironmentVariableModel> values,
  }) = _EnvironmentModel;

  factory EnvironmentModel.fromJson(Map<String, Object?> json) =>
      _$EnvironmentModelFromJson(json);
}

@freezed
class EnvironmentVariableModel with _$EnvironmentVariableModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory EnvironmentVariableModel({
    required String key,
    required String value,
    @Default(EnvironmentVariableType.variable) EnvironmentVariableType type,
    @Default(false) bool enabled,
  }) = _EnvironmentVariableModel;

  factory EnvironmentVariableModel.fromJson(Map<String, Object?> json) =>
      _$EnvironmentVariableModelFromJson(json);
}

const kEnvironmentVariableEmptyModel =
    EnvironmentVariableModel(key: "", value: "");
const kEnvironmentSecretEmptyModel = EnvironmentVariableModel(
    key: "", value: "", type: EnvironmentVariableType.secret);
