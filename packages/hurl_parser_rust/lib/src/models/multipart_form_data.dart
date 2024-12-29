// multipart_form_data.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'multipart_form_data.freezed.dart';
part 'multipart_form_data.g.dart';

@freezed
class MultipartFormData with _$MultipartFormData {
  const factory MultipartFormData({
    required String name,
    required String value,
    String? filename,
    String? contentType,
  }) = _MultipartFormData;

  factory MultipartFormData.fromJson(Map<String, dynamic> json) =>
      _$MultipartFormDataFromJson(json);
}
