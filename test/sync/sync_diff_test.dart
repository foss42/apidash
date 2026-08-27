import 'package:apidash/sync/models/sync_models.dart';
import 'package:apidash/sync/sync_diff.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('computeSyncChangeSet', () {
    test('empty when all manifests agree', () {
      final changeSet = computeSyncChangeSet(
        baseline: {'collections/a.json': 'h1'},
        local: {'collections/a.json': 'h1'},
        peer: {'collections/a.json': 'h1'},
      );
      expect(changeSet.isEmpty, isTrue);
      expect(changeSet.overlappingPaths, isEmpty);
    });

    test('classifies peer add/modify/delete as incoming', () {
      final changeSet = computeSyncChangeSet(
        baseline: {
          'collections/keep.json': 'h0',
          'collections/gone.json': 'hg',
          'collections/edit.json': 'he',
        },
        local: {
          'collections/keep.json': 'h0',
          'collections/gone.json': 'hg',
          'collections/edit.json': 'he',
        },
        peer: {
          'collections/keep.json': 'h0',
          'collections/edit.json': 'he2',
          'collections/new.json': 'hn',
        },
      );

      expect(
        changeSet.incoming.map((c) => '${c.path}:${c.kind.name}').toSet(),
        {
          'collections/gone.json:deleted',
          'collections/edit.json:modified',
          'collections/new.json:added',
        },
      );
      expect(changeSet.outgoing, isEmpty);
      expect(changeSet.overlappingPaths, isEmpty);
    });

    test('classifies local add/modify/delete as outgoing', () {
      final changeSet = computeSyncChangeSet(
        baseline: {
          'collections/keep.json': 'h0',
          'collections/gone.json': 'hg',
          'collections/edit.json': 'he',
        },
        local: {
          'collections/keep.json': 'h0',
          'collections/edit.json': 'he2',
          'collections/new.json': 'hn',
        },
        peer: {
          'collections/keep.json': 'h0',
          'collections/gone.json': 'hg',
          'collections/edit.json': 'he',
        },
      );

      expect(
        changeSet.outgoing.map((c) => '${c.path}:${c.kind.name}').toSet(),
        {
          'collections/gone.json:deleted',
          'collections/edit.json:modified',
          'collections/new.json:added',
        },
      );
      expect(changeSet.incoming, isEmpty);
    });

    test('marks overlapping when both diverge', () {
      final changeSet = computeSyncChangeSet(
        baseline: {'collections/a.json': 'h0'},
        local: {'collections/a.json': 'hLocal'},
        peer: {'collections/a.json': 'hPeer'},
      );

      expect(changeSet.overlappingPaths, {'collections/a.json'});
      expect(changeSet.incoming, hasLength(1));
      expect(changeSet.outgoing, hasLength(1));
    });

    test('peerHasBaseline false reports local-only changes as outgoing', () {
      final changeSet = computeSyncChangeSet(
        baseline: {'collections/a.json': 'h0'},
        local: {
          'collections/a.json': 'h1',
          'collections/b.json': 'hb',
        },
        peer: const {},
        peerHasBaseline: false,
      );

      expect(changeSet.incoming, isEmpty);
      expect(
        changeSet.outgoing.map((c) => c.path).toSet(),
        {'collections/a.json', 'collections/b.json'},
      );
    });
  });

  test('computeTransferChangeSet diffs against empty baseline', () {
    final changeSet = computeTransferChangeSet(
      local: {'collections/a.json': 'h1'},
      peer: {'collections/b.json': 'h2'},
    );
    expect(
      changeSet.outgoing.map((c) => '${c.path}:${c.kind.name}').toSet(),
      {'collections/a.json:added'},
    );
    expect(
      changeSet.incoming.map((c) => '${c.path}:${c.kind.name}').toSet(),
      {'collections/b.json:added'},
    );
  });
}
