import 'package:apidash/git/consts.dart';
import 'package:apidash/git/git_error.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatGitCollaborationError', () {
    test('maps push rejected / non-fast-forward', () {
      expect(
        formatGitCollaborationError('failed to push some refs to origin'),
        kMsgGitPushRejected,
      );
      expect(
        formatGitCollaborationError('! [rejected] non-fast-forward'),
        kMsgGitPushRejected,
      );
    });

    test('maps divergent pull, checkout, branch exists, merge', () {
      expect(
        formatGitCollaborationError('Need to reconcile divergent branches'),
        kMsgGitPullDivergent,
      );
      expect(
        formatGitCollaborationError(
          'Please commit your changes or stash them before you switch branches',
        ),
        kMsgGitCheckoutLocalChanges,
      );
      expect(
        formatGitCollaborationError('a branch named x already exists'),
        kMsgGitBranchExists,
      );
      expect(
        formatGitCollaborationError('Automatic merge failed; fix conflicts'),
        kMsgGitMergeConflict,
      );
      expect(
        formatGitCollaborationError('unmerged files would be overwritten'),
        kMsgGitUnmergedFiles,
      );
    });

    test('maps auth failures', () {
      expect(
        formatGitCollaborationError('Authentication failed for https://…'),
        kMsgGitAuthRequired,
      );
      expect(
        formatGitCollaborationError('terminal prompts disabled'),
        kMsgGitAuthRequired,
      );
      expect(
        formatGitCollaborationError('Permission denied (publickey)'),
        kMsgGitAuthRequired,
      );
      expect(
        formatGitCollaborationError('Repository not found'),
        kMsgGitAuthRequired,
      );
    });

    test('strips Bad state and picks fatal/error line', () {
      expect(
        formatGitCollaborationError('Bad state: fatal: not a git repository'),
        'not a git repository',
      );
      expect(
        formatGitCollaborationError('error: pathspec did not match'),
        'pathspec did not match',
      );
    });
  });

  test('gitCommandFailureMessage joins stderr and stdout', () {
    expect(gitCommandFailureMessage('err', 'out'), 'err\nout');
    expect(gitCommandFailureMessage('', ''), 'git command failed');
  });
}
