import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: kPh20v10,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_rounded,
              size: 40,
              color: color,
            ),
            SelectableText(
              message ?? 'And error occurred. $kUnexpectedRaiseIssue',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: color),
            ),
            kVSpacer20,
            FilledButton.tonalIcon(
              onPressed: () {
                launchUrl(Uri.parse(kGitUrl));
              },
              icon: const Icon(Icons.arrow_outward_rounded),
              label: Text(
                'Raise Issue',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
