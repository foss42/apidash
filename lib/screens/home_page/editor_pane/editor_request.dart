import 'package:apidash_design_system/ui/design_system_provider.dart';
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
    final ds = DesignSystemProvider.of(context);
    return context.isMediumWindow
        ? Padding(
            padding: kPb10,
            child: Column(
              children: [
                kVSpacer20(ds.scaleFactor),
                const Expanded(
                  child: EditRequestPane(
                    showViewCodeButton: false,
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: kIsMacOS ? kPt28o8 : kP8,
            child: Column(
              children: [
                const RequestEditorTopBar(),
                const EditorPaneRequestURLCard(),
                kVSpacer10(ds.scaleFactor),
                const Expanded(
                  child: EditorPaneRequestDetailsCard(),
                ),
              ],
            ),
          );
  }
}
