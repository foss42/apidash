import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'git_remote_types.dart';

/// Local Git operations via the system `git` executable on PATH.
/// Works with any remote (GitHub, GitLab, self-hosted) once the user configures `git remote`.
class LocalGitAdapter {
  LocalGitAdapter(this.repoRoot);

  final String repoRoot;

  String get _root => p.normalize(p.absolute(repoRoot));

  static Future<ProcessResult> _git(
    List<String> args, {
    required String workingDirectory,
    bool throwOnFailure = true,
  }) async {
    final result = await Process.run(
      'git',
      args,
      workingDirectory: workingDirectory,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    if (throwOnFailure && result.exitCode != 0) {
      final err = '${result.stderr}${result.stdout}'.trim();
      throw ProcessException(
        'git',
        args,
        err.isEmpty ? 'Command failed (exit ${result.exitCode})' : err,
        result.exitCode,
      );
    }
    return result;
  }

  /// Whether [path] is inside a Git working tree (`git` on PATH required).
  static Future<bool> isGitDirectory(String path) async {
    final dir = p.normalize(p.absolute(path.trim()));
    if (!Directory(dir).existsSync()) return false;
    final r = await Process.run(
      'git',
      const ['rev-parse', '--is-inside-work-tree'],
      workingDirectory: dir,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    return r.exitCode == 0 && r.stdout.toString().trim() == 'true';
  }

  Future<void> _ensureGitRepo() async {
    if (!await isGitDirectory(_root)) {
      throw GitSyncRemoteException('Not a Git repository: $_root');
    }
  }

  Future<ProcessResult> _runGit(List<String> args) =>
      _git(args, workingDirectory: _root);

  /// Initializes a new repository at [repoRoot] (directory must exist).
  static Future<LocalGitAdapter> init(
    String repoRoot, {
    String initialBranch = 'main',
  }) async {
    final root = p.normalize(p.absolute(repoRoot));
    final dir = Directory(root);
    if (!dir.existsSync()) {
      throw GitSyncRemoteException('Directory does not exist: $root');
    }
    if (await isGitDirectory(root)) {
      return LocalGitAdapter(root);
    }
    try {
      await _git(
        ['init', '-b', initialBranch],
        workingDirectory: root,
      );
    } on ProcessException catch (e) {
      throw GitSyncRemoteException('git init failed: ${e.message}');
    }
    return LocalGitAdapter(root);
  }

  Future<String> getBranchHeadSha(String branch) async {
    await _ensureGitRepo();
    try {
      final pr = await _runGit(['rev-parse', branch]);
      return pr.stdout.toString().trim();
    } on ProcessException catch (e) {
      throw GitSyncRemoteException(e.message, e.errorCode);
    }
  }

  Future<PullResult> pullCollectionAtBranchHead({required String branch}) async {
    final sha = await getBranchHeadSha(branch);
    final files = await readCollectionFilesAtRevision(sha);
    return PullResult(commitSha: sha, files: files);
  }

  Future<PullResult> pullCollectionAtCommit({required String commitSha}) async {
    await _ensureGitRepo();
    final files = await readCollectionFilesAtRevision(commitSha);
    return PullResult(commitSha: commitSha, files: files);
  }

  /// Reads `collection.json`, `environments.json`, and `requests/*.json` at [revision].
  Future<Map<String, String>> readCollectionFilesAtRevision(String revision) async {
    await _ensureGitRepo();
    final pr = await _runGit(
      ['ls-tree', '-r', '--name-only', revision],
    );
    final names = LineSplitter.split(pr.stdout.toString())
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .where(_isTrackedCollectionPath)
        .toList();

    final out = <String, String>{};
    for (final path in names) {
      try {
        final show = await _runGit(['show', '$revision:$path']);
        out[path] = show.stdout.toString();
      } on ProcessException catch (e) {
        throw GitSyncRemoteException(
          'Failed to read $path at $revision: ${e.message}',
          e.errorCode,
        );
      }
    }
    return out;
  }

  bool _isTrackedCollectionPath(String path) {
    if (path == '.gitignore' ||
        path == 'collection.json' ||
        path == 'environments.json') {
      return true;
    }
    return path.startsWith('requests/') && path.endsWith('.json');
  }

  /// Writes [files] into the working tree, stages them, and commits. Returns new HEAD SHA.
  Future<String> commitCollectionFiles({
    required String branch,
    required Map<String, String> files,
    required String commitMessage,
  }) async {
    await _ensureGitRepo();
    for (final e in files.entries) {
      final file = File(p.join(_root, e.key));
      await file.parent.create(recursive: true);
      await file.writeAsString(e.value);
    }

    if (files.isEmpty) {
      return getBranchHeadSha(branch);
    }

    final paths = files.keys.toList();
    await _runGit(['add', '--'] + paths);

    final staged = await _runGit(['diff', '--cached', '--stat']);
    if (staged.stdout.toString().trim().isEmpty) {
      return getBranchHeadSha(branch);
    }

    try {
      await _runGit(['commit', '-m', commitMessage]);
    } on ProcessException catch (e) {
      throw GitSyncRemoteException(e.message, e.errorCode);
    }

    return getBranchHeadSha(branch);
  }

  /// `git pull` for [branch] when a remote exists; no-op failure if no remote.
  Future<void> pullWithFfOnly(String branch) async {
    await _ensureGitRepo();
    final remotes = await _runGit(['remote']);
    if (remotes.stdout.toString().trim().isEmpty) return;
    try {
      await _runGit(['pull', '--ff-only', 'origin', branch]);
    } on ProcessException catch (e) {
      throw GitSyncRemoteException(
        'git pull failed: ${e.message}',
        e.errorCode,
      );
    }
  }

  /// Pushes [branch] to `origin` if configured.
  Future<void> pushIfRemote(String branch) async {
    await _ensureGitRepo();
    final remotes = await _runGit(['remote']);
    if (remotes.stdout.toString().trim().isEmpty) return;
    try {
      await _runGit(['push', '-u', 'origin', branch]);
    } on ProcessException catch (e) {
      throw GitSyncRemoteException(
        'git push failed (add a remote with `git remote add origin <url>`): ${e.message}',
        e.errorCode,
      );
    }
  }

  Future<List<CommitInfo>> getCommitHistory({
    required String branch,
    int perPage = 30,
  }) async {
    await _ensureGitRepo();
    final pr = await _runGit(
      [
        'log',
        branch,
        '-n',
        '$perPage',
        '--format=%H%x1f%s%x1f%an%x1f%ae%x1f%ai%x1f%T',
      ],
    );
    final lines = LineSplitter.split(pr.stdout.toString())
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final out = <CommitInfo>[];
    for (final line in lines) {
      final parts = line.split('\x1f');
      if (parts.length < 6) continue;
      final sha = parts[0];
      final message = parts[1];
      final authorName = parts[2];
      final authorEmail = parts[3];
      final date = DateTime.tryParse(parts[4]);
      final treeSha = parts[5];
      out.add(
        CommitInfo(
          sha: sha,
          message: message,
          authorName: authorName,
          authorEmail: authorEmail,
          date: date,
          treeSha: treeSha,
        ),
      );
    }
    return out;
  }

  Future<List<BranchInfo>> listBranches() async {
    await _ensureGitRepo();
    final pr = await _runGit(
      [
        'for-each-ref',
        '--format=%(refname:short)%x09%(objectname)',
        'refs/heads/',
      ],
    );
    final lines = LineSplitter.split(pr.stdout.toString())
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final out = <BranchInfo>[];
    for (final line in lines) {
      final idx = line.lastIndexOf('\t');
      if (idx <= 0) continue;
      final name = line.substring(0, idx);
      final sha = line.substring(idx + 1);
      if (name.isEmpty || sha.isEmpty) continue;
      out.add(BranchInfo(name: name, sha: sha));
    }
    return out;
  }

  Future<void> createBranch({
    required String branchName,
    required String fromSha,
  }) async {
    await _ensureGitRepo();
    try {
      await _runGit(['branch', branchName, fromSha]);
    } on ProcessException catch (e) {
      throw GitSyncRemoteException(e.message, e.errorCode);
    }
  }

  Future<void> deleteBranch(String branchName) async {
    await _ensureGitRepo();
    try {
      await _runGit(['branch', '-D', branchName]);
    } on ProcessException catch (e) {
      throw GitSyncRemoteException(e.message, e.errorCode);
    }
  }

  Future<bool> hasRemotes() async {
    await _ensureGitRepo();
    final pr = await _runGit(['remote']);
    return pr.stdout.toString().trim().isNotEmpty;
  }

  /// Output of `git remote -v` (empty if no remotes).
  Future<String> remotesVerbose() async {
    await _ensureGitRepo();
    final pr = await _runGit(['remote', '-v']);
    return pr.stdout.toString().trimRight();
  }

  /// `git remote get-url <name>` or null if missing / error.
  Future<String?> remoteFetchUrl(String remoteName) async {
    await _ensureGitRepo();
    final pr = await _git(
      ['remote', 'get-url', remoteName],
      workingDirectory: _root,
      throwOnFailure: false,
    );
    if (pr.exitCode != 0) return null;
    final url = pr.stdout.toString().trim();
    return url.isEmpty ? null : url;
  }

  /// One-line branch + short status for the CLI tab.
  Future<String> statusShortBranch() async {
    await _ensureGitRepo();
    final pr = await _runGit(
      ['status', '--short', '--branch'],
    );
    return pr.stdout.toString().trimRight();
  }
}
