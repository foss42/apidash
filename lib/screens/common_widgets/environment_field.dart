import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/envvar_utils.dart';
import 'package:apidash/widgets/widgets.dart';

class EnvironmentField extends HookConsumerWidget {
  const EnvironmentField({
    super.key,
    required this.keyId,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.style,
    this.decoration,
  });

  final String keyId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextStyle? style;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mentionValue = ref.watch(environmentFieldEditStateProvider);
    final envMap = ref.watch(availableEnvironmentVariablesStateProvider);
    final activeEnvironmentId = ref.watch(activeEnvironmentIdStateProvider);
    final initialMentions =
        getMentions(initialValue, envMap, activeEnvironmentId);
    final suggestions = getEnvironmentVariableSuggestions(
        mentionValue, envMap, activeEnvironmentId);
    return EnvironmentFieldBase(
      key: Key(keyId),
      mentionValue: mentionValue,
      onMentionValueChanged: (value) {
        ref.read(environmentFieldEditStateProvider.notifier).state = value;
      },
      initialValue: initialValue,
      initialMentions: initialMentions,
      suggestions: suggestions,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: style,
      decoration: decoration,
    );
  }
}
