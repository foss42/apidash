import 'package:apidash/sync/sync_file_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isSyncablePath', () {
    test('allows collections and environments', () {
      expect(isSyncablePath('collections/collection_index.json'), isTrue);
      expect(
        isSyncablePath('collections/API/get-users_abcd1234/request.json'),
        isTrue,
      );
      expect(isSyncablePath('environments/global.json'), isTrue);
      expect(isSyncablePath('environments/environment_index.json'), isTrue);
    });

    test('rejects git, apidash meta, history, oauth, local env, junk', () {
      expect(isSyncablePath('.git/config'), isFalse);
      expect(isSyncablePath('.gitignore'), isFalse);
      expect(isSyncablePath('.apidash/workspace.json'), isFalse);
      expect(isSyncablePath('.apidash/sync.json'), isFalse);
      expect(isSyncablePath('history/request_history/x.json'), isFalse);
      expect(isSyncablePath('oauth2_credentials.json'), isFalse);
      expect(isSyncablePath('oauth1_credentials.json'), isFalse);
      expect(isSyncablePath('environments/dev.local.json'), isFalse);
      expect(isSyncablePath('collections/foo.tmp'), isFalse);
      expect(isSyncablePath('.DS_Store'), isFalse);
      expect(isSyncablePath('collections/.DS_Store'), isFalse);
      expect(isSyncablePath('workflows/flow.json'), isFalse);
      expect(isSyncablePath(''), isFalse);
    });

    test('normalizes windows separators', () {
      expect(
        isSyncablePath(r'collections\API\request_index.json'),
        isTrue,
      );
    });
  });
}
