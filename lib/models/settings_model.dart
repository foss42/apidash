import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/saved_workspace_entry.dart';

@immutable
class SettingsModel {
  const SettingsModel({
    this.isDark = false,
    this.alwaysShowCollectionPaneScrollbar = true,
    this.size,
    this.offset,
    this.defaultUriScheme = kDefaultUriScheme,
    this.defaultCodeGenLang = CodegenLanguage.curl,
    this.saveResponses = true,
    this.saveMediaResponsesAsFiles = false,
    this.promptBeforeClosing = true,
    this.activeEnvironmentId,
    this.historyRetentionPeriod = HistoryRetentionPeriod.oneWeek,
    this.workspaceFolderPath,
    this.savedWorkspaces = const [],
    this.isSSLDisabled = false,
    this.isDashBotEnabled = true,
    this.defaultAIModel,
  });

  final bool isDark;
  final bool alwaysShowCollectionPaneScrollbar;
  final Size? size;
  final Offset? offset;
  final SupportedUriSchemes defaultUriScheme;
  final CodegenLanguage defaultCodeGenLang;
  final bool saveResponses;
  final bool saveMediaResponsesAsFiles;
  final bool promptBeforeClosing;
  final String? activeEnvironmentId;
  final HistoryRetentionPeriod historyRetentionPeriod;
  final String? workspaceFolderPath;
  final List<SavedWorkspaceEntry> savedWorkspaces;
  final bool isSSLDisabled;
  final bool isDashBotEnabled;
  final Map<String, Object?>? defaultAIModel;

  SettingsModel copyWith({
    bool? isDark,
    bool? alwaysShowCollectionPaneScrollbar,
    Size? size,
    Offset? offset,
    SupportedUriSchemes? defaultUriScheme,
    CodegenLanguage? defaultCodeGenLang,
    bool? saveResponses,
    bool? saveMediaResponsesAsFiles,
    bool? promptBeforeClosing,
    String? activeEnvironmentId,
    HistoryRetentionPeriod? historyRetentionPeriod,
    String? workspaceFolderPath,
    List<SavedWorkspaceEntry>? savedWorkspaces,
    bool? isSSLDisabled,
    bool? isDashBotEnabled,
    Map<String, Object?>? defaultAIModel,
  }) {
    return SettingsModel(
      isDark: isDark ?? this.isDark,
      alwaysShowCollectionPaneScrollbar: alwaysShowCollectionPaneScrollbar ??
          this.alwaysShowCollectionPaneScrollbar,
      size: size ?? this.size,
      defaultUriScheme: defaultUriScheme ?? this.defaultUriScheme,
      defaultCodeGenLang: defaultCodeGenLang ?? this.defaultCodeGenLang,
      offset: offset ?? this.offset,
      saveResponses: saveResponses ?? this.saveResponses,
      saveMediaResponsesAsFiles:
          saveMediaResponsesAsFiles ?? this.saveMediaResponsesAsFiles,
      promptBeforeClosing: promptBeforeClosing ?? this.promptBeforeClosing,
      activeEnvironmentId: activeEnvironmentId ?? this.activeEnvironmentId,
      historyRetentionPeriod:
          historyRetentionPeriod ?? this.historyRetentionPeriod,
      workspaceFolderPath: workspaceFolderPath ?? this.workspaceFolderPath,
      savedWorkspaces: savedWorkspaces ?? this.savedWorkspaces,
      isSSLDisabled: isSSLDisabled ?? this.isSSLDisabled,
      isDashBotEnabled: isDashBotEnabled ?? this.isDashBotEnabled,
      defaultAIModel: defaultAIModel ?? this.defaultAIModel,
    );
  }

  SettingsModel copyWithPath({
    String? workspaceFolderPath,
  }) {
    return SettingsModel(
      isDark: isDark,
      alwaysShowCollectionPaneScrollbar: alwaysShowCollectionPaneScrollbar,
      size: size,
      defaultUriScheme: defaultUriScheme,
      defaultCodeGenLang: defaultCodeGenLang,
      offset: offset,
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
    );
  }

