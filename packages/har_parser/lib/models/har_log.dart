import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'har_log.freezed.dart';
part 'har_log.g.dart';

HarLog harLogFromJsonStr(String str) => HarLog.fromJson(json.decode(str));

String harLogToJsonStr(HarLog data) =>
    JsonEncoder.withIndent('  ').convert(data);

@freezed
class HarLog with _$HarLog {
  @JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
  const factory HarLog({
    Log? log,
  }) = _HarLog;

  factory HarLog.fromJson(Map<String, dynamic> json) => _$HarLogFromJson(json);
}

@freezed
class Log with _$Log {
  @JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
  const factory Log({
    String? version,
    Creator? creator,
    List<Entry>? entries,
  }) = _Log;

  factory Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);
}

@freezed
class Creator with _$Creator {
  @JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
  const factory Creator({
    String? name,
    String? version,
  }) = _Creator;

  factory Creator.fromJson(Map<String, dynamic> json) =>
      _$CreatorFromJson(json);
}

@freezed
class Entry with _$Entry {
  @JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
  const factory Entry({
    String? startedDateTime,
    int? time,
    Request? request,
    Response? response,
  }) = _Entry;

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
}

@freezed
class Request with _$Request {
  @JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
  const factory Request({
    String? method,
    String? url,
    String? httpVersion,
    List<dynamic>? cookies,
    List<dynamic>? headers,
    List<dynamic>? queryString,
    Map<String, dynamic>? postData,
    int? headersSize,
    int? bodySize,
  }) = _Request;

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);
}

@freezed
class Response with _$Response {
  @JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
  const factory Response({
    int? status,
    String? statusText,
    String? httpVersion,
    List<dynamic>? cookies,
    List<dynamic>? headers,
    Content? content,
    String? redirectURL,
    int? headersSize,
    int? bodySize,
  }) = _Response;

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
}

@freezed
class Content with _$Content {
  @JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
  const factory Content({
    int? size,
    String? mimeType,
  }) = _Content;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}
