import 'dart:io';

import 'package:apidash/hive_directory_selector.dart';
import 'package:apidash/models/hive_storage_folder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Directory tempDir = await Directory.systemTemp.createTemp('hive_dir_temp');

  testWidgets('Given valid path, Then load the child component', (widgetTester) async {
    await widgetTester.runAsync(() async {
      // Set the hive save folder
      SharedPreferences.setMockInitialValues({});
      await setHiveSaveFolder(tempDir.path);

      // Rendering the widgets
      await widgetTester.pumpWidget(
        HiveDirectorySelector(
          getDirectoryPath: () async => tempDir.path,
          child: Container(),
        ),
      );

      // Find the container widget in the tree
      expect(find.byType(Container), findsOneWidget);
    });
  });

  testWidgets('Given when no path is set, Then set hive save folder',
      (widgetTester) async {
    await widgetTester.runAsync(() async {
      // Checking inital hive save folder to be null
      SharedPreferences.setMockInitialValues({});
      expect(await getHiveSaveFolder(), null);

      // rendering the widgets
      await widgetTester.pumpWidget(
        HiveDirectorySelector(
          getDirectoryPath: () async => tempDir.path,
          child: Container(),
        ),
      );

      // making a pump to render the widgets
      await widgetTester.pump();

      // check if CircularProgressIndicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // check if the function `selectFolder` is called
      final state = widgetTester.state(find.byType(HiveDirectorySelector))
          as HiveDirectorySelectorState;
      expect(state.selectFolder, isNotNull,
          reason: "The function selectFolder isn't rechable.");

      // check if the hive save folder is set
      expect(await getHiveSaveFolder(), tempDir.path);
    });
  });
}
