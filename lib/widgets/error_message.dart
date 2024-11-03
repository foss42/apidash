import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    super.key,
    required this.message,
    this.showIcon = true,
    this.showIssueButton = true,
  });

  final String? message;
  final bool showIcon;
  final bool showIssueButton;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: kPh20v10,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showIcon
                  ? Icon(
                      Icons.warning_rounded,
                      size: 40,
                      color: color,
                    )
                  : const SizedBox(),
              SelectableText(
                message ?? 'An error occurred. $kUnexpectedRaiseIssue',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: color),
              ),
              kVSpacer20,
              showIssueButton
                  ? FilledButton.tonalIcon(
                      onPressed: () {
                        launchUrl(Uri.parse(kGitUrl));
                      },
                      icon: const Icon(Icons.arrow_outward_rounded),
                      label: Text(
                        'Raise Issue',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
