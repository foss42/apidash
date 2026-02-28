import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  group('DashbotActionMixin', () {
    test('mixin has action getter', () {
      // This is a mixin, so we test it by creating a class that uses it
      final testWidget = TestActionWidget();
      expect(testWidget.action, isA<ChatAction>());
    });
  });

  group('DashbotActionWidgetFactory.build', () {
    group('ChatActionType.other cases', () {
      test('returns DashbotImportNowButton when action is import_now_openapi',
          () {
        const action = ChatAction(
          action: 'import_now_openapi',
          target: 'httpRequestModel',
          actionType: ChatActionType.other,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotImportNowButton>());
        expect((widget as DashbotImportNowButton).action, equals(action));
      });

      test(
          'returns DashbotSelectOperationButton when field is select_operation',
          () {
        const action = ChatAction(
          action: 'some_action',
          target: 'httpRequestModel',
          field: 'select_operation',
          actionType: ChatActionType.other,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotSelectOperationButton>());
        expect((widget as DashbotSelectOperationButton).action, equals(action));
      });

      test('returns DashbotAddTestButton when targetType is test', () {
        const action = ChatAction(
          action: 'some_action',
          target: 'test',
          actionType: ChatActionType.other,
          targetType: ChatActionTarget.test,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAddTestButton>());
        expect((widget as DashbotAddTestButton).action, equals(action));
      });

      test('returns DashbotGeneratedCodeBlock when targetType is code', () {
        const action = ChatAction(
          action: 'some_action',
          target: 'code',
          actionType: ChatActionType.other,
          targetType: ChatActionTarget.code,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotGeneratedCodeBlock>());
        expect((widget as DashbotGeneratedCodeBlock).action, equals(action));
      });

      test('returns null when no conditions match for ChatActionType.other',
          () {
        const action = ChatAction(
          action: 'unknown_action',
          target: 'httpRequestModel',
          field: 'unknown_field',
          actionType: ChatActionType.other,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isNull);
      });
    });

    group('ChatActionType.showLanguages cases', () {
      test('returns DashbotGenerateLanguagePicker when targetType is codegen',
          () {
        const action = ChatAction(
          action: 'show_languages',
          target: 'codegen',
          actionType: ChatActionType.showLanguages,
          targetType: ChatActionTarget.codegen,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotGenerateLanguagePicker>());
        expect(
            (widget as DashbotGenerateLanguagePicker).action, equals(action));
      });

      test('returns null when targetType is not codegen for showLanguages', () {
        const action = ChatAction(
          action: 'show_languages',
          target: 'httpRequestModel',
          actionType: ChatActionType.showLanguages,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isNull);
      });
    });

    group('ChatActionType.applyCurl cases', () {
      test('returns DashbotApplyCurlButton', () {
        const action = ChatAction(
          action: 'apply_curl',
          target: 'httpRequestModel',
          actionType: ChatActionType.applyCurl,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotApplyCurlButton>());
        expect((widget as DashbotApplyCurlButton).action, equals(action));
      });
    });

    group('ChatActionType.applyOpenApi cases', () {
      test('returns DashbotImportNowButton when action is import_now_openapi',
          () {
        const action = ChatAction(
          action: 'import_now_openapi',
          target: 'httpRequestModel',
          actionType: ChatActionType.applyOpenApi,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotImportNowButton>());
        expect((widget as DashbotImportNowButton).action, equals(action));
      });

      test('returns null when action is not import_now_openapi', () {
        const action = ChatAction(
          action: 'some_other_action',
          target: 'httpRequestModel',
          actionType: ChatActionType.applyOpenApi,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isNull);
      });
    });

    group('ChatActionType.downloadDoc cases', () {
      test('returns DashbotDownloadDocButton', () {
        const action = ChatAction(
          action: 'download_doc',
          target: 'documentation',
          actionType: ChatActionType.downloadDoc,
          targetType: ChatActionTarget.documentation,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotDownloadDocButton>());
        expect((widget as DashbotDownloadDocButton).action, equals(action));
      });
    });

    group('ChatActionType.noAction cases', () {
      test('returns DashbotImportNowButton when action is import_now_openapi',
          () {
        const action = ChatAction(
          action: 'import_now_openapi',
          target: 'httpRequestModel',
          actionType: ChatActionType.noAction,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotImportNowButton>());
        expect((widget as DashbotImportNowButton).action, equals(action));
      });

      test('returns null when action is not import_now_openapi', () {
        const action = ChatAction(
          action: 'some_other_action',
          target: 'httpRequestModel',
          actionType: ChatActionType.noAction,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isNull);
      });
    });

    group('ChatActionType update/add/delete cases', () {
      test('returns DashbotAutoFixButton for updateField', () {
        const action = ChatAction(
          action: 'update_field',
          target: 'httpRequestModel',
          actionType: ChatActionType.updateField,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAutoFixButton>());
        expect((widget as DashbotAutoFixButton).action, equals(action));
      });

      test('returns DashbotAutoFixButton for addHeader', () {
        const action = ChatAction(
          action: 'add_header',
          target: 'httpRequestModel',
          actionType: ChatActionType.addHeader,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAutoFixButton>());
        expect((widget as DashbotAutoFixButton).action, equals(action));
      });

      test('returns DashbotAutoFixButton for updateHeader', () {
        const action = ChatAction(
          action: 'update_header',
          target: 'httpRequestModel',
          actionType: ChatActionType.updateHeader,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAutoFixButton>());
        expect((widget as DashbotAutoFixButton).action, equals(action));
      });

      test('returns DashbotAutoFixButton for deleteHeader', () {
        const action = ChatAction(
          action: 'delete_header',
          target: 'httpRequestModel',
          actionType: ChatActionType.deleteHeader,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAutoFixButton>());
        expect((widget as DashbotAutoFixButton).action, equals(action));
      });

      test('returns DashbotAutoFixButton for updateBody', () {
        const action = ChatAction(
          action: 'update_body',
          target: 'httpRequestModel',
          actionType: ChatActionType.updateBody,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAutoFixButton>());
        expect((widget as DashbotAutoFixButton).action, equals(action));
      });

      test('returns DashbotAutoFixButton for updateUrl', () {
        const action = ChatAction(
          action: 'update_url',
          target: 'httpRequestModel',
          actionType: ChatActionType.updateUrl,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAutoFixButton>());
        expect((widget as DashbotAutoFixButton).action, equals(action));
      });

      test('returns DashbotAutoFixButton for updateMethod', () {
        const action = ChatAction(
          action: 'update_method',
          target: 'httpRequestModel',
          actionType: ChatActionType.updateMethod,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAutoFixButton>());
        expect((widget as DashbotAutoFixButton).action, equals(action));
      });
    });

    group('ChatActionType.uploadAsset cases', () {
      test('returns DashbotUploadRequestButton when targetType is attachment',
          () {
        const action = ChatAction(
          action: 'upload_asset',
          target: 'attachment',
          actionType: ChatActionType.uploadAsset,
          targetType: ChatActionTarget.attachment,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotUploadRequestButton>());
        expect((widget as DashbotUploadRequestButton).action, equals(action));
      });

      test('returns null when targetType is not attachment for uploadAsset',
          () {
        const action = ChatAction(
          action: 'upload_asset',
          target: 'httpRequestModel',
          actionType: ChatActionType.uploadAsset,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isNull);
      });
    });

    group('Fallback cases (legacy string-based checks)', () {
      test('returns DashbotAddTestButton when action=other and target=test',
          () {
        const action = ChatAction(
          action: 'other',
          target: 'test',
          actionType: ChatActionType.other,
          targetType: ChatActionTarget
              .httpRequestModel, // Different target type to test fallback
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAddTestButton>());
        expect((widget as DashbotAddTestButton).action, equals(action));
      });

      test(
          'returns DashbotGeneratedCodeBlock when action=other and target=code',
          () {
        const action = ChatAction(
          action: 'other',
          target: 'code',
          actionType: ChatActionType.other,
          targetType: ChatActionTarget
              .httpRequestModel, // Different target type to test fallback
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotGeneratedCodeBlock>());
        expect((widget as DashbotGeneratedCodeBlock).action, equals(action));
      });

      test(
          'returns DashbotGenerateLanguagePicker when action=show_languages and target=codegen',
          () {
        const action = ChatAction(
          action: 'show_languages',
          target: 'codegen',
          actionType: ChatActionType.other,
          targetType: ChatActionTarget
              .httpRequestModel, // Different target type to test fallback
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotGenerateLanguagePicker>());
        expect(
            (widget as DashbotGenerateLanguagePicker).action, equals(action));
      });

      test('returns DashbotApplyCurlButton when action=apply_curl', () {
        const action = ChatAction(
          action: 'apply_curl',
          target: 'httpRequestModel',
          actionType:
              ChatActionType.other, // Different action type to test fallback
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotApplyCurlButton>());
        expect((widget as DashbotApplyCurlButton).action, equals(action));
      });

      test('returns DashbotAutoFixButton when action contains "update"', () {
        const action = ChatAction(
          action: 'update_something',
          target: 'httpRequestModel',
          actionType:
              ChatActionType.other, // Different action type to test fallback
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAutoFixButton>());
        expect((widget as DashbotAutoFixButton).action, equals(action));
      });

      test('returns DashbotAutoFixButton when action contains "add"', () {
        const action = ChatAction(
          action: 'add_something',
          target: 'httpRequestModel',
          actionType:
              ChatActionType.other, // Different action type to test fallback
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAutoFixButton>());
        expect((widget as DashbotAutoFixButton).action, equals(action));
      });

      test('returns DashbotAutoFixButton when action contains "delete"', () {
        const action = ChatAction(
          action: 'delete_something',
          target: 'httpRequestModel',
          actionType:
              ChatActionType.other, // Different action type to test fallback
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isA<DashbotAutoFixButton>());
        expect((widget as DashbotAutoFixButton).action, equals(action));
      });

      test('returns null when no fallback conditions match', () {
        const action = ChatAction(
          action: 'unknown_action',
          target: 'unknown_target',
          actionType: ChatActionType.other,
          targetType: ChatActionTarget.httpRequestModel,
        );

        final widget = DashbotActionWidgetFactory.build(action);

        expect(widget, isNull);
      });
    });
  });
}

// Test class that implements DashbotActionMixin for testing purposes
class TestActionWidget extends Widget with DashbotActionMixin {
  const TestActionWidget({super.key});

  @override
  ChatAction get action => const ChatAction(
        action: 'test',
        target: 'test',
        actionType: ChatActionType.other,
        targetType: ChatActionTarget.httpRequestModel,
      );

  @override
  Element createElement() => throw UnimplementedError();
}
