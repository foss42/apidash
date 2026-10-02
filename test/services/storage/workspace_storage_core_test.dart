import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/services/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../providers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpWorkspaceStorage();
  });

  group('Workspace bootstrap (replaces Hive box init)', () {
    test('seeds default collection, global env, and history dirs', () {
      final collections = workspaceStorage.getCollectionsIndex();
      expect(collections, isNotEmpty);
      expect(collections.first.name, kDefaultCollectionName);

      final collection = workspaceStorage.getCollection(kDefaultCollectionName);
      expect(collection, isNotNull);
      expect(collection![kWorkspaceRequestsKey], isA<List>());

      expect(workspaceStorage.getEnvironmentIds(), [kGlobalEnvironmentId]);
      expect(workspaceStorage.getEnvironment(kGlobalEnvironmentId), isNotNull);

      expect(
        Directory(
          p.join(workspaceStorage.rootPath, kWorkspaceHistoryDir),
        ).existsSync(),
        isTrue,
      );
    });

    test('does not reseed after the user empties the collections index',
        () async {
      await workspaceStorage.setCollectionsIndex([]);
      await workspaceStorage.deleteCollection(kDefaultCollectionName);

      final reopened = await initWorkspaceStorage(
        true,
        workspaceStorage.rootPath,
        createIfMissing: true,
      );
      expect(reopened, isTrue);
      expect(workspaceStorage.getCollectionsIndex(), isEmpty);
    });

    test('opens an explicit selected folder path (workspace selector flow)',
        () async {
      final selected = await Directory.systemTemp.createTemp(
        'apidash_selected_workspace_',
      );
      addTearDown(() async {
        if (await selected.exists()) {
          await selected.delete(recursive: true);
        }
      });

      final opened = await initWorkspaceStorage(
        true,
        selected.path,
        createIfMissing: true,
      );
      expect(opened, isTrue);
      expect(workspaceStorage.rootPath, selected.path);
      expect(
        Directory(p.join(selected.path, kWorkspaceCollectionsDir)).existsSync(),
        isTrue,
      );
      expect(
        Directory(p.join(selected.path, kWorkspaceEnvironmentsDir)).existsSync(),
        isTrue,
      );
    });
  });

  group('Collections + requests (Hive data box parity)', () {
    test('persists and loads a request model round-trip', () async {
      const requestId = 'req-get';
      await workspaceStorage.setCollection(kDefaultCollectionName, {
        kWorkspaceCollectionNameKey: kDefaultCollectionName,
        kWorkspaceRequestsKey: [
          {'id': requestId, 'name': 'Get users'},
        ],
      });
      await workspaceStorage.setRequestModel(
        kDefaultCollectionName,
        requestId,
        {
          'id': requestId,
          'name': 'Get users',
          'httpRequestModel': {
            'method': 'get',
            'url': 'https://api.apidash.dev/users',
          },
        },
      );

      expect(workspaceStorage.getIds(kDefaultCollectionName), [requestId]);
      expect(
        workspaceStorage.requestExistsOnDisk(
          kDefaultCollectionName,
          requestId,
        ),
        isTrue,
      );

      final loaded = workspaceStorage.getRequestModel(
        kDefaultCollectionName,
        requestId,
      );
      expect(loaded?['name'], 'Get users');
      expect(
        (loaded?['httpRequestModel'] as Map)['url'],
        'https://api.apidash.dev/users',
      );
    });

    test('deletes request storage when setRequestModel gets null', () async {
      const requestId = 'req-delete';
      await workspaceStorage.setRequestModel(
        kDefaultCollectionName,
        requestId,
        {'id': requestId, 'name': 'Temp'},
      );
      expect(
        workspaceStorage.requestExistsOnDisk(
          kDefaultCollectionName,
          requestId,
        ),
        isTrue,
      );

      await workspaceStorage.setRequestModel(
        kDefaultCollectionName,
        requestId,
        null,
      );
      expect(
        workspaceStorage.requestExistsOnDisk(
          kDefaultCollectionName,
          requestId,
        ),
        isFalse,
      );
    });

    test('removeUnused deletes orphan request directories', () async {
      const keptId = 'kept';
      const orphanId = 'orphan';
      await workspaceStorage.setRequestModel(
        kDefaultCollectionName,
        keptId,
        {'id': keptId, 'name': 'Kept'},
      );
      await workspaceStorage.setRequestModel(
        kDefaultCollectionName,
        orphanId,
        {'id': orphanId, 'name': 'Orphan'},
      );

      await workspaceStorage.removeUnused(
        kDefaultCollectionName,
        requestIds: {keptId},
      );

      expect(
        workspaceStorage.requestExistsOnDisk(kDefaultCollectionName, keptId),
        isTrue,
      );
      expect(
        workspaceStorage.requestExistsOnDisk(kDefaultCollectionName, orphanId),
        isFalse,
      );
    });
  });

  group('Environments (Hive environment box parity)', () {
    test('persists environment values and deletes custom envs', () async {
      const envId = 'staging';
      await workspaceStorage.setEnvironment(envId, {
        'id': envId,
        'name': 'Staging',
        'values': [
          {
            'key': 'BASE_URL',
            'value': 'https://staging.example',
            'enabled': true,
          },
        ],
      });
      await workspaceStorage.setEnvironmentIds([kGlobalEnvironmentId, envId]);

      final loaded = workspaceStorage.getEnvironment(envId);
      expect(loaded?['name'], 'Staging');
      expect((loaded?['values'] as List).first['key'], 'BASE_URL');
      expect(workspaceStorage.getEnvironmentIds(), contains(envId));

      await workspaceStorage.deleteEnvironment(envId);
      await workspaceStorage.setEnvironmentIds([kGlobalEnvironmentId]);
      expect(workspaceStorage.getEnvironment(envId), isNull);
      expect(workspaceStorage.getEnvironmentIds(), [kGlobalEnvironmentId]);
    });
  });

  group('History (Hive history box parity)', () {
    test('persists history meta and request payloads', () async {
      const historyId = 'hist-1';
      await workspaceStorage.setHistoryMeta(historyId, {
        'id': historyId,
        'name': 'GET /users',
      });
      await workspaceStorage.setHistoryRequest(historyId, {
        'id': historyId,
        'httpRequestModel': {
          'method': 'get',
          'url': 'https://api.apidash.dev/users',
        },
      });

      expect(workspaceStorage.getHistoryMeta(historyId)?['name'], 'GET /users');
      final request = await workspaceStorage.getHistoryRequest(historyId);
      expect(request, isA<Map>());
      expect((request as Map)['id'], historyId);

      await workspaceStorage.clearAllHistory();
      expect(workspaceStorage.getHistoryMeta(historyId), isNull);
      expect(await workspaceStorage.getHistoryRequest(historyId), isNull);
    });
  });
}
