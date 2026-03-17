import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class OpenResponsesViewer extends StatelessWidget {
  const OpenResponsesViewer({super.key, required this.result});

  final OpenResponsesResult result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.separated(
            padding: kP8,
            itemCount: result.output.length,
            separatorBuilder: (_, __) => kVSpacer8,
            itemBuilder: (context, i) {
              return switch (result.output[i]) {
                MessageOutputItem() =>
                  _MessageCard(item: result.output[i] as MessageOutputItem),
                ReasoningOutputItem() =>
                  _ReasoningCard(item: result.output[i] as ReasoningOutputItem),
                FunctionCallOutputItem() => _FunctionCallCard(
                    item: result.output[i] as FunctionCallOutputItem),
                FunctionCallResultItem() => _FunctionResultCard(
                    item: result.output[i] as FunctionCallResultItem),
                UnknownOutputItem() =>
                  _UnknownCard(item: result.output[i] as UnknownOutputItem),
              };
            },
          ),
        ),
        if (result.usage != null) _UsageBar(usage: result.usage!),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.item});
  final MessageOutputItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = item.role == 'user';
    final roleColor = isUser
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerLow;
    final textColor = isUser
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser) ...[
          CircleAvatar(
            radius: 14,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
            child: Icon(Icons.auto_awesome_rounded,
                size: 16, color: theme.colorScheme.primary),
          ),
          kHSpacer8,
        ],
        Expanded(
          child: Container(
            padding: kP8,
            decoration: BoxDecoration(
              color: roleColor,
              borderRadius: kBorderRadius8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.role.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textColor.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                kVSpacer5,
                SelectableText(
                  item.text,
                  style: kCodeStyle.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
        if (isUser) ...[
          kHSpacer8,
          CircleAvatar(
            radius: 14,
            backgroundColor: theme.colorScheme.primary,
            child: Icon(Icons.person_rounded, size: 16,
                color: theme.colorScheme.onPrimary),
          ),
        ],
      ],
    );
  }
}

class _ReasoningCard extends StatefulWidget {
  const _ReasoningCard({required this.item});
  final ReasoningOutputItem item;

  @override
  State<_ReasoningCard> createState() => _ReasoningCardState();
}

class _ReasoningCardState extends State<_ReasoningCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFull = widget.item.content != null &&
        widget.item.content!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        borderRadius: kBorderRadius8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: kBorderRadius8,
            onTap: hasFull ? () => setState(() => _expanded = !_expanded) : null,
            child: Padding(
              padding: kP8,
              child: Row(
                children: [
                  Icon(Icons.psychology_rounded,
                      size: 16, color: theme.colorScheme.tertiary),
                  kHSpacer8,
                  Text(
                    'Reasoning',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (hasFull)
                    Icon(
                      _expanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      size: 18,
                      color: theme.colorScheme.outline,
                    ),
                ],
              ),
            ),
          ),
          if (widget.item.summary != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: SelectableText(
                widget.item.summary!,
                style: theme.textTheme.bodySmall,
              ),
            ),
          if (_expanded && hasFull)
            Container(
              width: double.maxFinite,
              padding: kP8,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: SelectableText(
                widget.item.content!,
                style: kCodeStyle.copyWith(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.75)),
              ),
            ),
        ],
      ),
    );
  }
}

class _FunctionCallCard extends StatefulWidget {
  const _FunctionCallCard({required this.item});
  final FunctionCallOutputItem item;

  @override
  State<_FunctionCallCard> createState() => _FunctionCallCardState();
}

class _FunctionCallCardState extends State<_FunctionCallCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String prettyArgs = widget.item.arguments;
    try {
      prettyArgs = const JsonEncoder.withIndent('  ')
          .convert(jsonDecode(widget.item.arguments));
    } catch (_) {}

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: kBorderRadius8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: kBorderRadius8,
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: kP8,
              child: Row(
                children: [
                  Icon(Icons.code_rounded,
                      size: 16, color: theme.colorScheme.secondary),
                  kHSpacer8,
                  Expanded(
                    child: Text(
                      widget.item.name,
                      style: kCodeStyle.copyWith(
                        fontSize: 13,
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _StatusChip(status: widget.item.status),
                  kHSpacer8,
                  Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 18,
                    color: theme.colorScheme.outline,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Container(
              width: double.maxFinite,
              padding: kP8,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: SelectableText(
                prettyArgs,
                style: kCodeStyle.copyWith(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class _FunctionResultCard extends StatelessWidget {
  const _FunctionResultCard({required this.item});
  final FunctionCallResultItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: kP8,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: kBorderRadius8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.output_rounded,
                  size: 16, color: theme.colorScheme.outline),
              kHSpacer8,
              Text(
                'Tool result',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              kHSpacer4,
              Text(
                '· ${item.callId}',
                style: kCodeStyle.copyWith(
                    fontSize: 11, color: theme.colorScheme.outlineVariant),
              ),
            ],
          ),
          kVSpacer5,
          SelectableText(
            item.output,
            style: kCodeStyle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _UnknownCard extends StatelessWidget {
  const _UnknownCard({required this.item});
  final UnknownOutputItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: kP8,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: kBorderRadius8,
      ),
      child: Text(
        item.type,
        style: kCodeStyle.copyWith(
            fontSize: 12, color: theme.colorScheme.outline),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (status) {
      'completed' => Colors.green,
      'in_progress' => theme.colorScheme.primary,
      'failed' => theme.colorScheme.error,
      _ => theme.colorScheme.outline,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class _UsageBar extends StatelessWidget {
  const _UsageBar({required this.usage});
  final OpenResponsesUsage usage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.token_rounded, size: 14, color: theme.colorScheme.outline),
          kHSpacer4,
          Text(
            '${usage.inputTokens} in · ${usage.outputTokens} out · ${usage.totalTokens} total',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
