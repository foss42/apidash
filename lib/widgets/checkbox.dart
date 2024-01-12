import 'package:flutter/material.dart';

class CheckBox extends StatelessWidget {
  final String keyId;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final ColorScheme? colorScheme;
  const CheckBox({
    super.key,
    required this.keyId,
    required this.value,
    required this.onChanged,
    this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = this.colorScheme ?? Theme.of(context).colorScheme;
    return Checkbox(
        key: Key(keyId),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        side: BorderSide(
          color: colorScheme.surfaceVariant,
          width: 1.5,
        ),
        splashRadius: 0,
        value: value,
        onChanged: onChanged,
        checkColor: colorScheme.onPrimary,
        fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary;
            }
            return null;
          },
        ));
  }
}
