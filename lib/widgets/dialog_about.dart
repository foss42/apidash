import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';

showAboutAppDialog(
  BuildContext context,
) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: kPt20 + kPh20 + kPb10,
          content: Container(
            width: double.infinity,
            height: double.infinity,
            constraints: const BoxConstraints(maxWidth: 540, maxHeight: 544),
            child: const IntroMessage(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      });
}
