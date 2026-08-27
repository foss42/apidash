import 'package:apidash/workflow/engine/workflow_branch_context.dart';
import 'package:apidash/workflow/engine/workflow_parallel.dart';
import 'package:test/test.dart';

void main() {
  group('WorkflowBranchContext', () {
    test('share keeps the same map and updates status in place', () {
      final parent = WorkflowBranchContext(scopedVariables: {'a': '1'});
      final continued = parent.share(lastStatusCode: 200);

      expect(identical(continued.scopedVariables, parent.scopedVariables), isTrue);
      expect(continued.lastStatusCode, 200);
      expect(parent.lastStatusCode, 200);

      continued.scopedVariables['b'] = '2';
      expect(parent.scopedVariables['b'], '2');
    });

    test('fork copies variables so siblings stay isolated', () {
      final parent = WorkflowBranchContext(
        scopedVariables: {'token': 'abc'},
        lastStatusCode: 201,
      );
      final left = parent.fork();
      final right = parent.fork();

      expect(identical(left.scopedVariables, parent.scopedVariables), isFalse);
      expect(identical(left.scopedVariables, right.scopedVariables), isFalse);
      expect(left.scopedVariables, {'token': 'abc'});
      expect(left.lastStatusCode, 201);

      left.scopedVariables['token'] = 'left-only';
      left.scopedVariables['fromLeft'] = '1';
      right.scopedVariables['fromRight'] = '2';

      expect(parent.scopedVariables, {'token': 'abc'});
      expect(left.scopedVariables, {'token': 'left-only', 'fromLeft': '1'});
      expect(right.scopedVariables, {'token': 'abc', 'fromRight': '2'});
    });
  });

  group('contextsForSuccessors', () {
    test('returns empty when there are no successors', () {
      final current = WorkflowBranchContext();
      expect(contextsForSuccessors(current, count: 0), isEmpty);
    });

    test('single successor shares the parent context (linear chain)', () {
      final parent = WorkflowBranchContext(scopedVariables: {'x': '1'});
      final next = contextsForSuccessors(parent, count: 1);

      expect(next, hasLength(1));
      expect(identical(next.single, parent), isTrue);

      next.single.scopedVariables['y'] = '2';
      expect(parent.scopedVariables['y'], '2');
    });

    test('fan-out forks so each branch has its own chain context', () {
      final parent = WorkflowBranchContext(
        scopedVariables: {'shared': 'start'},
        lastStatusCode: 200,
      );
      final branches = contextsForSuccessors(parent, count: 3);

      expect(branches, hasLength(3));
      expect(identical(branches[0], parent), isFalse);
      expect(
        identical(branches[0].scopedVariables, branches[1].scopedVariables),
        isFalse,
      );

      branches[0].scopedVariables['token'] = 't0';
      branches[0].lastStatusCode = 201;
      branches[1].scopedVariables['userId'] = 'u1';
      branches[1].lastStatusCode = 404;

      expect(parent.scopedVariables, {'shared': 'start'});
      expect(parent.lastStatusCode, 200);
      expect(branches[0].scopedVariables, {'shared': 'start', 'token': 't0'});
      expect(branches[0].lastStatusCode, 201);
      expect(branches[1].scopedVariables, {'shared': 'start', 'userId': 'u1'});
      expect(branches[1].lastStatusCode, 404);
      expect(branches[2].scopedVariables, {'shared': 'start'});
      expect(branches[2].lastStatusCode, 200);
    });

    test('linear chain then fan-out isolates only siblings', () {
      final start = WorkflowBranchContext();
      final afterLogin = contextsForSuccessors(start, count: 1).single
        ..scopedVariables['token'] = 'abc'
        ..lastStatusCode = 200;

      expect(identical(afterLogin, start), isTrue);

      final siblings = contextsForSuccessors(afterLogin, count: 2);
      siblings[0].scopedVariables['profile'] = 'ok';
      siblings[1].scopedVariables['orders'] = 'ok';

      expect(afterLogin.scopedVariables, {'token': 'abc'});
      expect(siblings[0].scopedVariables, {'token': 'abc', 'profile': 'ok'});
      expect(siblings[1].scopedVariables, {'token': 'abc', 'orders': 'ok'});
      expect(siblings[0].scopedVariables.containsKey('orders'), isFalse);
      expect(siblings[1].scopedVariables.containsKey('profile'), isFalse);
    });
  });

  group('mergeBranchContexts', () {
    test('unions disjoint keys from parallel branches', () {
      final merged = mergeBranchContexts([
        WorkflowBranchContext(
          scopedVariables: {'token': 'abc', 'a': '1'},
          lastStatusCode: 200,
        ),
        WorkflowBranchContext(
          scopedVariables: {'token': 'abc', 'b': '2'},
          lastStatusCode: 200,
        ),
      ]);

      expect(merged.scopedVariables, {'token': 'abc', 'a': '1', 'b': '2'});
      expect(merged.lastStatusCode, 200);
    });

    test('allows same key when values match', () {
      final merged = mergeBranchContexts([
        WorkflowBranchContext(scopedVariables: {'x': '1'}),
        WorkflowBranchContext(scopedVariables: {'x': '1', 'y': '2'}),
      ]);
      expect(merged.scopedVariables, {'x': '1', 'y': '2'});
    });

    test('throws on conflicting values for the same key', () {
      expect(
        () => mergeBranchContexts([
          WorkflowBranchContext(scopedVariables: {'id': '1'}),
          WorkflowBranchContext(scopedVariables: {'id': '2'}),
        ]),
        throwsA(isA<WorkflowMergeConflict>()),
      );
    });

    test('clears lastStatusCode when branches disagree', () {
      final merged = mergeBranchContexts([
        WorkflowBranchContext(lastStatusCode: 200),
        WorkflowBranchContext(lastStatusCode: 404),
      ]);
      expect(merged.lastStatusCode, isNull);
    });
  });

  group('workflow reachability / join expectations', () {
    final adjacency = buildWorkflowOutAdjacency([
      (source: 'start', target: 'a'),
      (source: 'start', target: 'b'),
      (source: 'a', target: 'c'),
      (source: 'b', target: 'c'),
      (source: 'b', target: 'd'),
    ]);

    test('canReach follows directed edges', () {
      expect(workflowCanReach(adjacency, from: 'a', to: 'c'), isTrue);
      expect(workflowCanReach(adjacency, from: 'a', to: 'd'), isFalse);
      expect(workflowCanReach(adjacency, from: 'start', to: 'd'), isTrue);
    });

    test('expected join arrivals ignore siblings that cannot reach', () {
      expect(
        workflowExpectedJoinArrivals(
          adjacency,
          siblingRoots: ['a', 'b'],
          joinNodeId: 'c',
        ),
        2,
      );
      expect(
        workflowExpectedJoinArrivals(
          adjacency,
          siblingRoots: ['a', 'b'],
          joinNodeId: 'd',
        ),
        1,
      );
    });
  });

  group('WorkflowJoinBarrier', () {
    test('waits for all arrivals then merges', () async {
      final barrier = WorkflowJoinBarrier(expected: 2);
      final first = barrier.arrive(
        WorkflowBranchContext(scopedVariables: {'a': '1'}),
      );
      final second = barrier.arrive(
        WorkflowBranchContext(scopedVariables: {'b': '2'}),
      );

      final merged = await Future.wait([first, second]);
      expect(merged.first.scopedVariables, {'a': '1', 'b': '2'});
      expect(merged.last.scopedVariables, {'a': '1', 'b': '2'});
    });

    test('surfaces merge conflicts to waiters', () async {
      final barrier = WorkflowJoinBarrier(expected: 2);
      final first = barrier.arrive(
        WorkflowBranchContext(scopedVariables: {'id': '1'}),
      );
      final second = barrier.arrive(
        WorkflowBranchContext(scopedVariables: {'id': '2'}),
      );

      expect(first, throwsA(isA<WorkflowMergeConflict>()));
      expect(second, throwsA(isA<WorkflowMergeConflict>()));
    });
  });
}
