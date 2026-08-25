import 'dart:convert';

import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import 'dashboard_common.dart';

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
  late final ScrollController _previewScrollController;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    final s = ref.read(webhookAutoSendProvider);
    _urlController = TextEditingController(text: s.url);
    _nameController = TextEditingController(text: s.reportName);
    _previewScrollController = ScrollController();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    _previewScrollController.dispose();
    super.dispose();
  }

  void _syncFields() {
    ref.read(webhookAutoSendProvider.notifier).updateUrl(_urlController.text);
    ref
        .read(webhookAutoSendProvider.notifier)
        .updateReportName(_nameController.text);
  }

  String _prettyJson() {
    final payload =
        ref.read(webhookAutoSendProvider.notifier).previewPayload();
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<void> _copyJson() async {
    _syncFields();
    final text = _prettyJson();
    await Clipboard.setData(ClipboardData(text: text));
    ref.read(webhookAutoSendProvider.notifier).markCopied();
  }

  @override
  Widget build(BuildContext context) {
    final auto = ref.watch(webhookAutoSendProvider);
    // Rebuild preview when dashboard filters / metrics change.
    ref.watch(dashboardTimeRangeProvider);
    ref.watch(dashboardCollectionFilterProvider);
    ref.watch(dashboardWorkflowFilterProvider);
    ref.watch(collectionDashboardProvider);
    ref.watch(workflowDashboardProvider);
    ref.watch(scriptCoverageProvider);

    final scheme = Theme.of(context).colorScheme;
    final timeFmt = DateFormat.Hm();
    final preview = _prettyJson();

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
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sends one combined report with both Collections and Workflows '
                'metrics (current time range and filters). Pick a format for '
                'the destination.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              kVSpacer10,
              Text(
                'Format',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              kVSpacer8,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final format in WebhookPayloadFormat.values)
                    ChoiceChip(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(format.label),
                      ),
                      selected: auto.format == format,
                      onSelected: (_) {
                        ref
                            .read(webhookAutoSendProvider.notifier)
                            .updateFormat(format);
                      },
                    ),
                ],
              ),
              kVSpacer10,
              TextField(
                controller: _nameController,
                onChanged: (v) {
                  ref
                      .read(webhookAutoSendProvider.notifier)
                      .updateReportName(v);
                  setState(() {});
                },
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
                decoration: InputDecoration(
                  labelText: 'Webhook URL',
                  hintText: switch (auto.format) {
                    WebhookPayloadFormat.slack =>
                      'https://hooks.slack.com/services/...',
                    WebhookPayloadFormat.discord =>
                      'https://discord.com/api/webhooks/...',
                    WebhookPayloadFormat.raw => 'https://example.com/hook',
                  },
                  border: const OutlineInputBorder(),
                ),
              ),
              kVSpacer12,
              Row(
                children: [
                  Text(
                    'Payload preview · ${auto.format.label}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _copyJson,
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('Copy'),
                  ),
                ],
              ),
              kVSpacer6,
              Container(
                constraints: const BoxConstraints(maxHeight: 240),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh.withValues(alpha: 0.55),
                  borderRadius: kBorderRadius8,
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Scrollbar(
                  controller: _previewScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _previewScrollController,
                    primary: false,
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(
                      preview,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            height: 1.35,
                          ),
                    ),
                  ),
                ),
              ),
              kVSpacer12,
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
                        Text.rich(
                          TextSpan(
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              TextSpan(
                                text:
                                    'Last sent · ${timeFmt.format(auto.lastSentAt!.toLocal())}',
                              ),
                              if (auto.lastSendOk != null) ...[
                                const TextSpan(text: '  ·  '),
                                TextSpan(
                                  text: auto.lastSendOk! ? 'Success' : 'Failed',
                                  style: TextStyle(
                                    color: auto.lastSendOk!
                                        ? dashboardSuccessColor(context)
                                        : scheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (auto.lastSendOk == false &&
                                    auto.lastStatus != null &&
                                    auto.lastStatus!.startsWith('HTTP ')) ...[
                                  TextSpan(
                                    text: ' · ${auto.lastStatus}',
                                    style: TextStyle(color: scheme.error),
                                  ),
                                ],
                              ],
                            ],
                          ),
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
              if (auto.lastStatus != null &&
                  !(auto.lastSendOk == false &&
                      auto.lastStatus!.startsWith('HTTP '))) ...[
                kVSpacer10,
                Text(
                  auto.lastStatus!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: auto.lastStatus!.startsWith('Enter') ||
                                auto.lastSendOk == false
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
