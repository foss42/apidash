import 'package:flutter/material.dart';
import 'package:mention_tag_text_field/mention_tag_text_field.dart';

class MentionField extends StatelessWidget {
  const MentionField({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.initialMentions,
    required this.mentionValue,
    required this.onMentionValueChanged,
    required this.isSuggestionsVisible,
    this.onChanged,
    this.onFieldSubmitted,
    this.style,
    this.decoration,
    required this.mentionStart,
    this.mentionBreak = "",
    this.maxWords,
    this.allowDecrement = false,
    this.allowEmbedding = true,
    this.showMentionStartSymbol = false,
  });

  final FocusNode focusNode;
  final MentionTagTextEditingController controller;
  final List<(String, Object?, Widget?)> initialMentions;
  final String? mentionValue;
  final void Function(String?) onMentionValueChanged;
  final ValueNotifier<bool> isSuggestionsVisible;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextStyle? style;
  final InputDecoration? decoration;
  final List<String> mentionStart;
  final String mentionBreak;
  final int? maxWords;
  final bool allowDecrement;
  final bool allowEmbedding;
  final bool showMentionStartSymbol;

  void onMention(String? value) {
    onMentionValueChanged.call(value);
    if (value != null) {
      isSuggestionsVisible.value = true;
    } else {
      isSuggestionsVisible.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MentionTagTextField(
      focusNode: focusNode,
      onTap: () {
        focusNode.requestFocus();
      },
      onTapOutside: (event) {
        focusNode.unfocus();
        isSuggestionsVisible.value = false;
      },
      controller: controller,
      style: style,
      initialMentions: initialMentions,
      onMention: onMention,
      onChanged: (value) {
        onChanged?.call(controller.text);
      },
      onEditingComplete: () {
        focusNode.unfocus();
        onFieldSubmitted?.call(controller.text);
        isSuggestionsVisible.value = false;
      },
      decoration: decoration,
      mentionTagDecoration: MentionTagDecoration(
        mentionStart: mentionStart,
        mentionBreak: mentionBreak,
        maxWords: maxWords,
        allowDecrement: allowDecrement,
        allowEmbedding: allowEmbedding,
        showMentionStartSymbol: showMentionStartSymbol,
      ),
    );
  }
}
