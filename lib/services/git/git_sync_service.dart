import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/providers/environment_providers.dart';
import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash/services/file_system_handler.dart';
import 'package:apidash/services/git/git_remote_types.dart';
import 'package:apidash/services/git/local_git_adapter.dart';
import 'package:apidash/services/git_collection_serializer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

class GitSyncNotConnectedException implements Exception {
  GitSyncNotConnectedException(this.message);
  final String message;
}

class GitSyncConflictException implements Exception {
  GitSyncConflictException({
    required this.expectedSha,
    required this.remoteSha,
  });

  final String? expectedSha;
  final String remoteSha;
}

class GitSyncService {
  GitSyncService(this.ref);

  final WidgetRef ref;

  final GitCollectionSerializer _serializer = const GitCollectionSerializer();
  static const String _repoReadmePath = 'README.md';

  LocalGitAdapter _adapter(GitConnectionModel git) =>
      LocalGitAdapter(git.localRepoPath);

  Future<PushPreview> getPushPreview({
    required String branch,
  }) async {
    await ref.read(collectionStateNotifierProvider.notifier).saveData();
    final git = _getActiveGitConnection();
    final adapter = _adapter(git);
    final localFiles = await _buildFilesFromLocalSnapshot();

    Map<String, String> remoteFiles = const <String, String>{};
    try {
      final pull = await adapter.pullCollectionAtBranchHead(branch: branch);
      remoteFiles = pull.files;
    } on GitSyncRemoteException {
      remoteFiles = const <String, String>{};
    }

    final changes = <PushFileChange>[];
    final allPaths = <String>{...localFiles.keys, ...remoteFiles.keys}.toList()
      ..sort();
    for (final path in allPaths) {
      final local = localFiles[path];
      final remote = remoteFiles[path];
      if (remote == null && local != null) {
        changes.add(PushFileChange(path: path, type: PushChangeType.added));
        continue;
      }
      if (remote != null && local == null) {
        changes.add(PushFileChange(path: path, type: PushChangeType.deleted));
        continue;
      }
      if (remote != null && local != null && remote != local) {
        changes.add(PushFileChange(path: path, type: PushChangeType.modified));
      }
    }

    return PushPreview(changes: changes);
  }

  CollectionModel _getActiveCollection() {
    final activeId = ref.read(activeCollectionIdStateProvider);
    final collections = ref.read(collectionsStateProvider);
    if (activeId == null || !collections.containsKey(activeId)) {
      throw GitSyncNotConnectedException('No active collection found');
    }
    return collections[activeId]!;
  }

  GitConnectionModel _getActiveGitConnection() {
    final c = _getActiveCollection();
    final git = c.gitConnection;
    if (git == null || git.localRepoPath.isEmpty) {
      throw GitSyncNotConnectedException(
        'Collection is not connected to a local Git repository',
      );
    }
    return git;
  }

  Future<Map<String, String>> _buildFilesFromLocalSnapshot() async {
    final activeCollection = _getActiveCollection();
    final collectionId = activeCollection.id;

    final requestOrder = (await fileSystemHandler.getCollectionRequestIds(collectionId) as List?)
            ?.whereType<String>()
            .toList() ??
        const <String>[];

    final requestsById = <String, RequestModel>{};
    for (final requestId in requestOrder) {
      final raw = await fileSystemHandler.getCollectionRequestModel(collectionId, requestId);
      if (raw is! Map) continue;
      try {
        final json = raw.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        requestsById[requestId] = RequestModel.fromJson(json);
      } catch (_) {}
    }

    final environmentOrder = (fileSystemHandler.getEnvironmentIds() as List?)
            ?.whereType<String>()
            .toList() ??
        const <String>[];
    final environmentsById = <String, EnvironmentModel>{};
    for (final envId in environmentOrder) {
      final raw = fileSystemHandler.getEnvironment(envId);
      if (raw is! Map) continue;
      try {
        final json = raw.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        environmentsById[envId] = EnvironmentModel.fromJson(json);
      } catch (_) {}
    }

    final collectionMeta = await fileSystemHandler.getCollectionMeta(collectionId);
    String collectionName = activeCollection.name;
    String collectionDescription = activeCollection.description;
    String? activeEnvironmentId = ref.read(activeEnvironmentIdStateProvider);
    if (collectionMeta is Map) {
      final meta = collectionMeta.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      collectionName = (meta['name'] as String?) ?? collectionName;
      collectionDescription =
          (meta['description'] as String?) ?? collectionDescription;
      activeEnvironmentId =
          (meta['activeEnvironmentId'] as String?) ?? activeEnvironmentId;
    }

    final collectionModel = CollectionModel(
      id: collectionId,
      name: collectionName,
      description: collectionDescription,
      requestIds: requestOrder,
      activeEnvironmentId: activeEnvironmentId,
      gitConnection: null,
    );

    final files = _serializer.toGitFiles(
      collection: collectionModel,
      requestsById: requestsById,
      requestOrder: requestOrder,
      environmentsById: environmentsById,
      environmentOrder: environmentOrder,
      activeEnvironmentId: activeEnvironmentId,
    );
    return files.files;
  }

