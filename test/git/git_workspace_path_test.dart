import 'package:apidash/git/git_workspace_path.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isApidashWorkspaceGitPath', () {
    test('allows collections and environments', () {
      expect(isApidashWorkspaceGitPath('collections'), isTrue);
      expect(isApidashWorkspaceGitPath('collections/API/request.json'), isTrue);
      expect(isApidashWorkspaceGitPath('environments'), isTrue);
      expect(isApidashWorkspaceGitPath('environments/global.json'), isTrue);
    });

    test('rejects local env secrets and non-workspace paths', () {
      expect(isApidashWorkspaceGitPath('environments/dev.local.json'), isFalse);
      expect(isApidashWorkspaceGitPath('history/x.json'), isFalse);
      expect(isApidashWorkspaceGitPath('.apidash/sync.json'), isFalse);
      expect(isApidashWorkspaceGitPath('README.md'), isFalse);
      expect(isApidashWorkspaceGitPath('workflows/flow.json'), isFalse);
    });

    test('normalizes windows separators', () {
      expect(
        isApidashWorkspaceGitPath(r'collections\API\request_index.json'),
        isTrue,
      );
    });
  });
}
