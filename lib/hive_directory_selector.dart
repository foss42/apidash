import 'package:apidash/models/hive_storage_folder.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HiveDirectorySelector extends StatefulWidget {
  final Widget child;
  const HiveDirectorySelector({super.key, required this.child});

  @override
  HiveDirectorySelectorState createState() => HiveDirectorySelectorState();
}

class HiveDirectorySelectorState extends State<HiveDirectorySelector> {
  void selectFolder() async {
    // While installing zenity libxmlb is installed which is reqiured for
    // Packages (4) appstream-1.0.3-1  libadwaita-1:1.5.1-1  libxmlb-0.3.19-1  zenity-4.0.1-1
    // ERROR: FilePicker requires zenity for picking files

    // Show the folder selection menu
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    // TODO: check if can write in current folder
    // If the selected selectedDirectory isn't null save it as hive save folder
    if (selectedDirectory != null) setHiveSaveFolder(selectedDirectory);
    // Changing the state of application
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const circularLoader = MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    return FutureBuilder<String?>(
      future: getHiveSaveFolder(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return circularLoader;
        }

        // If there isn't hive selected folder choose it
        if (snapshot.data == null) {
          selectFolder();
          return circularLoader;
        }

        // Once _hiveSaveFolder is set, display DashApp after hive init
        return FutureBuilder<void>(
          future: openBoxes(snapshot.data!),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            // if loading show circularLoader
            if (snapshot.connectionState != ConnectionState.done) {
              return circularLoader;
            }
            // Display widget
            return widget.child;
          },
        );
      },
    );
  }
}
