import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'details_card/details_card.dart';
import 'url_card.dart';

class RequestEditor extends StatelessWidget {
  const RequestEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const EditorPaneRequestURLCard(),
        kVSpacer10,
        Expanded(
          child: kIsMobile
              ? const EditRequestPane()
              : const EditorPaneRequestDetailsCard(),
        ),
      ],
    );
  }
}
