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
    return ADDropdownButton<CodegenLanguage>(
      value: codegenLanguage,
      values: CodegenLanguage.values.map((e) => (e, e.label)),
      onChanged: onChanged,
      iconSize: 16,
      isExpanded: true,
    );
  }
}
