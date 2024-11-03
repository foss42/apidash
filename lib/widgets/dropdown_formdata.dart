import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class DropdownButtonFormData extends StatelessWidget {
  const DropdownButtonFormData({
    super.key,
    this.formDataType,
    this.onChanged,
  });

  final FormDataType? formDataType;
  final void Function(FormDataType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<FormDataType>(
      dropdownColor: surfaceColor,
      focusColor: surfaceColor,
      value: formDataType,
      icon: const Icon(
        Icons.unfold_more_rounded,
        size: 16,
      ),
      elevation: 4,
      style: kCodeStyle.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
      underline: const IgnorePointer(),
      onChanged: onChanged,
      borderRadius: kBorderRadius12,
      items: FormDataType.values
          .map<DropdownMenuItem<FormDataType>>((FormDataType value) {
        return DropdownMenuItem<FormDataType>(
          value: value,
          child: Padding(
            padding: kPs8,
            child: Text(
              value.name,
              style: kTextStyleButton,
            ),
          ),
        );
      }).toList(),
    );
  }
}
