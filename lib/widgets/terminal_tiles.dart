import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_core/apidash_core.dart';
import '../consts.dart';
import '../models/terminal/models.dart';
import '../utils/ui_utils.dart';
import 'expandable_section.dart';

class SystemLogTile extends StatelessWidget {
  const SystemLogTile(
      {super.key, required this.entry, this.showTimestamp = false});
  final TerminalEntry entry;
  final bool showTimestamp;
  @override
  Widget build(BuildContext context) {
    assert(entry.system != null, 'System tile requires SystemLogData');
    final s = entry.system!;
    final cs = Theme.of(context).colorScheme;
    IconData icon;
    Color? iconColor;
    switch (entry.level) {
      case TerminalLevel.error:
        icon = Icons.error_outline_rounded;
        iconColor = cs.error;
        break;
      case TerminalLevel.warn:
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.amber[800];
        break;
      case TerminalLevel.info:
      case TerminalLevel.debug:
        icon = Icons.info_outline;
        iconColor = cs.primary;
        break;
    }
    final titleStyle = Theme.of(context).textTheme.bodyMedium;
    final subStyle = Theme.of(context).textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTimestamp) ...[
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 8),
              child: Text(_formatTs(entry.ts), style: subStyle),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 8),
              child: Icon(icon, size: 18, color: iconColor),
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('[${s.category}] ${s.message}', style: titleStyle),
                if (s.stack != null && s.stack!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  SelectableText(s.stack!, style: subStyle),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JsLogTile extends StatelessWidget {
  const JsLogTile(
      {super.key,
      required this.entry,
      this.showTimestamp = false,
      this.requestName});
  final TerminalEntry entry;
  final bool showTimestamp;
  final String? requestName;
  @override
  Widget build(BuildContext context) {
    assert(entry.js != null, 'JS tile requires JsLogData');
    final cs = Theme.of(context).colorScheme;
    final j = entry.js!;
    IconData? icon;
    Color? iconColor;
    Color? bg;
    switch (entry.level) {
      case TerminalLevel.error:
        icon = Icons.error_outline_rounded;
        iconColor = cs.error;
        bg = Colors.redAccent.shade200.withValues(alpha: 0.2);
        break;
      case TerminalLevel.warn:
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.amber[800];
        bg = Colors.amberAccent.shade200.withValues(alpha: 0.25);
        break;
      case TerminalLevel.info:
      case TerminalLevel.debug:
        break;
    }
    final bodyParts = <String>[];
    if (requestName != null && requestName!.isNotEmpty) {
      bodyParts.add('[$requestName]');
    }
    // Add JS level/context prefix to disambiguate
    if (j.context != null && j.context!.isNotEmpty) {
      bodyParts.add('(${j.context})');
    }
    bodyParts.addAll(j.args);
    final bodyText = bodyParts.join(' ');
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTimestamp) ...[
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 8),
              child: Text(_formatTs(entry.ts),
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ] else if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 8),
              child: Icon(icon, size: 18, color: iconColor),
            ),
          ],
          Expanded(
            child: SelectableText(
              bodyText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkLogTile extends StatefulWidget {
  const NetworkLogTile(
      {super.key,
      required this.entry,
      this.showTimestamp = false,
      this.requestName});
  final TerminalEntry entry;
  final bool showTimestamp;
  final String? requestName;
  @override
  State<NetworkLogTile> createState() => _NetworkLogTileState();
}

class _NetworkLogTileState extends State<NetworkLogTile> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final n = widget.entry.network!;
    final status = n.responseStatus != null ? '${n.responseStatus}' : null;
    final duration =
        n.duration != null ? '${n.duration!.inMilliseconds} ms' : null;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    final methodStyle = kCodeStyle.copyWith(
      fontWeight: FontWeight.bold,
      color: getAPIColor(
        APIType.rest,
        method: n.method,
        brightness: Theme.of(context).brightness,
      ),
    );
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                if (widget.showTimestamp) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      _formatTs(widget.entry.ts),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: bodyStyle,
                      children: [
                        if (widget.requestName != null &&
                            widget.requestName!.isNotEmpty) ...[
                          TextSpan(text: '[${widget.requestName}] '),
                        ],
                        TextSpan(
                            text: n.method.name.toUpperCase(),
                            style: methodStyle),
                        TextSpan(text: ' ${n.url}'),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                if (status != null) Text(status),
                if (status != null && duration != null) const Text('  |  '),
                if (duration != null) Text(duration),
                const SizedBox(width: 6),
                Icon(_expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        if (_expanded) NetworkDetails(n: n),
      ],
    );
  }
}

class NetworkDetails extends StatelessWidget {
  const NetworkDetails({super.key, required this.n});
  final NetworkLogData n;
  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      ExpandableSection(
        title: 'Network',
        child: _kvBody({
          'API Type': n.apiType.name,
          'Phase': n.phase.name,
          if (n.isStreaming) 'Streaming': 'true',
          if (n.sentAt != null) 'Sent': n.sentAt!.toIso8601String(),
          if (n.completedAt != null)
            'Completed': n.completedAt!.toIso8601String(),
          if (n.duration != null)
            'Duration': '${n.duration!.inMilliseconds} ms',
          'URL': n.url,
          'Method': n.method.name.toUpperCase(),
          if (n.responseStatus != null) 'Status': '${n.responseStatus}',
          if (n.errorMessage != null) 'Error': n.errorMessage!,
        }),
      ),
      ExpandableSection(
          title: 'Request Headers', child: _mapBody(n.requestHeaders)),
      ExpandableSection(
          title: 'Request Body', child: _textBody(n.requestBodyPreview)),
      ExpandableSection(
          title: 'Response Headers', child: _mapBody(n.responseHeaders)),
      ExpandableSection(
          title: 'Response Body', child: _textBody(n.responseBodyPreview)),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: [
          for (int i = 0; i < tiles.length; i++) ...[
            tiles[i],
            if (i != tiles.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _textBody(String? text) {
    return SelectableText(text == null || text.isEmpty ? '(empty)' : text);
  }

  Widget _mapBody(Map<String, String>? map) {
    if (map == null || map.isEmpty) {
      return const SelectableText('(none)');
    }
    final lines = map.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    return SelectableText(lines);
  }

  Widget _kvBody(Map<String, String> map) {
    final lines = map.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    return SelectableText(lines);
  }
}

String _formatTs(DateTime ts) {
  // Show only time (HH:mm:ss) for compactness
  final h = ts.hour.toString().padLeft(2, '0');
  final m = ts.minute.toString().padLeft(2, '0');
  final s = ts.second.toString().padLeft(2, '0');
  return '$h:$m:$s';
}
