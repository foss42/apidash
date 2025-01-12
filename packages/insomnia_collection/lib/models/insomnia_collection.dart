import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'insomnia_collection.freezed.dart';
part 'insomnia_collection.g.dart';

InsomniaCollection insomniaCollectionFromJsonStr(String str) {
  var Insomniajson = json.decode(str);
  // Remove all resources which are not requests
  Insomniajson['resources'] = (Insomniajson['resources'] as List)
      .where((resource) => resource['_type'] == 'request')
      .toList();

  return InsomniaCollection.fromJson(Insomniajson);
}


InsomniaCollection insomniaCollectionFromJson(Map<String, dynamic> json) {
  // Remove all resources which are not requests
  json['resources'] = (json['resources'] as List)
      .where((resource) => resource['_type'] == 'request')
      .toList();

  return InsomniaCollection.fromJson(json);
}

/// TODO: functions to convert to json and json string

@freezed
class InsomniaCollection with _$InsomniaCollection {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory InsomniaCollection({
    @JsonKey(name: '_type') String? type,
    @JsonKey(name: '__export_format') num? exportFormat,
    @JsonKey(name: '__export_date') String? exportDate,
    @JsonKey(name: '__export_source') String? exportSource,
    List<Resource>? resources,
  }) = _InsomniaCollection;

  factory InsomniaCollection.fromJson(Map<String, dynamic> json) =>
      _$InsomniaCollectionFromJson(json);
}

@freezed
class Resource with _$Resource {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Resource({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'parentId') String? parentId,
    num? modified,
    num? created,
    String? url,
    String? name,
    String? description,
    String? method,
    Body? body,
    List<Parameter>? parameters,
    List<Header>? headers,
    String? preRequestScript,
    num? metaSortKey,
    bool? isPrivate,
    String? afterResponseScript,
    bool? settingSendCookies,
    bool? settingStoreCookies,
    bool? settingDisableRenderRequestBody,
    bool? settingEncodeUrl,
    bool? settingRebuildPath,
    String? settingFollowRedirects,
    @JsonKey(name: '_type') String? type,
  }) = _Resource;

  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);
}

@freezed
class Body with _$Body {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Body({
    String? mimeType,
    String? text,
  }) = _Body;

  factory Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);
}

@freezed
class Parameter with _$Parameter {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Parameter({
    String? id,
    String? name,
    String? value,
    String? description,
    bool? disabled,
  }) = _Parameter;

  factory Parameter.fromJson(Map<String, dynamic> json) =>
      _$ParameterFromJson(json);
}

@freezed
class Header with _$Header {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Header({
    String? name,
    String? value,
    bool? disabled,
  }) = _Header;

  factory Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);
}
