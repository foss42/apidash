import 'package:apidash/sync/models/sync_models.dart';
import 'package:apidash/sync/sync_apply.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('expandSyncWritePaths adds collection and environment indexes', () {
    final expanded = expandSyncWritePaths(const [
      SyncFileChange(
        path: 'collections/API/get-users_abcd1234/request.json',
        kind: SyncFileChangeKind.added,
        direction: SyncChangeDirection.outgoing,
      ),
      SyncFileChange(
        path: 'environments/staging.json',
        kind: SyncFileChangeKind.modified,
        direction: SyncChangeDirection.outgoing,
      ),
      SyncFileChange(
        path: 'collections/Old/gone.json',
        kind: SyncFileChangeKind.deleted,
        direction: SyncChangeDirection.outgoing,
      ),
    ]);

    expect(expanded, contains('collections/API/get-users_abcd1234/request.json'));
    expect(expanded, contains('collections/API/request_index.json'));
    expect(expanded, contains('collections/collection_index.json'));
    expect(expanded, contains('environments/staging.json'));
    expect(expanded, contains('environments/environment_index.json'));
    expect(expanded, isNot(contains('collections/Old/gone.json')));
  });

  test('expandSyncWritePaths returns empty for delete-only outgoing', () {
    expect(
      expandSyncWritePaths(const [
        SyncFileChange(
          path: 'collections/API/x.json',
          kind: SyncFileChangeKind.deleted,
          direction: SyncChangeDirection.outgoing,
        ),
      ]),
      isEmpty,
    );
  });
}
