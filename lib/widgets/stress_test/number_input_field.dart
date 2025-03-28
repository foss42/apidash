import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? helperText;
  final int min;
  final int max;
  final bool enabled;

  const NumberInputField({
    Key? key, 
    required this.controller,
    required this.labelText,
    this.helperText,
    required this.min,
    required this.max,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helperText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        helperStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      enabled: enabled,
      onChanged: (value) {
        final numValue = int.tryParse(value) ?? min;
        
        if (numValue < min) {
          controller.text = min.toString();
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        } else if (numValue > max) {
          controller.text = max.toString();
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        }
      },
    );
  }
}
