import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class CodegenPopupMenu extends StatelessWidget {
  const CodegenPopupMenu({
    super.key,
    required this.value,
    this.onChanged,
  });

  final CodegenLanguage value;
  final void Function(CodegenLanguage? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final double width = context.isCompactWindow ? 150 : 220;
    return ADPopupMenu<CodegenLanguage>(
      value: value.label,
      values: CodegenLanguage.values.map((e) => (e, e.label)),
      width: width,
      tooltip: "Select Code Generation Language",
      onChanged: onChanged,
      isOutlined: true,
    );
  }
}
