import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<String?> showColorPickerDialog(
  BuildContext context, {
  Color? initialColor,
}) async {
  Color selectedColor = initialColor ?? Colors.white;
  bool confirmed = false;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Pick a color'),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: selectedColor,
          onColorChanged: (color) {
            selectedColor = color;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            confirmed = true;
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );

  if (confirmed) {
    return '#${selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
  return null;
}