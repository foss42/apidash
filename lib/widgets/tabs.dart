import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class TabLabel extends StatelessWidget {
  const TabLabel({super.key, required this.text, this.showIndicator = false});
  final String text;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kTabHeight,
      child: Stack(
        children: [
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: kTextStyleButton,
            ),
          ),
          if (showIndicator)
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 6),
                child: Icon(
                  Icons.circle,
                  size: 6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
