import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/environment_model.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/envvar_utils.dart';
import 'package:apidash/widgets/widgets.dart';

class EnvironmentAutocompleteField extends HookConsumerWidget {
  const EnvironmentAutocompleteField({
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
    return EnvironmentAutocompleteFieldBase(
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

class EnvironmentVariableSpan extends HookConsumerWidget {
  const EnvironmentVariableSpan({
    super.key,
    required this.suggestion,
  });

  final EnvironmentVariableSuggestion suggestion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environments = ref.watch(environmentsStateNotifierProvider);
    final envMap = ref.watch(availableEnvironmentVariablesStateProvider);
    final activeEnvironmentId = ref.watch(activeEnvironmentIdStateProvider);

    final currentSuggestion =
        getCurrentVariableStatus(suggestion, envMap, activeEnvironmentId);

    final showPopover = useState(false);

    final isMissingVariable = currentSuggestion.isUnknown;
    final String scope = isMissingVariable
        ? 'unknown'
        : getEnvironmentTitle(
            environments?[currentSuggestion.environmentId]?.name);
    final colorScheme = Theme.of(context).colorScheme;

    var text = Text(
      '{{${currentSuggestion.variable.key}}}',
      style: TextStyle(
          color: isMissingVariable ? colorScheme.error : colorScheme.primary,
          fontWeight: FontWeight.w600),
    );

    return PortalTarget(
      visible: showPopover.value,
      portalFollower: MouseRegion(
        onEnter: (_) {
          showPopover.value = true;
        },
        onExit: (_) {
          showPopover.value = false;
        },
        child:
            EnvironmentPopoverCard(suggestion: currentSuggestion, scope: scope),
      ),
      anchor: const Aligned(
        follower: Alignment.bottomCenter,
        target: Alignment.topCenter,
        backup: Aligned(
          follower: Alignment.topCenter,
          target: Alignment.bottomCenter,
        ),
      ),
      child: kIsMobile
          ? TapRegion(
              onTapInside: (_) {
                showPopover.value = true;
              },
              onTapOutside: (_) {
                showPopover.value = false;
              },
              child: text,
            )
          : MouseRegion(
              onEnter: (_) {
                showPopover.value = true;
              },
              onExit: (_) {
                showPopover.value = false;
              },
              child: text,
            ),
    );
  }
}

class EnvironmentPopoverCard extends StatelessWidget {
  const EnvironmentPopoverCard({
    super.key,
    required this.suggestion,
    required this.scope,
  });

  final EnvironmentVariableSuggestion suggestion;
  final String scope;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      borderRadius: kBorderRadius8,
      elevation: 8,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 200),
        child: Ink(
          padding: kP8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: kBorderRadius8,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EnvironmentIndicator(suggestion: suggestion),
                  kHSpacer10,
                  Text(suggestion.variable.key),
                ],
              ),
              kVSpacer5,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VALUE',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  kHSpacer10,
                  Text(suggestion.variable.value),
                ],
              ),
              kVSpacer5,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SCOPE',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  kHSpacer10,
                  Text(scope),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
