import 'package:insomnia_collection/insomnia_collection.dart';
import 'package:test/test.dart';

void main() {
  group('Insomnia Utils tests', () {
    test('getRequestsFromInsomniaCollection handles null/empty', () {
      expect(getRequestsFromInsomniaCollection(null), isEmpty);
      expect(
        getRequestsFromInsomniaCollection(InsomniaCollection(resources: [])),
        isEmpty,
      );
    });

    test('getRequestsFromInsomniaCollection returns requests', () {
      final collection = InsomniaCollection(
        resources: [
          Resource(type: 'request', name: 'req1'),
          Resource(type: 'environment', name: 'env1'),
          Resource(type: 'request', name: 'req2'),
          Resource(name: 'untyped'),
        ],
      );

      final requests = getRequestsFromInsomniaCollection(collection);
      expect(requests.length, 2);
      expect(requests[0].$1, 'req1');
      expect(requests[1].$1, 'req2');
    });

    test('getEnvironmentsFromInsomniaCollection returns environments', () {
      final collection = InsomniaCollection(
        resources: [
          Resource(type: 'request', name: 'req1'),
          Resource(type: 'environment', name: 'env1'),
          Resource(type: 'environment', name: 'env2'),
        ],
      );

      final environments = getEnvironmentsFromInsomniaCollection(collection);
      expect(environments.length, 2);
      expect(environments[0].$1, 'env1');
      expect(environments[1].$1, 'env2');
    });

    test('getItemByTypeFromInsomniaCollection handles null collection', () {
      expect(getItemByTypeFromInsomniaCollection(null, 'request'), isEmpty);
    });
  });
}
