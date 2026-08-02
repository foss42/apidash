import 'package:apidash/consts.dart';
import 'package:apidash/git/consts.dart';
import 'package:apidash/git/models/git_models.dart';
import 'package:apidash/git/providers/git_last_fetched_provider.dart';
import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GitOverviewPanel extends ConsumerWidget {
  const GitOverviewPanel({
    super.key,
    required this.status,
    required this.busy,
    required this.onFetch,
    required this.onPull,
  });

  final GitStatus status;
  final bool busy;
  final VoidCallback onFetch;
  final VoidCallback onPull;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final workspacePath = ref.watch(
      settingsProvider.select((s) => s.workspaceFolderPath),
    );
    final lastFetchedMap = ref.watch(gitLastFetchedProvider);
    final lastFetched = workspacePath != null && workspacePath.isNotEmpty
        ? lastFetchedMap[workspacePath]
        : null;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: kP20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                kGitIconAsset,
                width: 72,
                height: 72,
                filterQuality: FilterQuality.medium,
              ),
              kVSpacer16,
              Text(
                kMsgGitOverviewHint,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              kVSpacer20,
              if (status.behind > 0) ...[
                _BehindRemoteHint(behind: status.behind),
                kVSpacer10,
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ActionButton(
                    label: kLabelFetch,
                    busy: busy,
                    emphasized: false,
                    onPressed: onFetch,
                  ),
                  kHSpacer10,
                  _ActionButton(
                    label: kLabelPull,
                    busy: busy,
                    emphasized: status.behind > 0,
                    onPressed: onPull,
                  ),
                ],
              ),
              kVSpacer20,
              Text(
                formatGitLastFetched(lastFetched),
                style: textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              kVSpacer10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SyncCount(
                    icon: Icons.arrow_upward_rounded,
                    count: status.ahead,
                    color: scheme.primary,
                    label: kLabelGitAhead,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '|',
                      style: textTheme.labelMedium?.copyWith(
                        color: scheme.outline,
                      ),
                    ),
                  ),
                  _SyncCount(
                    icon: Icons.arrow_downward_rounded,
                    count: status.behind,
                    color: scheme.error,
                    label: kLabelGitBehind,
                  ),
                ],
              ),
              if (status.ahead > 0 || status.behind > 0) ...[
                kVSpacer16,
                _AheadBehindSummary(
                  ahead: status.ahead,
                  behind: status.behind,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.busy,
    required this.onPressed,
    this.emphasized = false,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final onPressedOrNull = busy ? null : onPressed;
    final padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    if (emphasized) {
      return FilledButton(
        onPressed: onPressedOrNull,
        style: FilledButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: padding,
        ),
        child: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: onPressedOrNull,
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: padding,
      ),
      child: Text(label),
    );
  }
}

class _SyncCount extends StatelessWidget {
  const _SyncCount({
    required this.icon,
    required this.count,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final int count;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        kHSpacer4,
        Text(
          '$count $label',
          style: textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _BehindRemoteHint extends StatelessWidget {
  const _BehindRemoteHint({required this.behind});

  final int behind;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: scheme.onSecondaryContainer,
          ),
          kHSpacer10,
          Expanded(
            child: Text(
              formatGitBehindRemoteHint(behind),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _AheadBehindSummary extends StatelessWidget {
  const _AheadBehindSummary({
    required this.ahead,
    required this.behind,
  });

  final int ahead;
  final int behind;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final messages = <String>[];
    if (ahead > 0) {
      final unit = ahead == 1 ? 'commit' : 'commits';
      messages.add('$ahead $unit ahead of remote');
    }
    if (behind > 0) {
      final unit = behind == 1 ? 'commit' : 'commits';
      messages.add('$behind $unit behind remote');
    }

    var text = messages.join(' · ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        '> $text',
        style: textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
