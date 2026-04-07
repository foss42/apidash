import 'dart:io';

import 'package:test/test.dart';

Directory _packageRoot() {
  final candidates = <String>[
    '${Directory.current.path}${Platform.pathSeparator}packages${Platform.pathSeparator}better_networking',
    Directory.current.path,
  ];

  for (final candidate in candidates) {
    final pubspec = File('$candidate${Platform.pathSeparator}pubspec.yaml');
    if (pubspec.existsSync()) {
      return Directory(candidate);
    }
  }

  fail('Unable to locate better_networking package root.');
}

Future<List<File>> _dartFilesIn(Directory dir) async {
  return dir
      .list(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.dart'))
      .cast<File>()
      .toList();
}

void main() {
  group('pure Dart compatibility', () {
    test('pubspec does not require Flutter-only dependencies', () async {
      final root = _packageRoot();
      final pubspec =
          await File('${root.path}${Platform.pathSeparator}pubspec.yaml')
              .readAsString();

      expect(pubspec,
          isNot(contains(RegExp(r'^\s*flutter:\s*$', multiLine: true))));
      expect(pubspec, isNot(contains('sdk: flutter')));
      expect(pubspec, isNot(contains('flutter_web_auth_2')));
      expect(pubspec, contains('seed: any'));
    });

    test('library sources do not import Flutter-only libraries', () async {
      final root = _packageRoot();
      final libDir = Directory('${root.path}${Platform.pathSeparator}lib');
      final dartFiles = await _dartFilesIn(libDir);

      for (final file in dartFiles) {
        final content = await file.readAsString();
        expect(
          content,
          isNot(contains('package:flutter/')),
          reason: 'Unexpected Flutter import in ${file.path}',
        );
        expect(
          content,
          isNot(contains('kIsWeb')),
          reason: 'Unexpected Flutter kIsWeb usage in ${file.path}',
        );
      }
    });

    test('OAuth auth flow does not log access tokens', () async {
      final root = _packageRoot();
      final handleAuthFile = File(
        '${root.path}${Platform.pathSeparator}lib${Platform.pathSeparator}utils${Platform.pathSeparator}auth${Platform.pathSeparator}handle_auth.dart',
      );
      final content = await handleAuthFile.readAsString();

      expect(content,
          isNot(contains('logDebug(res.\$1.credentials.accessToken)')));
      expect(
          content, isNot(contains('logDebug(client.credentials.accessToken)')));
      expect(content,
          isNot(contains('developer.log(res.\$1.credentials.accessToken)')));
      expect(content,
          isNot(contains('developer.log(client.credentials.accessToken)')));
    });
  });
}
