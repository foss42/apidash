import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class TabLabel extends StatelessWidget {
  const TabLabel({
    super.key,
    required this.text,
    this.showIndicator = false,
  });

  final String text;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kTabHeight,
      child: Stack(
        children: [
          Center(
            child: Tooltip( //  NEW
              message: text,
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, //  improved
                maxLines: 1, // NEW
                style: kTextStyleTab,
              ),
            ),
          ),
          if (showIndicator)
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 1),
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
