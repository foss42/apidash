import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/utils/color_utils.dart';

/// A simple color picker that displays a set of predefined colors and allows the user to select one
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    required this.onColorSelected,
  });

  final Color initialColor;
  final Function(Color) onColorSelected;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color selectedColor;

  // Predefined color palette with visually distinct colors
  final List<Color> colorPalette = [
    const Color(0xFFF44336), // Red
    const Color(0xFFE91E63), // Pink
    const Color(0xFF9C27B0), // Purple
    const Color(0xFF673AB7), // Deep Purple
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFF2196F3), // Blue
    const Color(0xFF03A9F4), // Light Blue
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF009688), // Teal
    const Color(0xFF4CAF50), // Green
    const Color(0xFF8BC34A), // Light Green
    const Color(0xFFCDDC39), // Lime
    const Color(0xFFFFEB3B), // Yellow
    const Color(0xFFFFC107), // Amber
    const Color(0xFFFF9800), // Orange
    const Color(0xFFFF5722), // Deep Orange
    const Color(0xFF795548), // Brown
    const Color(0xFF607D8B), // Blue Grey
  ];

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius12),
      child: Padding(
        padding: kP12,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            kVSpacer16,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...colorPalette.map((color) => _buildColorOption(color)),
              ],
            ),
            kVSpacer16,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                kHSpacer8,
                FilledButton(
                  onPressed: () {
                    widget.onColorSelected(selectedColor);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Select'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = selectedColor.value == color.value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              )
            : null,
      ),
    );
  }
}

/// A widget that displays the current color and allows the user to change it by opening a color picker dialog
class ColorPickerButton extends StatelessWidget {
  const ColorPickerButton({
    super.key,
    required this.color,
    required this.onColorChanged,
  });

  final Color color;
  final Function(Color) onColorChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ColorPickerDialog(
            initialColor: color,
            onColorSelected: onColorChanged,
          ),
        );
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.colorize,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
