import 'dart:io';

import 'package:apidash/models/hive_storage_folder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() async{
  Directory tempDir =
      await Directory.systemTemp.createTemp('save_folder_path');

  test('Load Hive directory', () async {
    SharedPreferences.setMockInitialValues({kHiveSaveFolder: tempDir.path});
    expect(await getHiveSaveFolder(), tempDir.path);
  });

  test('Saving Hive directory', () async {
    setHiveSaveFolder(tempDir.path);
    expect(await getHiveSaveFolder(), tempDir.path);
  });
}
