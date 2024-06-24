import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/widgets/field_mention.dart';
import '../screens/common_widgets/common_widgets.dart';
import 'suggestions_menu.dart';

class EnvironmentFieldBase extends StatefulHookWidget {
  const EnvironmentFieldBase({
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
  State<EnvironmentFieldBase> createState() =>
      _EnvironmentAutocompleteFieldBaseState();
}

class _EnvironmentAutocompleteFieldBaseState
    extends State<EnvironmentFieldBase> {
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
      portalFollower: SuggestionsMenu(
        mentionController: controller,
        suggestions: widget.suggestions,
        suggestionBuilder: (context, index) {
          final suggestion = widget.suggestions![index];
          return ListTile(
            dense: true,
            leading: EnvVarIndicator(suggestion: suggestion),
            title: Text(suggestion.variable.key),
            subtitle: Text(suggestion.variable.value),
            onTap: () {
              controller.addMention(
                  label: '{${suggestion.variable.key}}}',
                  data: suggestion,
                  stylingWidget: EnvVarSpan(suggestion: suggestion));
              widget.onChanged?.call(controller.text);
              widget.onMentionValueChanged.call(null);
              isSuggestionsVisible.value = false;
            },
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
      child: MentionField(
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
        mentionStart: const ['{'],
        maxWords: 1,
      ),
    );
  }
}
