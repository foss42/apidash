import 'package:apidash/git/consts.dart';
import 'package:apidash/git/models/git_models.dart';
import 'package:apidash/git/providers/git_last_fetched_provider.dart';
import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const kGitPanelHeaderBranchRowHeight = 36.0;
const kGitPanelHeaderRemoteLineHeight = 16.0;

const kGitPushOriginBarHeight =
    kGitPanelHeaderBranchRowHeight + 5 + kGitPanelHeaderRemoteLineHeight;

class GitSyncToolbar extends ConsumerWidget {
  const GitSyncToolbar({
    super.key,
    required this.status,
    required this.busy,
    required this.onPush,
    this.showBack = false,
    this.onBack,
  });

  final GitStatus status;
  final bool busy;
  final VoidCallback? onPush;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPush =
        status.remoteUrl != null && status.ahead > 0 && onPush != null;
    final showBackButton = showBack && onBack != null;

    if (!canPush && !showBackButton) {
      return const SizedBox.shrink();
    }

    final workspacePath = ref.watch(
      settingsProvider.select((s) => s.workspaceFolderPath),
    );
    final lastFetched = ref.watch(gitLastFetchedProvider)[workspacePath];

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (canPush)
            SizedBox(
              height: kGitPushOriginBarHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showBackButton) ...[
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: busy ? null : onBack,
                        icon: const Icon(Icons.arrow_back_rounded, size: 20),
                        tooltip: kLabelGitBackToOverview,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ),
                    kHSpacer8,
                  ],
                  _GitPushOriginBar(
                    ahead: status.ahead,
                    busy: busy,
                    lastFetchedLabel: formatGitLastFetched(lastFetched),
                    onPressed: onPush,
                  ),
                ],
              ),
            )
          else
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: busy ? null : onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                tooltip: kLabelGitBackToOverview,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GitPushOriginBar extends StatelessWidget {
  const _GitPushOriginBar({
    required this.ahead,
    required this.busy,
    required this.lastFetchedLabel,
    required this.onPressed,
  });

  final int ahead;
  final bool busy;
  final String lastFetchedLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: scheme.primaryContainer.withValues(alpha: 0.45),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: scheme.primary.withValues(alpha: 0.22),
        ),
      ),
      child: InkWell(
        onTap: busy ? null : onPressed,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: SizedBox(
            height: kGitPushOriginBarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (busy)
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: scheme.primary,
                      ),
                    )
                  else
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 18,
                      color: scheme.primary,
                    ),
                  kHSpacer10,
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          busy ? kLabelGitPushingOrigin : kLabelGitPushOrigin,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          lastFetchedLabel,
                          style: textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  kHSpacer8,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surface.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: scheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      '$ahead ↑',
                      style: textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
