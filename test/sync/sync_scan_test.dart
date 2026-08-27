import 'package:apidash/sync/models/sync_models.dart';
import 'package:apidash/sync/sync_scan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveScanCase', () {
    test('firstLink when phone has no workspace id', () {
      expect(
        resolveScanCase(localWorkspaceId: null, qrWorkspaceId: 'ws-1'),
        SyncScanCase.firstLink,
      );
      expect(
        resolveScanCase(localWorkspaceId: '', qrWorkspaceId: 'ws-1'),
        SyncScanCase.firstLink,
      );
    });

    test('sameWorkspace when ids match and baseline exists', () {
      expect(
        resolveScanCase(
          localWorkspaceId: 'ws-1',
          qrWorkspaceId: 'ws-1',
          hasSyncedBaseline: true,
        ),
        SyncScanCase.sameWorkspace,
      );
    });

    test('differentWorkspace when ids match but no baseline', () {
      expect(
        resolveScanCase(
          localWorkspaceId: 'ws-1',
          qrWorkspaceId: 'ws-1',
          hasSyncedBaseline: false,
        ),
        SyncScanCase.differentWorkspace,
      );
    });

    test('differentWorkspace when ids mismatch', () {
      expect(
        resolveScanCase(
          localWorkspaceId: 'ws-a',
          qrWorkspaceId: 'ws-b',
          hasSyncedBaseline: true,
        ),
        SyncScanCase.differentWorkspace,
      );
    });
  });

  group('scanCaseNeedsAdoption / sessionModeForScanCase', () {
    test('maps cases to adoption and session mode', () {
      expect(scanCaseNeedsAdoption(SyncScanCase.sameWorkspace), isFalse);
      expect(scanCaseNeedsAdoption(SyncScanCase.firstLink), isTrue);
      expect(scanCaseNeedsAdoption(SyncScanCase.differentWorkspace), isTrue);

      expect(
        sessionModeForScanCase(SyncScanCase.sameWorkspace),
        SyncSessionMode.incremental,
      );
      expect(
        sessionModeForScanCase(SyncScanCase.firstLink),
        SyncSessionMode.workspaceReplace,
      );
      expect(
        sessionModeForScanCase(SyncScanCase.differentWorkspace),
        SyncSessionMode.workspaceReplace,
      );
    });
  });
}
