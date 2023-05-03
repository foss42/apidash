import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'editor_pane/editor_pane.dart';
import 'collection_pane.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(
          child: DashboardSplitView(
            sidebarWidget: CollectionPane(),
            mainWidget: RequestEditorPane(),
          ),
        ),
      ],
    );
  }
}
