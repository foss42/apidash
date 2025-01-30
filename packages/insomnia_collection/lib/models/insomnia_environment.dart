import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'insomnia_environment.freezed.dart';
part 'insomnia_environment.g.dart';

@freezed
class InsomniaEnvironment with _$InsomniaEnvironment {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory InsomniaEnvironment({
    @JsonKey(name: '_id') String? id,
    String? name,
    @JsonKey(name: 'kvPairData') List<EnvironmentVariable>? resources ,
    @JsonKey(name: '_type') String? type,
  }) = _InsomniaEnvironment;

  factory InsomniaEnvironment.fromJson(Map<String, dynamic> json) =>
      _$InsomniaEnvironmentFromJson(json);
}

InsomniaEnvironment insomniaEnvironmentFromJsonStr(String str) {
  var insomniaJson = json.decode(str);
  return InsomniaEnvironment.fromJson(insomniaJson);
}

String insomniaEnvironmentToJsonStr(InsomniaEnvironment environment) {
  return json.encode(environment.toJson());
}

@freezed
class EnvironmentVariable with _$EnvironmentVariable {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory EnvironmentVariable({
    String? id,
    @JsonKey(name: 'name') required String key,
    @JsonKey(name: 'value') required String value,
    String? type,
    @JsonKey(name: 'enabled') bool? enabled,
  }) = _EnvironmentVariable;

  factory EnvironmentVariable.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentVariableFromJson(json);
}

EnvironmentVariable environmentVariableFromJsonStr(String str) {
  var environmentJson = json.decode(str);
  return EnvironmentVariable.fromJson(environmentJson);
}

String environmentVariableToJsonStr(EnvironmentVariable variable) {
  return json.encode(variable.toJson());
}