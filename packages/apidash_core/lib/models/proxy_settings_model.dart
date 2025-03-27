import 'package:freezed_annotation/freezed_annotation.dart';

part 'proxy_settings_model.freezed.dart';
part 'proxy_settings_model.g.dart';

@freezed
class ProxySettings with _$ProxySettings {
  const factory ProxySettings({
    @Default('') String host,
    @Default('') String port,
    String? username,
    String? password,
  }) = _ProxySettings;

  factory ProxySettings.fromJson(Map<String, dynamic> json) =>
      _$ProxySettingsFromJson(json);
}
