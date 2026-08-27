import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/utils/workflow_variable_utils.dart';
import 'package:test/test.dart';

const _origin = WorkflowPosition(x: 0, y: 0);

void main() {
  group('upstreamExtractionVariables', () {
    test('collects extractions from predecessor request nodes only', () {
      const workflow = WorkflowDocument(
        id: 'flow',
        name: 'Flow',
        graph: WorkflowGraph(
          nodes: [
            WorkflowGraphNode(
              id: 'start',
              type: WorkflowNodeType.manualStart,
              label: 'Start',
              position: _origin,
            ),
            WorkflowGraphNode(
              id: 'login',
              type: WorkflowNodeType.request,
              label: 'Login',
              position: _origin,
              extractions: [
                WorkflowExtraction(varName: 'token', jsonPath: 'token'),
              ],
            ),
            WorkflowGraphNode(
              id: 'later',
              type: WorkflowNodeType.request,
              label: 'Later',
              position: _origin,
              extractions: [
                WorkflowExtraction(varName: 'unused', jsonPath: 'id'),
              ],
            ),
            WorkflowGraphNode(
              id: 'target',
              type: WorkflowNodeType.request,
              label: 'Target',
              position: _origin,
            ),
          ],
          edges: [
            WorkflowGraphEdge(
              id: 'e1',
              source: 'start',
              sourceHandle: WorkflowEdgeHandle.next,
              target: 'login',
            ),
            WorkflowGraphEdge(
              id: 'e2',
              source: 'login',
              sourceHandle: WorkflowEdgeHandle.success,
              target: 'target',
            ),
            WorkflowGraphEdge(
              id: 'e3',
              source: 'start',
              sourceHandle: WorkflowEdgeHandle.next,
              target: 'later',
            ),
          ],
        ),
      );

      final vars = upstreamExtractionVariables(workflow, 'target');
      expect(vars.keys, ['token']);
      expect(vars['token'], contains('Login'));
      expect(vars.containsKey('unused'), isFalse);
    });

    test('includes loop Save as and sequence Save as from upstream', () {
      const workflow = WorkflowDocument(
        id: 'flow',
        name: 'Flow',
        graph: WorkflowGraph(
          nodes: [
            WorkflowGraphNode(
              id: 'start',
              type: WorkflowNodeType.manualStart,
              label: 'Start',
              position: _origin,
            ),
            WorkflowGraphNode(
              id: 'seq',
              type: WorkflowNodeType.sequence,
              label: 'Build list',
              position: _origin,
              loopItemAs: 'users',
            ),
            WorkflowGraphNode(
              id: 'loop',
              type: WorkflowNodeType.loop,
              label: 'For each',
              position: _origin,
              loopItemAs: 'userId',
              loopItemField: 'id',
            ),
            WorkflowGraphNode(
              id: 'body',
              type: WorkflowNodeType.request,
              label: 'Body',
              position: _origin,
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
        ),
      );

      final vars = upstreamExtractionVariables(workflow, 'body');
      expect(vars['userId'], contains('For each'));
      expect(vars['users'], contains('sequence'));
    });

    test('returns empty when target has no predecessors', () {
      const workflow = WorkflowDocument(
        id: 'flow',
        name: 'Flow',
        graph: WorkflowGraph(
          nodes: [
            WorkflowGraphNode(
              id: 'solo',
              type: WorkflowNodeType.request,
              label: 'Solo',
              position: _origin,
              extractions: [
                WorkflowExtraction(varName: 'x', jsonPath: 'x'),
              ],
            ),
          ],
        ),
      );
      expect(upstreamExtractionVariables(workflow, 'solo'), isEmpty);
    });
  });
}
