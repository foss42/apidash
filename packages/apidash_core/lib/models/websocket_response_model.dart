import 'package:apidash_core/models/websocket_frame_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'websocket_response_model.freezed.dart';
part 'websocket_response_model.g.dart';


@freezed
class WebSocketResponseModel with _$WebSocketResponseModel {
  const WebSocketResponseModel._();

  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory WebSocketResponseModel({
    int? statusCode,
    @Default([]) List<WebSocketFrameModel> frames,
    Map<String, String>? headers,
    Map<String, String>? requestHeaders,
    
  }) = _WebSocketResponseModel;

  factory WebSocketResponseModel.fromJson(Map<String, Object?> json) =>
      _$WebSocketResponseModelFromJson(json);

}
