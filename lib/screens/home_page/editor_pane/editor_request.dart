import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'details_card/details_card.dart';
import 'details_card/request_pane/request_pane.dart';
import 'request_editor_top_bar.dart';
import 'url_card.dart';

class RequestEditor extends StatelessWidget {
  const RequestEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return context.isMediumWindow
        ? const Padding(
            padding: kPb10,
            child: Column(
              children: [
                kVSpacer20,
                Expanded(
                  child: EditRequestPane(),
                ),
              ],
            ),
          )
        : Padding(
            padding: kIsMacOS || kIsWindows ? kPt28o8 : kP8,
            child: const Column(
              children: [
                RequestEditorTopBar(),
                EditorPaneRequestURLCard(),
                kVSpacer10,
                Expanded(
                  child: EditorPaneRequestDetailsCard(),
                ),
              ],
            ),
          );
  }
}
