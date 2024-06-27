// Store hive save folder path.
// SharedPreferences dynamicall changes saving folder based on platform, which isn't null.
// Contrary to this hive stores the data in `getApplicationDocumentsDirectory()` given by 
// the path_provider package. Which is platform dependent and could be null. 
// See this issue for more details:
//  - https://github.com/foss42/apidash/issues/359

import 'package:shared_preferences/shared_preferences.dart';

// The key to store the folder path in shared preferences.
const String kHiveSaveFolder = 'hive_save_folder';

Future<String?> getHiveSaveFolder() async {
  // Retrieves the folder path where hive stores data. 
  // Which is stored in shared preferences.

  // Getting the shared preferences instance.
  final prefs = await SharedPreferences.getInstance();
  // Getting the folder path.
  return prefs.getString(kHiveSaveFolder);
}

Future<void> setHiveSaveFolder(String folder) async {
  // Sets the folder path where hive stores data. 

  // Getting the shared preferences instance.
  final prefs = await SharedPreferences.getInstance();
  // Setting the folder path.
  await prefs.setString(kHiveSaveFolder, folder);
}
