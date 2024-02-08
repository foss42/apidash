import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'details_card/details_card.dart';
import 'url_card.dart';

class RequestEditor extends StatelessWidget {
  const RequestEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        EditorPaneRequestURLCard(),
        kVSpacer10,
        Expanded(
          child: EditorPaneRequestDetailsCard(),
        ),
      ],
    );
  }
}
