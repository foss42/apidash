import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:seed/models/name_value_model.dart';
import '../extensions/extensions.dart'; // Custom extensions for map/row handling
import '../utils/utils.dart'
    show rowsToMap, getEnabledRows; // Utility functions for row handling

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
    bool? isConnected,
    List<NameValueModel>? headers, 
    List<bool>? isHeaderEnabledList, // Enabled state for headers
    List<NameValueModel>? params, // List of parameters
    List<bool>? isParamEnabledList, // Enabled state for parameters
    String? initialMessage, // Optional message to send on connection
    List<String>? receivedMessages, // Log of received messages
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

  
  bool get hasReceivedMessages => receivedMessages?.isNotEmpty ?? false;

  /// Resets received messages
  List<String> resetReceivedMessages() {
    return [];
  }
}
