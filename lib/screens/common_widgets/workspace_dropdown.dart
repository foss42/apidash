import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

class WorkspaceDropdown extends ConsumerWidget {
  const WorkspaceDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currentPath = settings.workspaceFolderPath;
    final label = savedWorkspaceNameForPath(
          settings.savedWorkspaces,
          currentPath,
        ) ??
        kLabelSelectWorkspace;

    return LayoutBuilder(
      builder: (context, constraints) {
        return WorkspacePopupMenu(
          width: constraints.maxWidth,
          currentLabel: label,
          workspaces: settings.savedWorkspaces,
          onPathSelected: (path) async {
            if (p.normalize(path) == p.normalize(currentPath ?? '')) {
              return;
            }
            final ok = await activateWorkspace(
              ref,
              path,
              createIfMissing: false,
            );
            if (!ok && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(kMsgWorkspaceOpenFailed)),
              );
            }
          },
          onOpenWorkspace: () => _openWorkspaceSelector(context, ref),
        );
      },
    );
  }

  Future<void> _openWorkspaceSelector(BuildContext context, WidgetRef ref) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (selectorContext) => WorkspaceSelector(
          onContinue: (path) async {
            final ok = await activateWorkspace(ref, path);
            if (ok && selectorContext.mounted) {
              Navigator.of(selectorContext).pop();
            }
          },
          onCancel: () async {
            if (selectorContext.mounted) {
              Navigator.of(selectorContext).pop();
            }
          },
        ),
      ),
    );
  }
}
