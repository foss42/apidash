import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/utils/utils.dart';
import 'package:apidash/dashbot/prompts/dashbot_prompts.dart';
import 'package:test/test.dart';

void main() {
  group('Smart Suggest feature tests', () {
    test('prompt generation', () {
      final prompts = DashbotPrompts();
      final prompt = prompts.suggestRequestPrompt(
        url: 'https://api.example.com/data',
        method: 'GET',
        headersMap: {'Authorization': 'Bearer 123'},
        paramsMap: {'q': 'test'},
      );
      
      expect(prompt, contains('https://api.example.com/data'));
      expect(prompt, contains('GET'));
      expect(prompt, contains('Bearer 123'));
      expect(prompt, contains('test'));
      expect(prompt, contains('update_method'));
      expect(prompt, contains('add_header'));
      expect(prompt, contains('add_query_param'));
      expect(prompt, contains('update_body'));
    });

    test('AI response parsing and conversion to AutoFix actions', () {
      const validJsonResponse = '''
      {
        "actions": [
          {
            "action": "update_method",
            "value": "POST"
          },
          {
            "action": "add_header",
            "path": "Content-Type",
            "value": "application/json"
          },
          {
            "action": "add_query_param",
            "path": "userId",
            "value": "123"
          }
        ]
      }
      ''';
      
      final parsed = MessageJson.safeParse(validJsonResponse);
      final actions = (parsed['actions'] as List)
          .whereType<Map<String, dynamic>>()
          .map(ChatAction.fromJson)
          .toList();

      expect(actions.length, 3);
      expect(actions[0].actionType, ChatActionType.updateMethod);
      expect(actions[0].value, 'POST');
      
      expect(actions[1].actionType, ChatActionType.addHeader);
      expect(actions[1].path, 'Content-Type');
      expect(actions[1].value, 'application/json');
      
      expect(actions[2].actionType, ChatActionType.addQueryParam);
      expect(actions[2].path, 'userId');
      expect(actions[2].value, '123');
    });

    test('Invalid AI response parsing ignores modifications safely', () {
      const invalidJsonResponse = 'Not a JSON response';
      
      expect(
        () {
          final parsed = MessageJson.safeParse(invalidJsonResponse);
          final actions = (parsed['actions'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(ChatAction.fromJson)
              .toList() ?? [];
          expect(actions.isEmpty, true);
        },
        returnsNormally,
      );
    });
  });
}
