// basic_auth.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'basic_auth.freezed.dart';
part 'basic_auth.g.dart';

@freezed
class BasicAuth with _$BasicAuth {
  const factory BasicAuth({
    required String username,
    required String password,
  }) = _BasicAuth;

  factory BasicAuth.fromJson(Map<String, dynamic> json) =>
      _$BasicAuthFromJson(json);
}
