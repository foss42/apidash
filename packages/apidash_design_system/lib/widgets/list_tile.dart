import 'package:flutter/material.dart';
import '../tokens/colors.dart';

enum ListTileType { switchOnOff, checkbox, button }

class ADListTile extends StatelessWidget {
  const ADListTile({
    super.key,
    required this.type,
    this.hoverColor = kColorTransparent,
    required this.title,
    this.subtitle,
    this.value,
    this.onChanged,
  });

  final ListTileType type;
  final Color hoverColor;
  final String title;
  final String? subtitle;
  // For Switch and checkbox tiles
  final bool? value;
  // For Switch and checkbox tiles
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final subtitleWidget = subtitle == null ? null : Text(subtitle!);
    return switch (type) {
      ListTileType.switchOnOff => SwitchListTile(
          hoverColor: hoverColor,
          title: Text(title),
          subtitle: subtitleWidget,
          value: value ?? false,
          onChanged: onChanged,
        ),
      ListTileType.checkbox => CheckboxListTile(
          hoverColor: hoverColor,
          title: Text(title),
          subtitle: subtitleWidget,
          value: value ?? false,
          onChanged: onChanged,
        ),
      ListTileType.button => ListTile(
          hoverColor: hoverColor,
          title: Text(title),
          subtitle: subtitleWidget,
          onTap: onChanged == null ? null : () => onChanged?.call(value),
        ),
    };
  }
}
