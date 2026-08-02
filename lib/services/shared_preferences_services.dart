import 'package:apidash_core/apidash_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'secure_storage.dart';

const String kSharedPrefSettingsKey = 'apidash-settings';
const String kSharedPrefOnboardingKey = 'apidash-onboarding-status';

Future<SettingsModel?> getSettingsFromSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  var settingsStr = prefs.getString(kSharedPrefSettingsKey);
  if (settingsStr != null) {
    var jsonSettings = kJsonDecoder.convert(settingsStr);
    var jsonMap = Map<String, Object?>.from(jsonSettings);
    var settingsModel = SettingsModel.fromJson(jsonMap);
    final defaultAi = settingsModel.defaultAIModel;
    if (defaultAi != null) {
      final apiKey = await aiRequestSecretsStorage.readDefaultApiKey();
      if (apiKey != null && apiKey.isNotEmpty) {
        settingsModel = settingsModel.copyWith(
          defaultAIModel: {...defaultAi, 'apiKey': apiKey},
        );
      }
    }
    return settingsModel;
  } else {
    return null;
  }
}

Future<void> setSettingsToSharedPrefs(SettingsModel settingsModel) async {
  final prefs = await SharedPreferences.getInstance();
  var model = settingsModel;
  final defaultAi = model.defaultAIModel;
  if (defaultAi != null) {
    final apiKey = defaultAi['apiKey'] as String?;
    if (apiKey != null && apiKey.isNotEmpty) {
      await aiRequestSecretsStorage.writeDefaultApiKey(apiKey);
    } else {
      await aiRequestSecretsStorage.deleteDefaultApiKey();
    }
    model = model.copyWith(
      defaultAIModel: AiRequestSecretsStorage.stripApiKeyFromDefaultAiModel(
        defaultAi,
      ),
    );
  }
  await prefs.setString(kSharedPrefSettingsKey, model.toString());
}

Future<void> setOnboardingStatusToSharedPrefs({
  required bool isOnboardingComplete,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(kSharedPrefOnboardingKey, isOnboardingComplete);
}

Future<bool> getOnboardingStatusFromSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final onboardingStatus = prefs.getBool(kSharedPrefOnboardingKey) ?? false;
  return onboardingStatus;
}

Future<void> clearSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
