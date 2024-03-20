import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../home_page/editor_pane/details_card/request_pane/request_pane.dart';
import '../home_page/editor_pane/url_card.dart';

class SliderBody extends StatelessWidget {
  const SliderBody({
    super.key,
    required this.panelController,
  });

  final PanelController panelController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        const EditorPaneRequestURLCard(),
        const SizedBox(
          height: 5,
        ),
        Flexible(
            child:
            EditRequestPane(panelController: panelController,)
        ),
        const SizedBox(
          height: 150,
        ),
      ],
    );
  }
}