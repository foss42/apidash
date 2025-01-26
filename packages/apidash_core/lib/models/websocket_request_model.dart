import 'package:apidash_core/consts.dart';
import 'package:apidash_core/models/websocket_frame_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:seed/models/name_value_model.dart';
import '../utils/utils.dart'
    show rowsToMap, getEnabledRows;
part 'websocket_request_model.freezed.dart';
part 'websocket_request_model.g.dart';

@freezed
class WebSocketRequestModel with _$WebSocketRequestModel {
  const WebSocketRequestModel._();

  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory WebSocketRequestModel({
    @Default("") String url,
    @Default(ContentTypeWebSocket.text) ContentTypeWebSocket contentType,
    bool? isConnected,
    List<NameValueModel>? headers, 
    List<bool>? isHeaderEnabledList, 
    List<NameValueModel>? params, 
    List<bool>? isParamEnabledList,
    String? message,
  }) = _WebSocketRequestModel;

  factory WebSocketRequestModel.fromJson(Map<String, Object?> json) =>
      _$WebSocketRequestModelFromJson(json);

  /// Headers Map
  Map<String, String> get headersMap => rowsToMap(headers) ?? {};
  List<NameValueModel>? get enabledHeaders =>
      getEnabledRows(headers, isHeaderEnabledList);
  Map<String, String> get enabledHeadersMap => rowsToMap(enabledHeaders) ?? {};
  bool get hasHeaders => enabledHeadersMap.isNotEmpty;

 
  Map<String, String> get paramsMap => rowsToMap(params) ?? {};
  List<NameValueModel>? get enabledParams =>
      getEnabledRows(params, isParamEnabledList);
  Map<String, String> get enabledParamsMap => rowsToMap(enabledParams) ?? {};
  bool get hasParams => enabledParamsMap.isNotEmpty;

  
  bool get isValidUrl => url.startsWith("ws://") || url.startsWith("wss://");

  /// Resets received messages
  List<String> resetReceivedMessages() {
    return [];
  }
}
