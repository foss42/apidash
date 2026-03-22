import 'dart:typed_data';
import 'package:apidash/dashbot/widgets/dashbot_action_buttons/dashbot_upload_requests_button.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_action.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';

import '../../../test_consts.dart';
import 'test_utils.dart';

class FakeFileSelectorPlatform extends FileSelectorPlatform {
  FakeFileSelectorPlatform({this.fileToReturn});

  XFile? fileToReturn;
  List<XTypeGroup>? lastAcceptedTypeGroups;

  @override
  Future<XFile?> openFile({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async {
    lastAcceptedTypeGroups = acceptedTypeGroups;
    return fileToReturn;
  }

  @override
  Future<List<XFile>> openFiles({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async {
    lastAcceptedTypeGroups = acceptedTypeGroups;
    return fileToReturn == null ? <XFile>[] : <XFile>[fileToReturn!];
  }

  @override
  Future<String?> getDirectoryPath({
    String? initialDirectory,
    String? confirmButtonText,
  }) async =>
      null;

  @override
  Future<List<String>> getDirectoryPaths({
    String? initialDirectory,
    String? confirmButtonText,
  }) async =>
      <String>[];

  @override
  Future<String?> getSavePath({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? suggestedName,
    String? confirmButtonText,
  }) async =>
      null;

  @override
  Future<FileSaveLocation?> getSaveLocation({
    List<XTypeGroup>? acceptedTypeGroups,
    SaveDialogOptions options = const SaveDialogOptions(),
  }) async =>
      null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFileSelectorPlatform fakePlatform;

  setUp(() {
    fakePlatform = FakeFileSelectorPlatform();
    FileSelectorPlatform.instance = fakePlatform;
  });

  group('DashbotUploadRequestButton', () {
    testWidgets('uploads OpenAPI attachment and forwards to chat viewmodel',
        (tester) async {
      final bytes = Uint8List.fromList('openapi spec'.codeUnits);
      fakePlatform.fileToReturn = XFile.fromData(bytes,
          name: 'spec.yaml', mimeType: 'application/yaml');

      const action = ChatAction(
        action: 'upload_asset',
        target: 'attachment',
        field: 'openapi_spec',
        value: {
          'purpose': 'OpenAPI specification',
          'accepted_types': ['application/yaml']
        },
        actionType: ChatActionType.uploadAsset,
        targetType: ChatActionTarget.attachment,
      );

      late TestChatViewmodel notifier;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatViewmodelProvider.overrideWith((ref) {
              notifier = TestChatViewmodel(ref);
              return notifier;
            }),
          ],
          child: MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: DashbotUploadRequestButton(action: action),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Upload: OpenAPI specification'));
      await tester.pump();

      expect(fakePlatform.lastAcceptedTypeGroups, isNotNull);
      final group = fakePlatform.lastAcceptedTypeGroups!.single;
      expect(group.mimeTypes, ['application/yaml']);

      expect(notifier.openApiAttachmentCalls, hasLength(1));
      final attachment = notifier.openApiAttachmentCalls.single;
      expect(attachment.mimeType, 'application/yaml');
      expect(attachment.sizeBytes, bytes.length);
    });

    testWidgets('sends message for non-openapi uploads', (tester) async {
      fakePlatform.fileToReturn =
          XFile.fromData(Uint8List.fromList([1, 2, 3]), name: 'data.bin');

      const action = ChatAction(
        action: 'upload_asset',
        target: 'attachment',
        value: {'purpose': 'Sample upload'},
        actionType: ChatActionType.uploadAsset,
        targetType: ChatActionTarget.attachment,
      );

      late TestChatViewmodel notifier;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatViewmodelProvider.overrideWith((ref) {
              notifier = TestChatViewmodel(ref);
              return notifier;
            }),
          ],
          child: MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: DashbotUploadRequestButton(action: action),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Upload: Sample upload'));
      await tester.pump();

      expect(notifier.sendMessageCalls, hasLength(1));
      final call = notifier.sendMessageCalls.single;
      expect(call.type, ChatMessageType.general);
      expect(call.text, contains('Attached file'));
      expect(call.text, contains('size=3'));
    });

    testWidgets('does nothing when user cancels file picker', (tester) async {
      fakePlatform.fileToReturn = null;

      const action = ChatAction(
        action: 'upload_asset',
        target: 'attachment',
        actionType: ChatActionType.uploadAsset,
        targetType: ChatActionTarget.attachment,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatViewmodelProvider.overrideWith((ref) => TestChatViewmodel(ref)),
          ],
          child: MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: DashbotUploadRequestButton(action: action),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Upload Attachment'));
      await tester.pump();

      // No exceptions and no attachments created
    });
  });
}
