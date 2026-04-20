import 'dart:io';

import 'package:hive_ce/hive.dart';

Future<void> main() async {
  final workspacePath = Platform.environment['APIDASH_WORKSPACE_PATH']?.trim();
  if (workspacePath == null || workspacePath.isEmpty) {
    stderr.writeln(
      'APIDASH_WORKSPACE_PATH is required. Example: '
      'APIDASH_WORKSPACE_PATH=D:/temp/apidash_cli_manual',
    );
    exitCode = 64;
    return;
  }

  Hive.init(workspacePath);

  final dataBox = await Hive.openBox('apidash-data');
  final historyMetaBox = await Hive.openBox('apidash-history-meta');
  final historyLazyBox = await Hive.openLazyBox('apidash-history-lazy');

  await dataBox.clear();
  await historyMetaBox.clear();
  await historyLazyBox.clear();

  const getId = 'manual_get_1';
  const postId = 'manual_post_1';

  final getRequest = <String, Object?>{
    'id': getId,
    'apiType': 'rest',
    'name': 'Manual GET Test',
    'description': 'Seeded request for CLI manual verification',
    'httpRequestModel': {
      'method': 'get',
      'url': 'https://httpbin.org/get',
      'headers': [
        {'name': 'Accept', 'value': 'application/json'},
      ],
      'params': [
        {'name': 'source', 'value': 'apidash-cli-manual'},
      ],
      'isHeaderEnabledList': [true],
      'isParamEnabledList': [true],
      'bodyContentType': 'json',
      'body': null,
      'query': null,
      'formData': <Map<String, Object?>>[],
    },
    'httpResponseModel': null,
  };

  final postRequest = <String, Object?>{
    'id': postId,
    'apiType': 'rest',
    'name': 'Manual POST Test',
    'description': 'Seeded request for CLI method filtering',
    'httpRequestModel': {
      'method': 'post',
      'url': 'https://httpbin.org/post',
      'headers': [
        {'name': 'Content-Type', 'value': 'application/json'},
      ],
      'params': <Map<String, Object?>>[],
      'isHeaderEnabledList': [true],
      'isParamEnabledList': <bool>[],
      'bodyContentType': 'json',
      'body': '{"hello":"apidash"}',
      'query': null,
      'formData': <Map<String, Object?>>[],
    },
    'httpResponseModel': null,
  };

  await dataBox.put('ids', [getId, postId]);
  await dataBox.put(getId, getRequest);
  await dataBox.put(postId, postRequest);

  stdout.writeln('Seed complete at: $workspacePath');
  stdout.writeln('Request IDs: $getId, $postId');
}
