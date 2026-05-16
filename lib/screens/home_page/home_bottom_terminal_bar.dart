import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/file_system_handler.dart';
import 'package:apidash/terminal/terminal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Collapsible integrated shell at the bottom of the request editor (desktop).
/// Bruno-style: multiple PTY sessions (one per collection), selectable in a sidebar.
class HomeBottomTerminalBar extends ConsumerWidget {
  const HomeBottomTerminalBar({super.key});

  static const double _panelHeight = 280;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kIsDesktop || kIsWeb) return const SizedBox.shrink();

    final expanded = ref.watch(homeBottomTerminalExpandedProvider);
    final shellState = ref.watch(shellTerminalSessionsNotifierProvider);
    final sessions = shellState.sessions;
    final activeSessionId = shellState.activeSessionId;
    final highlightId = sessions.isEmpty
        ? null
        : (activeSessionId != null &&
                sessions.any((s) => s.id == activeSessionId))
            ? activeSessionId
            : sessions.first.id;

    var activeIndex = 0;
    if (sessions.isNotEmpty) {
      final i = sessions.indexWhere((s) => s.id == highlightId);
      activeIndex = i >= 0 ? i : 0;
    }

    final cs = Theme.of(context).colorScheme;

    return Material(
      elevation: expanded ? 2 : 0,
      color: cs.surfaceContainerLow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              ref.read(homeBottomTerminalExpandedProvider.notifier).state =
                  !expanded;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    expanded ? Icons.expand_more : Icons.expand_less,
                    size: 20,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    kLabelShell,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  Text(
                    expanded ? 'Hide' : 'Show',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: cs.primary),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: expanded
                ? SizedBox(
                    height: _panelHeight,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 168,
                          child: Material(
                            color: cs.surfaceContainerHigh,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 8, 4, 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Sessions',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        tooltip:
                                            'Shell for active collection',
                                        icon: const Icon(Icons.add, size: 20),
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          final messenger =
                                              ScaffoldMessenger.maybeOf(context);
                                          final collectionId = ref.read(
                                            activeCollectionIdStateProvider,
                                          );
                                          if (collectionId == null) {
                                            messenger?.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Select a collection first.',
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                          final collections = ref.read(
                                            collectionsStateProvider,
                                          );
                                          final model = collections[collectionId];
                                          if (model == null) return;
                                          final git = model.gitConnection;
                                          final cwd = (git != null &&
                                                  git.localRepoPath.isNotEmpty)
                                              ? git.localRepoPath
                                              : collectionStorageDirectory(
                                                  collectionId,
                                                );
                                          ref
                                              .read(
                                                shellTerminalSessionsNotifierProvider
                                                    .notifier,
                                              )
                                              .upsertAndActivate(
                                                collectionId: collectionId,
                                                workingDirectory: cwd,
                                                label: model.name,
                                              );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Expanded(
                                  child: sessions.isEmpty
                                      ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              'Open integrated shell from a collection’s menu.',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: cs.onSurfaceVariant,
                                                  ),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          itemCount: sessions.length,
                                          itemBuilder: (context, i) {
                                            final s = sessions[i];
                                            final selected = s.id == highlightId;
                                            return Material(
                                              color: selected
                                                  ? cs.primaryContainer
                                                      .withValues(alpha: 0.35)
                                                  : null,
                                              child: InkWell(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                        shellTerminalSessionsNotifierProvider
                                                            .notifier,
                                                      )
                                                      .activate(s.id);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 6,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.terminal,
                                                        size: 16,
                                                        color: cs.onSurfaceVariant,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Expanded(
                                                        child: Text(
                                                          s.label,
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodySmall,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        tooltip: 'Close session',
                                                        icon: Icon(
                                                          Icons.close,
                                                          size: 16,
                                                          color: cs.onSurfaceVariant,
                                                        ),
                                                        visualDensity:
                                                            VisualDensity.compact,
                                                        padding: EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(
                                                          minWidth: 28,
                                                          minHeight: 28,
                                                        ),
                                                        onPressed: () {
                                                          ref
                                                              .read(
                                                                shellTerminalSessionsNotifierProvider
                                                                    .notifier,
                                                              )
                                                              .remove(s.id);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(
                          child: sessions.isEmpty
                              ? Center(
                                  child: Text(
                                    'No shell sessions yet.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: cs.onSurfaceVariant,
                                        ),
                                  ),
                                )
                              : IndexedStack(
                                  index: activeIndex,
                                  sizing: StackFit.expand,
                                  children: [
                                    for (final s in sessions)
                                      ShellTerminalView(
                                        key: ValueKey(s.id),
                                        workingDirectory: s.workingDirectory,
                                      ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
