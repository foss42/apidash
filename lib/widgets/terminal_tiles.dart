import 'package:flutter/material.dart';
import '../consts.dart';
import '../models/terminal/models.dart';
import 'expandable_section.dart';

class SystemLogTile extends StatelessWidget {
  const SystemLogTile({super.key, required this.entry});
  final TerminalEntry entry;
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
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 8),
            child: Icon(icon, size: 18, color: iconColor),
          ),
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
  const JsLogTile({super.key, required this.entry});
  final TerminalEntry entry;
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
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 8),
              child: Icon(icon, size: 18, color: iconColor),
            ),
          ],
          Expanded(
            child: SelectableText(
              j.args.join(' '),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkLogTile extends StatefulWidget {
  const NetworkLogTile({super.key, required this.entry});
  final TerminalEntry entry;
  @override
  State<NetworkLogTile> createState() => _NetworkLogTileState();
}

class _NetworkLogTileState extends State<NetworkLogTile> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final n = widget.entry.network!;
    final methodUrl = '${n.method.name.toUpperCase()} ${n.url}';
    final status = n.responseStatus != null ? '${n.responseStatus}' : null;
    final duration =
        n.duration != null ? '${n.duration!.inMilliseconds} ms' : null;
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    methodUrl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
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
