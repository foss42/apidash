import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class RawTextField extends StatelessWidget {
  const RawTextField({
    super.key,
    this.onChanged,
    this.controller,
    this.hintText,
    this.style,
    this.readOnly = false,
  });

  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? style;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      onChanged: onChanged,
      style: style,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: hintText,
        contentPadding: kPv8,
      ),
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
