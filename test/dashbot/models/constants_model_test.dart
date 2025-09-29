import 'package:apidash/dashbot/constants.dart';
import 'package:test/test.dart';

void main() {
  group('Constants enum mappings', () {
    test('ChatActionType round-trip mapping', () {
      final map = <ChatActionType, String>{
        ChatActionType.updateField: 'update_field',
        ChatActionType.addHeader: 'add_header',
        ChatActionType.updateHeader: 'update_header',
        ChatActionType.deleteHeader: 'delete_header',
        ChatActionType.updateBody: 'update_body',
        ChatActionType.updateUrl: 'update_url',
        ChatActionType.updateMethod: 'update_method',
        ChatActionType.showLanguages: 'show_languages',
        ChatActionType.applyCurl: 'apply_curl',
        ChatActionType.applyOpenApi: 'apply_openapi',
        ChatActionType.downloadDoc: 'download_doc',
        ChatActionType.other: 'other',
        ChatActionType.noAction: 'no_action',
        ChatActionType.uploadAsset: 'upload_asset',
      };
      map.forEach((enumVal, strVal) {
        expect(enumVal.text, strVal);
        expect(chatActionTypeFromString(strVal), enumVal);
      });
      // unknown
      expect(chatActionTypeFromString('some_new_type'), ChatActionType.other);
    });

    test('ChatActionTarget round-trip mapping', () {
      final map = <ChatActionTarget, String>{
        ChatActionTarget.httpRequestModel: 'httpRequestModel',
        ChatActionTarget.codegen: 'codegen',
        ChatActionTarget.test: 'test',
        ChatActionTarget.code: 'code',
        ChatActionTarget.attachment: 'attachment',
        ChatActionTarget.documentation: 'documentation',
      };
      map.forEach((enumVal, strVal) {
        expect(enumVal.name, strVal);
        expect(chatActionTargetFromString(strVal), enumVal);
      });
      // unknown maps to default httpRequestModel
      expect(chatActionTargetFromString('weird'),
          ChatActionTarget.httpRequestModel);
    });
  });
}
