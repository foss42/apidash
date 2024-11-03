import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class DropdownButtonCodegenLanguage extends StatelessWidget {
  const DropdownButtonCodegenLanguage({
    super.key,
    this.codegenLanguage,
    this.onChanged,
  });

  final CodegenLanguage? codegenLanguage;
  final void Function(CodegenLanguage?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<CodegenLanguage>(
      isExpanded: true,
      focusColor: surfaceColor,
      value: codegenLanguage,
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
      items: CodegenLanguage.values
          .map<DropdownMenuItem<CodegenLanguage>>((CodegenLanguage value) {
        return DropdownMenuItem<CodegenLanguage>(
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
