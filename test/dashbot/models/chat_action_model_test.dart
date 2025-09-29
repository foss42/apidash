import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('ChatAction serialization & defaults', () {
    test('fromJson (full) -> correct enum mapping', () {
      final json = {
        'action': 'apply_openapi',
        'target': 'documentation',
        'field': 'spec',
        'path': '/components/schemas',
        'value': {'k': 'v'},
      };
      final action = ChatAction.fromJson(json);
      expect(action.actionType, ChatActionType.applyOpenApi);
      expect(action.targetType, ChatActionTarget.documentation);
      expect(action.field, 'spec');
      expect(action.path, '/components/schemas');
      expect(action.value, {'k': 'v'});
    });

    test('fromJson (missing fields) -> uses safe defaults', () {
      final action = ChatAction.fromJson({});
      expect(action.actionType, ChatActionType.other);
      expect(action.targetType, ChatActionTarget.httpRequestModel);
      expect(action.field, '');
      expect(action.path, isNull);
    });

    test('toJson produces expected keys & enum strings', () {
      const action = ChatAction(
        action: 'download_doc',
        target: 'documentation',
        actionType: ChatActionType.downloadDoc,
        targetType: ChatActionTarget.documentation,
      );
      final json = action.toJson();
      expect(json, containsPair('action', 'download_doc'));
      expect(json, containsPair('target', 'documentation'));
      expect(json, containsPair('action_type', 'download_doc'));
      expect(json, containsPair('target_type', 'documentation'));
    });
  });
}
