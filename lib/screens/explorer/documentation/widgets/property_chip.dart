import 'package:flutter/material.dart';

class PropertyChip extends StatelessWidget {
  final String label;

  const PropertyChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}