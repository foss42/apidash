import 'package:apidash/models/llm_models/all_models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';

class DropdownButtonAiMethod extends StatelessWidget {
  const DropdownButtonAiMethod({
    super.key,
    this.method,
    this.onChanged,
  });

  final String? method;
  final void Function(String? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ADDropdownButton<String>(
      value: method,
      values: availableModels.entries
          .map((e) => (e.key, e.value.$1.modelName.toUpperCase())),
      onChanged: onChanged,
      dropdownMenuItemPadding:
          EdgeInsets.only(left: context.isMediumWindow ? 8 : 16, right: 10),
      dropdownMenuItemtextStyle: (String v) => kCodeStyle.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
