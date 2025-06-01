import 'package:apidash/models/llm_models/all_models.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class LLMProviderPopupMenu extends StatelessWidget {
  const LLMProviderPopupMenu({
    super.key,
    required this.value,
    this.onChanged,
  });

  final String value;
  final void Function(String? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final double width = context.isCompactWindow ? 150 : 220;
    return ADPopupMenu<String>(
      value: value,
      values: availableModels.entries
          .map((e) => (e.key, e.value.$1.modelName.toUpperCase())),
      width: width,
      tooltip: "Select LLM Provider",
      onChanged: onChanged,
      isOutlined: true,
    );
  }
}
