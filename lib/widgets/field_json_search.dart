import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'field_raw.dart';

class JsonSearchField extends StatelessWidget {
  const JsonSearchField({super.key, this.onChanged, this.controller});

  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return RawTextField(
      controller: controller,
      onChanged: onChanged,
      style: kCodeStyle,
      hintText: 'Search..',
    );
  }
}
