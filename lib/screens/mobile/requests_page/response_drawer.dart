import 'package:flutter/material.dart';
import '../../home_page/editor_pane/details_card/response_pane.dart';

class ResponseDrawer extends StatelessWidget {
  const ResponseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text("Response"),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: const ResponsePane(),
      ),
    );
  }
}
