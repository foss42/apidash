import 'package:freezed_annotation/freezed_annotation.dart';
// import 'models.dart';
import 'package:seed/models/name_value_model.dart';

part 'websocket_request_model.freezed.dart';
part 'websocket_request_model.g.dart';

@freezed
abstract class WebSocketRequestModel with _$WebSocketRequestModel {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory WebSocketRequestModel({
    @Default("") String url,
    @Default([]) List<NameValueModel> headers,
    @Default([]) List<NameValueModel> params,
    @Default([]) List<WebSocketMessageModel> messages,
  }) = _WebSocketRequestModel;

  factory WebSocketRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WebSocketRequestModelFromJson(json);
}

@freezed
abstract class WebSocketMessageModel with _$WebSocketMessageModel {
  const factory WebSocketMessageModel({
    required String message,
    required DateTime time,
    required bool
        isSent, // true if sent by client, false if received from server
  }) = _WebSocketMessageModel;

  factory WebSocketMessageModel.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageModelFromJson(json);
}
