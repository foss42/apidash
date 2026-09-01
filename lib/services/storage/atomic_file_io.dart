import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

Future<void> writeFileAtomic(String path, List<int> bytes) async {
  final file = File(path);
  final parent = file.parent;
  if (!await parent.exists()) {
    await parent.create(recursive: true);
  }
  final tmpPath = '$path.tmp';
  final tmpFile = File(tmpPath);
  try {
    await tmpFile.writeAsBytes(bytes, flush: true);
    if (await file.exists()) {
      await file.delete();
    }
    await tmpFile.rename(path);
  } catch (e, st) {
    debugPrint('writeFileAtomic failed for $path: $e\n$st');
    if (await tmpFile.exists()) {
      try {
        await tmpFile.delete();
      } catch (_) {}
    }
    rethrow;
  }
}

Future<void> writeJsonAtomic(String path, Map<String, Object?> json) async {
  final encoded = const JsonEncoder.withIndent('  ').convert(json);
  await writeFileAtomic(path, utf8.encode(encoded));
}

Future<String?> readFileString(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    return null;
  }
  return file.readAsString();
}

Future<Map<String, Object?>?> readJsonFile(String path) async {
  final raw = await readFileString(path);
  if (raw == null || raw.isEmpty) {
    return null;
  }
  final decoded = jsonDecode(raw);
  if (decoded is! Map) {
    return null;
  }
  return Map<String, Object?>.from(decoded);
}
