import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/terminal_models.dart';
import '../../providers/terminal_providers.dart';

class TerminalPage extends ConsumerWidget {
  const TerminalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(terminalStateProvider);
    final entries = state.entries;

    return Scaffold(
      appBar: AppBar(title: const Text('Terminal')),
      body: ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          final e = entries[i];
          final title = _titleFor(e);
          final subtitle = _subtitleFor(e);
          final icon = _iconFor(e);
          return ListTile(
            leading: Icon(icon),
            title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(subtitle ?? '',
                maxLines: 2, overflow: TextOverflow.ellipsis),
            dense: true,
          );
        },
      ),
    );
  }

  IconData _iconFor(TerminalEntry e) {
    switch (e.source) {
      case TerminalSource.network:
        return Icons.language;
      case TerminalSource.js:
        return Icons.javascript;
      case TerminalSource.system:
        return Icons.info_outline;
    }
  }

  String _titleFor(TerminalEntry e) {
    switch (e.source) {
      case TerminalSource.network:
        final n = e.network!;
        final status = n.responseStatus != null ? ' — ${n.responseStatus}' : '';
        return '${n.method.name.toUpperCase()} ${n.url}$status';
      case TerminalSource.js:
        final j = e.js!;
        return 'JS ${j.level}';
      case TerminalSource.system:
        return 'System';
    }
  }

  String? _subtitleFor(TerminalEntry e) {
    switch (e.source) {
      case TerminalSource.network:
        final n = e.network!;
        if (n.errorMessage != null) return n.errorMessage;
        return n.responseBodyPreview ?? n.requestBodyPreview;
      case TerminalSource.js:
        final j = e.js!;
        return j.args.join(' ');
      case TerminalSource.system:
        final s = e.system!;
        return s.message;
    }
  }
}
