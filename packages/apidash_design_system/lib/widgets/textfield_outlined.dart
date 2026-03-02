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
  }) : assert(!(controller != null && initialValue != null),
            ("controller and initialValue cannot be simultaneously defined."));

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
  State<StatefulWidget> createState() => _ADOutlinedTextField();
}

class _ADOutlinedTextField extends State<ADOutlinedTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    final initialText = widget.initialValue ?? '';
    controller = widget.controller ??
        TextEditingController.fromValue(TextEditingValue(
            text: initialText,
            selection: TextSelection.collapsed(offset: initialText.length)));
  }

  @override
  void didUpdateWidget(covariant ADOutlinedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keyId != widget.keyId) {
      controller = widget.controller ??
          TextEditingController.fromValue(TextEditingValue(
              text: widget.initialValue!,
              selection: TextSelection.collapsed(
                  offset: widget.initialValue!.length)));
    } else if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null &&
        controller.text != widget.initialValue) {
      // Update controller text only if it differs from current text
      // This preserves cursor position when typing
      final currentSelection = controller.selection;
      controller.text = widget.initialValue!;
      // Restore the selection if it's still valid
      if (currentSelection.baseOffset <= controller.text.length) {
        controller.selection = currentSelection;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var clrScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    return TextFormField(
      key: widget.keyId != null ? Key(widget.keyId!) : null,
      controller: controller,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      expands: widget.expands,
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
        contentPadding: widget.contentPadding,
        focussedBorderColor: widget.focussedBorderColor,
        enabledBorderColor: widget.enabledBorderColor,
        isDense: widget.isDense,
      ),
      onChanged: widget.onChanged,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
