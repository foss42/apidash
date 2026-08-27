import 'package:apidash/git/models/git_change_tree.dart';
import 'package:apidash/git/models/git_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('gitFolderIdentityFileName', () {
    test('maps collection / request / environment folders', () {
      expect(
        gitFolderIdentityFileName('collections/API'),
        'request_index.json',
      );
      expect(
        gitFolderIdentityFileName('collections/API/get-users_abcd1234'),
        'request.json',
      );
      expect(
        gitFolderIdentityFileName('environments/staging'),
        'staging.json',
      );
      expect(gitFolderIdentityFileName('collections'), isNull);
      expect(gitFolderIdentityFileName('history/x'), isNull);
    });
  });

  group('buildGitChangeTree', () {
    test('nests files under folders and sorts identity files first', () {
      final tree = buildGitChangeTree(const [
        GitChange(
          path: 'collections/API/get-users_abcd1234/response.json',
          type: GitChangeType.modified,
        ),
        GitChange(
          path: 'collections/API/get-users_abcd1234/request.json',
          type: GitChangeType.modified,
        ),
        GitChange(
          path: 'collections/API/request_index.json',
          type: GitChangeType.modified,
        ),
        GitChange(
          path: 'collections/collection_index.json',
          type: GitChangeType.modified,
        ),
      ]);

      expect(tree, hasLength(1));
      expect(tree.single.name, 'collections');
      final collectionIndex = tree.single.children.first;
      expect(collectionIndex.name, 'collection_index.json');
      expect(collectionIndex.isFile, isTrue);

      final api = tree.single.children.firstWhere((n) => n.name == 'API');
      expect(api.isFile, isFalse);
      expect(api.children.first.name, 'request_index.json');
      final requestFolder =
          api.children.firstWhere((n) => n.name == 'get-users_abcd1234');
      expect(requestFolder.children.map((c) => c.name).toList(), [
        'request.json',
        'response.json',
      ]);
    });

    test('marks collection deleted only when identity file is deleted', () {
      final tree = buildGitChangeTree(const [
        GitChange(
          path: 'collections/API/request_index.json',
          type: GitChangeType.deleted,
        ),
        GitChange(
          path: 'collections/API/get-users_abcd1234/request.json',
          type: GitChangeType.deleted,
        ),
      ]);
      final api = tree.single.children.single;
      expect(api.summary?.entityRemoved, isTrue);
      expect(api.displayLabel, 'API (deleted)');
      expect(api.summary?.displayBadgeTypes, [GitChangeType.deleted]);
    });

    test('does not label collection deleted when only nested files deleted', () {
      final tree = buildGitChangeTree(const [
        GitChange(
          path: 'collections/API/get-users_abcd1234/request.json',
          type: GitChangeType.deleted,
        ),
        GitChange(
          path: 'collections/API/request_index.json',
          type: GitChangeType.modified,
        ),
      ]);
      final api = tree.single.children.single;
      expect(api.summary?.entityRemoved, isFalse);
      expect(api.displayLabel, 'API');
      expect(api.summary?.displayBadgeTypes, [GitChangeType.modified]);
    });

    test('marks request added from identity untracked/added', () {
      final tree = buildGitChangeTree(const [
        GitChange(
          path: 'collections/API/new-req_abcd1234/request.json',
          type: GitChangeType.untracked,
        ),
      ]);
      final request = tree.single.children.single.children.single;
      expect(request.summary?.entityAdded, isTrue);
      expect(request.displayLabel, 'new-req_abcd1234 (added)');
      expect(request.summary?.displayBadgeTypes, [GitChangeType.untracked]);
    });
  });

  group('folderSelectionState', () {
    test('returns false / true / null for none / all / partial', () {
      final tree = buildGitChangeTree(const [
        GitChange(
          path: 'collections/a.json',
          type: GitChangeType.modified,
        ),
        GitChange(
          path: 'collections/b.json',
          type: GitChangeType.modified,
        ),
      ]);
      final folder = tree.single;
      expect(folderSelectionState(folder, {}), isFalse);
      expect(
        folderSelectionState(folder, {
          'collections/a.json',
          'collections/b.json',
        }),
        isTrue,
      );
      expect(
        folderSelectionState(folder, {'collections/a.json'}),
        isNull,
      );
    });
  });

  test('preferredExpandedGitTreePaths expands living entities', () {
    final tree = buildGitChangeTree(const [
      GitChange(
        path: 'collections/API/request_index.json',
        type: GitChangeType.modified,
      ),
      GitChange(
        path: 'collections/API/get-users_abcd1234/request.json',
        type: GitChangeType.modified,
      ),
    ]);
    final expanded = preferredExpandedGitTreePaths(tree);
    expect(expanded, contains('collections'));
    expect(expanded, contains('collections/API'));
    expect(expanded, contains('collections/API/get-users_abcd1234'));
  });
}
