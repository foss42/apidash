import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apidash/consts.dart';

class DiscordButton extends StatelessWidget {
  const DiscordButton({
    super.key,
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    var label = text ?? 'Discord Server';
    return ADFilledButton(
      icon: Icons.discord,
      iconSize: kButtonIconSizeLarge,
      label: label,
      onPressed: () {
        launchUrl(Uri.parse(kDiscordUrl));
      },
    );
  }
}
