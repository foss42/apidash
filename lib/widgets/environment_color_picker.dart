import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

/// Color picker dialog for selecting environment colors
class EnvironmentColorPicker extends StatelessWidget {
  final int? currentColor;
  final Function(int?) onColorSelected;

  const EnvironmentColorPicker({
    super.key,
    this.currentColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Environment Color'),
      content: SizedBox(
        width: 300,
        height: 300,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: kEnvironmentColors.length + 1, // +1 for "no color" option
          itemBuilder: (context, index) {
            if (index == 0) {
              // "No color" / Default option
              return _buildColorButton(
                context,
                null,
                currentColor == null,
              );
            }

            final color = kEnvironmentColors[index - 1];
            return _buildColorButton(
              context,
              color.value,
              currentColor == color.value,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildColorButton(
    BuildContext context,
    int? colorValue,
    bool isSelected,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        onColorSelected(colorValue);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorValue != null 
              ? Color(colorValue) 
              : (isDark ? Colors.grey[700] : Colors.grey[300]),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: colorValue != null 
                    ? _getContrastColor(Color(colorValue))
                    : (isDark ? Colors.white : Colors.black87),
              )
            : null,
      ),
    );
  }

  /// Get contrasting color for the check icon
  Color _getContrastColor(Color color) {
    // Calculate relative luminance
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
