import 'package:freezed_annotation/freezed_annotation.dart';
import 'query.dart';
import 'filter.dart';

part 'capture.freezed.dart';
part 'capture.g.dart';

@freezed
class Capture with _$Capture {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory Capture({
    required String name,
    required Query query,
    List<Filter>? filters,
  }) = _Capture;

  factory Capture.fromJson(Map<String, dynamic> json) =>
      _$CaptureFromJson(json);
}
