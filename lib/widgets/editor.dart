import 'dart:math' as math;
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldEditor extends StatefulWidget {
  const TextFieldEditor({
    super.key,
    required this.fieldKey,
    this.onChanged,
    this.initialValue,
    this.readOnly = false,
  });

  final String fieldKey;
  final Function(String)? onChanged;
  final String? initialValue;
  final bool readOnly;
  @override
  State<TextFieldEditor> createState() => _TextFieldEditorState();
}

class _TextFieldEditorState extends State<TextFieldEditor> {
  final TextEditingController controller = TextEditingController();
  late final FocusNode editorFocusNode;

  void insertTab() {
    String sp = "    ";
    int offset = math.min(
        controller.selection.baseOffset, controller.selection.extentOffset);
    String text = controller.text.substring(0, offset) +
        sp +
        controller.text.substring(offset);
    controller.value = TextEditingValue(
      text: text,
      selection: controller.selection.copyWith(
        baseOffset: controller.selection.baseOffset + sp.length,
        extentOffset: controller.selection.extentOffset + sp.length,
      ),
    );
    widget.onChanged?.call(text);
  }

  @override
  void initState() {
    super.initState();
    editorFocusNode = FocusNode(debugLabel: "Editor Focus Node");
    controller.addListener(() {
      _processPlaceholders();
    });
  }

  void _processPlaceholders() {
    final placeholderRegex = RegExp(r'\{\{(.*?)\}\}');
    final matches = placeholderRegex.allMatches(controller.text);

    if (matches.isNotEmpty) {
      String updatedText = controller.text;

      for (final match in matches) {
        final placeholder = match.group(1);
        String replacement = "";

        switch (placeholder) {
          case 'username':
            replacement = _generateRandomUsername();
            break;
          case 'email':
            replacement = _generateRandomEmail();
            break;
          default:
            replacement = "{{unknown}}";
        }

        updatedText = updatedText.replaceFirst(match.group(0)!, replacement);
      }

      controller.value = TextEditingValue(
        text: updatedText,
        selection: TextSelection.collapsed(offset: updatedText.length),
      );

      widget.onChanged?.call(updatedText);
    }
  }

  String _generateRandomUsername() {
    const adjectives = [
      'Brave',
      'Clever',
      'Swift',
      'Bright',
      'Happy',
      'Lively',
      'Strong',
      'Gentle',
      'Kind',
      'Bold'
    ];
    const nouns = [
      'Lion',
      'Eagle',
      'Fox',
      'Wolf',
      'Bear',
      'Tiger',
      'Hawk',
      'Dolphin',
      'Panther',
      'Dragon'
    ];

    final random = math.Random();
    String adjective = adjectives[random.nextInt(adjectives.length)];
    String noun = nouns[random.nextInt(nouns.length)];

    return '$adjective$noun${random.nextInt(1000)}';
  }

  String _generateRandomEmail() {
    const domains = ['example.com', 'test.com', 'mail.com'];
    final random = math.Random();
    final name = _generateRandomUsername().toLowerCase();
    final domain = domains[random.nextInt(domains.length)];
    return '$name@$domain';
  }

  @override
  void dispose() {
    editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.tab): () {
          insertTab();
        },
      },
      child: TextFormField(
        key: Key(widget.fieldKey),
        controller: controller,
        focusNode: editorFocusNode,
        keyboardType: TextInputType.multiline,
        expands: true,
        maxLines: null,
        readOnly: widget.readOnly,
        style: kCodeStyle,
        textAlignVertical: TextAlignVertical.top,
        onChanged: widget.onChanged,
        onTapOutside: (PointerDownEvent event) {
          editorFocusNode.unfocus();
        },
        decoration: InputDecoration(
          hintText: "Enter content (body)",
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.outline.withOpacity(
                  kHintOpacity,
                ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: kBorderRadius8,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(
                    kHintOpacity,
                  ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: kBorderRadius8,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          filled: true,
          hoverColor: kColorTransparent,
          fillColor: Color.alphaBlend(
              (Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.primaryContainer)
                  .withOpacity(kForegroundOpacity),
              Theme.of(context).colorScheme.surface),
        ),
      ),
    );
  }
}
