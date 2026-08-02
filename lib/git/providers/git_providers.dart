import 'package:apidash/providers/auto_save.dart';
import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/providers/workspace_lifecycle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/git_models.dart';
import 'git_last_fetched_provider.dart';
import 'git_status_provider.dart';

export 'git_status_provider.dart';

Future<GitStatus> gitFetch(WidgetRef ref) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return GitStatus.empty;

  final git = ref.read(gitServiceProvider);
  await git.fetch(path);
  ref.read(gitLastFetchedProvider.notifier).markFetched(path);
  final status = await git.getStatus(path);
  await _reloadGitStatus(ref);
  return status;
}

Future<void> gitPull(WidgetRef ref) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return;

  await ref.read(autoSaveNotifierProvider.notifier).flushNow(force: true);
  await ref.read(gitServiceProvider).pull(path);
  await reloadWorkspaceFromDisk(ref);
  await _reloadGitStatus(ref);
}

Future<void> refreshGitStatus(WidgetRef ref) => _reloadGitStatus(ref);

Future<void> _reloadGitStatus(WidgetRef ref) async {
  ref.invalidate(gitStatusProvider);
}

Future<void> gitCommitChanges(
  WidgetRef ref, {
  required String message,
  required List<String> paths,
}) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return;
  if (paths.isEmpty) {
    throw StateError('Select at least one change to commit');
  }

  await ref.read(autoSaveNotifierProvider.notifier).flushNow(force: true);

  final git = ref.read(gitServiceProvider);
  await git.stage(path, paths);
  await git.commit(path, message);
  await _reloadGitStatus(ref);
}

Future<void> gitPush(WidgetRef ref) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return;

  await ref.read(autoSaveNotifierProvider.notifier).flushNow(force: true);
  await ref.read(gitServiceProvider).push(path);
  await _reloadGitStatus(ref);
}

Future<void> gitInitRepository(WidgetRef ref) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return;
  await ref.read(gitServiceProvider).initRepository(path);
  await _reloadGitStatus(ref);
}

Future<void> gitSetRemote(WidgetRef ref, String url) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return;
  await ref.read(gitServiceProvider).setRemoteUrl(path, url);
  await _reloadGitStatus(ref);
}

Future<String> gitCloneRepository(
  WidgetRef ref, {
  required String remoteUrl,
  required String parentDirectory,
  required String folderName,
}) async {
  final git = ref.read(gitServiceProvider);
  if (!await git.isGitInstalled()) {
    throw StateError('Git is not installed. Install Git to clone repositories.');
  }
  return git.clone(
    remoteUrl,
    parentDirectory,
    folderName: folderName,
  );
}

Future<void> gitCheckoutBranch(WidgetRef ref, String branch) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return;

  await ref.read(autoSaveNotifierProvider.notifier).flushNow(force: true);
  await ref.read(gitServiceProvider).checkoutBranch(path, branch);
  await reloadWorkspaceFromDisk(ref);
  await _reloadGitStatus(ref);
}

Future<void> gitCreateBranch(WidgetRef ref, String branchName) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return;

  await ref.read(autoSaveNotifierProvider.notifier).flushNow(force: true);
  await ref.read(gitServiceProvider).createBranch(path, branchName);
  await reloadWorkspaceFromDisk(ref);
  await _reloadGitStatus(ref);
}

Future<void> gitRestoreToCommit(WidgetRef ref, String commitHash) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return;

  await ref.read(autoSaveNotifierProvider.notifier).flushNow(force: true);
  await ref.read(gitServiceProvider).restoreToCommit(path, commitHash);
  await reloadWorkspaceFromDisk(ref);
  await _reloadGitStatus(ref);
}

Future<void> gitResetWorkspace(WidgetRef ref) async {
  final path = ref.read(settingsProvider).workspaceFolderPath;
  if (path == null || path.isEmpty) return;

  await ref.read(autoSaveNotifierProvider.notifier).cancelPendingAndWait();
  ref.read(hasUnsavedChangesProvider.notifier).state = false;
  await ref.read(gitServiceProvider).resetHard(path);
  await reloadWorkspaceFromDisk(ref);
  await _reloadGitStatus(ref);
}
