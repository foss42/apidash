import 'package:apidash/workflow/engine/workflow_validator.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:test/test.dart';

const _origin = WorkflowPosition(x: 0, y: 0);

WorkflowDocument _doc({
  required List<WorkflowGraphNode> nodes,
  List<WorkflowGraphEdge> edges = const [],
  String id = 'flow',
  String name = 'Flow',
}) {
  return WorkflowDocument(
    id: id,
    name: name,
    graph: WorkflowGraph(nodes: nodes, edges: edges),
  );
}

void main() {
  const validator = WorkflowValidator();

  group('WorkflowValidator', () {
    test('accepts a simple start → request chain', () {
      final result = validator.validate(
        _doc(
          nodes: const [
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
              request: {
                'id': 'r1',
                'httpRequestModel': {
                  'method': 'get',
                  'url': 'https://example.com',
                },
              },
            ),
          ],
          edges: const [
            WorkflowGraphEdge(
              id: 'e1',
              source: 'start',
              sourceHandle: WorkflowEdgeHandle.next,
              target: 'req',
            ),
          ],
        ),
      );
      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('errors on missing id, duplicates, bad edges, and cycles', () {
      final missingId = validator.validate(
        _doc(id: '', nodes: const [
          WorkflowGraphNode(
            id: 'start',
            type: WorkflowNodeType.manualStart,
            label: 'Start',
            position: _origin,
          ),
        ]),
      );
      expect(missingId.errors, contains('Workflow id is required.'));

      final duplicate = validator.validate(
        _doc(nodes: const [
          WorkflowGraphNode(
            id: 'a',
            type: WorkflowNodeType.manualStart,
            label: 'A',
            position: _origin,
          ),
          WorkflowGraphNode(
            id: 'a',
            type: WorkflowNodeType.request,
            label: 'Dup',
            position: _origin,
          ),
        ]),
      );
      expect(duplicate.errors.any((e) => e.contains('Duplicate node id')), isTrue);

      final badEdge = validator.validate(
        _doc(
          nodes: const [
            WorkflowGraphNode(
              id: 'start',
              type: WorkflowNodeType.manualStart,
              label: 'Start',
              position: _origin,
            ),
          ],
          edges: const [
            WorkflowGraphEdge(
              id: 'e1',
              source: 'start',
              sourceHandle: WorkflowEdgeHandle.next,
              target: 'missing',
            ),
          ],
        ),
      );
      expect(
        badEdge.errors.any((e) => e.contains('missing target node')),
        isTrue,
      );

      final cycle = validator.validate(
        _doc(
          nodes: const [
            WorkflowGraphNode(
              id: 'a',
              type: WorkflowNodeType.request,
              label: 'A',
              position: _origin,
              request: {
                'id': 'r1',
                'httpRequestModel': {'method': 'get', 'url': 'https://a'},
              },
            ),
            WorkflowGraphNode(
              id: 'b',
              type: WorkflowNodeType.request,
              label: 'B',
              position: _origin,
              request: {
                'id': 'r2',
                'httpRequestModel': {'method': 'get', 'url': 'https://b'},
              },
            ),
          ],
          edges: const [
            WorkflowGraphEdge(
              id: 'e1',
              source: 'a',
              sourceHandle: WorkflowEdgeHandle.success,
              target: 'b',
            ),
            WorkflowGraphEdge(
              id: 'e2',
              source: 'b',
              sourceHandle: WorkflowEdgeHandle.success,
              target: 'a',
            ),
          ],
        ),
      );
      expect(cycle.errors, contains('Workflow graph contains a cycle.'));
    });

    test('warns for incomplete condition / loop / delay / sequence config', () {
      final result = validator.validate(
        _doc(
          nodes: const [
            WorkflowGraphNode(
              id: 'start',
              type: WorkflowNodeType.manualStart,
              label: 'Start',
              position: _origin,
            ),
            WorkflowGraphNode(
              id: 'cond',
              type: WorkflowNodeType.condition,
              label: 'If',
              position: _origin,
            ),
            WorkflowGraphNode(
              id: 'loop',
              type: WorkflowNodeType.loop,
              label: 'For each',
              position: _origin,
            ),
            WorkflowGraphNode(
              id: 'delay',
              type: WorkflowNodeType.delay,
              label: 'Wait',
              position: _origin,
            ),
            WorkflowGraphNode(
              id: 'seq',
              type: WorkflowNodeType.sequence,
              label: 'Seq',
              position: _origin,
            ),
          ],
          edges: const [
            WorkflowGraphEdge(
              id: 'e0',
              source: 'start',
              sourceHandle: WorkflowEdgeHandle.next,
              target: 'cond',
            ),
            WorkflowGraphEdge(
              id: 'e1',
              source: 'start',
              sourceHandle: WorkflowEdgeHandle.next,
              target: 'loop',
            ),
            WorkflowGraphEdge(
              id: 'e2',
              source: 'start',
              sourceHandle: WorkflowEdgeHandle.next,
              target: 'delay',
            ),
            WorkflowGraphEdge(
              id: 'e3',
              source: 'start',
              sourceHandle: WorkflowEdgeHandle.next,
              target: 'seq',
            ),
          ],
        ),
      );
      expect(result.isValid, isTrue);
      expect(
        result.warnings.any((w) => w.contains('no expression')),
        isTrue,
      );
      expect(
        result.warnings.any((w) => w.contains('List')),
        isTrue,
      );
      expect(
        result.warnings.any((w) => w.contains('wait time')),
        isTrue,
      );
      expect(
        result.warnings.any((w) => w.contains('Save as')),
        isTrue,
      );
      expect(
        result.warnings.any((w) => w.contains('True and False')),
        isTrue,
      );
    });

    test('warns when nodes are unreachable from Start', () {
      final result = validator.validate(
        _doc(
          nodes: const [
            WorkflowGraphNode(
              id: 'start',
              type: WorkflowNodeType.manualStart,
              label: 'Start',
              position: _origin,
            ),
            WorkflowGraphNode(
              id: 'orphan',
              type: WorkflowNodeType.request,
              label: 'Orphan',
              position: _origin,
              request: {
                'id': 'r1',
                'httpRequestModel': {'method': 'get', 'url': 'https://x'},
              },
            ),
          ],
        ),
      );
      expect(
        result.warnings.any((w) => w.contains('not connected from Start')),
        isTrue,
      );
    });

    test('entryNodes prefers Start over orphan roots', () {
      final workflow = _doc(
        nodes: const [
          WorkflowGraphNode(
            id: 'start',
            type: WorkflowNodeType.manualStart,
            label: 'Start',
            position: _origin,
          ),
          WorkflowGraphNode(
            id: 'orphan',
            type: WorkflowNodeType.request,
            label: 'Orphan',
            position: _origin,
          ),
        ],
      );
      final entries = validator.entryNodes(workflow);
      expect(entries.map((n) => n.id), ['start']);
    });
  });
}
