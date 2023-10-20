import 'package:apidash/utils/header_utils.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HeaderField extends StatefulWidget {
  const HeaderField({
    super.key,
    required this.keyId,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.colorScheme,
  });
  final String keyId;
  final String? hintText;
  final String? initialValue;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;

  @override
  State<HeaderField> createState() => _HeaderFieldState();
}

class _HeaderFieldState extends State<HeaderField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    return TypeAheadField(
      key: Key(widget.keyId),
      hideOnEmpty: true,
      minCharsForSuggestions: 1,
      onSuggestionSelected: (value) {
        setState(() {
          controller.text = value;
        });
        widget.onChanged!.call(value);
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(
          dense: true,
          title: Text(suggestion),
        );
      },
      suggestionsCallback: headerSuggestionCallback,
      suggestionsBoxDecoration: suggestionBoxDecorations(context),
      textFieldConfiguration: TextFieldConfiguration(
        onChanged: (s) {
          widget.onChanged?.call(s);
        },
        controller: controller,
        style: kCodeStyle.copyWith(
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintStyle: kCodeStyle.copyWith(
            color: colorScheme.outline.withOpacity(
              kHintOpacity,
            ),
          ),
          hintText: widget.hintText,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme.primary.withOpacity(
                kHintOpacity,
              ),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme.surfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  SuggestionsBoxDecoration suggestionBoxDecorations(BuildContext context) {
    return SuggestionsBoxDecoration(
      elevation: 4,
      constraints: const BoxConstraints(maxHeight: 400),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1.2,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      clipBehavior: Clip.hardEdge,
    );
  }

  Future<List<String>> headerSuggestionCallback(String pattern) async {
    return getHeaderSuggestions(pattern);
  }
}
