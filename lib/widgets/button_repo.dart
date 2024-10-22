import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apidash/consts.dart';

class RepoButton extends StatelessWidget {
  const RepoButton({
    super.key,
    this.text,
    this.icon,
  });

  final String? text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    var label = text ?? "GitHub";
    if (icon == null) {
      return FilledButton(
        onPressed: () {
          launchUrl(Uri.parse(kGitUrl));
        },
        child: Text(
          label,
          style: kTextStyleButton,
        ),
      );
    }
    return FilledButton.icon(
      onPressed: () {
        launchUrl(Uri.parse(kGitUrl));
      },
      icon: Icon(
        icon,
        size: 20.0,
      ),
      label: Text(
        label,
        style: kTextStyleButton,
      ),
    );
  }
}
