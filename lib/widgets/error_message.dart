import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: kPh20v10,
      child: Center(
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
              message ??
                  '${l10n!.kLabelErrorOccoured} ${l10n.kUnexpectedRaiseIssue}',
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
                      l10n!.kLabelRaiseIssue,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
