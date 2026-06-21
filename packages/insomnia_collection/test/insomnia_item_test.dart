import 'package:insomnia_collection/insomnia_collection.dart';
import 'package:test/test.dart';

void main() {
  group('Insomnia Item tests', () {
    test('fromInsomniaCollection handles null or empty', () {
      expect(InsomniaItem.fromInsomniaCollection(null).id, isNull);
      expect(InsomniaItem.fromInsomniaCollection(InsomniaCollection()).id, isNull);
    });

    test('fromInsomniaCollection builds tree', () {
      final collection = InsomniaCollection(
        resources: [
          Resource(id: 'w1', type: 'workspace', name: 'Workspace'),
          Resource(id: 'r1', parentId: 'w1', type: 'request', name: 'Req1'),
          Resource(id: 'g1', parentId: 'w1', type: 'request_group', name: 'Group1'),
          Resource(id: 'r2', parentId: 'g1', type: 'request', name: 'Req2'),
          Resource(id: 'inv', parentId: 'w1', type: 'invalid_type', name: 'Invalid'),
        ],
      );

      final item = InsomniaItem.fromInsomniaCollection(collection);
      expect(item.id, 'w1');
      expect(item.type, ResourceType.workspace);
      expect(item.children!.length, 3);
      
      final r1 = item.children!.firstWhere((c) => c?.id == 'r1')!;
      expect(r1.type, ResourceType.request);
      expect(r1.children, isNull);

      final g1 = item.children!.firstWhere((c) => c?.id == 'g1')!;
      expect(g1.type, ResourceType.request_group);
      expect(g1.children!.length, 1);

      final r2 = g1.children!.firstWhere((c) => c?.id == 'r2')!;
      expect(r2.type, ResourceType.request);

      final inv = item.children!.firstWhere((c) => c?.id == 'inv')!;
      expect(inv.type, isNull);
    });

    test('getInsomniaItemChildren handles null', () {
      expect(getInsomniaItemChildren(null, {}, {}), isNull);
    });
  });
}
