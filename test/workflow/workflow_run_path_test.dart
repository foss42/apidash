import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/utils/workflow_run_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('workflowSourceFiredHandle', () {
    test('condition fires then/else from branch', () {
      const thenResult = WorkflowNodeRunResult(
        nodeId: 'c1',
        status: WorkflowNodeRunStatus.success,
        nodeType: WorkflowNodeType.condition,
        branch: 'true',
      );
      expect(
        workflowSourceFiredHandle(thenResult, WorkflowEdgeHandle.then),
        isTrue,
      );
      expect(
        workflowSourceFiredHandle(thenResult, WorkflowEdgeHandle.elseBranch),
        isFalse,
      );

      const elseResult = WorkflowNodeRunResult(
        nodeId: 'c1',
        status: WorkflowNodeRunStatus.success,
        nodeType: WorkflowNodeType.condition,
        branch: 'false',
      );
      expect(
        workflowSourceFiredHandle(elseResult, WorkflowEdgeHandle.elseBranch),
        isTrue,
      );
    });

    test('request success vs failure handles', () {
      const ok = WorkflowNodeRunResult(
        nodeId: 'r1',
        status: WorkflowNodeRunStatus.success,
        nodeType: WorkflowNodeType.request,
        branch: 'success',
      );
      expect(
        workflowSourceFiredHandle(ok, WorkflowEdgeHandle.success),
        isTrue,
      );
      expect(
        workflowSourceFiredHandle(ok, WorkflowEdgeHandle.failure),
        isFalse,
      );

      const fail = WorkflowNodeRunResult(
        nodeId: 'r1',
        status: WorkflowNodeRunStatus.failed,
        nodeType: WorkflowNodeType.request,
        branch: 'failure',
      );
      expect(
        workflowSourceFiredHandle(fail, WorkflowEdgeHandle.failure),
        isTrue,
      );
    });
  });

  group('workflowEdgeRunStyle', () {
    test('highlights taken branch and active next hop', () {
      final edge = WorkflowGraphEdge(
        id: 'e1',
        source: 'cond',
        target: 'req',
        sourceHandle: WorkflowEdgeHandle.then,
      );
      final untaken = WorkflowGraphEdge(
        id: 'e2',
        source: 'cond',
        target: 'other',
        sourceHandle: WorkflowEdgeHandle.elseBranch,
      );

      final results = <String, WorkflowNodeRunResult>{
        'cond': const WorkflowNodeRunResult(
          nodeId: 'cond',
          status: WorkflowNodeRunStatus.success,
          nodeType: WorkflowNodeType.condition,
          branch: 'true',
        ),
        'req': const WorkflowNodeRunResult(
          nodeId: 'req',
          status: WorkflowNodeRunStatus.running,
          nodeType: WorkflowNodeType.request,
        ),
      };

      expect(
        workflowEdgeRunStyle(edge: edge, results: results),
        WorkflowRunEdgeStyle.active,
      );
      expect(
        workflowEdgeRunStyle(edge: untaken, results: results),
        WorkflowRunEdgeStyle.idle,
      );
    });

    test('marks completed path after target succeeds', () {
      final edge = WorkflowGraphEdge(
        id: 'e1',
        source: 'start',
        target: 'a',
        sourceHandle: WorkflowEdgeHandle.next,
      );
      final results = <String, WorkflowNodeRunResult>{
        'start': const WorkflowNodeRunResult(
          nodeId: 'start',
          status: WorkflowNodeRunStatus.success,
          nodeType: WorkflowNodeType.manualStart,
        ),
        'a': const WorkflowNodeRunResult(
          nodeId: 'a',
          status: WorkflowNodeRunStatus.success,
          nodeType: WorkflowNodeType.request,
          branch: 'success',
        ),
      };

      expect(
        workflowEdgeRunStyle(edge: edge, results: results),
        WorkflowRunEdgeStyle.completed,
      );
    });
  });

  group('workflowNodeRunBorderColor', () {
    test('uses primary / success / error for run status', () {
      const scheme = ColorScheme.light();
      final running = workflowNodeRunBorderColor(
        result: const WorkflowNodeRunResult(
          nodeId: 'n',
          status: WorkflowNodeRunStatus.running,
        ),
        selected: false,
        scheme: scheme,
        brightness: Brightness.light,
      );
      expect(running, scheme.primary);

      final failed = workflowNodeRunBorderColor(
        result: const WorkflowNodeRunResult(
          nodeId: 'n',
          status: WorkflowNodeRunStatus.failed,
        ),
        selected: false,
        scheme: scheme,
        brightness: Brightness.light,
      );
      expect(failed, scheme.error);
    });
  });
}
