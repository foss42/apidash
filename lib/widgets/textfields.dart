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

class CellField extends StatefulWidget {
  const CellField(
      {super.key,
      required this.colorScheme,
      required this.keyId,
      required this.initialValue,
      this.hintText,
      this.onChanged});

  final ColorScheme colorScheme;
  final String keyId;
  final String initialValue;
  final String? hintText;
  final void Function(String)? onChanged;

  @override
  State<CellField> createState() => _CellFieldState();
}

class _CellFieldState extends State<CellField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key(widget.keyId),
      initialValue: widget.initialValue,
      style: kCodeStyle.copyWith(
        color: widget.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintStyle: kCodeStyle.copyWith(
          color: widget.colorScheme.outline.withOpacity(
            kHintOpacity,
          ),
        ),
        hintText: widget.hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.colorScheme.primary.withOpacity(
              kHintOpacity,
            ),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.colorScheme.surfaceVariant,
          ),
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
