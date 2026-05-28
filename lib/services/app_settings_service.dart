import '../models/models.dart';
import 'storage/app_settings_store.dart';
import 'storage/recent_workspace_store.dart';

Future<SettingsModel?> loadAppSettings() async {
  final snapshot = await AppSettingsStore.instance.load();
  return snapshot.settings;
}

Future<void> saveAppSettings(SettingsModel settingsModel) async {
  await AppSettingsStore.instance.saveSettings(settingsModel);
  await writeRecentWorkspacePath(settingsModel.workspaceFolderPath);
}

Future<void> saveOnboardingStatus({required bool isOnboardingComplete}) async {
  await AppSettingsStore.instance.saveOnboarding(
    isOnboardingComplete: isOnboardingComplete,
  );
}

Future<bool> loadOnboardingStatus() async {
  final snapshot = await AppSettingsStore.instance.load();
  return snapshot.onboardingComplete;
}

Future<void> clearAppSettings() async {
  await AppSettingsStore.instance.clear();
}
