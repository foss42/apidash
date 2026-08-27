import 'package:apidash/git/consts.dart';
import 'package:apidash/git/services/git_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('repoNameFromCloneUrl', () {
    test('parses https and ssh style urls', () {
      expect(
        repoNameFromCloneUrl('https://github.com/foss42/apidash.git'),
        'apidash',
      );
      expect(
        repoNameFromCloneUrl('git@github.com:foss42/apidash.git'),
        'apidash',
      );
      expect(
        repoNameFromCloneUrl('https://gitlab.com/org/my-repo/'),
        'my-repo',
      );
    });
  });

  group('looksLikeGitRemoteUrl', () {
    test('accepts common remotes and rejects junk', () {
      expect(looksLikeGitRemoteUrl('https://github.com/a/b.git'), isTrue);
      expect(looksLikeGitRemoteUrl('http://example.com/r.git'), isTrue);
      expect(looksLikeGitRemoteUrl('ssh://git@host/repo.git'), isTrue);
      expect(looksLikeGitRemoteUrl('git@github.com:a/b.git'), isTrue);
      expect(looksLikeGitRemoteUrl(''), isFalse);
      expect(looksLikeGitRemoteUrl('not a url'), isFalse);
      expect(looksLikeGitRemoteUrl('https://'), isFalse);
    });
  });

  test('gitignore template excludes local secrets and history', () {
    expect(kGitIgnoreTemplate, contains('environments/*.local.json'));
    expect(kGitIgnoreTemplate, contains('oauth2_credentials.json'));
    expect(kGitIgnoreTemplate, contains('.apidash/'));
    expect(kGitIgnoreTemplate, contains('history/'));
  });

  group('fetch / behind hint messages', () {
    test('formatGitBehindRemoteHint', () {
      expect(
        formatGitBehindRemoteHint(1),
        '1 commit behind remote. Pull to update before pushing.',
      );
      expect(
        formatGitBehindRemoteHint(3),
        '3 commits behind remote. Pull to update before pushing.',
      );
    });

    test('formatGitFetchResultMessage', () {
      expect(
        formatGitFetchResultMessage(ahead: 0, behind: 0),
        'Checked remote: up to date with remote',
      );
      expect(
        formatGitFetchResultMessage(ahead: 2, behind: 0),
        contains('2 local commits to push'),
      );
      expect(
        formatGitFetchResultMessage(ahead: 0, behind: 1),
        contains('1 commit available'),
      );
      expect(
        formatGitFetchResultMessage(ahead: 1, behind: 2),
        contains('Pull may need a merge'),
      );
    });
  });
}
