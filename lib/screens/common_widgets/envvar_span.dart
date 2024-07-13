import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import 'envvar_popover.dart';

class EnvVarSpan extends HookConsumerWidget {
  const EnvVarSpan({
    super.key,
    required this.variableKey,
  });

  final String variableKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environments = ref.watch(environmentsStateNotifierProvider);
    final envMap = ref.watch(availableEnvironmentVariablesStateProvider);
    final activeEnvironmentId = ref.watch(activeEnvironmentIdStateProvider);

    final suggestion =
        getVariableStatus(variableKey, envMap, activeEnvironmentId);

    final showPopover = useState(false);

    final isMissingVariable = suggestion.isUnknown;
    final String scope = isMissingVariable
        ? 'unknown'
        : getEnvironmentTitle(environments?[suggestion.environmentId]?.name);
    final colorScheme = Theme.of(context).colorScheme;

    var text = Text(
      '{{${suggestion.variable.key}}}',
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
        child: EnvVarPopover(suggestion: suggestion, scope: scope),
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
