import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';

class DropdownButtonHttpMethod extends StatelessWidget {
  const DropdownButtonHttpMethod({
    super.key,
    this.method,
    this.onChanged,
  });

  final HTTPVerb? method;
  final void Function(HTTPVerb? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ADDropdownButton<HTTPVerb>(
      value: method,
      values: HTTPVerb.values.map((e) => (e, e.name.toUpperCase())),
      onChanged: onChanged,
      dropdownMenuItemPadding:
          EdgeInsets.only(left: context.isMediumWindow ? 8 : 16),
      dropdownMenuItemtextStyle: (HTTPVerb v) => kCodeStyle.copyWith(
        fontWeight: FontWeight.bold,
        color: getAPIColor(
          APIType.rest,
          method: v,
          brightness: Theme.of(context).brightness,
        ),
      ),
    );
  }
}
