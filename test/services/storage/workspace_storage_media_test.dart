import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:apidash/consts.dart';
import 'package:apidash/services/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../providers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const collectionId = 'col1';
  const requestId = 'req1';

  // Minimal PNG header + payload (content does not matter for the test).
  final imageBytes = Uint8List.fromList(
    [137, 80, 78, 71, 13, 10, 26, 10, 1, 2, 3, 4, 5, 6, 7, 8],
  );

  Map<String, dynamic> requestJsonWith(
    Map<String, dynamic> responseModel,
  ) =>
      {
        'id': requestId,
        'httpResponseModel': responseModel,
      };

  String requestDirPath() => p.join(
        workspaceStorage.rootPath,
        kWorkspaceCollectionsDir,
        collectionId,
        requestId,
      );

  setUp(() async {
    await testSetUpWorkspaceStorage();
  });

  group('Media responses saved as files', () {
    test('extracts binary media body to a sibling file with a pointer',
        () async {
      await workspaceStorage.setRequestModel(
        collectionId,
        requestId,
        requestJsonWith({
          'statusCode': 200,
          'headers': {'content-type': 'image/png'},
          'bodyBytes': imageBytes,
        }),
        saveMediaAsFiles: true,
      );

      final responseJsonPath =
          p.join(requestDirPath(), kWorkspaceResponseFile);
      final responseJson = jsonDecode(
        await File(responseJsonPath).readAsString(),
      ) as Map<String, dynamic>;

      expect(responseJson.containsKey('bodyBytes'), isFalse);
      expect(responseJson[kWorkspaceResponseBodyFileKey], 'response_body.png');

      final bodyFile = File(
        p.join(requestDirPath(), 'response_body.png'),
      );
      expect(bodyFile.existsSync(), isTrue);
      expect(await bodyFile.readAsBytes(), imageBytes);
    });

    test('reads the body file back into bodyBytes on load', () async {
      await workspaceStorage.setRequestModel(
        collectionId,
        requestId,
        requestJsonWith({
          'statusCode': 200,
          'headers': {'content-type': 'image/png'},
          'bodyBytes': imageBytes,
        }),
        saveMediaAsFiles: true,
      );

      final loaded = workspaceStorage.getRequestModel(collectionId, requestId);
      final response =
          loaded!['httpResponseModel'] as Map<String, dynamic>;

      expect(response.containsKey(kWorkspaceResponseBodyFileKey), isFalse);
      expect(response['bodyBytes'], imageBytes);
    });

    test('inlines bytes when the setting is off', () async {
      await workspaceStorage.setRequestModel(
        collectionId,
        requestId,
        requestJsonWith({
          'statusCode': 200,
          'headers': {'content-type': 'image/png'},
          'bodyBytes': imageBytes,
        }),
        saveMediaAsFiles: false,
      );

      final responseJson = jsonDecode(
        await File(p.join(requestDirPath(), kWorkspaceResponseFile))
            .readAsString(),
      ) as Map<String, dynamic>;

      expect(responseJson['bodyBytes'], imageBytes);
      expect(responseJson.containsKey(kWorkspaceResponseBodyFileKey), isFalse);
      expect(
        File(p.join(requestDirPath(), 'response_body.png')).existsSync(),
        isFalse,
      );
    });

    test('does not extract non-media (text) responses even when on', () async {
      final textBytes = Uint8List.fromList(utf8.encode('hello world'));
      await workspaceStorage.setRequestModel(
        collectionId,
        requestId,
        requestJsonWith({
          'statusCode': 200,
          'headers': {'content-type': 'text/plain'},
          'bodyBytes': textBytes,
        }),
        saveMediaAsFiles: true,
      );

      final responseJson = jsonDecode(
        await File(p.join(requestDirPath(), kWorkspaceResponseFile))
            .readAsString(),
      ) as Map<String, dynamic>;

      expect(responseJson['bodyBytes'], textBytes);
      expect(responseJson.containsKey(kWorkspaceResponseBodyFileKey), isFalse);
    });

    test('cleans up a stale body file when content type becomes text',
        () async {
      await workspaceStorage.setRequestModel(
        collectionId,
        requestId,
        requestJsonWith({
          'statusCode': 200,
          'headers': {'content-type': 'image/png'},
          'bodyBytes': imageBytes,
        }),
        saveMediaAsFiles: true,
      );
      expect(
        File(p.join(requestDirPath(), 'response_body.png')).existsSync(),
        isTrue,
      );

      final textBytes = Uint8List.fromList(utf8.encode('now text'));
      await workspaceStorage.setRequestModel(
        collectionId,
        requestId,
        requestJsonWith({
          'statusCode': 200,
          'headers': {'content-type': 'text/plain'},
          'bodyBytes': textBytes,
        }),
        saveMediaAsFiles: true,
      );

      expect(
        File(p.join(requestDirPath(), 'response_body.png')).existsSync(),
        isFalse,
      );
    });
  });
}
