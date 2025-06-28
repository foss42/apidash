import 'package:apidash_design_system/apidash_design_system.dart'
    show kVSpacer20, kVSpacer16, kVSpacer10;
import 'package:dashbot/core/utils/dashbot_icons.dart';
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
        DashbotIcons.getDashbotIcon1(width: 60),

        kVSpacer20,
        Text(
          'Hello there!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        kVSpacer10,
        Text(
          'Request not made yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          "Why not go ahead and make one?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
        ),
      ],
    );
  }
}
