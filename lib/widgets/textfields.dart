import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class URLField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key("url-$selectedId"),
      initialValue: initialValue,
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
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}

class CellField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var clrScheme = colorScheme ?? Theme.of(context).colorScheme;
    return TextFormField(
      key: Key(keyId),
      initialValue: initialValue,
      style: kCodeStyle.copyWith(
        height: 1.6,
        color: clrScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintStyle: kCodeStyle.copyWith(
          height: 1.6,
          color: clrScheme.outline.withOpacity(
            kHintOpacity,
          ),
        ),
        hintText: hintText,
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
            color: clrScheme.surfaceVariant,
          ),
        ),
      ),
      onChanged: onChanged,
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
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: 'Search..',
      ),
    );
  }
}
