import 'package:seed/seed.dart';

part 'auth_basic_model.g.dart';
part 'auth_basic_model.freezed.dart';

@freezed
class AuthBasicAuthModel with _$AuthBasicAuthModel {
  const factory AuthBasicAuthModel({
    required String username,
    required String password,
  }) = _AuthBasicAuthModel;

  factory AuthBasicAuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthBasicAuthModelFromJson(json);
}
