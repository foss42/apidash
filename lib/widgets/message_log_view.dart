import 'dart:convert';

import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// Unified data model for one log entry (protocol-agnostic)
// ---------------------------------------------------------------------------

enum MessageDirection { sent, received, status, error }

/// Payload display format in the detail view.
enum PayloadFormat { text, prettyJson, hex, base64 }

class LogMessage {
  final String content;
  final MessageDirection direction;
  final DateTime timestamp;

  /// Optional (MQTT topic, gRPC method, etc.)
  final String? label;

  /// Optional QoS / metadata string shown as badge
  final String? badge;

  /// If true, show a "Retained" tag (MQTT)
  final bool retained;

  /// Optional colour hint for topic-based colouring
  final Color? topicColor;

  const LogMessage({
    required this.content,
    required this.direction,
    required this.timestamp,
    this.label,
    this.badge,
    this.retained = false,
    this.topicColor,
  });

  bool get isSent => direction == MessageDirection.sent;
  bool get isReceived => direction == MessageDirection.received;
  bool get isStatus => direction == MessageDirection.status;
  bool get isError => direction == MessageDirection.error;

  int get sizeBytes => utf8.encode(content).length;
}

// ---------------------------------------------------------------------------
// Filter state
// ---------------------------------------------------------------------------

enum DirectionFilter { all, sent, received }

// ---------------------------------------------------------------------------
// MessageLogToolbar – search, filter, export, clear, count
// ---------------------------------------------------------------------------

class MessageLogToolbar extends StatelessWidget {
  const MessageLogToolbar({
    super.key,
    required this.messageCount,
    required this.searchController,
    required this.onSearchChanged,
    required this.directionFilter,
    required this.onDirectionFilterChanged,
    this.topicFilters,
    this.activeTopicFilter,
    this.onTopicFilterChanged,
    this.onExport,
    this.onClear,
    this.matchCount,
    this.searchFocusNode,
  });

