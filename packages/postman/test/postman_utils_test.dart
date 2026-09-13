import 'package:postman/postman.dart';
import 'package:test/test.dart';

void main() {
  group('Postman Utils tests', () {
    test('getRequestsFromPostmanCollection handles null/empty', () {
      expect(getRequestsFromPostmanCollection(null), isEmpty);
      expect(
        getRequestsFromPostmanCollection(PostmanCollection(info: Info())),
        isEmpty,
      );
      expect(
        getRequestsFromPostmanCollection(
          PostmanCollection(info: Info(), item: []),
        ),
        isEmpty,
      );
    });

    test('getRequestsFromPostmanCollection returns requests', () {
      final collection = PostmanCollection(
        info: Info(),
        item: [
          Item(
            name: 'req1',
            request: Request(url: Url(raw: 'https://example.com/1')),
          ),
          Item(
            name: 'folder1',
            item: [
              Item(
                name: 'req2',
                request: Request(url: Url(raw: 'https://example.com/2')),
              ),
            ],
          ),
        ],
      );

      final requests = getRequestsFromPostmanCollection(collection);
      expect(requests.length, 2);
      expect(requests[0].$1, 'req1');
      expect(requests[0].$2.url?.raw, 'https://example.com/1');
      expect(requests[1].$1, 'req2');
      expect(requests[1].$2.url?.raw, 'https://example.com/2');
    });

    test('getRequestsFromPostmanItem handles null/empty', () {
      expect(getRequestsFromPostmanItem(null), isEmpty);
      expect(getRequestsFromPostmanItem(Item()), isEmpty);
      expect(getRequestsFromPostmanItem(Item(item: [])), isEmpty);
    });
  });
}
