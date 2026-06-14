import 'dart:io';
import 'dart:typed_data';
import 'package:apidash/consts.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final String tempPath;
  FakePathProviderPlatform(this.tempPath);

  @override
  Future<String?> getDownloadsPath() async {
    return tempPath;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return tempPath;
  }
}

class FakeFileSelectorPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements FileSelectorPlatform {
  @override
  Future<XFile?> openFile({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async {
    return XFile('/mock/picked/file.txt');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('apidash_file_test_dir');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
    FileSelectorPlatform.instance = FakeFileSelectorPlatform();
  });

  tearDownAll(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group(
    "Testing File Utils",
    () {
      test('Test getFileExtension', () {
        String mimetype = "text/csv";
        expect(getFileExtension(mimetype), "csv");
        expect(getFileExtension(null), isNull);
      });

      test('Test getShortPath', () {
        if (kIsWindows) {
          String path = r"A\B\C\D.csv";
          expect(getShortPath(path), r"...\C\D.csv");
          expect(getShortPath(r"A\B"), r"A\B");
        } else {
          String path = "A/B/C/D.csv";
          expect(getShortPath(path), ".../C/D.csv");
          expect(getShortPath("A/B"), "A/B");
        }
      });

      test('Test getFilenameFromPath', () {
        if (kIsWindows) {
          expect(getFilenameFromPath(r"A\B\C.txt"), "C.txt");
        } else {
          expect(getFilenameFromPath("A/B/C.txt"), "C.txt");
        }
      });

      test('Test getTempFileName', () {
        expect(getTempFileName().length, greaterThan(0));
      });

      test('Test getFileDownloadpath', () async {
        final path = await getFileDownloadpath("test", "txt");
        expect(path, startsWith(tempDir.path));
        expect(path, endsWith(".txt"));
        
        final path2 = await getFileDownloadpath(null, null);
        expect(path2, startsWith(tempDir.path));
      });

      test('getFileDownloadpath with existing file creates numbered suffix', () async {
        final path = await getFileDownloadpath('existing', 'txt');
        expect(path, isNotNull);
        final file = File(path!);
        await file.create();
        
        final path2 = await getFileDownloadpath('existing', 'txt');
        expect(path2, endsWith('existing (1).txt'));
        
        await file.delete();
      });

      test('getApplicationSupportDirectoryFilePath returns valid path', () async {
        final path = await getApplicationSupportDirectoryFilePath('appfile', 'log');
        expect(path, isNotNull);
        expect(path!.endsWith('.log'), isTrue);
      });

      test('getApplicationSupportDirectoryFilePath with existing file creates numbered suffix', () async {
        final path = await getApplicationSupportDirectoryFilePath('appfile_exist', 'log');
        expect(path, isNotNull);
        final file = File(path!);
        await file.create();
        
        final path2 = await getApplicationSupportDirectoryFilePath('appfile_exist', 'log');
        expect(path2, endsWith('appfile_exist (1).log'));
        
        await file.delete();
      });

      test('Test pickFile', () async {
        final file = await pickFile();
        expect(file?.path, "/mock/picked/file.txt");
      });

      test('Test saveFile and deleteFileFromPath', () async {
        // use a real temp dir for writing to actually test File API
        final directory = Directory.systemTemp;
        final testFilePath = '${directory.path}/test_save_file.txt';
        
        await saveFile(testFilePath, Uint8List.fromList([1, 2, 3]));
        expect(await File(testFilePath).exists(), isTrue);

        final loadedFile = await loadFileFromPath(testFilePath);
        expect(loadedFile?.path, testFilePath);

        final deleted = await deleteFileFromPath(testFilePath);
        expect(deleted, isTrue);
        expect(await File(testFilePath).exists(), isFalse);
      });

      test('Test loadFileFromPath returns null if missing', () async {
        final directory = Directory.systemTemp;
        final testFilePath = '${directory.path}/missing_file_xyz.txt';
        expect(await loadFileFromPath(testFilePath), isNull);
      });

      test('Test deleteFileFromPath returns false if missing', () async {
        final directory = Directory.systemTemp;
        final testFilePath = '${directory.path}/missing_file_xyz.txt';
        expect(await deleteFileFromPath(testFilePath), isFalse);
      });
    },
  );
}
