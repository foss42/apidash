import 'package:better_networking/utils/http_request_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:seed/models/name_value_model.dart';
import '../consts.dart';
import 'auth/api_auth_model.dart';

part 'websocket_request_model.freezed.dart';
part 'websocket_request_model.g.dart';

@freezed
class WebSocketRequestModel with _$WebSocketRequestModel {
  const WebSocketRequestModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory WebSocketRequestModel({
    @Default("") String url,
    List<NameValueModel>? headers,
    List<bool>? isHeaderEnabledList,
    List<NameValueModel>? params,
    List<bool>? isParamEnabledList,
    @Default(AuthModel(type: APIAuthType.none)) AuthModel? authModel,
    String? initialMessage,
    @Default(ContentType.json) ContentType messageContentType,
  }) = _WebSocketRequestModel;

  Map<String, String> get headersMap => rowsToMap(headers) ?? {};
  Map<String, String> get paramsMap => rowsToMap(params) ?? {};

  factory WebSocketRequestModel.fromJson(Map<String, Object?> json) =>
      _$WebSocketRequestModelFromJson(json);

  Map<String, String> get enabledHeadersMap => rowsToMap(enabledHeaders) ?? {};

  Map<String, String> get enabledParamsMap => rowsToMap(enabledParams) ?? {};

  List<NameValueModel>? get enabledHeaders =>
      getEnabledRows(headers, isHeaderEnabledList);

  List<NameValueModel>? get enabledParams =>
      getEnabledRows(params, isParamEnabledList);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
