import 'dart:io';

import 'package:apidash/sync/sync_manifest_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('apidash_sync_manifest_');
  });

  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  test('hashFileContent is stable sha256 prefix', () {
    expect(
      hashFileContent([1, 2, 3]),
      startsWith('sha256:'),
    );
    expect(hashFileContent([1, 2, 3]), hashFileContent([1, 2, 3]));
    expect(hashFileContent([1, 2, 3]), isNot(hashFileContent([1, 2, 4])));
  });

  test('buildSyncManifest includes syncable files and skips ignored', () async {
    final collection = Directory(p.join(root.path, 'collections', 'API'))
      ..createSync(recursive: true);
    File(p.join(collection.path, 'request_index.json'))
        .writeAsStringSync('{"requests":[]}');
    Directory(p.join(root.path, 'environments')).createSync(recursive: true);
    File(p.join(root.path, 'environments', 'global.json'))
        .writeAsStringSync('{"id":"global"}');
    File(p.join(root.path, 'environments', 'dev.local.json'))
        .writeAsStringSync('{"secret":true}');
    Directory(p.join(root.path, '.apidash')).createSync(recursive: true);
    File(p.join(root.path, '.apidash', 'sync.json')).writeAsStringSync('{}');
    Directory(p.join(root.path, 'history')).createSync(recursive: true);
    File(p.join(root.path, 'history', 'x.json')).writeAsStringSync('{}');

    final manifest = await buildSyncManifest(root.path);

    expect(manifest.keys.toList(), [
      'collections/API/request_index.json',
      'environments/global.json',
    ]);
    expect(manifest['collections/API/request_index.json'], startsWith('sha256:'));
  });

  test('buildSyncManifest returns empty for missing root', () async {
    expect(await buildSyncManifest(p.join(root.path, 'missing')), isEmpty);
  });
}
