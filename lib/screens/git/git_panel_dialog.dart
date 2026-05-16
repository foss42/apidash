import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/services/git/git_remote_types.dart';
import 'package:apidash/services/git/git_sync_service.dart';
import 'package:apidash/services/git/local_git_adapter.dart';
import 'package:apidash/utils/focus_integrated_shell.dart';
import 'package:apidash/utils/reveal_in_file_manager.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import 'package:apidash/providers/providers.dart';

class GitPanelDialog extends ConsumerStatefulWidget {
  const GitPanelDialog({
    super.key,
    required this.collectionId,
    this.startInImportMode = false,
  });

  final String collectionId;
  final bool startInImportMode;

  @override
  ConsumerState<GitPanelDialog> createState() => _GitPanelDialogState();
}

enum _GitTab { cli, push, history, branches }

class _GitPanelDialogState extends ConsumerState<GitPanelDialog>
    with SingleTickerProviderStateMixin {
  late final GitSyncService _syncService;

  late final TabController _tabController;

  _GitTab tab = _GitTab.cli;
  bool _busy = false;

  String _selectedBranch = 'main';

  bool _initRepoIfNeeded = true;

  bool _cliLoading = false;
  String _cliRemotes = '';
  String _cliStatus = '';

  String? _historyRemoteHeadSha;
  List<CommitInfo> _historyCommits = const [];
  bool _historyLoading = false;

  List<BranchInfo> _branches = const [];
  bool _branchesLoading = false;

  PushPreview? _pushPreview;
  bool _pushPreviewLoading = false;

  final TextEditingController _repoInputController = TextEditingController();
  final TextEditingController _branchController = TextEditingController(text: 'main');
  late bool _importMode;

  @override
  void initState() {
    super.initState();
    _importMode = widget.startInImportMode;
    _syncService = GitSyncService(ref);
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      final idx = _tabController.index;
      final nextTab = idx == 0
          ? _GitTab.cli
          : idx == 1
              ? _GitTab.push
              : idx == 2
                  ? _GitTab.history
                  : _GitTab.branches;
      if (nextTab == tab) return;
      setState(() => tab = nextTab);
      if (idx == 0) _loadCliContext();
      if (idx == 1) _loadPushPreview();
      if (idx == 2) _loadHistoryIfNeeded();
      if (idx == 3) _loadBranchesIfNeeded();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final activeId = ref.read(activeCollectionIdStateProvider);
      if (activeId != widget.collectionId) {
        await ref
            .read(collectionStateNotifierProvider.notifier)
            .switchCollection(widget.collectionId);
      }
      final collections = ref.read(collectionsStateProvider);
      final c = collections[widget.collectionId];
      final branch = c?.gitConnection?.branch ?? 'main';
      if ((c?.gitConnection == null) && _repoInputController.text.trim().isEmpty) {
        _repoInputController.text = _suggestRepoName(c?.name ?? 'new-collection');
      }
      setState(() {
        _selectedBranch = branch;
        _branchController.text = branch;
      });
      _loadCliContext();
      _loadHistoryIfNeeded();
      _loadPushPreview();
    });
  }

  Future<void> _loadCliContext() async {
    final collections = ref.read(collectionsStateProvider);
    final c = collections[widget.collectionId];
    final git = c?.gitConnection;
    if (git == null || git.localRepoPath.isEmpty) return;

    setState(() => _cliLoading = true);
    try {
      final adapter = LocalGitAdapter(git.localRepoPath);
      final rem = await adapter.remotesVerbose();
      final st = await adapter.statusShortBranch();
      if (!mounted) return;
      setState(() {
        _cliRemotes = rem;
        _cliStatus = st;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cliRemotes = '';
        _cliStatus = 'Could not run git: $e';
      });
    } finally {
      if (mounted) setState(() => _cliLoading = false);
    }
  }

  String _suggestRepoName(String collectionName) {
    final trimmed = collectionName.trim().toLowerCase();
    if (trimmed.isEmpty) return 'new-collection';
    final slug = trimmed
        .replaceAll(RegExp(r'[^a-z0-9._-]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return slug.isEmpty ? 'new-collection' : slug;
  }

  @override
  void dispose() {
    _repoInputController.dispose();
    _branchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collections = ref.watch(collectionsStateProvider);
    final active = collections[widget.collectionId];
    final git = active?.gitConnection;

    final repoLabel = git != null
        ? (git.repoDisplayName ?? p.basename(git.localRepoPath))
        : 'Not connected';

    if (git == null || git.localRepoPath.isEmpty) {
      return Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 560,
          height: 520,
          child: Column(
            children: [
              _DialogHeader(
                title: active?.name ?? 'Collection',
                subtitle: repoLabel,
                onClose: () => Navigator.of(context).pop(),
              ),
              const Divider(height: 1),
              Expanded(
                child: _buildInitialConnectFlow(),
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 960,
        height: 680,
        child: Column(
          children: [
            _DialogHeader(
              title: active?.name ?? 'Collection',
              subtitle: repoLabel,
              onClose: () => Navigator.of(context).pop(),
            ),
            const Divider(height: 1),
            Expanded(
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'CLI'),
                      Tab(text: 'Push'),
                      Tab(text: 'History'),
                      Tab(text: 'Branches'),
                    ],
                    indicatorColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _buildBody(git: git),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialConnectFlow() {
    return _ConnectToGitCard(
      importMode: _importMode,
      initRepoIfNeeded: _initRepoIfNeeded,
      onInitRepoChanged: (v) => setState(() => _initRepoIfNeeded = v),
      repoController: _repoInputController,
      branchController: _branchController,
      onBrowseFolder: () async {
        final dir = await getDirectoryPath();
        if (dir != null && mounted) {
          setState(() => _repoInputController.text = dir);
        }
      },
      onConnect: () async {
        await ref
            .read(collectionStateNotifierProvider.notifier)
            .switchCollection(widget.collectionId);
        setState(() => _busy = true);
        try {
          final branch = _branchController.text.trim().isEmpty
              ? 'main'
              : _branchController.text.trim();
          final path = _repoInputController.text.trim();
          if (path.isEmpty) {
            throw StateError('Choose a local folder for the Git repository');
          }
          if (_importMode) {
            final malformed = await _syncService.connectAndImportActiveCollection(
              localRepoPath: path,
              branch: branch,
            );
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    malformed.isEmpty
                        ? 'Import complete'
                        : 'Import complete (skipped ${malformed.length} malformed request(s))',
                  ),
                ),
              );
            }
          } else {
            await _syncService.connectAndPushActiveCollection(
              localRepoPath: path,
              branch: branch,
              initRepoIfNeeded: _initRepoIfNeeded,
            );
          }

          if (!mounted) return;
          setState(() => _selectedBranch = branch);
          _tabController.animateTo(2);
          await _loadHistoryIfNeeded();
        } on GitSyncRemoteException catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Git error: ${e.message}')),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Connection failed: $e')),
          );
        } finally {
          if (mounted) {
            setState(() => _busy = false);
          }
        }
      },
    );
  }

  Future<void> _loadHistoryIfNeeded() async {
    if (_historyLoading) return;
    final collections = ref.read(collectionsStateProvider);
    final c = collections[widget.collectionId];
    final git = c?.gitConnection;
    if (git == null) return;
    setState(() {
      _historyLoading = true;
    });
    try {
      final payload = await _syncService.loadHistory(branch: _selectedBranch);
      if (!mounted) return;
      setState(() {
        _historyRemoteHeadSha = payload.headSha;
        _historyCommits = payload.commits;
      });
    } on GitSyncRemoteException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Git error: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _historyLoading = false;
        });
      }
    }
  }

  Future<void> _loadBranchesIfNeeded() async {
    if (_branchesLoading) return;
    final collections = ref.read(collectionsStateProvider);
    final c = collections[widget.collectionId];
    final git = c?.gitConnection;
    if (git == null) return;
    setState(() {
      _branchesLoading = true;
    });
    try {
      final branches = await _syncService.loadBranches();
      if (!mounted) return;
      setState(() {
        _branches = branches;
      });
    } on GitSyncRemoteException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Git error: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _branchesLoading = false;
        });
      }
    }
  }

  Future<void> _loadPushPreview() async {
    final collections = ref.read(collectionsStateProvider);
    final c = collections[widget.collectionId];
    final git = c?.gitConnection;
    if (git == null) {
      if (mounted) {
        setState(() {
          _pushPreview = null;
          _pushPreviewLoading = false;
        });
      }
      return;
    }

    if (_pushPreviewLoading) return;
    setState(() => _pushPreviewLoading = true);
    try {
      final preview = await _syncService.getPushPreview(branch: _selectedBranch);
      if (!mounted) return;
      setState(() {
        _pushPreview = preview;
      });
    } on GitSyncRemoteException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Git error: ${e.message}')),
      );
    } finally {
      if (mounted) {
        setState(() => _pushPreviewLoading = false);
      }
    }
  }

  Future<String?> _askCommitMessage() async {
    final controller = TextEditingController(
      text: 'Inital Commit',
    );
    final message = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Commit message'),
        content: TextField(
          controller: controller,
          autofocus: true,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Describe this push',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isEmpty) return;
              Navigator.of(dialogContext).pop(value);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    controller.dispose();
    return message?.trim().isEmpty == true ? null : message?.trim();
  }

  Widget _buildBody({required GitConnectionModel? git}) {
    if (tab == _GitTab.cli) {
      return _buildCliTab(git: git);
    }
    if (tab == _GitTab.push) {
      return _buildPushTab(git: git);
    }
    if (tab == _GitTab.history) {
      return _buildHistoryTab(git: git);
    }
    return _buildBranchesTab(git: git);
  }

  Widget _buildCliTab({required GitConnectionModel? git}) {
    if (git == null) return const SizedBox.shrink();

    final hasRemote = _cliRemotes.trim().isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Local Git',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          hasRemote
              ? 'This folder is a Git repository. Remotes are listed below (any host). Run git in the bottom $kLabelShell panel.'
              : 'Collection files live here. Add a remote from the bottom $kLabelShell panel, then push.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85),
              ),
        ),
        const SizedBox(height: 12),
        if (_cliLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          if (_cliStatus.isNotEmpty)
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SelectableText(
                  _cliStatus,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          if (_cliRemotes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Remotes', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SelectableText(
                  _cliRemotes,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: () {
                final col = ref.read(collectionsStateProvider)[widget.collectionId];
                final label = (col?.name.trim().isNotEmpty == true)
                    ? col!.name
                    : p.basename(git.localRepoPath);
                focusIntegratedShell(
                  ref,
                  git.localRepoPath,
                  collectionId: widget.collectionId,
                  label: label,
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Using this folder in the bottom $kLabelShell panel.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.terminal_outlined, size: 18),
              label: const Text('Use folder in integrated terminal'),
            ),
            if (kIsDesktop)
              FilledButton.tonalIcon(
                onPressed: () async {
                  await revealInFileManager(git.localRepoPath);
                },
                icon: const Icon(Icons.folder_open_outlined, size: 18),
                label: const Text('Reveal in file manager'),
              ),
            OutlinedButton.icon(
              onPressed: _cliLoading ? null : _loadCliContext,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Refresh git status'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPushTab({required GitConnectionModel? git}) {
    if (git == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Connected to local Git',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SelectableText('Path: ${git.localRepoPath}'),
          Text('Branch: $_selectedBranch'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: _busy
                    ? null
                    : () async {
                        await ref
                            .read(collectionStateNotifierProvider.notifier)
                            .switchCollection(widget.collectionId);
                        setState(() => _busy = true);
                        try {
                          final malformed = await _syncService.pullLatestToActiveCollection(
                            branch: _selectedBranch,
                          );
                          await _loadHistoryIfNeeded();
                          await _loadPushPreview();
                          await _loadCliContext();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  malformed.isEmpty
                                      ? 'Pull complete'
                                      : 'Pull complete (skipped ${malformed.length} malformed request(s))',
                                ),
                              ),
                            );
                          }
                        } on GitSyncRemoteException catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Git error: ${e.message}')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _busy = false);
                        }
                      },
                child: const Text('Pull latest'),
              ),
              FilledButton.tonal(
                onPressed: _busy
                    ? null
                    : () async {
                        final commitMessage = await _askCommitMessage();
                        if (commitMessage == null) return;
                        await ref
                            .read(collectionStateNotifierProvider.notifier)
                            .switchCollection(widget.collectionId);
                        setState(() => _busy = true);
                        try {
                          await _syncService.pushActiveCollection(
                            branch: _selectedBranch,
                            commitMessage: commitMessage,
                          );
                          await _loadHistoryIfNeeded();
                          await _loadPushPreview();
                          await _loadCliContext();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Push complete')),
                            );
                          }
                        } on GitSyncConflictException catch (e) {
                          await showDialog<void>(
                            context: context,
                            builder: (context) => _PushConflictDialog(
                              remoteSha: e.remoteSha,
                              expectedSha: e.expectedSha,
                              onPullLatest: () async {
                                Navigator.of(context).pop();
                                setState(() => _busy = true);
                                try {
                                  await _syncService.pullLatestToActiveCollection(branch: _selectedBranch);
                                  await _loadHistoryIfNeeded();
                                } finally {
                                  if (mounted) setState(() => _busy = false);
                                }
                              },
                              onViewCommits: () async {
                                Navigator.of(context).pop();
                                _tabController.animateTo(2);
                                await _loadHistoryIfNeeded();
                              },
                            ),
                          );
                        } on GitSyncRemoteException catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Git error: ${e.message}')),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Push failed: $e')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _busy = false);
                        }
                      },
                child: const Text('Push changes'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PushPreviewCard(
            loading: _pushPreviewLoading,
            preview: _pushPreview,
            onRefresh: _busy ? null : _loadPushPreview,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab({required GitConnectionModel? git}) {
    if (git == null) {
      return const Center(child: Text('Connect the collection first.'));
    }
    if (_historyLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_historyCommits.isEmpty) {
      return const Center(child: Text('No commit history loaded.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _historyCommits.length,
      itemBuilder: (context, index) {
        final c = _historyCommits[index];
        final isCurrent = _historyRemoteHeadSha != null && _historyRemoteHeadSha == c.sha;
        return _CommitCard(
          message: c.message,
          shortSha: c.sha.substring(0, c.sha.length > 7 ? 7 : c.sha.length),
          author: c.authorName ?? 'unknown',
          date: c.date,
          isCurrent: isCurrent,
          onRollback: () async {
            await ref
                .read(collectionStateNotifierProvider.notifier)
                .switchCollection(widget.collectionId);
            final ok = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Rollback collection'),
                content: Text('Rollback to ${c.sha.substring(0, 7)}? This replaces the entire collection.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Rollback'),
                  ),
                ],
              ),
            );
            if (ok != true) return;

            setState(() => _busy = true);
            try {
              final malformed = await _syncService.rollbackActiveCollectionToCommit(
                commitSha: c.sha,
                branch: _selectedBranch,
              );
              await _loadHistoryIfNeeded();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      malformed.isEmpty
                          ? 'Rollback complete'
                          : 'Rollback complete (skipped ${malformed.length} malformed request(s))',
                    ),
                  ),
                );
              }
            } finally {
              if (mounted) setState(() => _busy = false);
            }
          },
          onCopySha: () async {
            await Clipboard.setData(ClipboardData(text: c.sha));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Commit SHA copied')),
            );
          },
        );
      },
    );
  }

  Widget _buildBranchesTab({required GitConnectionModel? git}) {
    if (git == null) {
      return const Center(child: Text('Connect the collection first.'));
    }
    if (_branchesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Branches in ${git.repoDisplayName ?? p.basename(git.localRepoPath)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _branches.length,
              itemBuilder: (context, index) {
                final b = _branches[index];
                final isSelected = _selectedBranch == b.name;
                return ListTile(
                  dense: true,
                  title: Text(b.name),
                  subtitle: Text('HEAD: ${b.sha.substring(0, 7)}'),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_outline)
                      : TextButton(
                          onPressed: () {
                            setState(() => _selectedBranch = b.name);
                            _tabController.animateTo(2);
                            _loadHistoryIfNeeded();
                          },
                          child: const Text('Switch'),
                        ),
                  onLongPress: () async {
                    if (b.protected) return;
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete branch'),
                        content: Text('Delete ${b.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (ok != true) return;

                    setState(() => _busy = true);
                    try {
                      await _syncService.deleteBranch(b.name);
                      await _loadBranchesIfNeeded();
                    } on GitSyncRemoteException catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Git error: ${e.message}')),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _branchController,
                  decoration: const InputDecoration(
                    labelText: 'Create new branch name',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: _busy
                    ? null
                    : () async {
                        final newName = _branchController.text.trim();
                        if (newName.isEmpty) return;
                        setState(() => _busy = true);
                        try {
                          await _syncService.createBranch(
                            fromBranch: _selectedBranch,
                            newBranchName: newName,
                          );
                          await _loadBranchesIfNeeded();
                          setState(() => _selectedBranch = newName);
                          await _loadHistoryIfNeeded();
                        } on GitSyncRemoteException catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Git error: ${e.message}')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _busy = false);
                        }
                      },
                child: const Text('Create'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _ConnectToGitCard extends StatelessWidget {
  const _ConnectToGitCard({
    required this.importMode,
    required this.initRepoIfNeeded,
    required this.onInitRepoChanged,
    required this.repoController,
    required this.branchController,
    required this.onBrowseFolder,
    required this.onConnect,
  });

  final bool importMode;
  final bool initRepoIfNeeded;
  final ValueChanged<bool> onInitRepoChanged;
  final TextEditingController repoController;
  final TextEditingController branchController;
  final Future<void> Function() onBrowseFolder;
  final Future<void> Function() onConnect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Link collection to a local Git folder',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            importMode
                ? 'Choose an existing clone that already contains API Dash JSON files.'
                : 'Choose an empty folder (or enable “Initialize Git” to run git init).',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: repoController,
                  decoration: const InputDecoration(
                    labelText: 'Repository folder path',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: () => onBrowseFolder(),
                child: const Text('Browse'),
              ),
            ],
          ),
          if (!importMode) ...[
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: initRepoIfNeeded,
              onChanged: (v) => onInitRepoChanged(v ?? false),
              title: const Text('Initialize Git here if needed'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
          const SizedBox(height: 10),
          TextField(
            controller: branchController,
            decoration: const InputDecoration(
              labelText: 'Branch',
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onConnect,
            child: Text(
              importMode ? 'Import from local Git folder' : 'Connect and push',
            ),
          ),
        ],
      ),
    );
  }
}

class _PushConflictDialog extends StatelessWidget {
  const _PushConflictDialog({
    required this.remoteSha,
    required this.expectedSha,
    required this.onPullLatest,
    required this.onViewCommits,
  });

  final String remoteSha;
  final String? expectedSha;
  final VoidCallback onPullLatest;
  final VoidCallback onViewCommits;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Push failed'),
      content: Text(
        'Remote has new commits. Pull latest and review changes before pushing again.\n\nRemote HEAD: ${remoteSha.substring(0, 7)}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: onPullLatest,
          child: const Text('Pull latest'),
        ),
        OutlinedButton(
          onPressed: onViewCommits,
          child: const Text('View commits'),
        ),
      ],
    );
  }
}

class _CommitCard extends StatelessWidget {
  const _CommitCard({
    required this.message,
    required this.shortSha,
    required this.author,
    required this.date,
    required this.isCurrent,
    required this.onRollback,
    required this.onCopySha,
  });

  final String message;
  final String shortSha;
  final String author;
  final DateTime? date;
  final bool isCurrent;
  final Future<void> Function() onRollback;
  final Future<void> Function() onCopySha;

  @override
  Widget build(BuildContext context) {
    final dLabel = date == null
        ? ''
        : ' · ${date!.toLocal().toString().substring(0, 16).replaceFirst('T', ' ')}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$shortSha · $author$dLabel',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ),
            ),
            if (isCurrent)
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('current', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            TextButton(
              onPressed: () async => await onRollback(),
              child: const Text('Rollback'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () async => onCopySha(),
              child: const Text('Copy SHA'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PushPreviewCard extends StatelessWidget {
  const _PushPreviewCard({
    required this.loading,
    required this.preview,
    required this.onRefresh,
  });

  final bool loading;
  final PushPreview? preview;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final p = preview;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Changes to push',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Refresh status',
                  onPressed: onRefresh == null ? null : () async => await onRefresh!(),
                  icon: const Icon(Icons.refresh, size: 18),
                ),
              ],
            ),
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              )
            else if (p == null)
              const Text('No status yet.')
            else if (p.changes.isEmpty)
              const Text('Working tree clean. Nothing to push.')
            else ...[
              Text(
                'Added: ${p.addedCount}  ·  Modified: ${p.modifiedCount}  ·  Deleted: ${p.deletedCount}',
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: p.changes.length,
                  itemBuilder: (context, index) {
                    final c = p.changes[index];
                    final (label, color) = switch (c.type) {
                      PushChangeType.added => ('A', const Color(0xFF1D9E75)),
                      PushChangeType.modified => ('M', const Color(0xFF3B82F6)),
                      PushChangeType.deleted => ('D', const Color(0xFFDC2626)),
                    };
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 18,
                            child: Text(
                              label,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              c.path,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

