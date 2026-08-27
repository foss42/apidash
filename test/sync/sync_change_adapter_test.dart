import 'package:apidash/git/models/git_models.dart';
import 'package:apidash/sync/models/sync_models.dart';
import 'package:apidash/sync/sync_change_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps sync kinds to git change types', () {
    expect(syncKindToGitChangeType(SyncFileChangeKind.added), GitChangeType.added);
    expect(
      syncKindToGitChangeType(SyncFileChangeKind.modified),
      GitChangeType.modified,
    );
    expect(
      syncKindToGitChangeType(SyncFileChangeKind.deleted),
      GitChangeType.deleted,
    );
  });

  test('converts sync changes for shared UI tree', () {
    const changes = [
      SyncFileChange(
        path: 'collections/a.json',
        kind: SyncFileChangeKind.added,
        direction: SyncChangeDirection.outgoing,
      ),
      SyncFileChange(
        path: 'environments/global.json',
        kind: SyncFileChangeKind.modified,
        direction: SyncChangeDirection.incoming,
      ),
    ];

    final gitChanges = syncChangesToGitChanges(changes);
    expect(gitChanges, hasLength(2));
    expect(gitChanges[0].path, 'collections/a.json');
    expect(gitChanges[0].type, GitChangeType.added);
    expect(gitChanges[1].path, 'environments/global.json');
    expect(gitChanges[1].type, GitChangeType.modified);

    final byPath = syncChangesByPath(changes);
    expect(byPath.keys, {'collections/a.json', 'environments/global.json'});
    expect(byPath['collections/a.json']!.isIncoming, isFalse);
  });
}
