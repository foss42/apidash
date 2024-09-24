import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class DropdownButtonCodegenLanguage extends StatelessWidget {
  const DropdownButtonCodegenLanguage({
    super.key,
    this.codegenLanguage,
    this.onChanged,
     this.scaleFactor=1,
  });

  final CodegenLanguage? codegenLanguage;
  final void Function(CodegenLanguage?)? onChanged;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final iconSize = 16 * scaleFactor;
    final textStyle = kCodeStyle.copyWith(
      fontSize: 14 * scaleFactor,
      color: Theme.of(context).colorScheme.primary,
    );

    return DropdownButton<CodegenLanguage>(
      isExpanded: true,
      focusColor: surfaceColor,
      value: codegenLanguage,
      icon: Icon(
        Icons.unfold_more_rounded,
        size: iconSize,
      ),
      elevation: 4,
      style: textStyle,
      underline: Container(
        height: 0,
      ),
      onChanged: onChanged,
      borderRadius: BorderRadius.circular(12 * scaleFactor),
      items: CodegenLanguage.values
          .map<DropdownMenuItem<CodegenLanguage>>((CodegenLanguage value) {
        return DropdownMenuItem<CodegenLanguage>(
          value: value,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5*scaleFactor),
            child: Text(
              value.label,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        );
      }).toList(),
    );
  }
}