  /// Creates a new Git repo at [localRepoPath] (or uses an existing one), then pushes the collection.
  Future<void> connectAndPushActiveCollection({
    required String localRepoPath,
    required String branch,
    required bool initRepoIfNeeded,
    String? commitMessage,
  }) async {
    final normalized = p.normalize(p.absolute(localRepoPath.trim()));

    if (initRepoIfNeeded) {
      await LocalGitAdapter.init(normalized, initialBranch: branch);
    }

    final displayName = p.basename(normalized);
    final gitConnection = GitConnectionModel(
      localRepoPath: normalized,
      repoDisplayName: displayName,
      branch: branch,
      lastSyncedCommitSha: null,
      lastPushedAt: null,
      lastPulledAt: null,
    );

    await ref
        .read(collectionStateNotifierProvider.notifier)
        .setActiveCollectionGitConnection(gitConnection);

    await pushActiveCollection(
      branch: branch,
      commitMessage: commitMessage ?? 'Initial commit',
    );
  }

  /// Imports from an existing local clone.
  Future<List<MalformedRequestFile>> connectAndImportActiveCollection({
    required String localRepoPath,
    required String branch,
  }) async {
    final normalized = p.normalize(p.absolute(localRepoPath.trim()));
    if (!await LocalGitAdapter.isGitDirectory(normalized)) {
      throw GitSyncNotConnectedException(
        'Not a Git repository (run `git init` or clone a repo first): $normalized',
      );
    }
    final displayName = p.basename(normalized);

    final gitConnection = GitConnectionModel(
      localRepoPath: normalized,
      repoDisplayName: displayName,
      branch: branch,
      lastSyncedCommitSha: null,
      lastPushedAt: null,
      lastPulledAt: null,
    );

    await ref
        .read(collectionStateNotifierProvider.notifier)
        .setActiveCollectionGitConnection(gitConnection);

    return pullLatestToActiveCollection(branch: branch);
  }

  Future<void> pushActiveCollection({
    required String branch,
    String? commitMessage,
  }) async {
    await ref.read(collectionStateNotifierProvider.notifier).saveData();
    final git = _getActiveGitConnection();
    final adapter = _adapter(git);

    String? remoteHead;
    try {
      remoteHead = await adapter.getBranchHeadSha(branch);
    } on GitSyncRemoteException {
      remoteHead = null;
    }

    if (git.lastSyncedCommitSha != null &&
        remoteHead != null &&
        git.lastSyncedCommitSha != remoteHead) {
      throw GitSyncConflictException(
        expectedSha: git.lastSyncedCommitSha,
        remoteSha: remoteHead,
      );
    }

    final preview = await getPushPreview(branch: branch);
    if (preview.changes.isEmpty && remoteHead != null) {
      final updatedGit = git.copyWith(
        branch: branch,
        lastSyncedCommitSha: remoteHead,
      );
      await ref
          .read(collectionStateNotifierProvider.notifier)
          .setActiveCollectionGitConnection(updatedGit);
      return;
    }

    var files = await _buildFilesFromLocalSnapshot();
    final isInitialRepoCommit = remoteHead == null;
    if (isInitialRepoCommit) {
      files = _withBootstrapRepoFiles(files);
    }

    final newCommitSha = await adapter.commitCollectionFiles(
      branch: branch,
      files: files,
      commitMessage: commitMessage ?? 'Update API Dash collection',
    );

    await adapter.pushIfRemote(branch);

    final updatedGit = git.copyWith(
      lastSyncedCommitSha: newCommitSha,
      lastPushedAt: DateTime.now(),
    );
    await ref
        .read(collectionStateNotifierProvider.notifier)
        .setActiveCollectionGitConnection(updatedGit);
  }

  Map<String, String> _withBootstrapRepoFiles(Map<String, String> files) {
    final out = Map<String, String>.from(files);
    out[_repoReadmePath] = _initialReadmeContent;
    return out;
  }

  static const String _initialReadmeContent = '''
# API Dash collection

Plain JSON files in this folder are produced by API Dash. Use any Git host (GitHub, GitLab, etc.) by adding a remote:

`git remote add origin <url>`
''';

