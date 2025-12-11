import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class URLField extends StatefulWidget {
  const URLField({
    super.key,
    required this.selectedId,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String selectedId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  @override
  State<URLField> createState() => _URLFieldState();
}

class _URLFieldState extends State<URLField> {
  late final TextEditingController _controller;
  String? _lastSelectedId;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _lastSelectedId = widget.selectedId;
  }

  @override
  void didUpdateWidget(URLField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update text when switching to a different request
    if (widget.selectedId != _lastSelectedId) {
      _controller.text = widget.initialValue ?? '';
      _lastSelectedId = widget.selectedId;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key("url-${widget.selectedId}"),
      controller: _controller,
      style: kCodeStyle,
      decoration: InputDecoration(
        hintText: kHintTextUrlCard,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        border: InputBorder.none,
      ),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