  final int messageCount;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final DirectionFilter directionFilter;
  final ValueChanged<DirectionFilter> onDirectionFilterChanged;
  final List<String>? topicFilters;
  final String? activeTopicFilter;
  final ValueChanged<String?>? onTopicFilterChanged;
  final VoidCallback? onExport;
  final VoidCallback? onClear;
  final int? matchCount;
  final FocusNode? searchFocusNode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.surfaceContainerHighest)),
      ),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: SizedBox(
              height: 30,
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                onChanged: onSearchChanged,
                style: kCodeStyle.copyWith(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Search messages…',
                  hintStyle: kCodeStyle.copyWith(
                      fontSize: 12, color: cs.outlineVariant),
                  prefixIcon:
                      const Icon(Icons.search, size: 16),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 32, minHeight: 30),
                  suffixIcon: searchController.text.isNotEmpty
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (matchCount != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  '$matchCount found',
                                  style: TextStyle(
                                      fontSize: 11, color: cs.outline),
                                ),
                              ),
                            InkWell(
                              onTap: () {
                                searchController.clear();
                                onSearchChanged('');
                              },
                              child:
                                  const Icon(Icons.close, size: 14),
                            ),
                            const SizedBox(width: 4),
                          ],
                        )
                      : null,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  border: OutlineInputBorder(
                    borderRadius: kBorderRadius6,
                    borderSide: BorderSide(color: cs.surfaceContainerHighest),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: kBorderRadius6,
                    borderSide: BorderSide(color: cs.surfaceContainerHighest),
                  ),
                  isDense: true,
                ),
              ),
            ),
          ),
          kHSpacer8,
          // Direction filter
          _DirectionFilterChips(
            value: directionFilter,
            onChanged: onDirectionFilterChanged,
          ),
          // Topic filter (MQTT only)
          if (topicFilters != null && topicFilters!.isNotEmpty) ...[
            kHSpacer4,
            _TopicFilterDropdown(
              topics: topicFilters!,
              active: activeTopicFilter,
              onChanged: onTopicFilterChanged!,
            ),
          ],
          kHSpacer8,
          // Export
          if (onExport != null)
            IconButton(
              icon: const Icon(Icons.download_outlined, size: 16),
              tooltip: 'Export messages',
              onPressed: onExport,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          // Clear
          if (onClear != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 16),
              tooltip: 'Clear messages',
              onPressed: onClear,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          kHSpacer4,
          // Message count
          Text(
            '$messageCount msg${messageCount != 1 ? 's' : ''}',
            style: TextStyle(fontSize: 12, color: cs.outline),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Direction filter chips
// ---------------------------------------------------------------------------

class _DirectionFilterChips extends StatelessWidget {
  const _DirectionFilterChips({required this.value, required this.onChanged});
  final DirectionFilter value;
  final ValueChanged<DirectionFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<DirectionFilter>(
      segments: const [
        ButtonSegment(value: DirectionFilter.all, label: Text('All')),
        ButtonSegment(
            value: DirectionFilter.sent,
            icon: Icon(Icons.arrow_upward, size: 12),
            label: Text('Sent')),
        ButtonSegment(
            value: DirectionFilter.received,
            icon: Icon(Icons.arrow_downward, size: 12),
            label: Text('Recv')),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        padding: WidgetStatePropertyAll(
            const EdgeInsets.symmetric(horizontal: 8)),
        textStyle: WidgetStatePropertyAll(
            const TextStyle(fontSize: 12)),
      ),
      showSelectedIcon: false,
    );
  }
}

// ---------------------------------------------------------------------------
// Topic filter dropdown (MQTT)
// ---------------------------------------------------------------------------

// Sentinel used to represent "All topics" selection, because Flutter's
// PopupMenuButton.onSelected never fires for null values (null is treated
// as "menu dismissed without selection").
const _kAllTopics = '__all_topics__';

class _TopicFilterDropdown extends StatelessWidget {
  const _TopicFilterDropdown({
    required this.topics,
    required this.active,
    required this.onChanged,
  });
  final List<String> topics;
  final String? active;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Filter by topic',
      initialValue: active ?? _kAllTopics,
      onSelected: (v) => onChanged(v == _kAllTopics ? null : v),
      itemBuilder: (_) => [
        const PopupMenuItem(value: _kAllTopics, child: Text('All topics')),
        const PopupMenuDivider(),
        ...topics.map((t) => PopupMenuItem(value: t, child: Text(t))),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: kBorderRadius6,
          border: Border.all(
            color: active != null
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_list, size: 14),
            kHSpacer4,
            Text(
              active ?? 'Topic',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ConnectionStatsBar – duration, msg count, bytes
// ---------------------------------------------------------------------------

class ConnectionStatsBar extends StatelessWidget {
  const ConnectionStatsBar({
    super.key,
    required this.statusLabel,
    required this.statusColor,
    this.connectedSince,
    this.sentCount = 0,
    this.receivedCount = 0,
    this.totalBytes = 0,
    this.extraInfo,
    this.onDisconnect,
  });

  final String statusLabel;
  final Color statusColor;
  final DateTime? connectedSince;
  final int sentCount;
  final int receivedCount;
  final int totalBytes;
  final String? extraInfo;
  final VoidCallback? onDisconnect;

  String _formatDuration(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds.remainder(60)}s';
    return '${d.inSeconds}s';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final duration = connectedSince != null
        ? DateTime.now().difference(connectedSince!)
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: cs.surfaceContainerHighest)),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: statusColor),
          kHSpacer6,
          Text(statusLabel,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor)),
          if (duration != null) ...[
            kHSpacer10,
            Icon(Icons.timer_outlined, size: 12, color: cs.outline),
            kHSpacer4,
            Text(_formatDuration(duration),
                style: TextStyle(fontSize: 12, color: cs.outline)),
          ],
          kHSpacer10,
          Text(
            '${sentCount + receivedCount} msgs ($receivedCount ↓ / $sentCount ↑)',
            style: TextStyle(fontSize: 12, color: cs.outline),
          ),
          kHSpacer10,
          Text(_formatBytes(totalBytes),
              style: TextStyle(fontSize: 12, color: cs.outline)),
          if (extraInfo != null) ...[
            kHSpacer10,
            Text(extraInfo!,
                style: TextStyle(fontSize: 12, color: cs.outline)),
          ],
          const Spacer(),
          if (onDisconnect != null)
            TextButton(
              onPressed: onDisconnect,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 24),
                textStyle: const TextStyle(fontSize: 12),
              ),
              child: const Text('Disconnect',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MessageLogRow – a single compact row in the log
// ---------------------------------------------------------------------------

class MessageLogRow extends StatelessWidget {
  const MessageLogRow({
    super.key,
    required this.message,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.searchQuery,
    required this.payloadFormat,
    required this.onFormatChanged,
    this.isBookmarked = false,
    this.onBookmarkToggle,
    this.onResend,
  });

  final LogMessage message;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final String searchQuery;
  final PayloadFormat payloadFormat;
  final ValueChanged<PayloadFormat> onFormatChanged;
  final bool isBookmarked;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onResend;

  Color _directionColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return switch (message.direction) {
      MessageDirection.sent => cs.primary,
      MessageDirection.received => Colors.green,
      MessageDirection.status => cs.outline,
      MessageDirection.error => cs.error,
    };
  }

  IconData _directionIcon() {
    return switch (message.direction) {
      MessageDirection.sent => Icons.arrow_upward,
      MessageDirection.received => Icons.arrow_downward,
      MessageDirection.status => Icons.info_outline,
      MessageDirection.error => Icons.error_outline,
    };
  }

  String _formatTimestamp() {
    final t = message.timestamp.toLocal();
    return '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}:'
        '${t.second.toString().padLeft(2, '0')}.'
        '${t.millisecond.toString().padLeft(3, '0')}';
  }

  String _formatPayload(String raw) {
    switch (payloadFormat) {
      case PayloadFormat.prettyJson:
        try {
          final decoded = jsonDecode(raw);
          return const JsonEncoder.withIndent('  ').convert(decoded);
        } catch (_) {
          return raw;
        }
      case PayloadFormat.hex:
        return utf8
            .encode(raw)
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(' ');
      case PayloadFormat.base64:
        return base64Encode(utf8.encode(raw));
      case PayloadFormat.text:
        return raw;
    }
  }

  String _compactPreview(String raw) {
    // Try to minify as JSON first (removes all whitespace between tokens)
    try {
      return jsonEncode(jsonDecode(raw));
    } catch (_) {
      // Not JSON — collapse all whitespace sequences to a single space
      return raw.replaceAll(RegExp(r'\s+'), ' ').trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dirColor = message.topicColor ?? _directionColor(context);
    final payloadPreview = _compactPreview(message.content);
    final truncated = payloadPreview.length > 120
        ? '${payloadPreview.substring(0, 120)}…'
        : payloadPreview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Compact row ──
        InkWell(
          onTap: message.isStatus ? null : onToggleExpand,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                // Direction icon
                Icon(_directionIcon(), size: 20, color: dirColor),
                kHSpacer6,
                // Timestamp
                Text(
                  _formatTimestamp(),
                  style: kCodeStyle.copyWith(fontSize: 16, color: cs.outline),
                ),
                kHSpacer8,
                // Topic label (MQTT)
                if (message.label != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: (message.topicColor ?? cs.primaryContainer)
                          .withValues(alpha: 0.2),
                      borderRadius: kBorderRadius4,
                    ),
                    child: Text(
                      message.label!,
                      style: kCodeStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: message.topicColor ?? cs.primary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  kHSpacer6,
                ],
                // Badge (QoS, etc.)
                if (message.badge != null) ...[
                  Text(message.badge!,
                      style: TextStyle(fontSize: 11, color: cs.outline)),
                  kHSpacer4,
                ],
                // Payload preview
                Expanded(
                  child: Text(
                    message.isStatus ? message.content : truncated,
                    style: kCodeStyle.copyWith(
                      fontSize: 16,
                      fontStyle:
                          message.isStatus ? FontStyle.italic : FontStyle.normal,
                      color: message.isError
                          ? cs.error
                          : message.isStatus
                              ? cs.outline
                              : cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Size badge
                if (!message.isStatus && message.sizeBytes > 64)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '[${_formatSize(message.sizeBytes)}]',
                      style: TextStyle(fontSize: 14, color: cs.outline),
                    ),
                  ),
                // Expand chevron
                if (!message.isStatus)
                  Icon(
                    isExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 20,
                    color: cs.outline,
                  ),
              ],
            ),
          ),
        ),

        // ── Expanded detail ──
        if (isExpanded && !message.isStatus)
          _ExpandedDetail(
            message: message,
            payloadFormat: payloadFormat,
            formattedPayload: _formatPayload(message.content),
            onFormatChanged: onFormatChanged,
            isBookmarked: isBookmarked,
            onBookmarkToggle: onBookmarkToggle,
            onResend: onResend,
          ),

        // Divider
        Divider(height: 0.5, thickness: 0.5, color: cs.surfaceContainerHighest),
      ],
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
}

