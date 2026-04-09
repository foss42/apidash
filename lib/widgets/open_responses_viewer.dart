import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class OpenResponsesViewer extends StatelessWidget {
  const OpenResponsesViewer({super.key, required this.result});

  final OpenResponsesResult result;

  List<Widget> _buildGroupedItems(BuildContext context) {
    final resultMap = <String, FunctionCallResultItem>{};
    for (final item in result.output) {
      if (item is FunctionCallResultItem) {
        resultMap[item.callId] = item;
      }
    }

    final widgets = <Widget>[];
    for (final item in result.output) {
      if (item is FunctionCallResultItem) continue;

      if (item is FunctionCallOutputItem) {
        final matchedResult = resultMap[item.callId];
        widgets.add(
          _ToolCallGroup(call: item, result: matchedResult),
        );
      } else {
        widgets.add(switch (item) {
          MessageOutputItem() => _MessageCard(item: item),
          ReasoningOutputItem() => _ReasoningCard(item: item),
          WebSearchCallOutputItem() => _WebSearchCard(item: item),
          FileSearchCallOutputItem() => _FileSearchCard(item: item),
          UnknownOutputItem() => _UnknownCard(item: item),
          _ => const SizedBox.shrink(),
        });
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildGroupedItems(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.separated(
            padding: kP8,
            itemCount: items.length,
            separatorBuilder: (_, __) => kVSpacer8,
            itemBuilder: (context, i) => items[i],
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

    final hasRefusal = item.content.whereType<RefusalPart>().isNotEmpty;

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
              color: hasRefusal
                  ? theme.colorScheme.errorContainer.withOpacity(0.3)
                  : roleColor,
              borderRadius: kBorderRadius8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.role.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: textColor.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const Spacer(),
                    if (item.text.isNotEmpty)
                      _CopyIconButton(text: item.text),
                  ],
                ),
                kVSpacer5,
                if (hasRefusal)
                  ...item.content.whereType<RefusalPart>().map(
                        (r) => Text(
                          r.refusal,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      )
                else
                  MarkdownBody(
                    data: item.text,
                    selectable: true,
                    extensionSet: md.ExtensionSet.gitHubFlavored,
                    styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                      code: kCodeStyle.copyWith(
                        fontSize: 12,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: kBorderRadius8,
                      ),
                    ),
                    onTapLink: (_, href, __) {
                      if (href != null) launchUrl(Uri.parse(href));
                    },
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

class _ToolCallGroup extends StatefulWidget {
  const _ToolCallGroup({required this.call, this.result});
  final FunctionCallOutputItem call;
  final FunctionCallResultItem? result;

  @override
  State<_ToolCallGroup> createState() => _ToolCallGroupState();
}

class _ToolCallGroupState extends State<_ToolCallGroup> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFailed = widget.call.status == 'failed';
    final borderColor = isFailed
        ? theme.colorScheme.error.withOpacity(0.5)
        : theme.colorScheme.outlineVariant;

    String prettyArgs = widget.call.arguments;
    try {
      prettyArgs = const JsonEncoder.withIndent('  ')
          .convert(jsonDecode(widget.call.arguments));
    } catch (_) {}

    return Container(
      decoration: BoxDecoration(
        color: isFailed
            ? theme.colorScheme.errorContainer.withOpacity(0.15)
            : theme.colorScheme.surfaceContainerLowest,
        border: Border.all(color: borderColor),
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
                      widget.call.name,
                      style: kCodeStyle.copyWith(
                        fontSize: 13,
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _StatusChip(status: widget.call.status),
                  kHSpacer8,
                  _CopyIconButton(text: prettyArgs),
                  kHSpacer4,
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
          if (_expanded) ...[
            Container(
              width: double.maxFinite,
              padding: kP8,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arguments',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  kVSpacer5,
                  SelectableText(
                    prettyArgs,
                    style: kCodeStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            if (widget.result != null)
              Container(
                width: double.maxFinite,
                padding: kP8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.output_rounded,
                            size: 14, color: theme.colorScheme.outline),
                        kHSpacer4,
                        Text(
                          'Result',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    kVSpacer5,
                    _StructuredOutput(raw: widget.result!.output),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// Renders tool output as a key-value table when it's a JSON object,
// otherwise falls back to a plain code block.
class _StructuredOutput extends StatelessWidget {
  const _StructuredOutput({required this.raw});
  final String raw;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    try {
      final parsed = jsonDecode(raw);
      if (parsed is Map<String, dynamic> && parsed.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: parsed.entries.map((e) {
            final value = e.value is String
                ? e.value as String
                : const JsonEncoder.withIndent('  ').convert(e.value);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      e.key,
                      style: kCodeStyle.copyWith(
                        fontSize: 11,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                  kHSpacer8,
                  Expanded(
                    child: SelectableText(
                      value,
                      style: kCodeStyle.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      }
    } catch (_) {}
    return SelectableText(raw, style: kCodeStyle.copyWith(fontSize: 12));
  }
}

class _WebSearchCard extends StatelessWidget {
  const _WebSearchCard({required this.item});
  final WebSearchCallOutputItem item;

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
      child: Row(
        children: [
          Icon(Icons.search_rounded,
              size: 16, color: theme.colorScheme.secondary),
          kHSpacer8,
          Text(
            'Web Search',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          _StatusChip(status: item.status),
        ],
      ),
    );
  }
}

class _FileSearchCard extends StatelessWidget {
  const _FileSearchCard({required this.item});
  final FileSearchCallOutputItem item;

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
              Icon(Icons.folder_open_rounded,
                  size: 16, color: theme.colorScheme.secondary),
              kHSpacer8,
              Text(
                'File Search',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _StatusChip(status: item.status),
            ],
          ),
          if (item.queries.isNotEmpty) ...[
            kVSpacer5,
            ...item.queries.map(
              (q) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    Icon(Icons.subdirectory_arrow_right_rounded,
                        size: 12, color: theme.colorScheme.outline),
                    kHSpacer4,
                    Expanded(
                      child: Text(
                        q,
                        style: kCodeStyle.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
    String prettyRaw;
    try {
      prettyRaw = const JsonEncoder.withIndent('  ').convert(item.raw);
    } catch (_) {
      prettyRaw = item.raw.toString();
    }
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
              Icon(Icons.help_outline_rounded,
                  size: 14, color: theme.colorScheme.outline),
              kHSpacer4,
              Text(
                item.type,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _CopyIconButton(text: prettyRaw),
            ],
          ),
          kVSpacer5,
          SelectableText(
            prettyRaw,
            style: kCodeStyle.copyWith(
                fontSize: 11, color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

class _CopyIconButton extends StatelessWidget {
  const _CopyIconButton({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 15,
        icon: Icon(Icons.copy_rounded,
            color: Theme.of(context).colorScheme.outline),
        tooltip: 'Copy',
        onPressed: () {
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Copied'),
                duration: Duration(seconds: 1),
              ),
            );
        },
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
