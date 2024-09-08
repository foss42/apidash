import 'package:file_selector/file_selector.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:flutter/material.dart';

class WorkspaceSelector extends StatefulWidget {
  final Future<void> Function(String)? onSelect;
  const WorkspaceSelector({
    super.key,
    required this.onSelect,
  });

  @override
  WorkspaceSelectorState createState() => WorkspaceSelectorState();
}

class WorkspaceSelectorState extends State<WorkspaceSelector> {
  void selectFolder() async {
    String? selectedDirectory = await getDirectoryPath();
    if (selectedDirectory != null) {
      widget.onSelect?.call(selectedDirectory);
    }
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
          future: openHiveBoxes(snapshot.data!),
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
