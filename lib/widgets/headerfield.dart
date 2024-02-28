import 'package:apidash/consts.dart';
import 'package:apidash/utils/header_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController controller = TextEditingController();
  final SuggestionsController suggestionsController = SuggestionsController();
  bool isKeyPressed = false;
  bool isInputFocused = false;

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue ?? "";
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    HardwareKeyboard.instance.addHandler((event) => _handleKeyDown(event));
  }

  @override
  void dispose() {
    controller.dispose();
    HardwareKeyboard.instance.removeHandler(_handleKeyDown);
    super.dispose();
  }

  @override
  void didUpdateWidget(HeaderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      controller.text = widget.initialValue ?? "";
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    return TypeAheadField(
      key: Key(widget.keyId),
      hideOnEmpty: true,
      controller: controller,
      onSelected: (value) {
        setState(() {
          controller.text = value;
        });
        widget.onChanged!.call(value);
      },
      itemBuilder: (context, dynamic suggestion) {
        return ListTile(
          dense: true,
          title: Text(suggestion),
        );
      },
      suggestionsCallback: headerSuggestionCallback,
      suggestionsController: suggestionsController,
      decorationBuilder: (context, child) =>
          suggestionBoxDecorations(context, child, colorScheme),
      constraints: const BoxConstraints(maxHeight: 400),
      builder: (context, controller, focusNode) => Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            isInputFocused = hasFocus;
          });
        },
        child:  TextField(
        onChanged: widget.onChanged,
        controller: controller,
        focusNode: focusNode,
        style: kCodeStyle.copyWith(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintStyle: kCodeStyle.copyWith(
              color: colorScheme.outline.withOpacity(kHintOpacity)),
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
      ),
    );
  }

  Theme suggestionBoxDecorations(
      BuildContext context, Widget child, ColorScheme colorScheme) {
    return Theme(
      data: ThemeData(colorScheme: colorScheme),
      child: Material(
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).dividerColor, width: 1.2),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        ),
        clipBehavior: Clip.hardEdge,
        child: child,
      ),
    );
  }

    bool _handleKeyDown(KeyEvent event) {
    if (event is KeyDownEvent) {
      if( isInputFocused && HardwareKeyboard.instance.isControlPressed && event.logicalKey == LogicalKeyboardKey.space) {
        isKeyPressed = true;
        suggestionsController.refresh();
        return true;
      }
    }
    return false;
  }

  Future<List<String>?> headerSuggestionCallback(String pattern) async {
    if (pattern.isEmpty && !isKeyPressed) {
      return null;
    }else if (pattern.isEmpty && isKeyPressed ) {
      isKeyPressed = false;
      return getHeaderSuggestions("");
    }
    return getHeaderSuggestions(pattern);
  }
}
