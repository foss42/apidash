import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

@immutable
class SettingsModel {
  const SettingsModel(
      {this.isDark = false,
      this.size,
      this.defaultUriScheme = kDefaultUriScheme,
      this.saveResponses = true});

  final bool isDark;
  final Size? size;
  final String defaultUriScheme;
  final bool saveResponses;

  SettingsModel copyWith({
    bool? isDark,
    Size? size,
    String? defaultUriScheme,
    bool? saveResponses,
  }) {
    return SettingsModel(
      isDark: isDark ?? this.isDark,
      size: size ?? this.size,
      defaultUriScheme: defaultUriScheme ?? this.defaultUriScheme,
      saveResponses: saveResponses ?? this.saveResponses,
    );
  }

  factory SettingsModel.fromJson(Map<dynamic, dynamic> data) {
    final isDark = data["isDark"] as bool?;
    final width = data["width"] as double?;
    final height = data["height"] as double?;
    Size? size;
    if (width != null && height != null) {
      size = Size(width, height);
    }
    final defaultUriScheme = data["defaultUriScheme"] as String?;
    final saveResponses = data["saveResponses"] as bool?;

    const sm = SettingsModel();

    return sm.copyWith(
      isDark: isDark,
      size: size,
      defaultUriScheme: defaultUriScheme,
      saveResponses: saveResponses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isDark": isDark,
      "width": size?.width,
      "height": size?.height,
      "defaultUriScheme": defaultUriScheme,
      "saveResponses": saveResponses,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
