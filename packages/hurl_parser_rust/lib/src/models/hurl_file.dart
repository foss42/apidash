// lib/src/models/hurl_file.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import 'hurl_entry.dart';

part 'hurl_file.freezed.dart';
part 'hurl_file.g.dart';

@freezed
class HurlFile with _$HurlFile {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory HurlFile({
    required List<HurlEntry> entries,
  }) = _HurlFile;

  factory HurlFile.fromJson(Map<String, dynamic> json) =>
      _$HurlFileFromJson(json);
}
