import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import 'package:apidash/utils/file_utils.dart';

class FakeFileSelectorPlatform extends FileSelectorPlatform {
  FileSaveLocation? locationToReturn;
  List<XTypeGroup>? lastAcceptedTypeGroups;
  String? lastSuggestedName;

  @override
  Future<XFile?> openFile({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async => null;

  @override
  Future<List<XFile>> openFiles({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async => <XFile>[];

  @override
  Future<String?> getDirectoryPath({
    String? initialDirectory,
    String? confirmButtonText,
  }) async => null;

  @override
  Future<List<String>> getDirectoryPaths({
    String? initialDirectory,
    String? confirmButtonText,
  }) async => <String>[];

  @override
  Future<String?> getSavePath({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? suggestedName,
    String? confirmButtonText,
  }) async => null;

  @override
  Future<FileSaveLocation?> getSaveLocation({
    List<XTypeGroup>? acceptedTypeGroups,
    SaveDialogOptions options = const SaveDialogOptions(),
  }) async {
    lastAcceptedTypeGroups = acceptedTypeGroups;
    lastSuggestedName = options.suggestedName;
    return locationToReturn;
  }
}

void main() {
  late FakeFileSelectorPlatform fakePlatform;

  setUp(() {
    fakePlatform = FakeFileSelectorPlatform();
    FileSelectorPlatform.instance = fakePlatform;
  });

  group("Testing File Utils", () {
    test('Test getFileExtension', () {
      String mimetype = "text/csv";
      expect(getFileExtension(mimetype), "csv");
    });

    test('Test getShortPath', () {
      if (kIsWindows) {
        String path = r"A\B\C\D.csv";
        expect(getShortPath(path), r"...\C\D.csv");
      } else {
        String path = "A/B/C/D.csv";
        expect(getShortPath(path), ".../C/D.csv");
      }
    });

    test('Test getTempFileName', () {
      expect(getTempFileName().length, greaterThan(0));
    });

    test('Test getSuggestedFileName', () {
      expect(getSuggestedFileName('response', 'json'), 'response.json');
      expect(getSuggestedFileName('response', null), 'response');
    });

    test('Test getFileSavePath', () async {
      fakePlatform.locationToReturn = const FileSaveLocation(
        '/tmp/response.json',
      );

      final path = await getFileSavePath(
        'response',
        'json',
        mimeType: 'application/json',
      );

      expect(path, '/tmp/response.json');
      expect(fakePlatform.lastSuggestedName, 'response.json');
      expect(fakePlatform.lastAcceptedTypeGroups, hasLength(1));
      expect(fakePlatform.lastAcceptedTypeGroups!.single.mimeTypes, <String>[
        'application/json',
      ]);
      expect(fakePlatform.lastAcceptedTypeGroups!.single.extensions, <String>[
        'json',
      ]);
    });
  });
}
