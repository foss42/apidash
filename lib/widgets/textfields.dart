import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class URLField extends StatefulWidget {
  const URLField({
    super.key,
    required this.activeId,
    this.initialValue,
    this.onChanged,
  });

  final String activeId;
  final String? initialValue;
  final void Function(String)? onChanged;

  @override
  State<URLField> createState() => _URLFieldState();
}

class _URLFieldState extends State<URLField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key("url-${widget.activeId}"),
      initialValue: widget.initialValue,
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
    );
  }
}
