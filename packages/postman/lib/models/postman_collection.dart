// To parse this JSON data, do
//
//     final postmanCollection = postmanCollectionFromJson(jsonString);
import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'postman_collection.freezed.dart';
part 'postman_collection.g.dart';

PostmanCollection postmanCollectionFromJsonStr(String str) =>
    PostmanCollection.fromJson(json.decode(str));

String postmanCollectionToJsonStr(PostmanCollection data) =>
    JsonEncoder.withIndent('  ').convert(data);

@freezed
class PostmanCollection with _$PostmanCollection {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory PostmanCollection({
    Info? info,
    List<Item>? item,
  }) = _PostmanCollection;

  factory PostmanCollection.fromJson(Map<String, dynamic> json) =>
      _$PostmanCollectionFromJson(json);
}

@freezed
class Info with _$Info {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Info({
    @JsonKey(name: '_postman_id') String? postmanId,
    String? name,
    String? schema,
    @JsonKey(name: '_exporter_id') String? exporterId,
  }) = _Info;

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
}

@freezed
class Item with _$Item {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Item({
    String? name,
    List<Item>? item,
    Request? request,
    List<dynamic>? response,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@freezed
class Request with _$Request {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Request({
    String? method,
    List<Header>? header,
    Body? body,
    Url? url,
  }) = _Request;

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);
}

@freezed
class Header with _$Header {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Header({
    String? key,
    String? value,
    String? type,
    bool? disabled,
  }) = _Header;

  factory Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);
}

@freezed
class Url with _$Url {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Url({
    String? raw,
    String? protocol,
    List<String>? host,
    List<String>? path,
    List<Query>? query,
  }) = _Url;

  factory Url.fromJson(Map<String, dynamic> json) => _$UrlFromJson(json);
}

@freezed
class Query with _$Query {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Query({
    String? key,
    String? value,
    bool? disabled,
  }) = _Query;

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);
}

@freezed
class Body with _$Body {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Body({
    String? mode,
    String? raw,
    Options? options,
    List<Formdatum>? formdata,
  }) = _Body;

  factory Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);
}

@freezed
class Options with _$Options {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Options({
    Raw? raw,
  }) = _Options;

  factory Options.fromJson(Map<String, dynamic> json) =>
      _$OptionsFromJson(json);
}

@freezed
class Raw with _$Raw {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Raw({
    String? language,
  }) = _Raw;

  factory Raw.fromJson(Map<String, dynamic> json) => _$RawFromJson(json);
}

@freezed
class Formdatum with _$Formdatum {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    includeIfNull: false,
  )
  const factory Formdatum({
    String? key,
    String? value,
    String? type,
    String? src,
  }) = _Formdatum;

  factory Formdatum.fromJson(Map<String, dynamic> json) =>
      _$FormdatumFromJson(json);
}
