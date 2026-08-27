import 'package:apidash/git/branch_name.dart';
import 'package:apidash/git/consts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateGitBranchName', () {
    test('accepts normal branch names', () {
      expect(validateGitBranchName('main'), isNull);
      expect(validateGitBranchName('feature/my-change'), isNull);
      expect(validateGitBranchName('fix_123'), isNull);
    });

    test('rejects empty, reserved, and invalid names', () {
      expect(validateGitBranchName(''), kMsgGitBranchNameEmpty);
      expect(validateGitBranchName('   '), kMsgGitBranchNameEmpty);
      expect(validateGitBranchName('HEAD'), kMsgGitBranchNameReserved);
      expect(validateGitBranchName('head'), kMsgGitBranchNameReserved);
      expect(validateGitBranchName('.hidden'), kMsgGitBranchNameInvalid);
      expect(validateGitBranchName('ends.'), kMsgGitBranchNameInvalid);
      expect(validateGitBranchName('foo.lock'), kMsgGitBranchNameInvalid);
      expect(validateGitBranchName('a..b'), kMsgGitBranchNameInvalid);
      expect(validateGitBranchName('a//b'), kMsgGitBranchNameInvalid);
      expect(validateGitBranchName('a@{b'), kMsgGitBranchNameInvalid);
      expect(validateGitBranchName('has space'), kMsgGitBranchNameInvalid);
      expect(validateGitBranchName('bad:name'), kMsgGitBranchNameInvalid);
      expect(validateGitBranchName('/leading'), kMsgGitBranchNameInvalid);
      expect(validateGitBranchName('trailing/'), kMsgGitBranchNameInvalid);
      expect(
        validateGitBranchName('x' * (kGitBranchNameMaxLength + 1)),
        kMsgGitBranchNameTooLong,
      );
    });
  });
}
