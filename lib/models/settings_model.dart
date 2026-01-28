import 'package:apidash_core/apidash_core.dart';
import 'package:better_networking/models/proxy_settings_model.dart';
import 'package:flutter/foundation.dart';
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
    this.defaultAIModel,
    this.proxyUriPrefix,
    this.networkProxy,
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
  final Map<String, Object?>? defaultAIModel;
  final String? proxyUriPrefix;
  final ProxySettings? networkProxy;

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
    Map<String, Object?>? defaultAIModel,
    String? proxyUriPrefix,
    ProxySettings? networkProxy,
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
      defaultAIModel: defaultAIModel ?? this.defaultAIModel,
      proxyUriPrefix: proxyUriPrefix ?? this.proxyUriPrefix,
      networkProxy: networkProxy ?? this.networkProxy,
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
    final defaultAIModel = data["defaultAIModel"] == null
        ? null
        : Map<String, Object?>.from(data["defaultAIModel"]);
    final proxyUriPrefix = data["proxyUriPrefix"] as String?;
    final networkProxy = data["networkProxy"] == null
        ? null
        : ProxySettings.fromJson(Map<String, dynamic>.from(data["networkProxy"]));
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
      defaultAIModel: defaultAIModel,
      proxyUriPrefix: proxyUriPrefix,
      networkProxy: networkProxy,
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
      "defaultAIModel": defaultAIModel,
      "proxyUriPrefix": proxyUriPrefix,
      "networkProxy": networkProxy?.toJson(),
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
        mapEquals(other.defaultAIModel, defaultAIModel) &&
        other.proxyUriPrefix == proxyUriPrefix &&
        other.networkProxy == networkProxy;
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
      defaultAIModel,
      proxyUriPrefix,
      networkProxy,
    );
  }
}
