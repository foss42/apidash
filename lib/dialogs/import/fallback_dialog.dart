import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ImportErrorDialog extends StatelessWidget {
  const ImportErrorDialog({super.key});

  Widget retryButton(BuildContext context) => FilledButton.tonalIcon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.refresh_rounded,
          color: Theme.of(context).colorScheme.onTertiary,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.tertiary,
          ),
        ),
        label: Text(
          'Import another file',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          kVSpacer20,
          const Column(
            children: [
              //TODO: Switch ErrorMessage
              // icon to Icons.error (outlined, rounded)
              ErrorMessage(
                message:
                    'Oops! Looks like we couldn\'t identify your file...\n$kRaiseIssue',
              ),
            ],
          ),
          kVSpacer20,
          retryButton(context),
        ],
      ),
    );
  }
}
