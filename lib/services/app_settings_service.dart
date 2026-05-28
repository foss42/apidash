import '../models/models.dart';
import 'shared_preferences_services.dart';

Future<SettingsModel?> loadAppSettings() => getSettingsFromSharedPrefs();

Future<void> saveAppSettings(SettingsModel settingsModel) =>
    setSettingsToSharedPrefs(settingsModel);

Future<void> saveOnboardingStatus({required bool isOnboardingComplete}) =>
    setOnboardingStatusToSharedPrefs(isOnboardingComplete: isOnboardingComplete);

Future<bool> loadOnboardingStatus() => getOnboardingStatusFromSharedPrefs();

Future<void> clearAppSettings() => clearSharedPrefs();
