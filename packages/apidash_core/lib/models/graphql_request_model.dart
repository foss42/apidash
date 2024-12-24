import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:seed/seed.dart';
import '../extensions/extensions.dart';
import '../utils/utils.dart'
    show rowsToFormDataMapList, rowsToMap, getEnabledRows;
import '../consts.dart';

part 'graphql_request_model.freezed.dart';

part 'graphql_request_model.g.dart';


@freezed
class GraphqlRequestModel with _$GraphqlRequestModel {
  const GraphqlRequestModel._();

  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory GraphqlRequestModel({
    @Default("") String url,
    List<NameValueModel>? headers,
    List<NameValueModel>? graphqlVariables,
    List<bool>? isHeaderEnabledList,
    List<bool>? isgraphqlVariablesEnabledList,
    String? query,
}) = _GraphqlRequestModel;

  factory GraphqlRequestModel.fromJson(Map<String, Object?> json) =>
      _$GraphqlRequestModelFromJson(json);

  Map<String, String> get headersMap => rowsToMap(headers) ?? {};
  Map<String, String> get graphqlVariablesMap => rowsToMap(graphqlVariables) ?? {};
  List<NameValueModel>? get enabledHeaders =>
      getEnabledRows(headers, isHeaderEnabledList);
  List<NameValueModel>? get enabledgraphqlVariables =>
      getEnabledRows(graphqlVariables, isgraphqlVariablesEnabledList);

  Map<String, String> get enabledHeadersMap => rowsToMap(enabledHeaders) ?? {};
  Map<String, String> get enabledgraphqlVariablesMap => rowsToMap(enabledgraphqlVariables) ?? {};

}
