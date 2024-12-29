import 'package:freezed_annotation/freezed_annotation.dart';
import 'hurl_request.dart';
import 'hurl_response.dart';

part 'hurl_entry.freezed.dart';
part 'hurl_entry.g.dart';

@freezed
class HurlEntry with _$HurlEntry {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory HurlEntry({
    required HurlRequest request,
    HurlResponse? response,
  }) = _HurlEntry;

  factory HurlEntry.fromJson(Map<String, dynamic> json) =>
      _$HurlEntryFromJson(json);
}
