import 'package:apidash/git/widgets/git_visual_diff/git_diff_file_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('detectGitDiffFileKind', () {
    test('detects request / response / body files', () {
      expect(
        detectGitDiffFileKind('collections/API/r1/request.json'),
        GitDiffFileKind.request,
      );
      expect(
        detectGitDiffFileKind('collections/API/r1/response.json'),
        GitDiffFileKind.response,
      );
      expect(
        detectGitDiffFileKind('collections/API/r1/response_body.bin'),
        GitDiffFileKind.responseBody,
      );
      expect(gitDiffSupportsVisual('collections/API/r1/request.json'), isTrue);
      expect(gitDiffIsResponseBodyFile('collections/API/r1/response_body.png'), isTrue);
    });

    test('detects indexes and environments', () {
      expect(
        detectGitDiffFileKind('collections/API/request_index.json'),
        GitDiffFileKind.collection,
      );
      expect(
        detectGitDiffFileKind('collections/collection_index.json'),
        GitDiffFileKind.collectionIndex,
      );
      expect(
        detectGitDiffFileKind('environments/environment_index.json'),
        GitDiffFileKind.environmentIndex,
      );
      expect(
        detectGitDiffFileKind('environments/global.json'),
        GitDiffFileKind.environment,
      );
    });

    test('unsupported for other paths', () {
      expect(
        detectGitDiffFileKind('README.md'),
        GitDiffFileKind.unsupported,
      );
      expect(gitDiffSupportsVisual('README.md'), isFalse);
    });
  });
}
