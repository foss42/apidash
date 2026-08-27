import 'package:apidash/workflow/engine/workflow_auto_arrange.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:test/test.dart';

const _origin = WorkflowPosition(x: 0, y: 0);

void main() {
  group('computeWorkflowAutoArrangePositions', () {
    test('returns empty for empty graph', () {
      expect(
        computeWorkflowAutoArrangePositions(const WorkflowGraph()),
        isEmpty,
      );
    });

    test('places start left of request on the main path', () {
      const graph = WorkflowGraph(
        nodes: [
          WorkflowGraphNode(
            id: 'start',
            type: WorkflowNodeType.manualStart,
            label: 'Start',
            position: _origin,
          ),
          WorkflowGraphNode(
            id: 'req',
            type: WorkflowNodeType.request,
            label: 'Get',
            position: _origin,
          ),
        ],
        edges: [
          WorkflowGraphEdge(
            id: 'e1',
            source: 'start',
            sourceHandle: WorkflowEdgeHandle.next,
            target: 'req',
          ),
        ],
      );

      final positions = computeWorkflowAutoArrangePositions(graph);
      expect(positions.keys, containsAll(['start', 'req']));
      expect(positions['start']!.dx, lessThan(positions['req']!.dx));
    });

    test('keeps sequence beside its loop rather than on the main lane', () {
      const graph = WorkflowGraph(
        nodes: [
          WorkflowGraphNode(
            id: 'start',
            type: WorkflowNodeType.manualStart,
            label: 'Start',
            position: _origin,
          ),
          WorkflowGraphNode(
            id: 'loop',
            type: WorkflowNodeType.loop,
            label: 'For each',
            position: _origin,
            loopExpression: '{{users}}',
          ),
          WorkflowGraphNode(
            id: 'seq',
            type: WorkflowNodeType.sequence,
            label: 'Seq',
            position: _origin,
            sequenceValue: '[1,2]',
            loopItemAs: 'item',
          ),
          WorkflowGraphNode(
            id: 'body',
            type: WorkflowNodeType.request,
            label: 'Body',
            position: _origin,
            request: {
              'id': 'r1',
              'httpRequestModel': {'method': 'get', 'url': 'https://x'},
            },
          ),
        ],
        edges: [
          WorkflowGraphEdge(
            id: 'e1',
            source: 'start',
            sourceHandle: WorkflowEdgeHandle.next,
            target: 'loop',
          ),
          WorkflowGraphEdge(
            id: 'e2',
            source: 'seq',
            sourceHandle: WorkflowEdgeHandle.next,
            targetHandle: WorkflowEdgeHandle.loopList,
            target: 'loop',
          ),
          WorkflowGraphEdge(
            id: 'e3',
            source: 'loop',
            sourceHandle: WorkflowEdgeHandle.next,
            target: 'body',
          ),
        ],
      );

      final positions = computeWorkflowAutoArrangePositions(graph);
      expect(positions.keys, containsAll(['start', 'loop', 'seq', 'body']));
      expect(positions['start']!.dx, lessThan(positions['loop']!.dx));
      expect(positions['loop']!.dx, lessThan(positions['body']!.dx));
      expect(positions.containsKey('seq'), isTrue);
    });
  });
}
