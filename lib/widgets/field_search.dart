import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = 'Search',
    this.height = 36,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    final theme = Theme.of(context);
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.surfaceContainerHighest,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 18*ds.scaleFactor),
          SizedBox(width: 6*ds.scaleFactor),
          Expanded(
            child: ADRawTextField(
              controller: controller,
              hintText: hintText,
              onChanged: onChanged,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
