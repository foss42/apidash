import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

class ADOutlinedTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var clrScheme = colorScheme ?? Theme.of(context).colorScheme;
    return TextFormField(
      key: keyId != null ? Key(keyId!) : null,
      controller: controller,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      expands: expands,
      initialValue: initialValue,
      style: textStyle ??
          kCodeStyle.copyWith(
            fontSize: textFontSize,
            color: textColor ?? clrScheme.onSurface,
          ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? clrScheme.surfaceContainerLowest,
        hintStyle: hintTextStyle ??
            kCodeStyle.copyWith(
              fontSize: hintTextFontSize,
              color: hintTextColor ?? clrScheme.outlineVariant,
            ),
        hintText: hintText,
        contentPadding: contentPadding ?? kP10,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: focussedBorderColor ?? clrScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: enabledBorderColor ?? clrScheme.surfaceContainerHighest,
          ),
        ),
        isDense: isDense,
      ),
      onChanged: onChanged,
    );
  }
}
