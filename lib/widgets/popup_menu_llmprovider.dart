import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class LLMProviderPopupMenu extends StatelessWidget {
  const LLMProviderPopupMenu({
    super.key,
    required this.value,
    this.onChanged,
  });

  final LLMProvider value;
  final void Function(LLMProvider? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final double width = context.isCompactWindow ? 150 : 220;
    return ADPopupMenu<LLMProvider>(
      value: value.label,
      values: LLMProvider.values.map((e) => (e, e.label)),
      width: width,
      tooltip: "Select LLM Provider",
      onChanged: onChanged,
      isOutlined: true,
    );
  }
}
