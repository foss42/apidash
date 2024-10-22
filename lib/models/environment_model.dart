import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';

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

class EnvironmentVariableSuggestion {
  final String environmentId;
  final EnvironmentVariableModel variable;
  final bool isUnknown;

  const EnvironmentVariableSuggestion({
    required this.environmentId,
    required this.variable,
    this.isUnknown = false,
  });

  EnvironmentVariableSuggestion copyWith({
    String? environmentId,
    EnvironmentVariableModel? variable,
    bool? isUnknown,
  }) {
    return EnvironmentVariableSuggestion(
      environmentId: environmentId ?? this.environmentId,
      variable: variable ?? this.variable,
      isUnknown: isUnknown ?? this.isUnknown,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnvironmentVariableSuggestion &&
        other.environmentId == environmentId &&
        other.variable == variable &&
        other.isUnknown == isUnknown;
  }

  @override
  int get hashCode =>
      environmentId.hashCode ^ variable.hashCode ^ isUnknown.hashCode;
}
