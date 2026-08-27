import 'dart:convert';
import 'dart:io';

import 'package:apidash/workflow/models/workflow_history_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads existing flow history record with response bodyBytes', () {
    final path = '/Users/shashwat/Desktop/test-workspace/test_api/history/'
        'flow_history/Workflow 1 2026-07-25 11.00.12 PM.json';
    final file = File(path);
    if (!file.existsSync()) {
      // Skip when workspace sample is not present.
      return;
    }
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final record = FlowHistoryRecord.fromJson(json);
    expect(record.nodeResults, isNotEmpty);
    expect(
      record.nodeResults.any((r) => r.hasHttpExchange),
      isTrue,
    );
  });

  test('roundtrips node result without bodyBytes', () {
    final encoded = workflowNodeRunResultToJson(
      workflowNodeRunResultFromJson({
        'nodeId': 'n1',
        'label': 'Get',
        'status': 'success',
        'method': 'get',
        'url': 'https://example.com',
        'httpResponseModel': {
          'statusCode': 200,
          'body': '{"ok":true}',
          'bodyBytes': [123, 34, 111, 107, 34, 58, 116, 114, 117, 101, 125],
        },
      }),
    );
    final decoded = workflowNodeRunResultFromJson(encoded);
    expect(decoded.statusCode ?? decoded.httpResponseModel?.statusCode, 200);
    expect(decoded.hasHttpExchange, isTrue);
    expect(encoded['httpResponseModel'], isA<Map>());
    expect(
      (encoded['httpResponseModel'] as Map).containsKey('bodyBytes'),
      isFalse,
    );
  });
}
