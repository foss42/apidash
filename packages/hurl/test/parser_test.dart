import 'package:flutter_test/flutter_test.dart';
import 'package:hurl/hurl.dart';

void main() {
  setUpAll(() async {
    await RustLib.init();
  });

  test('parse simple GET request', () {
    const hurlContent = '''
GET https://api.example.com/users
''';

    final result = parseHurlToJson(content: hurlContent);
    print('Result: $result');
    
    expect(result, contains('"method":"GET"'));
    expect(result, contains('"url":"https://api.example.com/users"'));
  });

  test('parse request with headers', () {
    const hurlContent = '''
GET https://api.example.com/users
Authorization: Bearer token123
Content-Type: application/json
''';

    final result = parseHurlToJson(content: hurlContent);
    print('Result: $result');
    
    expect(result, contains('"method":"GET"'));
    expect(result, contains('"name":"Authorization"'));
    expect(result, contains('"value":"Bearer token123"'));
    expect(result, contains('"name":"Content-Type"'));
    expect(result, contains('"value":"application/json"'));
  });

  test('parse multiple requests', () {
    const hurlContent = '''
GET https://api.example.com/users

POST https://api.example.com/users
Content-Type: application/json
''';

    final result = parseHurlToJson(content: hurlContent);
    print('Result: $result');
    
    expect(result, contains('"method":"GET"'));
    expect(result, contains('"method":"POST"'));
  });

  test('parse error handling', () {
    // Invalid syntax - missing URL
    const hurlContent = '''
GET
''';

    expect(
      () => parseHurlToJson(content: hurlContent),
      throwsA(isA<Object>()),
    );
  });
}
