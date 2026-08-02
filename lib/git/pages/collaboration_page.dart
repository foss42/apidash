import 'dart:async';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/git/consts.dart';
import 'package:apidash/git/git_error.dart';
import 'package:apidash/git/git_workspace_path.dart';
import 'package:apidash/git/models/git_change_tree.dart';
import 'package:apidash/git/models/git_models.dart';
import 'package:apidash/git/providers/providers.dart';
import 'package:apidash/git/widgets/dialog_git_branch.dart';
import 'package:apidash/git/widgets/dialog_git_remote.dart';
import 'package:apidash/git/widgets/git_branch_switcher.dart';
import 'package:apidash/git/widgets/git_changes_tree.dart';
import 'package:apidash/git/widgets/git_diff_panel.dart';
import 'package:apidash/git/widgets/git_overview_panel.dart';
import 'package:apidash/git/widgets/git_recent_commits_section.dart';
import 'package:apidash/git/widgets/git_sync_toolbar.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/storage/workspace_storage.dart';
import 'package:apidash/sync/consts.dart';
import 'package:apidash/sync/providers/sync_providers.dart';
import 'package:apidash/sync/ui/sync_host_dialog.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'collaboration_setup_guide.dart';

class CollaborationPage extends ConsumerStatefulWidget {
  const CollaborationPage({super.key});

  @override
  ConsumerState<CollaborationPage> createState() => _CollaborationPageState();
}

class _CollaborationPageState extends ConsumerState<CollaborationPage> {
  final _messageController = TextEditingController();
  final Set<String> _selectedPaths = {};
  /// Paths the user explicitly unchecked; auto-select must not revive them.
  final Set<String> _userDeselectedPaths = {};
  GitChange? _previewChange;
  bool _busy = false;
  int _diffRevision = 0;
  ProviderSubscription<AsyncValue<GitStatus>>? _gitStatusSubscription;
  ProviderSubscription<String?>? _workspacePathSubscription;

