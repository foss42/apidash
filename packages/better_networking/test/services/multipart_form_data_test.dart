import 'dart:convert';
import 'dart:io';
import 'package:better_networking/better_networking.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

Future<String> _encode(http.MultipartRequest request) async {
  final bytes = await request.finalize().toBytes();
  return utf8.decode(bytes);
}

List<String> _values(String body, String name) {
  final regex = RegExp(
    'name="${RegExp.escape(name)}"[^\\r\\n]*\\r\\n(?:[^\\r\\n]+\\r\\n)*\\r\\n([^\\r\\n]*)',
  );
  return regex.allMatches(body).map((m) => m.group(1)!).toList();
}

void main() {
  group('addFormDataToMultipartRequest', () {
    test('keeps every value of a repeated text field', () async {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://example.com'),
      );
      await addFormDataToMultipartRequest(request, const [
        FormDataModel(name: 'tags', value: 'a', type: FormDataType.text),
        FormDataModel(name: 'name', value: 'x', type: FormDataType.text),
        FormDataModel(name: 'tags', value: 'b', type: FormDataType.text),
        FormDataModel(name: 'tags', value: 'c', type: FormDataType.text),
      ]);

      final body = await _encode(request);
      expect(_values(body, 'tags'), ['a', 'b', 'c']);
      expect(_values(body, 'name'), ['x']);
      expect(body, isNot(contains('filename=')));
    });

    test('unique text fields stay in fields', () async {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://example.com'),
      );
      await addFormDataToMultipartRequest(request, const [
        FormDataModel(name: 'a', value: '1', type: FormDataType.text),
        FormDataModel(name: 'b', value: '2', type: FormDataType.text),
      ]);

      expect(request.fields, {'a': '1', 'b': '2'});
      expect(request.files, isEmpty);
    });

    test('adds file rows as file parts', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      addTearDown(() => tempDir.deleteSync(recursive: true));
      final file = File('${tempDir.path}/upload.txt')
        ..writeAsStringSync('hello');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://example.com'),
      );
      await addFormDataToMultipartRequest(request, [
        const FormDataModel(
          name: 'token',
          value: 'xyz',
          type: FormDataType.text,
        ),
        FormDataModel(name: 'doc', value: file.path, type: FormDataType.file),
      ]);

      expect(request.fields, {'token': 'xyz'});
      expect(request.files, hasLength(1));
      expect(request.files.single.field, 'doc');
      expect(request.files.single.filename, 'upload.txt');
    });
  });
}