  factory SettingsModel.fromJson(Map<dynamic, dynamic> data) {
    final isDark = data["isDark"] as bool?;
    final alwaysShowCollectionPaneScrollbar =
        data["alwaysShowCollectionPaneScrollbar"] as bool?;
    final width = data["width"] as double?;
    final height = data["height"] as double?;
    final dx = data["dx"] as double?;
    final dy = data["dy"] as double?;
    Size? size;
    if (width != null && height != null) {
      size = Size(width, height);
    }
    Offset? offset;
    if (dx != null && dy != null) {
      offset = Offset(dx, dy);
    }
    final defaultUriSchemeStr = data["defaultUriScheme"] as String?;
    SupportedUriSchemes? defaultUriScheme;
    if (defaultUriSchemeStr != null) {
      try {
        defaultUriScheme =
            SupportedUriSchemes.values.byName(defaultUriSchemeStr);
      } catch (e) {
        // pass
      }
    }
    final defaultCodeGenLangStr = data["defaultCodeGenLang"] as String?;
    CodegenLanguage? defaultCodeGenLang;
    if (defaultCodeGenLangStr != null) {
      try {
        defaultCodeGenLang =
            CodegenLanguage.values.byName(defaultCodeGenLangStr);
      } catch (e) {
        // pass
      }
    }
    final saveResponses = data["saveResponses"] as bool?;
    final saveMediaResponsesAsFiles =
        data["saveMediaResponsesAsFiles"] as bool?;
    final promptBeforeClosing = data["promptBeforeClosing"] as bool?;
    final activeEnvironmentId = data["activeEnvironmentId"] as String?;
    final historyRetentionPeriodStr = data["historyRetentionPeriod"] as String?;
    HistoryRetentionPeriod? historyRetentionPeriod;
    if (historyRetentionPeriodStr != null) {
      try {
        historyRetentionPeriod =
            HistoryRetentionPeriod.values.byName(historyRetentionPeriodStr);
      } catch (e) {
        // pass
      }
    }
    final workspaceFolderPath = data["workspaceFolderPath"] as String?;
    final savedWorkspaces = <SavedWorkspaceEntry>[];
    final rawWorkspaces = data['savedWorkspaces'];
    if (rawWorkspaces is List) {
      for (final item in rawWorkspaces) {
        if (item is Map) {
          savedWorkspaces.add(
            SavedWorkspaceEntry.fromJson(Map<String, Object?>.from(item)),
          );
        }
      }
    }
    final isSSLDisabled = data["isSSLDisabled"] as bool?;
    final isDashBotEnabled = data["isDashBotEnabled"] as bool?;
    final defaultAIModel = data["defaultAIModel"] == null
        ? null
        : Map<String, Object?>.from(data["defaultAIModel"]);
    const sm = SettingsModel();

    return sm.copyWith(
      isDark: isDark,
      alwaysShowCollectionPaneScrollbar: alwaysShowCollectionPaneScrollbar,
      size: size,
      offset: offset,
      defaultUriScheme: defaultUriScheme,
      defaultCodeGenLang: defaultCodeGenLang,
      saveResponses: saveResponses,
      saveMediaResponsesAsFiles: saveMediaResponsesAsFiles,
      promptBeforeClosing: promptBeforeClosing,
      activeEnvironmentId: activeEnvironmentId,
      historyRetentionPeriod:
          historyRetentionPeriod ?? HistoryRetentionPeriod.oneWeek,
      workspaceFolderPath: workspaceFolderPath,
      savedWorkspaces: savedWorkspaces,
      isSSLDisabled: isSSLDisabled,
      isDashBotEnabled: isDashBotEnabled,
      defaultAIModel: defaultAIModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isDark": isDark,
      "alwaysShowCollectionPaneScrollbar": alwaysShowCollectionPaneScrollbar,
      "width": size?.width,
      "height": size?.height,
      "dx": offset?.dx,
      "dy": offset?.dy,
      "defaultUriScheme": defaultUriScheme.name,
      "defaultCodeGenLang": defaultCodeGenLang.name,
      "saveResponses": saveResponses,
      "saveMediaResponsesAsFiles": saveMediaResponsesAsFiles,
      "promptBeforeClosing": promptBeforeClosing,
      "activeEnvironmentId": activeEnvironmentId,
      "historyRetentionPeriod": historyRetentionPeriod.name,
      "workspaceFolderPath": workspaceFolderPath,
      "savedWorkspaces": savedWorkspaces.map((e) => e.toJson()).toList(),
      "isSSLDisabled": isSSLDisabled,
      "isDashBotEnabled": isDashBotEnabled,
      "defaultAIModel": defaultAIModel,
    };
  }

  @override
  String toString() {
    return kJsonEncoder.convert(toJson());
  }

  @override
  bool operator ==(Object other) {
    return other is SettingsModel &&
        other.runtimeType == runtimeType &&
        other.isDark == isDark &&
        other.alwaysShowCollectionPaneScrollbar ==
            alwaysShowCollectionPaneScrollbar &&
        other.size == size &&
        other.offset == offset &&
        other.defaultUriScheme == defaultUriScheme &&
        other.defaultCodeGenLang == defaultCodeGenLang &&
        other.saveResponses == saveResponses &&
        other.saveMediaResponsesAsFiles == saveMediaResponsesAsFiles &&
        other.promptBeforeClosing == promptBeforeClosing &&
        other.activeEnvironmentId == activeEnvironmentId &&
        other.historyRetentionPeriod == historyRetentionPeriod &&
        other.workspaceFolderPath == workspaceFolderPath &&
        listEquals(other.savedWorkspaces, savedWorkspaces) &&
        other.isSSLDisabled == isSSLDisabled &&
        other.isDashBotEnabled == isDashBotEnabled &&
        mapEquals(other.defaultAIModel, defaultAIModel);
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      isDark,
      alwaysShowCollectionPaneScrollbar,
      size,
      offset,
      defaultUriScheme,
      defaultCodeGenLang,
      saveResponses,
      saveMediaResponsesAsFiles,
      promptBeforeClosing,
      activeEnvironmentId,
      historyRetentionPeriod,
      workspaceFolderPath,
      Object.hashAll(savedWorkspaces),
      isSSLDisabled,
      isDashBotEnabled,
      defaultAIModel,
    );
  }
}
