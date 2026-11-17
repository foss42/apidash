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

    test('imports a literal request URL and keeps its query values', () {
      final collection = postmanCollectionFromJsonStr(
        '{"info":{"name":"Example"}, "item":[{"name":"List items",'
        '"request":{"method":"GET",'
        '"url":"https://example.com/items?tag=one&label=a%20b&tag=two&literal=a%2Bb"}}]}',
      );
      final request = getRequestsFromPostmanCollection(collection).single.$2;

      expect(
        request.url?.raw,
        'https://example.com/items?tag=one&label=a%20b&tag=two&literal=a%2Bb',
      );
      expect(request.url?.query, [
        const Query(key: 'tag', value: 'one'),
        const Query(key: 'label', value: 'a b'),
        const Query(key: 'tag', value: 'two'),
        const Query(key: 'literal', value: 'a+b'),
      ]);
    });

    test('getRequestsFromPostmanItem handles null/empty', () {
      expect(getRequestsFromPostmanItem(null), isEmpty);
      expect(getRequestsFromPostmanItem(Item()), isEmpty);
      expect(getRequestsFromPostmanItem(Item(item: [])), isEmpty);
    });
  });
}
