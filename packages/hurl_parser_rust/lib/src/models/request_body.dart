import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_body.freezed.dart';
part 'request_body.g.dart';

@freezed
class RequestBody with _$RequestBody {
  @JsonSerializable(explicitToJson: true)
  const factory RequestBody({
    required String type,
    required dynamic value,
  }) = _RequestBody;

  factory RequestBody.fromJson(Map<String, dynamic> json) =>
      _$RequestBodyFromJson(json);
}