// ---------------------------------------------------------------------------
// Expanded detail panel
// ---------------------------------------------------------------------------

class _ExpandedDetail extends StatelessWidget {
  const _ExpandedDetail({
    required this.message,
    required this.payloadFormat,
    required this.formattedPayload,
    required this.onFormatChanged,
    this.isBookmarked = false,
    this.onBookmarkToggle,
    this.onResend,
  });

  final LogMessage message;
  final PayloadFormat payloadFormat;
  final String formattedPayload;
  final ValueChanged<PayloadFormat> onFormatChanged;
  final bool isBookmarked;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(left: 28, right: 8, bottom: 4),
      padding: kP8,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: kBorderRadius6,
        border: Border.all(color: cs.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action bar
          Row(
            children: [
              // Format selector
              ...PayloadFormat.values.map((f) => Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: _FormatChip(
                      label: f.name.toUpperCase(),
                      isActive: payloadFormat == f,
                      onTap: () => onFormatChanged(f),
                    ),
                  )),
              const Spacer(),
              // Copy button
              IconButton(
                icon: const Icon(Icons.copy, size: 14),
                tooltip: 'Copy payload',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message.content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied to clipboard'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
              // Bookmark
              if (onBookmarkToggle != null)
                IconButton(
                  icon: Icon(
                    isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    size: 14,
                    color: isBookmarked ? Colors.amber : null,
                  ),
                  tooltip: isBookmarked ? 'Unpin' : 'Pin message',
                  onPressed: onBookmarkToggle,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
              // Resend
              if (onResend != null && message.isSent)
                IconButton(
                  icon: const Icon(Icons.replay, size: 14),
                  tooltip: 'Resend',
                  onPressed: onResend,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
            ],
          ),
          kVSpacer5,
          // Payload content
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              child: SelectableText(
                formattedPayload,
                style: kCodeStyle.copyWith(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatChip extends StatelessWidget {
  const _FormatChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadius4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isActive ? cs.primaryContainer : Colors.transparent,
          borderRadius: kBorderRadius4,
          border: Border.all(
            color: isActive ? cs.primary : cs.surfaceContainerHighest,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? cs.onPrimaryContainer : cs.outline,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MessageLogView – the full composable widget
// ---------------------------------------------------------------------------

class MessageLogView extends StatefulWidget {
  const MessageLogView({
    super.key,
    required this.messages,
    this.onClear,
    this.onExport,
    this.onResend,
    this.showTopicFilter = false,
  });

  final List<LogMessage> messages;
  final VoidCallback? onClear;
  final VoidCallback? onExport;
  final void Function(LogMessage)? onResend;
  final bool showTopicFilter;

  @override
  State<MessageLogView> createState() => _MessageLogViewState();
}

class _MessageLogViewState extends State<MessageLogView> {
  final _searchCtrl = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';
  DirectionFilter _dirFilter = DirectionFilter.all;
  String? _topicFilter;

  final Set<int> _expandedIndices = {};
  final Map<int, PayloadFormat> _formats = {};
  final Set<int> _bookmarks = {};

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<LogMessage> get _filtered {
    var list = widget.messages;

    // Direction filter
    if (_dirFilter == DirectionFilter.sent) {
      list = list.where((m) => m.isSent).toList();
    } else if (_dirFilter == DirectionFilter.received) {
      list = list.where((m) => m.isReceived).toList();
    }

    // Topic filter
    if (_topicFilter != null) {
      list = list.where((m) => m.label == _topicFilter).toList();
    }

    // Search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((m) =>
              m.content.toLowerCase().contains(q) ||
              (m.label?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    return list;
  }

  List<String> get _topics {
    final topics = <String>{};
    for (final m in widget.messages) {
      if (m.label != null) topics.add(m.label!);
    }
    return topics.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final matchCount =
        _searchQuery.isNotEmpty ? filtered.length : null;

    return Column(
      children: [
        MessageLogToolbar(
          messageCount: widget.messages.length,
          searchController: _searchCtrl,
          onSearchChanged: (q) => setState(() => _searchQuery = q),
          directionFilter: _dirFilter,
          onDirectionFilterChanged: (f) => setState(() => _dirFilter = f),
          topicFilters: widget.showTopicFilter ? _topics : null,
          activeTopicFilter: _topicFilter,
          onTopicFilterChanged: widget.showTopicFilter
              ? (t) => setState(() => _topicFilter = t)
              : null,
          onExport: widget.onExport,
          onClear: widget.onClear,
          matchCount: matchCount,
          searchFocusNode: _searchFocusNode,
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    _searchQuery.isNotEmpty
                        ? 'No messages match "$_searchQuery"'
                        : 'No messages yet',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                            color:
                                Theme.of(context).colorScheme.outlineVariant),
                  ),
                )
              : KeyboardListener(
                  focusNode: FocusNode(),
                  autofocus: false,
                  onKeyEvent: (event) {
                    // Cmd+F / Ctrl+F to focus search
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.keyF &&
                        (HardwareKeyboard.instance.isMetaPressed ||
                            HardwareKeyboard.instance.isControlPressed)) {
                      _searchFocusNode.requestFocus();
                    }
                  },
                  child: ListView.builder(
                    // Reverse so newest messages appear at top
                    reverse: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      // Because reverse: true, index 0 is the last message
                      final msgIdx = filtered.length - 1 - index;
                      final msg = filtered[msgIdx];
                      final origIdx = widget.messages.indexOf(msg);

                      return MessageLogRow(
                        message: msg,
                        isExpanded: _expandedIndices.contains(origIdx),
                        onToggleExpand: () => setState(() {
                          if (_expandedIndices.contains(origIdx)) {
                            _expandedIndices.remove(origIdx);
                          } else {
                            _expandedIndices.add(origIdx);
                          }
                        }),
                        searchQuery: _searchQuery,
                        payloadFormat:
                            _formats[origIdx] ?? PayloadFormat.text,
                        onFormatChanged: (f) =>
                            setState(() => _formats[origIdx] = f),
                        isBookmarked: _bookmarks.contains(origIdx),
                        onBookmarkToggle: () => setState(() {
                          if (_bookmarks.contains(origIdx)) {
                            _bookmarks.remove(origIdx);
                          } else {
                            _bookmarks.add(origIdx);
                          }
                        }),
                        onResend: widget.onResend != null && msg.isSent
                            ? () => widget.onResend!(msg)
                            : null,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// SavedMessageTemplate model
// ---------------------------------------------------------------------------

class SavedMessageTemplate {
  final String id;
  final String name;
  final String payload;
  final String? topic; // MQTT
  final String? badge; // QoS for MQTT
  final DateTime createdAt;

  const SavedMessageTemplate({
    required this.id,
    required this.name,
    required this.payload,
    this.topic,
    this.badge,
    required this.createdAt,
  });
}

// ---------------------------------------------------------------------------
// SavedMessagesPanel – slide-out panel for saved templates
// ---------------------------------------------------------------------------

class SavedMessagesPanel extends StatelessWidget {
  const SavedMessagesPanel({
    super.key,
    required this.templates,
    required this.onSelect,
    required this.onDelete,
    required this.onSave,
  });

  final List<SavedMessageTemplate> templates;
  final ValueChanged<SavedMessageTemplate> onSelect;
  final ValueChanged<String> onDelete;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 260,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: cs.surfaceContainerHighest)),
        color: cs.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: cs.surfaceContainerHighest)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bookmark_outline, size: 16),
                kHSpacer8,
                const Text('Saved Messages',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  tooltip: 'Save current message',
                  onPressed: onSave,
                  visualDensity: VisualDensity.compact,
                  constraints:
                      const BoxConstraints(minWidth: 24, minHeight: 24),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: templates.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No saved messages yet.\nTap + to save the current message.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, color: cs.outlineVariant),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      final t = templates[index];
                      return ListTile(
                        dense: true,
                        title: Text(t.name,
                            style: const TextStyle(fontSize: 12)),
                        subtitle: Text(
                          t.payload.length > 60
                              ? '${t.payload.substring(0, 60)}…'
                              : t.payload,
                          style: kCodeStyle.copyWith(
                              fontSize: 10, color: cs.outline),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 12),
                          onPressed: () => onDelete(t.id),
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints(
                              minWidth: 20, minHeight: 20),
                          padding: EdgeInsets.zero,
                        ),
                        onTap: () => onSelect(t),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Export helper – generates JSON or CSV from messages
// ---------------------------------------------------------------------------

class MessageExporter {
  static String toJson(List<LogMessage> messages) {
    final list = messages.map((m) => {
          'timestamp': m.timestamp.toIso8601String(),
          'direction': m.direction.name,
          'content': m.content,
          if (m.label != null) 'topic': m.label,
          if (m.badge != null) 'qos': m.badge,
          if (m.retained) 'retained': true,
        });
    return const JsonEncoder.withIndent('  ').convert(list.toList());
  }

  static String toCsv(List<LogMessage> messages) {
    final buf = StringBuffer();
    buf.writeln('timestamp,direction,topic,qos,retained,content');
    for (final m in messages) {
      final escaped = m.content.replaceAll('"', '""');
      buf.writeln(
          '${m.timestamp.toIso8601String()},${m.direction.name},'
          '${m.label ?? ""},${m.badge ?? ""},${m.retained},"$escaped"');
    }
    return buf.toString();
  }
}
