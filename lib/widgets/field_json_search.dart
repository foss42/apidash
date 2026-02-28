import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';

class JsonSearchField extends StatelessWidget {
  const JsonSearchField({super.key, this.onChanged, this.controller});

  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return ADRawTextField(
      controller: controller,
      onChanged: onChanged,
      style: kCodeStyle.copyWith(
        fontSize: Theme.of(context).textTheme.bodySmall?.fontSize?? 12 * ds.scaleFactor,
      ),
      hintText: 'Search..',
      hintTextStyle: kCodeStyle.copyWith(
        fontSize: Theme.of(context).textTheme.bodySmall?.fontSize?? 12 * ds.scaleFactor,
      ),
    );
  }
}
