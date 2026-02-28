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
  const CellField({
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
  State<CellField> createState() => _CellFieldState();
}

class _CellFieldState extends State<CellField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = widget.colorScheme ?? Theme.of(context).colorScheme;

    return TextFormField(
      key: Key(widget.keyId),
      controller: _controller,
      style: kCodeStyle.copyWith(
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintStyle: kCodeStyle.copyWith(
          color: colorScheme.outline.withOpacity(kHintOpacity),
        ),
        hintText: widget.hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary.withOpacity(kHintOpacity),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.surfaceVariant,
          ),
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}

class JsonSearchField extends StatelessWidget {
  const JsonSearchField({super.key, this.onChanged, this.controller});

  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: kCodeStyle,
      cursorHeight: 18,
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: 'Search..',
      ),
    );
  }
}
