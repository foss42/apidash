import 'package:apidash/sync/consts.dart';
import 'package:apidash/sync/models/sync_models.dart';
import 'package:apidash/sync/sync_session_compute.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const changeSet = SyncChangeSet(
    incoming: [
      SyncFileChange(
        path: 'collections/in.json',
        kind: SyncFileChangeKind.added,
        direction: SyncChangeDirection.incoming,
      ),
    ],
    outgoing: [
      SyncFileChange(
        path: 'collections/out.json',
        kind: SyncFileChangeKind.modified,
        direction: SyncChangeDirection.outgoing,
      ),
      SyncFileChange(
        path: 'collections/both.json',
        kind: SyncFileChangeKind.modified,
        direction: SyncChangeDirection.outgoing,
      ),
    ],
    overlappingPaths: {'collections/both.json', 'collections/in.json'},
  );

  test('picks changes for send vs receive', () {
    expect(changesForDirection(changeSet, SyncDirectionMode.send), hasLength(2));
    expect(
      changesForDirection(changeSet, SyncDirectionMode.receive),
      hasLength(1),
    );
  });

  test('defaultDirectionMode prefers send when outgoing exists', () {
    expect(defaultDirectionMode(changeSet), SyncDirectionMode.send);
    expect(
      defaultDirectionMode(
        const SyncChangeSet(
          incoming: [
            SyncFileChange(
              path: 'a',
              kind: SyncFileChangeKind.added,
              direction: SyncChangeDirection.incoming,
            ),
          ],
        ),
      ),
      SyncDirectionMode.receive,
    );
  });

  test('overlappingForDirection intersects active paths', () {
    expect(
      overlappingForDirection(changeSet, SyncDirectionMode.send),
      {'collections/both.json'},
    );
    expect(
      overlappingForDirection(changeSet, SyncDirectionMode.receive),
      {'collections/in.json'},
    );
  });

  test('peersPairedBefore requires both baselines', () {
    expect(
      peersPairedBefore(localHadBaseline: true, peerHadBaseline: true),
      isTrue,
    );
    expect(
      peersPairedBefore(localHadBaseline: true, peerHadBaseline: false),
      isFalse,
    );
  });

  test('labels and warnings', () {
    expect(
      directionListTitle(mode: SyncDirectionMode.send, isHost: true),
      kLabelSyncSendingToPhone,
    );
    expect(
      updateButtonLabel(
        mode: SyncDirectionMode.receive,
        isHost: false,
        count: 2,
        updating: false,
      ),
      '$kLabelSyncUpdateFromComputer (2)',
    );
    expect(
      applyButtonLabel(
        mode: SyncSessionMode.workspaceReplace,
        hasWork: true,
      ),
      kLabelSyncSwitchAndSync,
    );
    expect(
      overlapWarningMessage(
        mode: SyncDirectionMode.send,
        overlapping: {'a'},
        isHost: true,
      ),
      contains('Phone also edited'),
    );
    expect(
      directionSummary(changeSet: changeSet, isHost: true),
      'Computer: 2 to send · Phone: 1 to send',
    );
  });
}
