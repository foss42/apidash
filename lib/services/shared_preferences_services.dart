import 'package:apidash/dashbot/features/home/models/llm_provider.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

const String kSharedPrefSettingsKey = 'apidash-settings';
const String kSharedPrefSelectedProvider = 'dashbot-selected-provider';

late SharedPreferences _sharedPreferences;

Future<void> initSharedPreferences() async {
  _sharedPreferences = await SharedPreferences.getInstance();
}

Future<SettingsModel?> getSettingsFromSharedPrefs() async {
  var settingsStr = _sharedPreferences.getString(kSharedPrefSettingsKey);
  if (settingsStr != null) {
    var jsonSettings = kJsonDecoder.convert(settingsStr);
    var jsonMap = Map<String, Object?>.from(jsonSettings);
    var settingsModel = SettingsModel.fromJson(jsonMap);
    return settingsModel;
  } else {
    return null;
  }
}

Future<void> setSettingsToSharedPrefs(SettingsModel settingsModel) async {
  await _sharedPreferences.setString(
      kSharedPrefSettingsKey, settingsModel.toString());
}

Future<void> clearSharedPrefs() async {
  await _sharedPreferences.clear();
}

void setSelectedLlmProviderToSharedPrefs(LlmProvider provider) {
  _sharedPreferences.setString(
    kSharedPrefSelectedProvider,
    provider.toJson(),
  );
}

LlmProvider? getSelectedProviderFromSharedPrefs() {
  final provider = _sharedPreferences.getString(kSharedPrefSelectedProvider);
  if (provider != null) {
    return LlmProvider.fromJson(provider);
  }
  return null;
}
