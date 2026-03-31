import 'dart:io';

import 'package:test/test.dart';

Directory _packageRoot() {
  final pubspec = File(
    '${Directory.current.path}${Platform.pathSeparator}pubspec.yaml',
  );
  if (!pubspec.existsSync()) {
    fail('Test must run from the package root. Missing pubspec.yaml.');
  }
  return Directory.current;
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
    test('pubspec does not require Flutter and resolves local better_networking', () async {
      final root = _packageRoot();
      final pubspec = await File('${root.path}${Platform.pathSeparator}pubspec.yaml')
          .readAsString();

      expect(pubspec, isNot(contains(RegExp(r'^\s*flutter:\s*$', multiLine: true))));
      expect(pubspec, isNot(contains('sdk: flutter')));
      expect(pubspec, contains('path: ../better_networking'));
    });

    test('library sources do not import Flutter-only libraries', () async {
      final root = _packageRoot();
      final libDir = Directory('${root.path}${Platform.pathSeparator}lib');
      final dartFiles = await _dartFilesIn(libDir);

      for (final file in dartFiles) {
        if (file.path.contains('${Platform.pathSeparator}widgets${Platform.pathSeparator}')) {
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
  });
}
