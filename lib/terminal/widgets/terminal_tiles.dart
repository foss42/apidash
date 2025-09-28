import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';
import '../enums.dart';
import '../models/models.dart';

class SystemLogTile extends StatelessWidget {
  const SystemLogTile({
    super.key,
    required this.entry,
    this.showTimestamp = false,
    this.searchQuery,
  });
  final TerminalEntry entry;
  final bool showTimestamp;
  final String? searchQuery;
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
                HighlightedSelectableText(
                  text: '[${s.category}] ${s.message}',
                  style: titleStyle,
                  query: searchQuery,
                ),
                if (s.stack != null && s.stack!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  HighlightedSelectableText(
                    text: s.stack!,
                    style: subStyle,
                    query: searchQuery,
                  ),
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
  const JsLogTile({
    super.key,
    required this.entry,
    this.showTimestamp = false,
    this.requestName,
    this.searchQuery,
  });
  final TerminalEntry entry;
  final bool showTimestamp;
  final String? requestName;
  final String? searchQuery;
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
            child: HighlightedSelectableText(
              text: bodyText,
              style: Theme.of(context).textTheme.bodyMedium,
              query: searchQuery,
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkLogTile extends StatefulWidget {
  const NetworkLogTile({
    super.key,
    required this.entry,
    this.showTimestamp = false,
    this.requestName,
    this.searchQuery,
  });
  final TerminalEntry entry;
  final bool showTimestamp;
  final String? requestName;
  final String? searchQuery;
  @override
  State<NetworkLogTile> createState() => _NetworkLogTileState();
}

class _NetworkLogTileState extends State<NetworkLogTile> {
  bool _expanded = false;
  String? _lastQuery;

  @override
  void didUpdateWidget(covariant NetworkLogTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-expand if a new non-empty search query matches hidden detail content
    final q = widget.searchQuery?.trim();
    if (q != null && q.isNotEmpty && q != _lastQuery) {
      if (!_expanded && _networkDetailsContainQuery(q)) {
        setState(() => _expanded = true);
      }
    }
    _lastQuery = q;
  }

  bool _networkDetailsContainQuery(String q) {
    final n = widget.entry.network!;
    final lowerQ = q.toLowerCase();
    bool inMap(Map<String, String>? m) =>
        m != null &&
        m.entries.any((e) =>
            e.key.toLowerCase().contains(lowerQ) ||
            e.value.toLowerCase().contains(lowerQ));
    bool inText(String? t) =>
        t != null && t.toLowerCase().contains(lowerQ) && t.isNotEmpty;
    return inMap(n.requestHeaders) ||
        inMap(n.responseHeaders) ||
        inText(n.requestBodyPreview) ||
        inText(n.responseBodyPreview) ||
        inText(n.errorMessage);
  }

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
                          ...buildHighlightedSpans(
                            '[${widget.requestName}]',
                            context,
                            widget.searchQuery,
                            baseStyle: bodyStyle,
                          ),
                          const TextSpan(text: ' '),
                        ],
                        ...buildHighlightedSpans(
                          n.method.name.toUpperCase(),
                          context,
                          widget.searchQuery,
                          baseStyle: methodStyle,
                        ),
                        const TextSpan(text: ' '),
                        ...buildHighlightedSpans(
                          n.url,
                          context,
                          widget.searchQuery,
                          baseStyle: bodyStyle,
                        ),
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
        if (_expanded) NetworkDetails(n: n, searchQuery: widget.searchQuery),
      ],
    );
  }
}

class NetworkDetails extends StatelessWidget {
  const NetworkDetails({super.key, required this.n, this.searchQuery});
  final NetworkLogData n;
  final String? searchQuery;
  @override
  Widget build(BuildContext context) {
    final q = searchQuery?.trim();
    bool contains(String? text) =>
        q != null &&
        q.isNotEmpty &&
        text != null &&
        text.toLowerCase().contains(q.toLowerCase());
    bool mapContains(Map<String, String>? m) =>
        q != null &&
        q.isNotEmpty &&
        m != null &&
        m.entries.any((e) =>
            e.key.toLowerCase().contains(q.toLowerCase()) ||
            e.value.toLowerCase().contains(q.toLowerCase()));

    final networkBodyMap = {
      'API Type': n.apiType.name,
      'Phase': n.phase.name,
      if (n.isStreaming) 'Streaming': 'true',
      if (n.sentAt != null) 'Sent': n.sentAt!.toIso8601String(),
      if (n.completedAt != null) 'Completed': n.completedAt!.toIso8601String(),
      if (n.duration != null) 'Duration': '${n.duration!.inMilliseconds} ms',
      'URL': n.url,
      'Method': n.method.name.toUpperCase(),
      if (n.responseStatus != null) 'Status': '${n.responseStatus}',
      if (n.errorMessage != null) 'Error': n.errorMessage!,
    };
    final networkSectionHasMatch = q != null &&
        q.isNotEmpty &&
        networkBodyMap.entries.any((e) =>
            e.key.toLowerCase().contains(q.toLowerCase()) ||
            e.value.toLowerCase().contains(q.toLowerCase()));

    final tiles = <Widget>[
      ExpandableSection(
        title: 'Network',
        forceOpen: networkSectionHasMatch ? true : null,
        highlightQuery: searchQuery,
        child: _kvBody(networkBodyMap, query: searchQuery),
      ),
      ExpandableSection(
        title: 'Request Headers',
        forceOpen: mapContains(n.requestHeaders) ? true : null,
        highlightQuery: searchQuery,
        child: _mapBody(n.requestHeaders, query: searchQuery),
      ),
      ExpandableSection(
        title: 'Request Body',
        forceOpen: contains(n.requestBodyPreview) ? true : null,
        highlightQuery: searchQuery,
        child: _textBody(n.requestBodyPreview, query: searchQuery),
      ),
      ExpandableSection(
        title: 'Response Headers',
        forceOpen: mapContains(n.responseHeaders) ? true : null,
        highlightQuery: searchQuery,
        child: _mapBody(n.responseHeaders, query: searchQuery),
      ),
      ExpandableSection(
        title: 'Response Body',
        forceOpen: contains(n.responseBodyPreview) ? true : null,
        highlightQuery: searchQuery,
        child: _textBody(n.responseBodyPreview, query: searchQuery),
      ),
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

  Widget _textBody(String? text, {String? query}) {
    final value = text == null || text.isEmpty ? '(empty)' : text;
    return HighlightedSelectableText(text: value, query: query);
  }

  Widget _mapBody(Map<String, String>? map, {String? query}) {
    if (map == null || map.isEmpty) {
      return const HighlightedSelectableText(text: '(none)');
    }
    final lines = map.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    return HighlightedSelectableText(text: lines, query: query);
  }

  Widget _kvBody(Map<String, String> map, {String? query}) {
    final lines = map.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    return HighlightedSelectableText(text: lines, query: query);
  }
}

String _formatTs(DateTime ts) {
  // Show only time (HH:mm:ss) for compactness
  final h = ts.hour.toString().padLeft(2, '0');
  final m = ts.minute.toString().padLeft(2, '0');
  final s = ts.second.toString().padLeft(2, '0');
  final ms = ts.millisecond.toString().padLeft(2, '0');
  return '$h:$m:$s.$ms';
}
