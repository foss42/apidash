import 'dart:math';
import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import '../screens/common_widgets/env_trigger_field.dart';

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
      this.initialValue});

  @override
  State<EnvAuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<EnvAuthField> {
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
            onChanged: widget.onChanged,
            initialValue: widget.initialValue,
            readOnly: widget.readOnly,
            // TODO: Needs some new implementation
            // obscureText: widget.isObscureText,
            style: kCodeStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            ),
            decoration: getTextFieldInputDecoration(
              Theme.of(context).colorScheme,
              hintText: widget.hintText,
              isDense: true,
              contentPadding: kIsMobile ? kPh6b12 : null,
            ),
          ),
        ],
      ),
    );
  }
}
