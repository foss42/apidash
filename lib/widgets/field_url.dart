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
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key("url-${widget.selectedId}"),
      initialValue: widget.initialValue,
      focusNode: _focusNode,
      style: kCodeStyle,
      maxLines: _isFocused ? null : 1,
      minLines: 1,
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
