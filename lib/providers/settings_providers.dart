import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart' show SettingsModel;
import '../services/services.dart' show hiveHandler, HiveHandler;
import '../consts.dart';

final codegenLanguageStateProvider = StateProvider<CodegenLanguage>((ref) =>
    ref.watch(settingsProvider.select((value) => value.defaultCodeGenLang)));

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
    bool? alwaysShowCollectionPaneScrollbar,
    Size? size,
    Offset? offset,
    String? defaultUriScheme,
    CodegenLanguage? defaultCodeGenLang,
    bool? saveResponses,
    bool? promptBeforeClosing,
  }) async {
    state = state.copyWith(
      isDark: isDark,
      alwaysShowCollectionPaneScrollbar: alwaysShowCollectionPaneScrollbar,
      size: size,
      offset: offset,
      defaultUriScheme: defaultUriScheme,
      defaultCodeGenLang: defaultCodeGenLang,
      saveResponses: saveResponses,
      promptBeforeClosing: promptBeforeClosing,
    );
    await hiveHandler.saveSettings(state.toJson());
  }
}
