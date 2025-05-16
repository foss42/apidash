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

  final AIVerb? method;
  final void Function(AIVerb? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ADDropdownButton<AIVerb>(
      value: method,
      values: AIVerb.values.map((e) => (e, e.dispName.toUpperCase())),
      onChanged: onChanged,
      dropdownMenuItemPadding:
          EdgeInsets.only(left: context.isMediumWindow ? 8 : 16, right: 10),
      dropdownMenuItemtextStyle: (AIVerb v) => kCodeStyle.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
