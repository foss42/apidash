import 'package:flutter/material.dart';
import '../home_page/editor_pane/details_card/code_pane.dart';
import '../home_page/editor_pane/details_card/response_pane.dart';

class SliderPanel extends StatelessWidget {
  const SliderPanel({
    super.key,
    required this.sliderView,
  });

  final bool sliderView;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey,
            ),
            width: 40,
            height: 5,
          ),
        ),
        Flexible(
          child: sliderView ?  const ResponsePane() : const CodePane(),
        ),
      ],
    );
  }
}