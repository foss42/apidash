import 'package:flutter/material.dart';
import '../consts.dart';

class ADOutlinedTextField extends StatelessWidget {
  const ADOutlinedTextField({
    super.key,
    this.keyId,
    this.initialValue,
    this.textStyle,
    this.textColor,
    this.hintText,
    this.hintTextStyle,
    this.hintTextColor,
    this.contentPadding,
    this.fillColor,
    this.focussedBorderColor,
    this.enabledBorderColor,
    this.isDense,
    this.onChanged,
    this.colorScheme,
  });

  final String? keyId;
  final String? initialValue;
  final TextStyle? textStyle;
  final Color? textColor;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Color? hintTextColor;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? focussedBorderColor;
  final Color? enabledBorderColor;
  final bool? isDense;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;

  @override
  Widget build(BuildContext context) {
    var clrScheme = colorScheme ?? Theme.of(context).colorScheme;
    return TextFormField(
      key: keyId != null ? Key(keyId!) : null,
      initialValue: initialValue,
      style: textStyle ??
          kCodeStyle.copyWith(
            color: textColor ?? clrScheme.onSurface,
          ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? clrScheme.surfaceContainerLowest,
        hintStyle: hintTextStyle ??
            kCodeStyle.copyWith(
              color: hintTextColor ??
                  clrScheme.outline.withOpacity(
                    kHintOpacity,
                  ),
            ),
        hintText: hintText,
        contentPadding: contentPadding ?? kP10,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: focussedBorderColor ??
                clrScheme.primary.withOpacity(
                  kHintOpacity,
                ),
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
