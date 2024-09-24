import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class RawTextField extends StatelessWidget {
  const RawTextField({
    super.key,
    this.onChanged,
    this.controller,
    this.hintText,
    this.style,
    this.readOnly = false,
    this.scaleFactor = 1
  });
  final double scaleFactor;
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
      style: style?.copyWith(fontSize: 14*scaleFactor),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: hintText,
        contentPadding: kPv8*scaleFactor,
      ),
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
