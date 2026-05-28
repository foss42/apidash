import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../../consts.dart';
import '../../models/models.dart';
import 'atomic_file_io.dart';
import 'workspace_storage.dart' show workspaceStorage;

class AppSettingsSnapshot {
  const AppSettingsSnapshot({
    this.settings,
    this.onboardingComplete = false,
  });

  final SettingsModel? settings;
  final bool onboardingComplete;
}

/// Loads/saves `<workspace>/settings.json` (workspace must be open).
class AppSettingsStore {
  AppSettingsStore._();

  static final AppSettingsStore instance = AppSettingsStore._();

  Future<AppSettingsSnapshot> load() async {
    if (!workspaceStorage.isInitialized) {
      return const AppSettingsSnapshot();
    }
    final filePath = p.join(
      workspaceStorage.workspaceRootPath,
      kAppSettingsFileName,
    );
    if (!File(filePath).existsSync()) {
      return const AppSettingsSnapshot();
    }

    try {
      final json = await readJsonFile(filePath);
      if (json == null) {
        return const AppSettingsSnapshot();
      }
      return _snapshotFromJson(json);
    } catch (e, st) {
      debugPrint('AppSettingsStore.load failed: $e\n$st');
      return const AppSettingsSnapshot();
    }
  }

  Future<void> saveSettings(SettingsModel settings) async {
    if (!workspaceStorage.isInitialized) {
      debugPrint('AppSettingsStore.saveSettings: workspace not open');
      return;
    }
    final filePath = p.join(
      workspaceStorage.workspaceRootPath,
      kAppSettingsFileName,
    );
    final json = Map<String, Object?>.from(settings.toJson());
    json[kAppSettingsVersionKey] = kAppSettingsVersion;
    await writeJsonAtomic(filePath, json);
  }

  Future<void> saveOnboarding({required bool isOnboardingComplete}) async {
    if (!workspaceStorage.isInitialized) {
      return;
    }
    final snapshot = await load();
    final settings = snapshot.settings ?? const SettingsModel();
    final filePath = p.join(
      workspaceStorage.workspaceRootPath,
      kAppSettingsFileName,
    );
    final json = Map<String, Object?>.from(settings.toJson());
    json[kAppSettingsVersionKey] = kAppSettingsVersion;
    json[kAppSettingsOnboardingCompleteKey] = isOnboardingComplete;
    await writeJsonAtomic(filePath, json);
  }

  Future<void> clear() async {
    if (!workspaceStorage.isInitialized) {
      return;
    }
    final file = File(
      p.join(workspaceStorage.workspaceRootPath, kAppSettingsFileName),
    );
    if (await file.exists()) {
      await file.delete();
    }
  }

  AppSettingsSnapshot _snapshotFromJson(Map<String, Object?> json) {
    final onboardingComplete =
        json[kAppSettingsOnboardingCompleteKey] as bool? ?? false;
    final settingsJson = Map<String, Object?>.from(json)
      ..remove(kAppSettingsVersionKey)
      ..remove(kAppSettingsOnboardingCompleteKey);
    final settings = SettingsModel.fromJson(settingsJson);
    return AppSettingsSnapshot(
      settings: settings,
      onboardingComplete: onboardingComplete,
    );
  }
}
