import 'package:freezed_annotation/freezed_annotation.dart';
import 'websocket_message_model.dart';

part 'websocket_connection_model.freezed.dart';
part 'websocket_connection_model.g.dart';

@freezed
class WebSocketConnectionModel with _$WebSocketConnectionModel {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory WebSocketConnectionModel({
    @Default(false) bool isConnecting,
    @Default(false) bool isConnected,
    @Default(false) bool isClosed,

    DateTime? connectedAt,
    DateTime? disconnectedAt,

    @Default(<WebSocketMessageModel>[])
    List<WebSocketMessageModel> messages,
  }) = _WebSocketConnectionModel;

  factory WebSocketConnectionModel.fromJson(Map<String, Object?> json) =>
      _$WebSocketConnectionModelFromJson(json);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
