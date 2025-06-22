import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:better_networking/better_networking.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart' show mergeMaps;
import '../llm_provider.dart';
part 'ai_response_model.freezed.dart';
part 'ai_response_model.g.dart';

@freezed
class AIResponseModel with _$AIResponseModel {
  const AIResponseModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true, createToJson: true)
  const factory AIResponseModel({
    int? statusCode,
    Map<String, String>? headers,
    Map<String, String>? requestHeaders,
    String? body,
    String? formattedBody,
    @JsonKey(
      fromJson: LLMProvider.fromJSONNullable,
      toJson: LLMProvider.toJSONNullable,
    )
    LLMProvider? llmProvider,
    @Uint8ListConverter() Uint8List? bodyBytes,
    @DurationConverter() Duration? time,
  }) = _AIResponseModel;

  factory AIResponseModel.fromJson(Map<String, Object?> json) =>
      _$AIResponseModelFromJson(json);

  AIResponseModel fromResponse({
    required Response response,
    required LLMProvider provider,
    Duration? time,
  }) {
    final responseHeaders = mergeMaps({
      HttpHeaders.contentLengthHeader: response.contentLength.toString(),
    }, response.headers);
    MediaType? mediaType = getMediaTypeFromHeaders(responseHeaders);
    final body = (mediaType?.subtype == kSubTypeJson)
        ? utf8.decode(response.bodyBytes)
        : response.body;
    return AIResponseModel(
      statusCode: response.statusCode,
      headers: responseHeaders,
      requestHeaders: response.request?.headers,
      body: body,
      formattedBody: response.statusCode == 200
          ? provider.modelController.outputFormatter(jsonDecode(body))
          : formatBody(body, mediaType),
      bodyBytes: response.bodyBytes,
      time: time,
      llmProvider: provider,
    );
  }

  String? get contentType => headers?.getValueContentType();
  MediaType? get mediaType => getMediaTypeFromHeaders(headers);
}
