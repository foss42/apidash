import 'dart:io';

import 'package:test/test.dart';

Directory _packageRoot() {
  final candidates = <String>[
    '${Directory.current.path}${Platform.pathSeparator}packages${Platform.pathSeparator}genai',
    Directory.current.path,
  ];

  for (final candidate in candidates) {
    final pubspec = File('$candidate${Platform.pathSeparator}pubspec.yaml');
    if (pubspec.existsSync()) {
      return Directory(candidate);
    }
  }

  fail('Unable to locate genai package root.');
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
    test('pubspec does not require Flutter and resolves local better_networking',
        () async {
      final root = _packageRoot();
      final pubspec = await File(
        '${root.path}${Platform.pathSeparator}pubspec.yaml',
      ).readAsString();

      expect(
        pubspec,
        isNot(contains(RegExp(r'^\s*flutter:\s*$', multiLine: true))),
      );
      expect(pubspec, isNot(contains('sdk: flutter')));
      expect(pubspec, contains('better_networking: any'));
    });

    test('library sources do not import Flutter-only libraries', () async {
      final root = _packageRoot();
      final libDir = Directory('${root.path}${Platform.pathSeparator}lib');
      final dartFiles = await _dartFilesIn(libDir);

      for (final file in dartFiles) {
        if (file.path.contains(
          '${Platform.pathSeparator}widgets${Platform.pathSeparator}',
        )) {
          continue;
        }
        final content = await file.readAsString();
        expect(
          content,
          isNot(contains('package:flutter/')),
          reason: 'Unexpected Flutter import in ${file.path}',
        );
        expect(
          content,
          isNot(contains('dart:ui')),
          reason: 'Unexpected dart:ui import in ${file.path}',
        );
      }
    });

    test('pure Dart and Flutter entrypoints stay separated', () async {
      final root = _packageRoot();
      final pureEntrypoint = await File(
        '${root.path}${Platform.pathSeparator}lib${Platform.pathSeparator}genai.dart',
      ).readAsString();
      final flutterEntrypoint = await File(
        '${root.path}${Platform.pathSeparator}lib${Platform.pathSeparator}genai_flutter.dart',
      ).readAsString();

      expect(pureEntrypoint, isNot(contains('widgets/widgets.dart')));
      expect(pureEntrypoint, isNot(contains('package:flutter/')));
      expect(flutterEntrypoint, contains("export 'genai.dart';"));
      expect(flutterEntrypoint, contains("export 'widgets/widgets.dart';"));
    });
  });
}
