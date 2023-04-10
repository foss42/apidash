import 'package:flutter/material.dart' show Color, Colors;

class ThemeModel {
  bool? themeMode;
  Color primaryColor;

  ThemeModel({
    this.themeMode,
    this.primaryColor = Colors.blue,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    Color color;
    final colorResult = json["primaryColor"];
    if (colorResult == null) {
      color = Colors.blue;
    } else {
      final valueString = colorResult.split('(0x')[1].split(')')[0];
      color = Color(int.parse(valueString, radix: 16));
    }
    return ThemeModel(
      themeMode: json["themeMode"],
      primaryColor: color,
    );
  }

  Map<String, dynamic> toJson() => {
        "themeMode": themeMode,
        "primaryColor": primaryColor.toString(),
      };

  ThemeModel copyWith({
    bool? themeMode,
    Color? primaryColor,
  }) {
    return ThemeModel(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}
