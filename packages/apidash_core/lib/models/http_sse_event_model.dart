import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_sse_event_model.freezed.dart';
part 'http_sse_event_model.g.dart';

@freezed
class SSEEventModel with _$SSEEventModel {
  const SSEEventModel._();

  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory SSEEventModel({
    @Default("") String event, // Custom event name
    @Default("") String data, // Event data (main payload)
    String? id, // Last event ID for reconnection
    int? retry, // Reconnect interval in milliseconds
    Map<String, String>? customFields, // Additional metadata
  }) = _SSEEventModel;

  factory SSEEventModel.fromJson(Map<String, Object?> json) =>
      _$SSEEventModelFromJson(json);

  /// Parses raw SSE data into an SSEEventModel
  static SSEEventModel fromRawSSE(String rawEvent) {
    final Map<String, String> fields = {};
    String? event, data, id;
    int? retry;

    for (var line in LineSplitter.split(rawEvent)) {
      if (line.startsWith(":")) {
        continue; // Ignore comments
      }
      final parts = line.split(": ");
      if (parts.length < 2) continue;

      final key = parts[0].trim();
      final value = parts.sublist(1).join(": ").trim();

      switch (key) {
        case "event":
          event = value;
          break;
        case "data":
          data = (data ?? "") + value + "\n"; // Multi-line data support
          break;
        case "id":
          id = value;
          break;
        case "retry":
          retry = int.tryParse(value);
          break;
        default:
          fields[key] = value; // Store unknown fields as custom metadata
      }
    }

    return SSEEventModel(
      event: event ?? "",
      data: data?.trim() ?? "",
      id: id,
      retry: retry,
      customFields: fields.isNotEmpty ? fields : null,
    );
  }
}