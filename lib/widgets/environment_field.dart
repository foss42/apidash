import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import '../screens/common/environment_autocomplete.dart';

class EnvironmentAutocompleteFieldBase extends StatefulHookWidget {
  const EnvironmentAutocompleteFieldBase({
    super.key,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.style,
    this.decoration,
    this.initialMentions,
    this.suggestions,
    this.mentionValue,
    required this.onMentionValueChanged,
  });

  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextStyle? style;
  final InputDecoration? decoration;
  final List<(String, Object?, Widget?)>? initialMentions;
  final List<EnvironmentVariableSuggestion>? suggestions;
  final String? mentionValue;
  final void Function(String?) onMentionValueChanged;

  @override
  State<EnvironmentAutocompleteFieldBase> createState() =>
      _EnvironmentAutocompleteFieldBaseState();
}

class _EnvironmentAutocompleteFieldBaseState
    extends State<EnvironmentAutocompleteFieldBase> {
  final MentionTagTextEditingController controller =
      MentionTagTextEditingController();

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final isSuggestionsVisible = useState(false);

    return PortalTarget(
      visible: isSuggestionsVisible.value && focusNode.hasFocus,
      portalFollower: EnvironmentSuggestionsMenu(
        mentionController: controller,
        suggestions: widget.suggestions,
        onSelect: (suggestion) {
          controller.addMention(
              label: '{${suggestion.variable.key}}}',
              data: suggestion,
              stylingWidget: EnvironmentVariableSpan(suggestion: suggestion));
          widget.onChanged?.call(controller.text);
          widget.onMentionValueChanged.call(null);
          isSuggestionsVisible.value = false;
          var mentionsCharacters =
              controller.mentions.fold<int>(0, (previousValue, element) {
            return previousValue + element.variable.key.length + 4 as int;
          });
          controller.selection = TextSelection.collapsed(
            offset: controller.text.length +
                controller.mentions.length -
                mentionsCharacters,
          );
        },
      ),
      anchor: const Aligned(
        follower: Alignment.topLeft,
        target: Alignment.bottomLeft,
        backup: Aligned(
          follower: Alignment.bottomLeft,
          target: Alignment.topLeft,
        ),
      ),
      child: EnvironmentMentionField(
        focusNode: focusNode,
        controller: controller,
        initialMentions: widget.initialMentions ?? [],
        mentionValue: widget.mentionValue,
        onMentionValueChanged: widget.onMentionValueChanged,
        isSuggestionsVisible: isSuggestionsVisible,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        style: widget.style,
        decoration: widget.decoration,
      ),
    );
  }
}

class EnvironmentMentionField extends StatelessWidget {
  const EnvironmentMentionField({
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
    return MentionTagTextFormField(
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
      onFieldSubmitted: (value) {
        onFieldSubmitted?.call(controller.text);
        isSuggestionsVisible.value = false;
      },
      decoration: decoration,
      mentionTagDecoration: const MentionTagDecoration(
        mentionStart: ['{'],
        mentionBreak:
            " ", // This is a workaround for the exception but adds a space after the mention
        maxWords: 1,
        allowDecrement: false,
        allowEmbedding: true,
        showMentionStartSymbol: false,
      ),
    );
  }
}

class EnvironmentSuggestionsMenu extends StatelessWidget {
  const EnvironmentSuggestionsMenu({
    super.key,
    required this.mentionController,
    required this.suggestions,
    this.onSelect,
  });

  final MentionTagTextEditingController mentionController;
  final List<EnvironmentVariableSuggestion>? suggestions;
  final Function(EnvironmentVariableSuggestion)? onSelect;

  @override
  Widget build(BuildContext context) {
    return suggestions == null || suggestions!.isEmpty
        ? const SizedBox.shrink()
        : ClipRRect(
            borderRadius: kBorderRadius8,
            child: Material(
              type: MaterialType.card,
              elevation: 8,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Ink(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: kBorderRadius8,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: suggestions?.length ?? 0,
                    separatorBuilder: (context, index) => const Divider(
                      height: 2,
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = suggestions![index];
                      return ListTile(
                        dense: true,
                        leading: EnvironmentIndicator(suggestion: suggestion),
                        title: Text(suggestion.variable.key),
                        subtitle: Text(suggestion.variable.value),
                        onTap: () {
                          onSelect?.call(suggestions![index]);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          );
  }
}

class EnvironmentIndicator extends StatelessWidget {
  const EnvironmentIndicator({super.key, required this.suggestion});

  final EnvironmentVariableSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final isUnknown = suggestion.isUnknown;
    final isGlobal = suggestion.environmentId == kGlobalEnvironmentId;
    return Container(
      padding: kP4,
      decoration: BoxDecoration(
        color: isUnknown
            ? Theme.of(context).colorScheme.errorContainer
            : isGlobal
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: kBorderRadius4,
      ),
      child: Icon(
        isUnknown
            ? Icons.block
            : isGlobal
                ? Icons.public
                : Icons.computer,
        size: 16,
      ),
    );
  }
}
