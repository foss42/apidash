import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnButton extends StatelessWidget {
  const LearnButton({
    super.key,
    this.label,
    this.icon,
    this.url,
  });

  final String? label;
  final IconData? icon;
  final String? url;

  @override
  Widget build(BuildContext context) {
    var textLabel = label ?? 'Learn';
    return SizedBox(
      height: 24,
      child: ADFilledButton(
        icon: Icons.help,
        iconSize: kButtonIconSizeSmall,
        label: textLabel,
        isTonal: true,
        buttonStyle: ButtonStyle(
          padding: WidgetStatePropertyAll(kP10),
        ),
        onPressed: () {
          if (url != null) {
            launchUrl(Uri.parse(url!));
          }
        },
      ),
    );
  }
}
