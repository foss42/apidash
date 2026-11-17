import 'package:apidash_core/import_export/postman_io.dart';
import 'package:test/test.dart';

void main() {
  test('imports string URLs without losing query entries', () {
    final result = PostmanIO().getHttpRequestModelList(
      '{"info":{"name":"Sample"},"item":[{"name":"Search",'
      '"request":{"method":"GET",'
      '"url":"https://example.com/items?tag=one&label=a%20b&tag=two"}}]}',
    );

    final (name, request) = result!.single;
    expect(name, 'Search');
    expect(request.url, 'https://example.com/items');
    expect(request.params!.map((entry) => (entry.name, entry.value)), [
      ('tag', 'one'),
      ('label', 'a b'),
      ('tag', 'two'),
    ]);
    expect(request.isParamEnabledList, [true, true, true]);
  });
}
