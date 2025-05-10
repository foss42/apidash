import 'package:freezed_annotation/freezed_annotation.dart';

part 'isolate_message.freezed.dart';
part 'isolate_message.g.dart';

@freezed
class IsolateMessage with _$IsolateMessage {
  const factory IsolateMessage({
    required String url,
    required String method,
    Map<String, String>? headers,
    dynamic body,
    Duration? timeout,
  }) = _IsolateMessage;

  factory IsolateMessage.fromJson(Map<String, Object?> json) => _$IsolateMessageFromJson(json);
}
