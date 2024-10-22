import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class DropdownButtonImportFormat extends StatelessWidget {
  const DropdownButtonImportFormat({
    super.key,
    required this.importFormat,
    this.onChanged,
  });

  final ImportFormat importFormat;
  final void Function(ImportFormat?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<ImportFormat>(
      isExpanded: false,
      focusColor: surfaceColor,
      value: importFormat,
      icon: const Icon(
        Icons.unfold_more_rounded,
        size: 16,
      ),
      elevation: 4,
      style: kCodeStyle.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
      underline: Container(
        height: 0,
      ),
      onChanged: onChanged,
      borderRadius: kBorderRadius12,
      items: ImportFormat.values
          .map<DropdownMenuItem<ImportFormat>>((ImportFormat value) {
        return DropdownMenuItem<ImportFormat>(
          value: value,
          child: Padding(
            padding: kPs8,
            child: Text(
              value.label,
              style: kTextStyleButton,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        );
      }).toList(),
    );
  }
}
