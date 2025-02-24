import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'insomnia_collection.freezed.dart';
part 'insomnia_collection.g.dart';

InsomniaCollection insomniaCollectionFromJsonStr(String str) =>
    InsomniaCollection.fromJson(json.decode(str));

String insomniaCollectionToJsonStr(InsomniaCollection data) =>
    JsonEncoder.withIndent('  ').convert(data);

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
    String? parentId,
    num? modified,
    num? created,
    String? url,
    String? name,
    String? description,
    String? method,
    Body? body,
    String? preRequestScript,
    List<Parameter>? parameters,
    List<Header>? headers,
    dynamic authentication,
    num? metaSortKey,
    bool? isPrivate,
    List<dynamic>? pathParameters,
    String? afterResponseScript,
    bool? settingStoreCookies,
    bool? settingSendCookies,
    bool? settingDisableRenderRequestBody,
    bool? settingEncodeUrl,
    bool? settingRebuildPath,
    String? settingFollowRedirects,
    dynamic environment,
    dynamic environmentPropertyOrder,
    String? scope,
    dynamic data,
    dynamic dataPropertyOrder,
    dynamic color,
    List<Cookie>? cookies,
    String? fileName,
    String? contents,
    String? contentType,
    String? environmentType,
    List<KVPairDatum>? kvPairData,
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
    List<Formdatum>? params,
  }) = _Body;

  factory Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);
}

@freezed
class Formdatum with _$Formdatum {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Formdatum({
    String? name,
    String? value,
    String? type,
    @JsonKey(name: 'fileName') String? src,
  }) = _Formdatum;

  factory Formdatum.fromJson(Map<String, dynamic> json) =>
      _$FormdatumFromJson(json);
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

@freezed
class Cookie with _$Cookie {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Cookie({
    String? key,
    String? value,
    String? domain,
    String? path,
    bool? secure,
    bool? httpOnly,
    bool? hostOnly,
    DateTime? creation,
    DateTime? lastAccessed,
    String? sameSite,
    String? id,
  }) = _Cookie;

  factory Cookie.fromJson(Map<String, dynamic> json) => _$CookieFromJson(json);
}

@freezed
class KVPairDatum with _$KVPairDatum {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory KVPairDatum({
    String? id,
    String? name,
    String? value,
    String? type,
    bool? enabled,
  }) = _KVPairDatum;

  factory KVPairDatum.fromJson(Map<String, dynamic> json) =>
      _$KVPairDatumFromJson(json);
}
