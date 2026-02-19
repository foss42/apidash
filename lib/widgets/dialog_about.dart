import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';

showAboutAppDialog(
  BuildContext context,
) {
  showDialog(
      context: context,
      builder: (context) {
        final ds = DesignSystemProvider.of(context);
        return AlertDialog(
          contentPadding: kPt20 + kPh20 + kPb10,
          content: Container(
            width: double.infinity*ds.scaleFactor,
            height: double.infinity*ds.scaleFactor,
            constraints: BoxConstraints(maxWidth: 540*ds.scaleFactor, maxHeight: 544*ds.scaleFactor),
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
