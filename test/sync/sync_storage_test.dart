import 'dart:io';

import 'package:apidash/sync/storage/sync_storage.dart';
import 'package:apidash/sync/sync_scan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('apidash_sync_storage_');
  });

  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  test('getOrCreateWorkspace persists identity', () async {
    final storage = SyncStorage(root.path);
    final created = await storage.getOrCreateWorkspace(name: 'Demo');
    expect(created.id, startsWith('ws-'));
    expect(created.name, 'Demo');

    final again = await storage.getOrCreateWorkspace(name: 'Ignored');
    expect(again.id, created.id);
    expect(again.name, 'Demo');
    expect(await storage.readWorkspace(), isNotNull);
  });

  test('sync state baseline round-trip and clear', () async {
    final storage = SyncStorage(root.path);
    expect(await storage.hasSyncedBefore(), isFalse);

    await storage.saveSyncState(
      const SyncState(
        lastSyncAt: '2026-01-01T00:00:00Z',
        peerDisplayName: 'Phone',
        baseline: {'collections/a.json': 'sha256:x'},
      ),
    );

    final state = await storage.readSyncState();
    expect(state, isNotNull);
    expect(state!.hasBaseline, isTrue);
    expect(state.peerDisplayName, 'Phone');
    expect(state.baseline, {'collections/a.json': 'sha256:x'});
    expect(await storage.hasSyncedBefore(), isTrue);

    await storage.clearSyncState();
    expect(await storage.readSyncState(), isNull);
    expect(await storage.hasSyncedBefore(), isFalse);
  });

  test('wipePhoneWorkspaceData clears collections/envs and sync state', () async {
    Directory(p.join(root.path, 'collections', 'API')).createSync(recursive: true);
    File(p.join(root.path, 'collections', 'API', 'x.json')).writeAsStringSync('{}');
    Directory(p.join(root.path, 'environments')).createSync(recursive: true);
    File(p.join(root.path, 'environments', 'global.json')).writeAsStringSync('{}');

    final storage = SyncStorage(root.path);
    await storage.saveSyncState(
      const SyncState(baseline: {'collections/API/x.json': 'h'}),
    );

    await wipePhoneWorkspaceData(root.path);

    expect(Directory(p.join(root.path, 'collections')).existsSync(), isTrue);
    expect(Directory(p.join(root.path, 'environments')).existsSync(), isTrue);
    expect(
      Directory(p.join(root.path, 'collections', 'API')).existsSync(),
      isFalse,
    );
    expect(await storage.readSyncState(), isNull);
  });

  test('adoptWorkspaceIdentity writes workspace.json', () async {
    await adoptWorkspaceIdentity(
      root.path,
      identity: const WorkspaceIdentity(id: 'ws-peer', name: 'From Desktop'),
    );
    final identity = await SyncStorage(root.path).readWorkspace();
    expect(identity?.id, 'ws-peer');
    expect(identity?.name, 'From Desktop');
  });
}
