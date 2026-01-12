import 'package:freezed_annotation/freezed_annotation.dart';

part 'websocket_message_model.freezed.dart';
part 'websocket_message_model.g.dart';

enum WebSocketMessageType {
  connect,
  disconnect,
  sent,
  received,
  error,
  info,
}

@freezed
class WebSocketMessageModel with _$WebSocketMessageModel {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory WebSocketMessageModel({
    required String id,

    @Default(WebSocketMessageType.info)
    WebSocketMessageType type,

    String? payload,

    DateTime? timestamp,

    String? message,

    int? sizeBytes,
  }) = _WebSocketMessageModel;

  factory WebSocketMessageModel.fromJson(Map<String, Object?> json) =>
      _$WebSocketMessageModelFromJson(json);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
