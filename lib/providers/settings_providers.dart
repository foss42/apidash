import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as p;
import '../models/models.dart';
import '../services/services.dart';
import '../consts.dart';

final codegenLanguageStateProvider = StateProvider<CodegenLanguage>(
  (ref) =>
      ref.watch(settingsProvider.select((value) => value.defaultCodeGenLang)),
);

final activeEnvironmentIdStateProvider = StateProvider<String?>(
  (ref) =>
      ref.watch(settingsProvider.select((value) => value.activeEnvironmentId)),
);

final StateNotifierProvider<ThemeStateNotifier, SettingsModel>
settingsProvider = StateNotifierProvider((ref) => ThemeStateNotifier());

class ThemeStateNotifier extends StateNotifier<SettingsModel> {
  ThemeStateNotifier({this.settingsModel}) : super(const SettingsModel()) {
    state = settingsModel ?? const SettingsModel();
    _backfillWorkspaceListIfNeeded();
  }
  final SettingsModel? settingsModel;

  void _backfillWorkspaceListIfNeeded() {
    final path = state.workspaceFolderPath;
    if (path == null || path.isEmpty || state.savedWorkspaces.isNotEmpty) {
      return;
    }
    Future.microtask(() async {
      await rememberWorkspace(path: path, name: p.basename(path));
    });
  }

  Future<void> update({
    bool? isDark,
    bool? alwaysShowCollectionPaneScrollbar,
    Size? size,
    Offset? offset,
    SupportedUriSchemes? defaultUriScheme,
    SupportedWsSchemes? defaultWsScheme,
    CodegenLanguage? defaultCodeGenLang,
    bool? saveResponses,
    bool? saveMediaResponsesAsFiles,
    bool? promptBeforeClosing,
    String? activeEnvironmentId,
    HistoryRetentionPeriod? historyRetentionPeriod,
    String? workspaceFolderPath,
    List<NamePathModel>? savedWorkspaces,
    bool? isSSLDisabled,
    bool? isDashBotEnabled,
    Map<String, Object?>? defaultAIModel,
    int? maxConnectionMessages,
  }) async {
    state = state.copyWith(
      isDark: isDark,
      alwaysShowCollectionPaneScrollbar: alwaysShowCollectionPaneScrollbar,
      size: size,
      offset: offset,
      defaultUriScheme: defaultUriScheme,
      defaultWsScheme: defaultWsScheme,
      defaultCodeGenLang: defaultCodeGenLang,
      saveResponses: saveResponses,
      saveMediaResponsesAsFiles: saveMediaResponsesAsFiles,
      promptBeforeClosing: promptBeforeClosing,
      activeEnvironmentId: activeEnvironmentId,
      historyRetentionPeriod: historyRetentionPeriod,
      workspaceFolderPath: workspaceFolderPath,
      savedWorkspaces: savedWorkspaces,
      isSSLDisabled: isSSLDisabled,
      isDashBotEnabled: isDashBotEnabled,
      defaultAIModel: defaultAIModel,
      maxConnectionMessages: maxConnectionMessages,
    );
    await setSettingsToSharedPrefs(state);
  }

  Future<void> rememberWorkspace({
    required String name,
    required String path,
  }) async {
    final normalized = p.normalize(path);
    final rest = state.savedWorkspaces
        .where((e) => p.normalize(e.path) != normalized)
        .toList();
    final list = [
      NamePathModel(name: name, path: normalized),
      ...rest,
    ].take(kMaxSavedWorkspaces).toList();
    await update(workspaceFolderPath: normalized, savedWorkspaces: list);
  }
}
