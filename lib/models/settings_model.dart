import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

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
    this.promptBeforeClosing = true,
    this.activeEnvironmentId,
    this.historyRetentionPeriod = HistoryRetentionPeriod.oneWeek,
    this.workspaceFolderPath,
    this.isSSLDisabled = false,
    this.isDashBotEnabled = true,
    this.defaultLLMProvider = 'llama3_local',
    this.defaultLLMProviderCredentials = '',
  });

  final bool isDark;
  final bool alwaysShowCollectionPaneScrollbar;
  final Size? size;
  final Offset? offset;
  final SupportedUriSchemes defaultUriScheme;
  final CodegenLanguage defaultCodeGenLang;
  final bool saveResponses;
  final bool promptBeforeClosing;
  final String? activeEnvironmentId;
  final HistoryRetentionPeriod historyRetentionPeriod;
  final String? workspaceFolderPath;
  final bool isSSLDisabled;
  final bool isDashBotEnabled;
  final String defaultLLMProvider;
  final String defaultLLMProviderCredentials;

  SettingsModel copyWith({
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
    bool? isDashBotEnabled,
    String? defaultLLMProvider,
    String? defaultLLMProviderCredentials,
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
      promptBeforeClosing: promptBeforeClosing ?? this.promptBeforeClosing,
      activeEnvironmentId: activeEnvironmentId ?? this.activeEnvironmentId,
      historyRetentionPeriod:
          historyRetentionPeriod ?? this.historyRetentionPeriod,
      workspaceFolderPath: workspaceFolderPath ?? this.workspaceFolderPath,
      isSSLDisabled: isSSLDisabled ?? this.isSSLDisabled,
      isDashBotEnabled: isDashBotEnabled ?? this.isDashBotEnabled,
      defaultLLMProvider: defaultLLMProvider ?? this.defaultLLMProvider,
      defaultLLMProviderCredentials:
          defaultLLMProviderCredentials ?? this.defaultLLMProviderCredentials,
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
      promptBeforeClosing: promptBeforeClosing,
      activeEnvironmentId: activeEnvironmentId,
      historyRetentionPeriod: historyRetentionPeriod,
      workspaceFolderPath: workspaceFolderPath,
      isSSLDisabled: isSSLDisabled,
      isDashBotEnabled: isDashBotEnabled,
      defaultLLMProvider: defaultLLMProvider,
      defaultLLMProviderCredentials: defaultLLMProviderCredentials,
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

    final defaultLLMProvider = data["defaultLLMProvider"] as String?;

    final defaultLLMProviderCredentialsStr =
        data['defaultLLMProviderCredentials'] as String?;
    String? defaultLLMProviderCredentials;
    if (defaultLLMProviderCredentialsStr != null) {
      try {
        defaultLLMProviderCredentials = defaultLLMProviderCredentialsStr;
      } catch (e) {
        // pass
      }
    }

    final saveResponses = data["saveResponses"] as bool?;
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
    final isSSLDisabled = data["isSSLDisabled"] as bool?;
    final isDashBotEnabled = data["isDashBotEnabled"] as bool?;

    const sm = SettingsModel();

    return sm.copyWith(
      isDark: isDark,
      alwaysShowCollectionPaneScrollbar: alwaysShowCollectionPaneScrollbar,
      size: size,
      offset: offset,
      defaultUriScheme: defaultUriScheme,
      defaultCodeGenLang: defaultCodeGenLang,
      saveResponses: saveResponses,
      promptBeforeClosing: promptBeforeClosing,
      activeEnvironmentId: activeEnvironmentId,
      historyRetentionPeriod:
          historyRetentionPeriod ?? HistoryRetentionPeriod.oneWeek,
      workspaceFolderPath: workspaceFolderPath,
      isSSLDisabled: isSSLDisabled,
      isDashBotEnabled: isDashBotEnabled,
      defaultLLMProvider: defaultLLMProvider,
      defaultLLMProviderCredentials: defaultLLMProviderCredentials,
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
      "promptBeforeClosing": promptBeforeClosing,
      "activeEnvironmentId": activeEnvironmentId,
      "historyRetentionPeriod": historyRetentionPeriod.name,
      "workspaceFolderPath": workspaceFolderPath,
      "isSSLDisabled": isSSLDisabled,
      "isDashBotEnabled": isDashBotEnabled,
      "defaultLLMProvider": defaultLLMProvider,
      "defaultLLMProviderCredentials": defaultLLMProviderCredentials,
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
        other.promptBeforeClosing == promptBeforeClosing &&
        other.activeEnvironmentId == activeEnvironmentId &&
        other.historyRetentionPeriod == historyRetentionPeriod &&
        other.workspaceFolderPath == workspaceFolderPath &&
        other.isSSLDisabled == isSSLDisabled &&
        other.isDashBotEnabled == isDashBotEnabled &&
        other.defaultLLMProvider == defaultLLMProvider &&
        other.defaultLLMProviderCredentials == defaultLLMProviderCredentials;
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
      promptBeforeClosing,
      activeEnvironmentId,
      historyRetentionPeriod,
      workspaceFolderPath,
      isSSLDisabled,
      isDashBotEnabled,
      defaultLLMProvider,
      defaultLLMProviderCredentials,
    );
  }
}
