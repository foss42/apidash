import 'dart:math';
import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'env_trigger_field.dart';

class EnvAuthField extends StatefulWidget {
  final String hintText;
  final String? title;
  final bool isObscureText;
  final Function(String)? onChanged;
  final bool readOnly;
  final String? infoText;
  final String? initialValue;

  const EnvAuthField(
      {super.key,
      this.title,
      required this.hintText,
      required this.onChanged,
      this.readOnly = false,
      this.isObscureText = false,
      this.infoText,
      this.initialValue = ""});

  @override
  State<EnvAuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<EnvAuthField> {
  late bool _obscureText;
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue ?? "";
    if (_currentValue.contains("{{")) {
      _obscureText = false;
    } else {
      _obscureText = widget.isObscureText;
    }
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.title ?? widget.hintText),
              if (widget.infoText != null)
                Tooltip(
                  message: widget.infoText!,
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: Duration(seconds: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      Icons.help_outline_rounded,
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          EnvironmentTriggerField(
            keyId: "auth-${widget.title ?? widget.hintText}-${Random.secure()}",
            onChanged: (value) {
              setState(() {
                _currentValue = value;
                // Update obscure text based on whether the current value contains env vars
                if (value.contains("{{")) {
                  _obscureText = false;
                } else {
                  _obscureText = widget.isObscureText;
                }
              });
              widget.onChanged?.call(value);
            },
            initialValue: widget.initialValue,
            readOnly: widget.readOnly,
            obscureText: _obscureText,
            style: kCodeStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            ),
            decoration: getTextFieldInputDecoration(
              Theme.of(context).colorScheme,
              hintText: widget.hintText,
              isDense: true,
              contentPadding: kIsMobile ? kPh6b12 : null,
              // null when initial text contains env vars
              suffixIcon: (widget.isObscureText &&
                      !_currentValue.contains("{{"))
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: _toggleVisibility,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
