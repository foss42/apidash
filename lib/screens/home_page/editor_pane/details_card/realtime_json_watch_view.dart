import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash/utils/json_watch_utils.dart';
import 'package:apidash/widgets/button_copy.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

Future<String?> showJsonWatchDialog(
  BuildContext context, {
  required String currentExpression,
}) async {
  var draftExpression = currentExpression;
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Watch a JSON value'),
      content: TextFormField(
        key: const ValueKey('websocket-watch-field'),
        initialValue: draftExpression,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: r'Key or JSONPath, for example $.price',
          helperText: 'Plain keys search nested objects automatically.',
        ),
        onChanged: (value) => draftExpression = value,
        onFieldSubmitted: (value) => Navigator.pop(context, value.trim()),
      ),
      actions: [
        if (currentExpression.isNotEmpty)
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            child: const Text('Stop watching'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, draftExpression.trim()),
          child: const Text('Watch'),
        ),
      ],
    ),
  );
}

class RealtimeJsonWatchView extends StatelessWidget {
  const RealtimeJsonWatchView({
    super.key,
    required this.history,
    required this.expression,
    required this.maxEvents,
  });

  final List<WebSocketMessage> history;
  final String expression;
  final int maxEvents;

  @override
  Widget build(BuildContext context) {
    final matches = <_WatchedValue>[];
    for (final message in history) {
      if (message.messageType != WebSocketMessageType.received) continue;
      final result = extractJsonWatchValue(message.payload, expression);
      if (result.found) {
        matches.add(
          _WatchedValue(
            timestamp: message.timestamp,
            displayValue: result.displayValue,
          ),
        );
      }
    }

    final visibleMatches = matches.length > maxEvents
        ? matches.sublist(matches.length - maxEvents)
        : matches;
    if (visibleMatches.isEmpty) {
      return Center(
        child: Text(
          'No values found for "$expression" in received JSON messages.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Text('Time', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(width: 32),
              Expanded(
                child: Text(
                  '$expression (${visibleMatches.length})',
                  style: Theme.of(context).textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: visibleMatches.length,
            itemBuilder: (context, index) {
              final match = visibleMatches[visibleMatches.length - 1 - index];
              return _WatchValueRow(value: match);
            },
          ),
        ),
      ],
    );
  }
}

class _WatchedValue {
  const _WatchedValue({required this.timestamp, required this.displayValue});

  final DateTime? timestamp;
  final String displayValue;
}

class _WatchValueRow extends StatelessWidget {
  const _WatchValueRow({required this.value});

  final _WatchedValue value;

  @override
  Widget build(BuildContext context) {
    final timestamp = value.timestamp;
    final time = timestamp == null
        ? '--:--:--'
        : '${timestamp.hour.toString().padLeft(2, '0')}:'
              '${timestamp.minute.toString().padLeft(2, '0')}:'
              '${timestamp.second.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              time,
              style: kCodeStyle.copyWith(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: SelectableText(
              value.displayValue,
              key: ValueKey('watched-value-${value.displayValue}'),
              style: kCodeStyle.copyWith(fontSize: 12),
            ),
          ),
          CopyButton(toCopy: value.displayValue, showLabel: false),
        ],
      ),
    );
  }
}
