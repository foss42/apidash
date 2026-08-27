import 'package:apidash/dashbot/services/actions/workflow_apply_service.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:test/test.dart';

void main() {
  const service = WorkflowApplyService();

  Map<String, dynamic> validLeanWorkflow({
    String name = 'Login Flow',
    List<Map<String, dynamic>>? nodes,
    List<Map<String, dynamic>>? edges,
  }) {
    return {
      'name': name,
      'nodes': nodes ??
          [
            {
              'id': 'start',
              'type': 'start',
              'label': 'Start',
              'position': {'x': 80, 'y': 180},
            },
            {
              'id': 'login',
              'type': 'request',
              'label': 'Login',
              'position': {'x': 320, 'y': 180},
              'request': {
                'id': 'req_login',
                'httpRequestModel': {
                  'method': 'post',
                  'url': 'https://api.example.com/login',
                },
              },
            },
          ],
      'edges': edges ??
          [
            {
              'id': 'e1',
              'from': 'start',
              'to': 'login',
              'out': 'next',
            },
          ],
    };
  }

  group('WorkflowApplyService.prepare', () {
    test('accepts lean JSON and sets id from unique name', () {
      final result = service.prepare(
        validLeanWorkflow(),
        existingNames: const [],
      );
      expect(result.document.name, 'Login Flow');
      expect(result.document.id, 'Login Flow');
      expect(result.document.graph.nodes.length, 2);
      expect(result.message, contains('Login Flow'));
      final json = result.document.toJson();
      expect(json.containsKey('schemaVersion'), isFalse);
      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('connections'), isFalse);
      expect(json['nodes'], isA<List>());
      expect(json['edges'], isA<List>());
    });

    test('suffixes name when already taken', () {
      final result = service.prepare(
        validLeanWorkflow(),
        existingNames: const ['Login Flow'],
      );
      expect(result.document.name, 'Login Flow (2)');
      expect(result.document.id, 'Login Flow (2)');
    });

    test('replaceExistingId keeps current id and updates message', () {
      final result = service.prepare(
        validLeanWorkflow(name: 'AI Suggested Name'),
        existingNames: const ['My Flow', 'Other'],
        replaceExistingId: 'My Flow',
      );
      expect(result.document.id, 'My Flow');
      expect(result.document.name, 'My Flow');
      expect(result.message, contains('Updated'));
      expect(result.message, contains('My Flow'));
      expect(result.document.graph.nodes.length, 2);
    });

    test('auto-layouts when all positions are zero', () {
      final result = service.prepare(
        validLeanWorkflow(
          nodes: [
            {
              'id': 'start',
              'type': 'start',
              'label': 'Start',
              'position': {'x': 0, 'y': 0},
            },
            {
              'id': 'login',
              'type': 'request',
              'label': 'Login',
              'position': {'x': 0, 'y': 0},
              'request': {
                'id': 'req_login',
                'httpRequestModel': {
                  'method': 'get',
                  'url': 'https://api.example.com/me',
                },
              },
            },
          ],
        ),
        existingNames: const [],
      );
      expect(result.document.graph.nodes.first.position.x, 80);
      expect(
        result.document.graph.nodes[1].position.x,
        greaterThan(result.document.graph.nodes.first.position.x),
      );
    });

    test('chains nodes when edges are missing and auto-arranges', () {
      final result = service.prepare(
        {
          'name': 'Chained',
          'nodes': [
            {
              'id': 'start',
              'type': 'start',
              'label': 'Start',
              'position': {'x': 10, 'y': 10},
            },
            {
              'id': 'login',
              'type': 'request',
              'label': 'Login',
              'position': {'x': 10, 'y': 10},
              'request': {
                'id': 'req_login',
                'httpRequestModel': {
                  'method': 'post',
                  'url': 'https://api.example.com/login',
                },
              },
            },
            {
              'id': 'me',
              'type': 'request',
              'label': 'Me',
              'position': {'x': 10, 'y': 10},
              'request': {
                'id': 'req_me',
                'httpRequestModel': {
                  'method': 'get',
                  'url': 'https://api.example.com/me',
                },
              },
            },
          ],
          'edges': <Map<String, dynamic>>[],
        },
        existingNames: const [],
      );
      expect(result.document.graph.edges.length, 2);
      expect(result.document.graph.edges[0].source, 'start');
      expect(result.document.graph.edges[0].target, 'login');
      expect(
        result.document.graph.edges[0].sourceHandle,
        WorkflowEdgeHandle.next,
      );
      expect(result.document.graph.edges[1].source, 'login');
      expect(result.document.graph.edges[1].target, 'me');
      expect(
        result.document.graph.nodes[1].position.x,
        greaterThan(result.document.graph.nodes.first.position.x),
      );
    });

    test('accepts connections alias when edges are absent', () {
      final result = service.prepare(
        {
          'name': 'Alias Edges',
          'nodes': [
            {
              'id': 'start',
              'type': 'start',
              'label': 'Start',
              'position': {'x': 80, 'y': 180},
            },
            {
              'id': 'login',
              'type': 'request',
              'label': 'Login',
              'position': {'x': 320, 'y': 180},
              'request': {
                'id': 'req_login',
                'httpRequestModel': {
                  'method': 'get',
                  'url': 'https://api.example.com/me',
                },
              },
            },
          ],
          'connections': [
            {'id': 'c1', 'from': 'start', 'to': 'login', 'out': 'next'},
          ],
        },
        existingNames: const [],
      );
      expect(result.document.graph.edges.length, 1);
      expect(result.document.graph.edges.first.source, 'start');
    });

    test('rejects missing payload', () {
      expect(
        () => service.prepare(null, existingNames: const []),
        throwsA(isA<WorkflowApplyException>()),
      );
    });

    test('rejects empty name', () {
      expect(
        () => service.prepare(
          validLeanWorkflow(name: '  '),
          existingNames: const [],
        ),
        throwsA(isA<WorkflowApplyException>()),
      );
    });

    test('rejects missing start', () {
      expect(
        () => service.prepare(
          validLeanWorkflow(
            nodes: [
              {
                'id': 'login',
                'type': 'request',
                'label': 'Login',
                'position': {'x': 80, 'y': 180},
                'request': {
                  'id': 'req_login',
                  'httpRequestModel': {
                    'method': 'get',
                    'url': 'https://api.example.com/me',
                  },
                },
              },
            ],
            edges: const [],
          ),
          existingNames: const [],
        ),
        throwsA(
          isA<WorkflowApplyException>().having(
            (e) => e.message,
            'message',
            contains('exactly one start'),
          ),
        ),
      );
    });

    test('rejects start-only graph', () {
      expect(
        () => service.prepare(
          {
            'name': 'Empty',
            'nodes': [
              {
                'id': 'start',
                'type': 'start',
                'label': 'Start',
                'position': {'x': 80, 'y': 180},
              },
            ],
            'edges': <Map<String, dynamic>>[],
          },
          existingNames: const [],
        ),
        throwsA(
          isA<WorkflowApplyException>().having(
            (e) => e.message,
            'message',
            contains('at least one step'),
          ),
        ),
      );
    });

    test('rejects edge with unknown node', () {
      expect(
        () => service.prepare(
          validLeanWorkflow(
            edges: [
              {
                'id': 'e1',
                'from': 'start',
                'to': 'missing',
                'out': 'next',
              },
            ],
          ),
          existingNames: const [],
        ),
        throwsA(
          isA<WorkflowApplyException>().having(
            (e) => e.message,
            'message',
            contains('unknown node'),
          ),
        ),
      );
    });
  });
}
