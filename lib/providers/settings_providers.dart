import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../consts.dart';

final codegenLanguageStateProvider = StateProvider<CodegenLanguage>((ref) =>
    ref.watch(settingsProvider.select((value) => value.defaultCodeGenLang)));

final activeEnvironmentIdStateProvider = StateProvider<String?>((ref) =>
    ref.watch(settingsProvider.select((value) => value.activeEnvironmentId)));

final StateNotifierProvider<ThemeStateNotifier, SettingsModel>
    settingsProvider = StateNotifierProvider((ref) => ThemeStateNotifier());

class ThemeStateNotifier extends StateNotifier<SettingsModel> {
  ThemeStateNotifier({this.settingsModel}) : super(const SettingsModel()) {
    state = settingsModel ?? const SettingsModel();
  }
  final SettingsModel? settingsModel;

  Future<void> update({
    bool? isDark,
    bool? alwaysShowCollectionPaneScrollbar,
    Size? size,
    Offset? offset,
    SupportedUriSchemes? defaultUriScheme,
    CodegenLanguage? defaultCodeGenLang,
    bool? saveResponses,
    bool? promptBeforeClosing,
    String? activeEnvironmentId,
    HistoryRetentionPeriod? historyRetentionPeriod,
    String? workspaceFolderPath,
    bool? isSSLDisabled,
    ProxySettings? proxySettings,
  }) async {
    state = state.copyWith(
      isDark: isDark ?? state.isDark,
      alwaysShowCollectionPaneScrollbar: alwaysShowCollectionPaneScrollbar ?? state.alwaysShowCollectionPaneScrollbar,
      size: size ?? state.size,
      offset: offset ?? state.offset,
      defaultUriScheme: defaultUriScheme ?? state.defaultUriScheme,
      defaultCodeGenLang: defaultCodeGenLang ?? state.defaultCodeGenLang,
      saveResponses: saveResponses ?? state.saveResponses,
      promptBeforeClosing: promptBeforeClosing ?? state.promptBeforeClosing,
      activeEnvironmentId: activeEnvironmentId ?? state.activeEnvironmentId,
      historyRetentionPeriod: historyRetentionPeriod ?? state.historyRetentionPeriod,
      workspaceFolderPath: workspaceFolderPath ?? state.workspaceFolderPath,
      isSSLDisabled: isSSLDisabled ?? state.isSSLDisabled,
      proxySettings: proxySettings ?? state.proxySettings,
    );
    await setSettingsToSharedPrefs(state);
  }
}
