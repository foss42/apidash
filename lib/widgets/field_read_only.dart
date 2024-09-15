import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class ReadOnlyTextField extends StatelessWidget {
  const ReadOnlyTextField({
    super.key,
    this.initialValue,
    this.style,
    this.decoration,
  });

  final String? initialValue;
  final TextStyle? style;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: initialValue),
      style: style,
      decoration: decoration ??
          const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: kPv8,
          ),
    );
  }
}
