import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class EnvironmentField extends StatefulWidget {
  const EnvironmentField({
    super.key,
    required this.keyId,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.colorScheme,
  });
  final String keyId;
  final String? hintText;
  final String? initialValue;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;

  @override
  State<EnvironmentField> createState() => _EnvironmentFieldState();
}

class _EnvironmentFieldState extends State<EnvironmentField> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue ?? "";
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvironmentField oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      controller.text = widget.initialValue ?? "";
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    return TextField(
      key: Key(widget.keyId),
      decoration: InputDecoration(
        hintStyle: kCodeStyle.copyWith(
          color: colorScheme.outline.withOpacity(
            kHintOpacity,
          ),
        ),
        hintText: widget.hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary.withOpacity(
              kHintOpacity,
            ),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.surfaceVariant,
          ),
        ),
      ),
    );
  }
}