  Future<void> _openSyncToPhoneDialog() async {
    if (!mounted) return;
    await showSyncHostDialog(context);
    if (!mounted) return;
    await invalidateSyncUnsyncedCount(ref);
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onCommitMessageChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _gitStatusSubscription = ref.listenManual<AsyncValue<GitStatus>>(
        gitStatusProvider,
        (previous, next) {
          next.whenData((status) {
            if (!status.isRepository || status.remoteUrl == null) return;
            _scheduleAutoSelect(status.changes);
          });
        },
        fireImmediately: true,
      );
      _workspacePathSubscription = ref.listenManual<String?>(
        settingsProvider.select((s) => s.workspaceFolderPath),
        (previous, next) {
          if (previous != null && previous != next && mounted) {
            setState(_clearGitUiState);
          }
        },
      );
      unawaited(_refreshGitStatus());
    });
  }

  void _onCommitMessageChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _gitStatusSubscription?.close();
    _workspacePathSubscription?.close();
    _messageController.removeListener(_onCommitMessageChanged);
    _messageController.dispose();
    super.dispose();
  }

  void _clearGitUiState() {
    _selectedPaths.clear();
    _userDeselectedPaths.clear();
    _previewChange = null;
    _messageController.clear();
    _diffRevision++;
  }

  Future<void> _refreshGitStatus() async {
    if (!mounted) return;
    final path = ref.read(settingsProvider).workspaceFolderPath;
    if (path == null || path.isEmpty || !isWorkspaceStorageInitialized()) {
      return;
    }
    await ref.read(autoSaveNotifierProvider.notifier).flushNow(force: true);
  }

  bool _autoSelectWorkspaceChanges(List<GitChange> changes) {
    final paths = changes.map((c) => c.path).toSet();
    var changed = false;

    for (final path in _selectedPaths.toList()) {
      if (!paths.contains(path)) {
        _selectedPaths.remove(path);
        changed = true;
      }
    }

    _userDeselectedPaths.removeWhere((path) => !paths.contains(path));

    for (final change in changes) {
      if (!isApidashWorkspaceGitPath(change.path)) continue;
      if (_userDeselectedPaths.contains(change.path)) continue;
      if (_selectedPaths.add(change.path)) {
        changed = true;
      }
    }

    if (_previewChange != null && !paths.contains(_previewChange!.path)) {
      _previewChange = null;
      changed = true;
    }

    return changed;
  }

  void _applySelection(Set<String> paths, List<GitChange> changes) {
    final workspacePaths = {
      for (final change in changes)
        if (isApidashWorkspaceGitPath(change.path)) change.path,
    };
    _selectedPaths
      ..clear()
      ..addAll(paths);
    _userDeselectedPaths
      ..removeWhere((path) => paths.contains(path))
      ..addAll(workspacePaths.difference(paths));
  }

  void _scheduleAutoSelect(List<GitChange> changes) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_autoSelectWorkspaceChanges(changes)) {
        setState(() {});
      }
    });
  }

  Future<void> _connectRemote() async {
    final url = await showGitRemoteDialog(context);
    if (url == null || url.isEmpty || !mounted) return;
    await _run(() => gitSetRemote(ref, url), 'Remote connected');
  }

  Future<void> _createBranch(GitStatus status) async {
    if (_busy) return;
    final name = await showGitBranchDialog(context, suggestedName: null);
    if (name == null || name.isEmpty || !mounted) return;
    await _run(() => gitCreateBranch(ref, name), kMsgGitCreateBranchSuccess);
  }

  Future<void> _revealWorkspace() async {
    final path = ref.read(settingsProvider).workspaceFolderPath;
    if (path == null || path.isEmpty) return;
    final uri = Uri.directory(path, windows: Platform.isWindows);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw StateError('Could not open workspace folder');
    }
  }

  Future<void> _openWorkspaceInEditor() async {
    final path = ref.read(settingsProvider).workspaceFolderPath;
    if (path == null || path.isEmpty) return;
    final uri = _vsCodeFileUri(path);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw StateError('Could not open workspace in VS Code');
    }
  }

  Future<void> _confirmResetWorkspace() async {
    if (_busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(kMsgGitResetWorkspaceConfirmTitle),
            content: const Text(kMsgGitResetWorkspaceConfirmBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(kLabelCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(kLabelResetWorkspace),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;
    await _run(() => gitResetWorkspace(ref), kMsgGitResetWorkspaceSuccess);
  }

  Future<void> _confirmRestoreCommit(GitLogEntry entry) async {
    if (_busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(kMsgGitRestoreCommitConfirmTitle),
            content: Text(
              '${entry.message}\n\n${entry.author} · ${entry.relativeTime}\n\n'
              '$kMsgGitRestoreCommitConfirmBody',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(kLabelCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(kLabelGitRestoreCommit),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;
    await _run(
      () => gitRestoreToCommit(ref, entry.hash),
      kMsgGitRestoreCommitSuccess,
    );
  }

  Future<void> _run(
    Future<void> Function() action,
    String successMessage, {
    Future<String> Function()? successMessageBuilder,
    VoidCallback? onSuccess,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    final sm = ScaffoldMessenger.of(context);
    try {
      await action();
      if (mounted) {
        setState(() {
          _clearGitUiState();
        });
        onSuccess?.call();
        final message = successMessageBuilder != null
            ? await successMessageBuilder()
            : successMessage;
        if (mounted) {
          sm.showSnackBar(getSnackBar(message));
        }
      }
    } catch (e) {
      if (mounted) {
        sm.showSnackBar(
          getSnackBar(formatGitCollaborationError(e), color: kColorRed),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsDesktop) {
      return const Center(
        child: Text('Collaboration is available on desktop only.'),
      );
    }

    ref.watch(gitWorkspaceWatchProvider);

    ref.listen<int>(navRailIndexStateProvider, (previous, next) {
      if (next == kNavRailCollaborationIndex && previous != next) {
        unawaited(_refreshGitStatus());
      }
    });

    final statusAsync = ref.watch(gitStatusProvider);
    final unsyncedAsync = ref.watch(syncUnsyncedCountProvider);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: kPh20t40,
          child: Row(
            children: [
              Text(
                kLabelCollaboration,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              _CollaborationActionsMenu(
                enabled: !_busy,
                revealLabel: _revealWorkspaceLabel(),
                onSelected: (action) {
                  switch (action) {
                    case _CollaborationAction.reveal:
                      unawaited(
                        _run(_revealWorkspace, kMsgWorkspaceRevealSuccess),
                      );
                    case _CollaborationAction.openInEditor:
                      unawaited(
                        _run(
                          _openWorkspaceInEditor,
                          kMsgWorkspaceEditorOpenSuccess,
                        ),
                      );
                    case _CollaborationAction.resetWorkspace:
                      unawaited(_confirmResetWorkspace());
                  }
                },
              ),
              const Spacer(),
              kHSpacer8,
              FilledButton.tonalIcon(
                onPressed: _busy ? null : _openSyncToPhoneDialog,
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                label: unsyncedAsync.maybeWhen(
                  data:
                      (count) =>
                          count > 0
                              ? const Text(kLabelSyncToPhone)
                              : const Text(kLabelSyncToPhone),
                  orElse: () => const Text(kLabelSyncToPhone),
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: kPh20, child: Divider(height: 1)),
        Expanded(
          child: statusAsync.when(
            skipLoadingOnReload: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
            data: (status) {
              if (!status.gitInstalled ||
                  !status.isRepository ||
                  status.remoteUrl == null) {
                return CollaborationSetupGuide(
                  status: status,
                  busy: _busy,
                  onInitialize:
                      _busy
                          ? null
                          : () => _run(
                            () => gitInitRepository(ref),
                            'Repository initialized',
                          ),
                  onConnectRemote: _busy ? null : _connectRemote,
                );
              }

              final treeRoots = buildGitChangeTree(status.changes);

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (status.errorMessage != null) ...[
                      _InfoBanner(message: status.errorMessage!, isError: true),
                      kVSpacer8,
                    ],
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 300,
                            child: _GitPanel(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _GitSidebarHeader(
                                    status: status,
                                    branches: _branchOptions(status),
                                    busy: _busy,
                                    onBranchSelected:
                                        (branch) => _run(
                                          () => gitCheckoutBranch(ref, branch),
                                          kMsgGitCheckoutSuccess,
                                        ),
                                    onCreateBranch: () => _createBranch(status),
                                  ),
                                  if (status.recentCommits.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      child: Text(
                                        kMsgGitSetupSyncBody,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelSmall?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    child:
                                        status.changes.isEmpty
                                            ? _EmptyChangesState()
                                            : GitChangesTree(
                                              roots: treeRoots,
                                              selectedPaths: _selectedPaths,
                                              previewPath: _previewChange?.path,
                                              busy: _busy,
                                              onSelectionChanged: (paths) {
                                                setState(
                                                  () => _applySelection(
                                                    paths,
                                                    status.changes,
                                                  ),
                                                );
                                              },
                                              onFilePreview: (change) async {
                                                await ref
                                                    .read(
                                                      autoSaveNotifierProvider
                                                          .notifier,
                                                    )
                                                    .flushNow(force: true);
                                                if (!mounted) return;
                                                setState(() {
                                                  _previewChange = change;
                                                  _diffRevision++;
                                                });
                                              },
                                            ),
                                  ),
                                  const Divider(height: 1),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _CommitterLine(
                                          name: status.committerName,
                                        ),
                                        kVSpacer8,
                                        ADOutlinedTextField(
                                          keyId: 'git-commit-message',
                                          controller: _messageController,
                                          hintText: kLabelCommitMessage,
                                          maxLines: 2,
                                        ),
                                        kVSpacer8,
                                        FilledButton.icon(
                                          onPressed:
                                              _busy ||
                                                      _selectedPaths.isEmpty ||
                                                      _messageController.text
                                                          .trim()
                                                          .isEmpty
                                                  ? null
                                                  : () => _run(
                                                    () => gitCommitChanges(
                                                      ref,
                                                      message:
                                                          _messageController
                                                              .text,
                                                      paths:
                                                          _selectedPaths
                                                              .toList(),
                                                    ),
                                                    kMsgGitCommitSuccess,
                                                    onSuccess:
                                                        () =>
                                                            _messageController
                                                                .clear(),
                                                  ),
                                          icon: const Icon(
                                            Icons.check_rounded,
                                            size: 18,
                                          ),
                                          label: Text(kLabelCommitChanges),
                                          style: FilledButton.styleFrom(
                                            visualDensity:
                                                VisualDensity.compact,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                          ),
                                        ),
                                        GitRecentCommitsSection(
                                          commits: status.recentCommits,
                                          busy: _busy,
                                          onRestore: _confirmRestoreCommit,
                                        ),
                                        kVSpacer8,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          kHSpacer10,
                          Expanded(
                            child: _GitPanel(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  GitSyncToolbar(
                                    status: status,
                                    busy: _busy,
                                    showBack: _previewChange != null,
                                    onBack:
                                        () => setState(
                                          () => _previewChange = null,
                                        ),
                                    onPush:
                                        status.ahead > 0
                                            ? () => _run(
                                              () => gitPush(ref),
                                              kMsgGitPushSuccess,
                                            )
                                            : null,
                                  ),
                                  Expanded(
                                    child:
                                        _previewChange == null
                                            ? GitOverviewPanel(
                                              status: status,
                                              busy: _busy,
                                              onFetch: () {
                                                late GitStatus fetchStatus;
                                                unawaited(
                                                  _run(
                                                    () async {
                                                      fetchStatus =
                                                          await gitFetch(ref);
                                                    },
                                                    kMsgGitFetchSuccess,
                                                    successMessageBuilder:
                                                        () async =>
                                                            formatGitFetchResultMessage(
                                                      ahead: fetchStatus.ahead,
                                                      behind:
                                                          fetchStatus.behind,
                                                    ),
                                                  ),
                                                );
                                              },
                                              onPull:
                                                  () => _run(
                                                    () => gitPull(ref),
                                                    kMsgGitPullSuccess,
                                                  ),
                                            )
                                            : GitDiffPanel(
                                              change: _previewChange,
                                              refreshToken: _diffRevision,
                                            ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<String> _branchOptions(GitStatus status) {
    final names = <String>{...status.branches};
    final current = status.branch;
    if (current != null && current.isNotEmpty) {
      names.add(current);
    }
    return names.toList()..sort();
  }
}

enum _CollaborationAction { reveal, openInEditor, resetWorkspace }

String _revealWorkspaceLabel() {
  if (Platform.isMacOS) return kLabelRevealInFinder;
  if (Platform.isWindows) return kLabelRevealInExplorer;
  return kLabelRevealInFileManager;
}

Uri _vsCodeFileUri(String path) {
  final normalized = Platform.isWindows ? path.replaceAll('\\', '/') : path;
  final uriPath =
      Platform.isWindows && !normalized.startsWith('/')
          ? '/$normalized'
          : normalized;
  return Uri(scheme: 'vscode', host: 'file', path: uriPath);
}

class _CollaborationActionsMenu extends StatelessWidget {
  const _CollaborationActionsMenu({
    required this.enabled,
    required this.revealLabel,
    required this.onSelected,
  });

  final bool enabled;
  final String revealLabel;
  final ValueChanged<_CollaborationAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_CollaborationAction>(
      enabled: enabled,
      tooltip: kLabelMoreOptions,
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: onSelected,
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: _CollaborationAction.reveal,
              child: Text(revealLabel),
            ),
            const PopupMenuItem(
              value: _CollaborationAction.openInEditor,
              child: Text(kLabelOpenInEditor),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: _CollaborationAction.resetWorkspace,
              child: Text(
                kLabelResetWorkspace,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
    );
  }
}

class _GitPanel extends StatelessWidget {
  const _GitPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerLow.withValues(alpha: 0.55),
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.25),
          ),
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
      ),
    );
  }
}

class _GitSidebarHeader extends StatelessWidget {
  const _GitSidebarHeader({
    required this.status,
    required this.branches,
    required this.busy,
    required this.onBranchSelected,
    required this.onCreateBranch,
  });

  final GitStatus status;
  final List<String> branches;
  final bool busy;
  final ValueChanged<String> onBranchSelected;
  final VoidCallback onCreateBranch;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GitBranchSwitcher(
            branches: branches,
            currentBranch: status.branch,
            busy: busy,
            onBranchSelected: onBranchSelected,
            onCreateBranch: onCreateBranch,
          ),
          if (status.remoteUrl != null) ...[
            kVSpacer5,
            Text(
              status.remoteUrl!,
              style: textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _CommitterLine extends StatelessWidget {
  const _CommitterLine({required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final displayName = name?.trim();
    final isConfigured = displayName != null && displayName.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                isConfigured
                    ? scheme.primaryContainer
                    : scheme.surfaceContainerHigh,
            child: Icon(
              Icons.person_outline_rounded,
              size: 18,
              color: isConfigured ? scheme.onPrimaryContainer : scheme.outline,
            ),
          ),
          kHSpacer10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kLabelGitCommitter,
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isConfigured ? displayName : kMsgGitCommitterNotConfigured,
                  style: textTheme.bodySmall?.copyWith(
                    color: isConfigured ? scheme.onSurface : scheme.outline,
                    fontStyle:
                        isConfigured ? FontStyle.normal : FontStyle.italic,
                    fontWeight:
                        isConfigured ? FontWeight.w600 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isError
                ? scheme.errorContainer.withValues(alpha: 0.35)
                : scheme.secondaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.info_outline,
            size: 18,
            color: isError ? scheme.error : scheme.onSecondaryContainer,
          ),
          kHSpacer10,
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _EmptyChangesState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          kMsgGitNoChanges,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
