import 'package:apidash_design_system/apidash_design_system.dart'
    show kVSpacer20, kVSpacer16, kVSpacer10, kVSpacer3;
import 'package:flutter/material.dart';

class DashbotDefaultPage extends StatelessWidget {
  const DashbotDefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        kVSpacer16,
        Image.asset(
          'assets/dashbot_icon_1.png',
          width: 60,
        ),
        kVSpacer20,
        Text(
          'Hello there!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        kVSpacer10,
        Text(
          'Seems like you haven\'t made any\nrequest yet! 👀',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        kVSpacer3,
        Text(
          "Why not go ahead and make one?",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}
