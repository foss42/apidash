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
    return ADDropdownButton<ImportFormat>(
      value: importFormat,
      values: ImportFormat.values.map((e) => (e, e.label)),
      onChanged: onChanged,
      iconSize: 16,
    );
  }
}
