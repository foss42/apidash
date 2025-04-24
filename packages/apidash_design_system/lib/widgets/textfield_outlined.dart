import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import 'decoration_input_textfield.dart';

class ADOutlinedTextField extends StatefulWidget {
  const ADOutlinedTextField({
    super.key,
    this.keyId,
    this.controller,
    this.readOnly = false,
    this.enabled,
    this.maxLines = 1,
    this.expands = false,
    this.initialValue,
    this.textStyle,
    this.textColor,
    this.textFontSize,
    this.hintText,
    this.hintTextStyle,
    this.hintTextColor,
    this.hintTextFontSize,
    this.contentPadding,
    this.fillColor,
    this.focussedBorderColor,
    this.enabledBorderColor,
    this.isDense,
    this.onChanged,
    this.colorScheme,
  });

  final String? keyId;
  final TextEditingController? controller;
  final bool readOnly;
  final bool? enabled;
  final int? maxLines;
  final bool expands;
  final bool? isDense;
  final String? initialValue;
  final TextStyle? textStyle;
  final double? textFontSize;
  final Color? textColor;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final double? hintTextFontSize;
  final Color? hintTextColor;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? focussedBorderColor;
  final Color? enabledBorderColor;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;

  @override
  State<ADOutlinedTextField> createState() => _ADOutlinedTextFieldState();
}

class _ADOutlinedTextFieldState extends State<ADOutlinedTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var clrScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    return TextFormField(
      key: widget.keyId != null ? Key(widget.keyId!) : null,
      controller: widget.controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: _isFocused ? null : 1, // Multi-line when focused, single-line otherwise
      keyboardType: TextInputType.multiline, // Support newlines
      expands: widget.expands,
      initialValue: widget.initialValue,
      style: widget.textStyle ??
          kCodeStyle.copyWith(
            fontSize: widget.textFontSize,
            color: widget.textColor ?? clrScheme.onSurface,
          ),
      decoration: getTextFieldInputDecoration(
        clrScheme,
        fillColor: widget.fillColor,
        hintText: widget.hintText,
        hintTextStyle: widget.hintTextStyle,
        hintTextFontSize: widget.hintTextFontSize,
        hintTextColor: widget.hintTextColor,
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        focussedBorderColor: widget.focussedBorderColor,
        enabledBorderColor: widget.enabledBorderColor,
        isDense: widget.isDense ?? true, // Ensure compact rendering
      ),
      onChanged: widget.onChanged,
    );
  }
}