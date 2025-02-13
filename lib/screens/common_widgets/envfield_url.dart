import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'env_trigger_field.dart';

class EnvURLField extends StatefulWidget {
  const EnvURLField({
    super.key,
    required this.selectedId,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.controller,
  }) : assert(
          !(controller != null && initialValue != null),
          'controller and initialValue cannot be simultaneously defined.',
        );

  final String selectedId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  State<EnvURLField> createState() => _EnvURLFieldState();
}

class _EnvURLFieldState extends State<EnvURLField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController.fromValue(widget.initialValue != null
            ? TextEditingValue(text: widget.initialValue!)
            : TextEditingValue.empty);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvURLField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.initialValue != widget.initialValue)) {
      _controller = widget.controller ??
          TextEditingController.fromValue(widget.initialValue != null
              ? TextEditingValue(text: widget.initialValue!)
              : TextEditingValue.empty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EnvironmentTriggerField(
      keyId: "url-${widget.selectedId}",
      controller: _controller,
      focusNode: _focusNode,
      style: kCodeStyle,
      decoration: InputDecoration(
        hintText: kHintTextUrlCard,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outline.withOpacity(
                kHintOpacity,
              ),
        ),
        border: InputBorder.none,
      ),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      optionsWidthFactor: 1,
    );
  }
}
