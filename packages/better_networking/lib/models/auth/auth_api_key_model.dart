import 'package:seed/seed.dart';

part 'auth_api_key_model.g.dart';
part 'auth_api_key_model.freezed.dart';

@freezed
class AuthApiKeyModel with _$AuthApiKeyModel {
  const factory AuthApiKeyModel({
    required String key,
    @Default('header') String location, // 'header' or 'query'
    @Default('x-api-key') String name,
  }) = _AuthApiKeyModel;

  factory AuthApiKeyModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiKeyModelFromJson(json);
}
