import 'package:apidash/services/secure_storage.dart';
import 'package:apidash/workflow/utils/workflow_ai_secrets.dart';
import 'package:test/test.dart';

void main() {
  group('workflow AI secrets helpers', () {
    test('stripApiKeyFromJson clears aiRequestModel.apiKey', () {
      final stripped = AiRequestSecretsStorage.stripApiKeyFromJson({
        'id': 'req1',
        'aiRequestModel': {
          'model': 'gpt',
          'apiKey': 'sk-secret',
        },
      });
      final ai = stripped['aiRequestModel'] as Map;
      expect(ai['apiKey'], isNull);
      expect(ai['model'], 'gpt');
    });

    test('prepareWorkflowJsonForDisk strips keys when storage uninitialized',
        () async {
      final prepared = await prepareWorkflowJsonForDisk(
        workflowId: 'My Flow',
        json: {
          'name': 'My Flow',
          'nodes': [
            {
              'id': 'n1',
              'type': 'request',
              'label': 'AI',
              'request': {
                'id': 'req1',
                'aiRequestModel': {
                  'model': 'gpt',
                  'apiKey': 'sk-live',
                },
              },
            },
          ],
          'edges': [],
        },
      );

      final nodes = prepared['nodes'] as List;
      final request = (nodes.first as Map)['request'] as Map;
      final ai = request['aiRequestModel'] as Map;
      expect(ai['apiKey'], isNull);
      expect(ai['model'], 'gpt');
      expect(prepared['name'], 'My Flow');
    });

    test('apiKeyFromJson reads nested key', () {
      expect(
        AiRequestSecretsStorage.apiKeyFromJson({
          'aiRequestModel': {'apiKey': 'sk-x'},
        }),
        'sk-x',
      );
      expect(AiRequestSecretsStorage.apiKeyFromJson({}), isNull);
    });
  });
}
