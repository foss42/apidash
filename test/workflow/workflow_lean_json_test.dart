import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:test/test.dart';

void main() {
  group('WorkflowDocument lean JSON', () {
    test('round-trips nodes/edges without editor chrome', () {
      const doc = WorkflowDocument(
        id: 'Login Flow',
        name: 'Login Flow',
        description: 'optional',
        graph: WorkflowGraph(
          nodes: [
            WorkflowGraphNode(
              id: 'start',
              type: WorkflowNodeType.manualStart,
              label: 'Start',
              position: WorkflowPosition(x: 80, y: 180),
            ),
            WorkflowGraphNode(
              id: 'login',
              type: WorkflowNodeType.request,
              label: 'Login',
              position: WorkflowPosition(x: 320, y: 180),
              request: {
                'id': 'req_login',
                'httpRequestModel': {
                  'method': 'post',
                  'url': 'https://api.example.com/login',
                },
              },
              extractions: [
                WorkflowExtraction(varName: 'token', jsonPath: 'token'),
              ],
            ),
          ],
          edges: [
            WorkflowGraphEdge(
              id: 'e1',
              source: 'start',
              sourceHandle: WorkflowEdgeHandle.next,
              target: 'login',
            ),
          ],
        ),
      );

      final json = doc.toJson();
      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('connections'), isFalse);
      expect(json.containsKey('schemaVersion'), isFalse);
      expect(json['nodes'], isA<List>());
      expect(json['edges'], isA<List>());

      final nodes = json['nodes'] as List;
      final start = nodes.first as Map;
      expect(start.containsKey('ports'), isFalse);
      expect(start.containsKey('width'), isFalse);
      expect(start.containsKey('data'), isFalse);
      expect(start['position'], {'x': 80, 'y': 180});

      final edges = json['edges'] as List;
      final edge = edges.first as Map;
      expect(edge['from'], 'start');
      expect(edge['to'], 'login');
      expect(edge['out'], 'next');
      expect(edge.containsKey('sourceNodeId'), isFalse);

      final roundTrip = WorkflowDocument.fromJson(json);
      expect(roundTrip.name, 'Login Flow');
      expect(roundTrip.graph.nodes, hasLength(2));
      expect(roundTrip.graph.edges.single.sourceHandle, WorkflowEdgeHandle.next);
      expect(roundTrip.graph.nodes[1].extractions.single.varName, 'token');
    });

    test('omits default success out on request edges', () {
      const edge = WorkflowGraphEdge(
        id: 'e2',
        source: 'a',
        sourceHandle: WorkflowEdgeHandle.success,
        target: 'b',
      );
      final json = edge.toJson();
      expect(json['from'], 'a');
      expect(json['to'], 'b');
      expect(json.containsKey('out'), isFalse);
    });

    test('round-trips loop field/as promote keys', () {
      const node = WorkflowGraphNode(
        id: 'loop1',
        type: WorkflowNodeType.loop,
        label: 'For each user',
        position: WorkflowPosition(x: 10, y: 20),
        loopExpression: 'var:users',
        loopItemField: 'id',
        loopItemAs: 'userId',
      );
      final json = node.toJson();
      expect(json['items'], 'var:users');
      expect(json['field'], 'id');
      expect(json['as'], 'userId');
      final roundTrip = WorkflowGraphNode.fromJson(json);
      expect(roundTrip.loopItemField, 'id');
      expect(roundTrip.loopItemAs, 'userId');
    });

    test('lowercases HTTP method and lifts nested extract from request', () {
      final node = WorkflowGraphNode.fromJson({
        'id': 'get_users',
        'type': 'request',
        'label': 'Get Users',
        'position': {'x': 1, 'y': 2},
        'request': {
          'id': 'req_get_users',
          'httpRequestModel': {
            'method': 'GET',
            'url': 'https://api.apidash.dev/users',
          },
          'extract': [
            {'var': 'userId', 'path': 'data.0.id'},
          ],
        },
      });
      expect(
        node.request?['httpRequestModel']?['method'],
        'get',
      );
      expect(node.extractions, hasLength(1));
      expect(node.extractions.single.varName, 'userId');
      expect(node.request?.containsKey('extract'), isFalse);
      final model = node.requestModel();
      expect(model?.httpRequestModel?.method.name, 'get');
    });

    test('wraps slim request method/url into httpRequestModel', () {
      final node = WorkflowGraphNode.fromJson({
        'id': 'get_users',
        'type': 'request',
        'label': 'Get Users',
        'position': {'x': 1, 'y': 2},
        'request': {
          'method': 'GET',
          'url': 'https://apidash.dev/users',
        },
        'extract': [
          {'var': 'user_id', 'path': 'data[0].id'},
        ],
      });
      expect(node.request?['httpRequestModel']?['method'], 'get');
      expect(
        node.request?['httpRequestModel']?['url'],
        'https://apidash.dev/users',
      );
      expect(node.extractions.single.jsonPath, 'data[0].id');
      expect(node.requestModel()?.httpRequestModel?.method.name, 'get');
    });
  });
}
