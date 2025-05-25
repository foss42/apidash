import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class ADRawTextField extends StatefulWidget {
  const ADRawTextField({
    super.key,
    this.onChanged,
    this.controller,
    this.hintText,
    this.hintTextStyle,
    this.style,
    this.readOnly = false,
  });

  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? style;
  final bool readOnly;

  @override
  State<ADRawTextField> createState() => _ADRawTextFieldState();
}

class _ADRawTextFieldState extends State<ADRawTextField> {
  bool isFocused = false;
  @override
  void initState() {
    isFocused = false;
    super.initState();
  }

  void alterFocus(bool val) {
    setState(() {
      isFocused = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: TextField(
        onTap: () => alterFocus(true),
        readOnly: widget.readOnly,
        controller: widget.controller,
        onSubmitted: (value) => alterFocus(false),
        maxLines: isFocused ? null : 1,
        minLines: 1,
        onChanged: widget.onChanged,
        style: widget.style,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: widget.hintTextStyle,
          contentPadding: kPv8,
        ),
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
          alterFocus(false);
        },
      ),
    );
  }
}
