import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

showHistoryRetentionDialog(
  BuildContext context,
  HistoryRetentionPeriod historyRetentionPeriod,
  Function(HistoryRetentionPeriod) onRetentionPeriodChange,
) {
  HistoryRetentionPeriod selectedRetentionPeriod = historyRetentionPeriod;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.manage_history_rounded),
        iconColor: Theme.of(context).colorScheme.primary,
        title: const Text("Manage History"),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        contentPadding: kPv20,
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: kPh24,
                child: Text(
                  "Select the duration for which you want to retain your request history",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.8),
                      ),
                ),
              ),
              kVSpacer10,
              ...HistoryRetentionPeriod.values
                  .map((e) => RadioListTile<HistoryRetentionPeriod>(
                        title: Text(
                          e.label,
                          style: TextStyle(
                              color: selectedRetentionPeriod == e
                                  ? Theme.of(context).colorScheme.primary
                                  : null),
                        ),
                        secondary: Icon(e.icon,
                            color: selectedRetentionPeriod == e
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6)),
                        value: e,
                        groupValue: selectedRetentionPeriod,
                        onChanged: (value) {
                          if (value != null) {
                            selectedRetentionPeriod = value;
                            (context as Element).markNeedsBuild();
                          }
                        },
                      ))
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              onRetentionPeriodChange(selectedRetentionPeriod);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