  Future<List<MalformedRequestFile>> pullLatestToActiveCollection({
    required String branch,
    String? commitMessage,
  }) async {
    final git = _getActiveGitConnection();
    final adapter = _adapter(git);
    await adapter.pullWithFfOnly(branch);

    final pull = await adapter.pullCollectionAtBranchHead(branch: branch);

    final activeCollection = _getActiveCollection();
    // Local folder id (slug) is authoritative; remote collection.json may omit id or use a legacy UUID.
    final import = _serializer.fromGitFiles(
      files: pull.files,
      fallbackCollectionId: activeCollection.id,
      fallbackCollectionName: activeCollection.name,
    );

    final malformed = await ref
        .read(collectionStateNotifierProvider.notifier)
        .replaceActiveCollectionFromGit(
          remoteCollection: import.collection,
          requestOrder: import.collection.requestIds,
          requestsById: import.requestsById,
          malformedRequests: import.malformedRequests,
        );

    await ref.read(environmentsStateNotifierProvider.notifier).importEnvironmentsFromGit(
          environmentsById: import.environmentsById,
          environmentOrder: import.environmentOrder,
        );

    final remoteActiveEnv = import.collection.activeEnvironmentId;
    if (remoteActiveEnv != null && remoteActiveEnv.isNotEmpty) {
      await ref.read(settingsProvider.notifier).update(
            activeEnvironmentId: remoteActiveEnv,
          );
    }

    final updatedGit = git.copyWith(
      branch: branch,
      lastSyncedCommitSha: pull.commitSha,
      lastPulledAt: DateTime.now(),
    );
    await ref
        .read(collectionStateNotifierProvider.notifier)
        .setActiveCollectionGitConnection(updatedGit);

    return malformed;
  }

  Future<List<MalformedRequestFile>> rollbackActiveCollectionToCommit({
    required String commitSha,
    required String branch,
  }) async {
    final git = _getActiveGitConnection();
    final adapter = _adapter(git);
    final pull = await adapter.pullCollectionAtCommit(commitSha: commitSha);

    final activeCollection = _getActiveCollection();
    // Local folder id (slug) is authoritative; remote collection.json may omit id or use a legacy UUID.
    final import = _serializer.fromGitFiles(
      files: pull.files,
      fallbackCollectionId: activeCollection.id,
      fallbackCollectionName: activeCollection.name,
    );

    final malformed = await ref
        .read(collectionStateNotifierProvider.notifier)
        .replaceActiveCollectionFromGit(
          remoteCollection: import.collection,
          requestOrder: import.collection.requestIds,
          requestsById: import.requestsById,
          malformedRequests: import.malformedRequests,
        );

    await ref.read(environmentsStateNotifierProvider.notifier).importEnvironmentsFromGit(
          environmentsById: import.environmentsById,
          environmentOrder: import.environmentOrder,
        );

    final remoteActiveEnv = import.collection.activeEnvironmentId;
    if (remoteActiveEnv != null && remoteActiveEnv.isNotEmpty) {
      await ref.read(settingsProvider.notifier).update(
            activeEnvironmentId: remoteActiveEnv,
          );
    }

    final updatedGit = git.copyWith(
      branch: branch,
      lastSyncedCommitSha: pull.commitSha,
      lastPulledAt: DateTime.now(),
    );
    await ref
        .read(collectionStateNotifierProvider.notifier)
        .setActiveCollectionGitConnection(updatedGit);

    return malformed;
  }

  Future<({String? headSha, List<CommitInfo> commits})> loadHistory({
    required String branch,
  }) async {
    final git = _getActiveGitConnection();
    final adapter = _adapter(git);
    String? headSha;
    try {
      headSha = await adapter.getBranchHeadSha(branch);
    } on GitSyncRemoteException {
      return (headSha: null, commits: const <CommitInfo>[]);
    }
    final commits = await adapter.getCommitHistory(branch: branch, perPage: 30);
    return (headSha: headSha, commits: commits);
  }

  Future<List<BranchInfo>> loadBranches() async {
    final git = _getActiveGitConnection();
    final adapter = _adapter(git);
    return adapter.listBranches();
  }

  Future<void> createBranch({
    required String fromBranch,
    required String newBranchName,
  }) async {
    final git = _getActiveGitConnection();
    final adapter = _adapter(git);
    final headSha = await adapter.getBranchHeadSha(fromBranch);
    await adapter.createBranch(
      branchName: newBranchName,
      fromSha: headSha,
    );
  }

  Future<void> deleteBranch(String branchName) async {
    final git = _getActiveGitConnection();
    final adapter = _adapter(git);
    await adapter.deleteBranch(branchName);
  }
}

enum PushChangeType { added, modified, deleted }

class PushFileChange {
  const PushFileChange({
    required this.path,
    required this.type,
  });

  final String path;
  final PushChangeType type;
}

class PushPreview {
  const PushPreview({
    required this.changes,
  });

  final List<PushFileChange> changes;

  int get addedCount =>
      changes.where((c) => c.type == PushChangeType.added).length;
  int get modifiedCount =>
      changes.where((c) => c.type == PushChangeType.modified).length;
  int get deletedCount =>
      changes.where((c) => c.type == PushChangeType.deleted).length;
}
