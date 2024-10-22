import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ObscurableCellField extends HookWidget {
  const ObscurableCellField({
    super.key,
    required this.keyId,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.colorScheme,
  });

  final String keyId;
  final String? initialValue;
  final String? hintText;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);
    var clrScheme = colorScheme ?? Theme.of(context).colorScheme;
    return TextFormField(
      key: Key(keyId),
      initialValue: initialValue,
      style: kCodeStyle.copyWith(
        color: clrScheme.onSurface,
      ),
      obscureText: obscureText.value,
      decoration: InputDecoration(
        hintStyle: kCodeStyle.copyWith(
          color: clrScheme.outline.withOpacity(
            kHintOpacity,
          ),
        ),
        hintText: hintText,
        suffixIcon: IconButton(
          padding: kP4,
          icon: Icon(
            obscureText.value ? Icons.visibility : Icons.visibility_off,
            color: clrScheme.onSurface,
            size: 14,
          ),
          onPressed: () {
            obscureText.value = !obscureText.value;
          },
        ),
        contentPadding: const EdgeInsets.only(bottom: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: clrScheme.primary.withOpacity(
              kHintOpacity,
            ),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: clrScheme.surfaceContainerHighest,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
