import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

InputDecoration getTextFieldInputDecoration(
  ColorScheme clrScheme, {
  Color? fillColor,
  String? hintText,
  TextStyle? hintTextStyle,
  double? hintTextFontSize,
  Color? hintTextColor,
  EdgeInsetsGeometry? contentPadding,
  Color? focussedBorderColor,
  Color? enabledBorderColor,
  bool? isDense,
}) {
  return InputDecoration(
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
  );
}
