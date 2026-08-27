import 'package:apidash/workflow/engine/workflow_branch_context.dart';
import 'package:apidash/workflow/engine/workflow_parallel.dart';
import 'package:test/test.dart';

void main() {
  group('WorkflowJoinBarrier', () {
    test('completes when absents fill remaining slots', () async {
      final barrier = WorkflowJoinBarrier(expected: 3);
      final first = barrier.arrive(WorkflowBranchContext(scopedVariables: {'a': '1'}));
      barrier.markAbsent();
      barrier.markAbsent();
      final merged = await first;
      expect(merged.scopedVariables['a'], '1');
      expect(barrier.isComplete, isTrue);
    });

    test('initialAbsent counts toward completion', () async {
      final barrier = WorkflowJoinBarrier(expected: 2, initialAbsent: 1);
      final merged = await barrier.arrive(
        WorkflowBranchContext(scopedVariables: {'ok': 'yes'}),
      );
      expect(merged.scopedVariables['ok'], 'yes');
      expect(barrier.isComplete, isTrue);
    });
  });
}
