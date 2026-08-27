import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/widgets/workflow_vyuh_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('port ids round-trip lean edge handles', () {
    for (final handle in WorkflowEdgeHandle.values) {
      final id = workflowHandleToPortId(handle);
      expect(workflowPortIdToHandle(id), handle);
    }
  });

  test('adapter builds vyuh graph from lean document', () {
    final doc = WorkflowDocument(
      id: 'Demo',
      name: 'Demo',
      graph: WorkflowGraph(
        nodes: [
          WorkflowGraphNode(
            id: 'start',
            type: WorkflowNodeType.manualStart,
            label: 'Start',
            position: const WorkflowPosition(x: 80, y: 180),
          ),
          WorkflowGraphNode(
            id: 'req1',
            type: WorkflowNodeType.request,
            label: 'Login',
            position: const WorkflowPosition(x: 320, y: 180),
          ),
        ],
        edges: [
          const WorkflowGraphEdge(
            id: 'e1',
            source: 'start',
            target: 'req1',
            sourceHandle: WorkflowEdgeHandle.next,
          ),
        ],
      ),
    );

    final graph = WorkflowVyuhAdapter.toGraph(doc);

    expect(graph.nodes.map((n) => n.id), ['start', 'req1']);
    expect(graph.nodes.first.ports.map((p) => p.id), ['next']);
    expect(
      graph.nodes.last.ports.map((p) => p.id).toList(),
      ['in', 'success', 'failure'],
    );
    expect(graph.connections, hasLength(1));
    expect(graph.connections.single.sourcePortId, 'next');
    expect(graph.connections.single.targetPortId, 'in');
  });
}
