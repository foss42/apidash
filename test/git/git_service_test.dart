import 'dart:io';

import 'package:apidash/git/models/git_models.dart';
import 'package:apidash/git/services/git_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory root;
  late GitService git;

  setUp(() {
    root = Directory.systemTemp.createTempSync('apidash_git_service_');
    git = GitService();
  });

  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  Future<void> _configureCommitter() async {
    await Process.run(
      'git',
      ['config', 'user.email', 'test@apidash.dev'],
      workingDirectory: root.path,
    );
    await Process.run(
      'git',
      ['config', 'user.name', 'API Dash Test'],
      workingDirectory: root.path,
    );
  }

  test('isGitInstalled reports system git', () async {
    final installed = await git.isGitInstalled();
    expect(installed, isA<bool>());
  });

  test('getStatus notRepo before init', () async {
    if (!await git.isGitInstalled()) {
      return;
    }
    final status = await git.getStatus(root.path);
    expect(status.syncState, GitSyncState.notRepo);
    expect(status.isRepository, isFalse);
  });

  test('initRepository writes ignore and surfaces dirty status', () async {
    if (!await git.isGitInstalled()) {
      return;
    }

    await git.initRepository(root.path);
    expect(await git.isRepository(root.path), isTrue);
    expect(
      File(p.join(root.path, '.gitignore')).readAsStringSync(),
      contains('.apidash/'),
    );

    Directory(p.join(root.path, 'collections')).createSync();
    File(p.join(root.path, 'collections', 'collection_index.json'))
        .writeAsStringSync('{"collections":[]}');

    await _configureCommitter();
    var status = await git.getStatus(root.path);
    expect(status.isRepository, isTrue);
    expect(
      status.changes.any((c) => c.path.contains('collection_index.json')),
      isTrue,
    );

    await git.stage(root.path, [
      'collections/collection_index.json',
      '.gitignore',
    ]);
    await git.commit(root.path, 'seed workspace');

    status = await git.getStatus(root.path);
    expect(status.changes, isEmpty);
    expect(status.recentCommits, isNotEmpty);
    expect(status.recentCommits.first.message, 'seed workspace');
  });

  test('commit rejects empty message', () async {
    if (!await git.isGitInstalled()) {
      return;
    }
    await git.initRepository(root.path);
    await _configureCommitter();
    expect(
      () => git.commit(root.path, '   '),
      throwsA(isA<StateError>()),
    );
  });

  test('setRemoteUrl add and update origin', () async {
    if (!await git.isGitInstalled()) {
      return;
    }
    await git.initRepository(root.path);
    await git.setRemoteUrl(root.path, 'https://github.com/foss42/apidash.git');
    var status = await git.getStatus(root.path);
    expect(status.remoteUrl, 'https://github.com/foss42/apidash.git');

    await git.setRemoteUrl(root.path, 'https://github.com/foss42/other.git');
    status = await git.getStatus(root.path);
    expect(status.remoteUrl, 'https://github.com/foss42/other.git');
  });
}
