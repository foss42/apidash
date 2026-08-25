import 'dart:convert';

import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';

Future<void> showWebhookReportsDialog(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _WebhookReportsDialog(),
  );
}

class _WebhookReportsDialog extends ConsumerStatefulWidget {
  const _WebhookReportsDialog();

  @override
  ConsumerState<_WebhookReportsDialog> createState() =>
      _WebhookReportsDialogState();
}

class _WebhookReportsDialogState extends ConsumerState<_WebhookReportsDialog> {
  late final TextEditingController _urlController;
  late final TextEditingController _nameController;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    final s = ref.read(webhookAutoSendProvider);
    _urlController = TextEditingController(text: s.url);
    _nameController = TextEditingController(text: s.reportName);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _syncFields() {
    ref.read(webhookAutoSendProvider.notifier).updateUrl(_urlController.text);
    ref
        .read(webhookAutoSendProvider.notifier)
        .updateReportName(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final auto = ref.watch(webhookAutoSendProvider);
    final scheme = Theme.of(context).colorScheme;
    final timeFmt = DateFormat.Hm();

    return AlertDialog(
      title: Row(
        children: [
          const Expanded(child: Text('Webhook reports')),
          if (auto.active)
            Chip(
              avatar: Icon(Icons.schedule, size: 16, color: scheme.primary),
              label: Text('Auto · ${auto.interval.label}'),
              visualDensity: VisualDensity.compact,
              backgroundColor: scheme.primaryContainer,
            ),
        ],
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sends the current Dashboard tab metrics as JSON to any HTTP endpoint (Slack, Discord, CI).',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              kVSpacer10,
              TextField(
                controller: _nameController,
                onChanged: (v) =>
                    ref.read(webhookAutoSendProvider.notifier).updateReportName(v),
                decoration: const InputDecoration(
                  labelText: 'Report name',
                  border: OutlineInputBorder(),
                ),
              ),
              kVSpacer10,
              TextField(
                controller: _urlController,
                onChanged: (v) =>
                    ref.read(webhookAutoSendProvider.notifier).updateUrl(v),
                decoration: const InputDecoration(
                  labelText: 'Webhook URL',
                  hintText: 'https://hooks.slack.com/...',
                  border: OutlineInputBorder(),
                ),
              ),
              kVSpacer10,
              Text(
                'Auto-send interval',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              kVSpacer8,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final interval in WebhookInterval.values)
                    ChoiceChip(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(interval.label),
                      ),
                      selected: auto.interval == interval,
                      onSelected: (_) {
                        ref
                            .read(webhookAutoSendProvider.notifier)
                            .updateInterval(interval);
                      },
                    ),
                ],
              ),
              if (auto.lastSentAt != null ||
                  (auto.active && auto.nextSendAt != null)) ...[
                kVSpacer10,
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHigh.withValues(alpha: 0.55),
                    borderRadius: kBorderRadius8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (auto.lastSentAt != null)
                        Text(
                          'Last sent · ${timeFmt.format(auto.lastSentAt!.toLocal())}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (auto.active && auto.nextSendAt != null)
                        Text(
                          'Next send · ${timeFmt.format(auto.nextSendAt!.toLocal())}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
              if (auto.lastStatus != null) ...[
                kVSpacer10,
                Text(
                  auto.lastStatus!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: auto.lastStatus!.startsWith('Failed') ||
                                auto.lastStatus!.startsWith('Enter')
                            ? scheme.error
                            : scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _syncFields();
            final payload =
                ref.read(webhookAutoSendProvider.notifier).previewPayload();
            Clipboard.setData(
              ClipboardData(
                text: const JsonEncoder.withIndent('  ').convert(payload),
              ),
            );
            ref.read(webhookAutoSendProvider.notifier).markCopied();
          },
          child: const Text('Copy JSON'),
        ),
        if (auto.active)
          TextButton(
            onPressed: () =>
                ref.read(webhookAutoSendProvider.notifier).stopAutoSend(),
            child: const Text('Stop auto-send'),
          )
        else
          TextButton(
            onPressed: () {
              _syncFields();
              ref.read(webhookAutoSendProvider.notifier).startAutoSend();
            },
            child: const Text('Start auto-send'),
          ),
        TextButton(
          onPressed: _sending ? null : () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: _sending
              ? null
              : () async {
                  setState(() => _sending = true);
                  _syncFields();
                  await ref.read(webhookAutoSendProvider.notifier).sendNow();
                  if (mounted) setState(() => _sending = false);
                },
          child: _sending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send now'),
        ),
      ],
    );
  }
}
