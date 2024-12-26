import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:apidash_core/apidash_core.dart';
import 'package:json_annotation/json_annotation.dart' as json_annotation;
import 'package:apidash_core/models/http_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart' show mergeMaps;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import '../extensions/extensions.dart';
import '../utils/utils.dart';
import '../consts.dart';


part 'graphql_response_model.freezed.dart';

part 'graphql_response_model.g.dart';



@freezed
class GraphqlResponseModel with _$GraphqlResponseModel {
  const GraphqlResponseModel._();
  @json_annotation.JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )

  const factory GraphqlResponseModel({
    int? statusCode,
    Map<String, String>? headers,
    Map<String, String>? requestHeaders,
    GraphqlRequestModel? graphqlRequestModel,
    String? body,
    String? formattedBody,
    @DurationConverter() Duration? time,
  }) = _GraphqlResponseModel;

  factory GraphqlResponseModel.fromJson(Map<String, Object?> json) =>
      _$GraphqlResponseModelFromJson(json);

 

  GraphqlResponseModel fromResponse({
    required QueryResult response,
    Duration? time,
     GraphqlRequestModel? graphqlRequestModel,
  }) {
     final responseHeaders = response.context.entry<HttpLinkResponseContext>()?.headers ?? {};
    MediaType mediaType = MediaType("application","json");
    final body =  jsonEncode(response.data);
    return GraphqlResponseModel(
      statusCode: response.context.entry<HttpLinkResponseContext>()?.statusCode,
      headers: responseHeaders,
      requestHeaders: graphqlRequestModel!.headersMap,
      body: body,
      formattedBody: formatBody(body, mediaType),
      time: time,
    );
  }
}
