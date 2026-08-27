import 'package:apidash/sync/consts.dart';
import 'package:apidash/sync/transport/sync_messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SyncMessage', () {
    test('round-trips hello and accessors', () {
      final message = SyncMessage.hello(
        token: 'ABCD2345',
        workspaceId: 'ws-1',
        displayName: 'Desk',
        hasBaseline: true,
        sessionMode: 'incremental',
      );

      final decoded = SyncMessage.tryDecode(message.encode());
      expect(decoded, isNotNull);
      expect(decoded!.type, SyncMessageType.hello);
      expect(decoded.stringToken, 'ABCD2345');
      expect(decoded.stringWorkspaceId, 'ws-1');
      expect(decoded.stringDisplayName, 'Desk');
      expect(decoded.hasBaseline, isTrue);
      expect(decoded.stringSessionMode, 'incremental');
      expect(decoded.payload['protocolVersion'], kSyncProtocolVersion);
    });

    test('manifest / applyComplete / fileContent helpers', () {
      final manifest = SyncMessage.manifest({'collections/a.json': 'sha256:x'});
      expect(manifest.readManifest(), {'collections/a.json': 'sha256:x'});

      final apply = SyncMessage.applyComplete(
        {'collections/a.json': 'sha256:y'},
        writes: {'collections/a.json': '{}'},
        deletes: ['collections/old.json'],
      );
      expect(apply.readWrites(), {'collections/a.json': '{}'});
      expect(apply.readDeletes(), ['collections/old.json']);

      final content = SyncMessage.fileContent(
        path: 'collections/a.json',
        content: '{}',
      );
      expect(content.stringPath, 'collections/a.json');
      expect(content.stringContent, '{}');
      expect(content.isDeleted, isFalse);

      final deleted = SyncMessage.fileContent(
        path: 'collections/gone.json',
        deleted: true,
      );
      expect(deleted.isDeleted, isTrue);
    });

    test('tryDecode rejects garbage', () {
      expect(SyncMessage.tryDecode('not-json'), isNull);
      expect(SyncMessage.tryDecode('{"type":"nope"}'), isNull);
      expect(SyncMessage.tryDecode('[]'), isNull);
    });
  });

  group('SyncQrPayload', () {
    test('round-trips websocket url fields', () {
      const payload = SyncQrPayload(
        host: '192.168.1.10',
        port: kSyncDefaultPort,
        token: 'ABCD2345',
        workspaceId: 'ws-1',
        workspaceName: 'Demo',
        desktopName: 'Mac',
      );

      expect(payload.websocketUrl, 'ws://192.168.1.10:$kSyncDefaultPort/sync');

      final decoded = SyncQrPayload.tryDecode(payload.encode());
      expect(decoded, isNotNull);
      expect(decoded!.host, '192.168.1.10');
      expect(decoded.port, kSyncDefaultPort);
      expect(decoded.token, 'ABCD2345');
      expect(decoded.workspaceId, 'ws-1');
      expect(decoded.workspaceName, 'Demo');
      expect(decoded.desktopName, 'Mac');
    });

    test('tryDecode rejects invalid payloads', () {
      expect(SyncQrPayload.tryDecode('nope'), isNull);
      expect(SyncQrPayload.tryDecode('{"host":"x"}'), isNull);
      expect(
        SyncQrPayload.tryDecode('{"host":"x","port":"bad","token":"t"}'),
        isNull,
      );
    });
  });
}
