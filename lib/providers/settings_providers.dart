import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart' show SettingsModel;
import 'package:apidash/services/services.dart' show hiveHandler, HiveHandler;

final StateNotifierProvider<ThemeStateNotifier, SettingsModel>
    settingsProvider =
    StateNotifierProvider((ref) => ThemeStateNotifier(hiveHandler));

class ThemeStateNotifier extends StateNotifier<SettingsModel> {
  ThemeStateNotifier(this.hiveHandler) : super(const SettingsModel()) {
    state = SettingsModel.fromJson(hiveHandler.settings);
  }
  final HiveHandler hiveHandler;

  Future<void> update({
    bool? isDark,
    Size? size,
    String? defaultUriScheme,
    bool? saveResponses,
  }) async {
    state = state.copyWith(
      isDark: isDark,
      size: size,
      defaultUriScheme: defaultUriScheme,
      saveResponses: saveResponses,
    );
    await hiveHandler.saveSettings(state.toJson());
  }
}
