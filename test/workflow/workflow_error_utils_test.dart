import 'package:apidash/workflow/utils/workflow_error_utils.dart';
import 'package:test/test.dart';

void main() {
  group('formatWorkflowNodeError', () {
    test('appends node label in brackets', () {
      expect(
        formatWorkflowNodeError(
          'Connection refused',
          nodeLabel: 'Get Users',
        ),
        'Connection refused [Get Users]',
      );
    });

    test('falls back to node id when label empty', () {
      expect(
        formatWorkflowNodeError(
          'Missing request on node',
          nodeLabel: '  ',
          nodeId: 'node_users',
        ),
        'Missing request on node [node_users]',
      );
    });

    test('does not duplicate suffix', () {
      expect(
        formatWorkflowNodeError(
          'Timeout [Login]',
          nodeLabel: 'Login',
        ),
        'Timeout [Login]',
      );
    });
  });

  group('formatWorkflowFailedStepsError', () {
    test('lists unique failed node labels', () {
      expect(
        formatWorkflowFailedStepsError(const [
          (nodeId: 'a', label: 'Get Users'),
          (nodeId: 'b', label: 'Get Users'),
          (nodeId: 'c', label: 'Detail'),
        ]),
        'One or more steps failed [Get Users, Detail]',
      );
    });
  });
}
