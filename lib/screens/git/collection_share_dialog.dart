import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/file_system_handler.dart';
import 'package:apidash/services/git/local_git_adapter.dart';
import 'package:apidash/utils/focus_integrated_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import 'git_panel_dialog.dart';

/// Share / export entry point: Git quick start, optional exports, remote link when connected.
class CollectionShareDialog extends ConsumerStatefulWidget {
  const CollectionShareDialog({
    super.key,
    required this.collectionId,
    required this.anchorContext,
  });

  final String collectionId;

  /// Host context for opening another dialog after this one closes.
  final BuildContext anchorContext;

  @override
  ConsumerState<CollectionShareDialog> createState() =>
      _CollectionShareDialogState();
}

class _CollectionShareDialogState extends ConsumerState<CollectionShareDialog> {
  bool _bootstrapped = false;
  bool _loadingRemote = false;
  String? _originUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final activeId = ref.read(activeCollectionIdStateProvider);
    if (activeId != widget.collectionId) {
      await ref
          .read(collectionStateNotifierProvider.notifier)
          .switchCollection(widget.collectionId);
    }
    if (!mounted) return;
    setState(() => _bootstrapped = true);

    final collections = ref.read(collectionsStateProvider);
    final git = collections[widget.collectionId]?.gitConnection;
    if (git == null || git.localRepoPath.isEmpty) {
      if (mounted) setState(() => _loadingRemote = false);
      return;
    }

    setState(() => _loadingRemote = true);
    try {
      final adapter = LocalGitAdapter(git.localRepoPath);
      final url = await adapter.remoteFetchUrl('origin');
      if (!mounted) return;
      setState(() {
        _originUrl = url;
        _loadingRemote = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _loadingRemote = false);
      }
    }
  }

  String _workingDirectory(GitConnectionModel? git) {
    if (git != null && git.localRepoPath.isNotEmpty) {
      return git.localRepoPath;
    }
    return collectionStorageDirectory(widget.collectionId);
  }

  void _openShellAndOptionalClose({required bool pop}) {
    final git = ref.read(collectionsStateProvider)[widget.collectionId]?.gitConnection;
    final col = ref.read(collectionsStateProvider)[widget.collectionId];
    final label = (col?.name.trim().isNotEmpty == true) ? col!.name : 'Collection';
    focusIntegratedShell(
      ref,
      _workingDirectory(git),
      collectionId: widget.collectionId,
      label: label,
    );
    if (pop && mounted) Navigator.of(context).pop();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Expand the bottom $kLabelShell panel — cwd is set to your collection folder.',
          ),
        ),
      );
    }
  }

  void _stubExport(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label export is not wired yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final collections = ref.watch(collectionsStateProvider);
    final collection = collections[widget.collectionId];
    final git = collection?.gitConnection;
    final connected = git != null && git.localRepoPath.isNotEmpty;
    final cwd = _workingDirectory(git);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 620),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                collection?.name ?? 'Collection',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                connected
                    ? 'Git: ${p.basename(git.localRepoPath)} · ${git.branch}'
                    : 'Not connected to a Git repository',
              ),
              trailing: IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: !_bootstrapped
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (connected) ...[
                          Text(
                            'Remote repository',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          if (_loadingRemote)
                            const LinearProgressIndicator()
                          else if (_originUrl != null && _originUrl!.isNotEmpty)
                            Card(
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: SelectableText(
                                        _originUrl!,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Copy URL',
                                      onPressed: () async {
                                        await Clipboard.setData(
                                          ClipboardData(text: _originUrl!),
                                        );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Copied remote URL'),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.copy, size: 20),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Text(
                              'No `origin` remote yet. Add one from the bottom $kLabelShell panel, e.g. `git remote add origin <url>`.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          const SizedBox(height: 20),
                        ],
                        Text(
                          'Git workflow',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        _GitStepsCard(
                          cwdLabel: cwd,
                          showInitSteps: !connected,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton.icon(
                              onPressed: () =>
                                  _openShellAndOptionalClose(pop: true),
                              icon: const Icon(Icons.terminal_outlined, size: 18),
                              label: Text(
                                connected
                                    ? 'Open $kLabelShell here'
                                    : 'Initialize Git in $kLabelShell',
                              ),
                            ),
                            if (connected)
                              FilledButton.tonalIcon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (!widget.anchorContext.mounted) return;
                                    showDialog<void>(
                                      context: widget.anchorContext,
                                      builder: (ctx) => GitPanelDialog(
                                        collectionId: widget.collectionId,
                                      ),
                                    );
                                  });
                                },
                                icon: const Icon(Icons.hub_outlined, size: 18),
                                label: const Text('Sync, branches, history'),
                              ),
                          ],
                        ),
                        if (!connected) ...[
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!widget.anchorContext.mounted) return;
                                showDialog<void>(
                                  context: widget.anchorContext,
                                  builder: (ctx) => GitPanelDialog(
                                    collectionId: widget.collectionId,
                                  ),
                                );
                              });
                            },
                            icon: const Icon(Icons.link, size: 18),
                            label: const Text('Connect or import Git repository…'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'After `git init`, use the panel above to point API Dash at the same folder.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.7),
                                ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        Text(
                          'Export collection',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Other tools (stubs — wire-up later)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: const Icon(Icons.folder_zip_outlined),
                          title: const Text('Postman Collection'),
                          onTap: () => _stubExport('Postman'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.layers_outlined),
                          title: const Text('Insomnia'),
                          onTap: () => _stubExport('Insomnia'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.http_outlined),
                          title: const Text('HAR bundle'),
                          onTap: () => _stubExport('HAR'),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GitStepsCard extends StatelessWidget {
  const _GitStepsCard({
    required this.cwdLabel,
    required this.showInitSteps,
  });

  final String cwdLabel;
  final bool showInitSteps;

  @override
  Widget build(BuildContext context) {
    final steps = <String>[
      'Working folder: $cwdLabel',
      if (showInitSteps) ...[
        'Run `git init -b main` (or your default branch name).',
        'Optionally `git remote add origin <repo-url>`.',
      ] else ...[
        'Create a branch: `git checkout -b feature/my-change`.',
        'Commit & push when ready: `git add -A && git commit -m "…" && git push -u origin HEAD`.',
      ],
      'Use “Sync, branches, history” in API Dash for pull / push of collection files.',
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      '${i + 1}.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Expanded(
                    child: SelectableText(
                      steps[i],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
