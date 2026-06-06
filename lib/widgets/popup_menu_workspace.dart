import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import '../consts.dart';
import '../models/models.dart';

const kWorkspaceMenuOpenSentinel = '__open_workspace__';

class WorkspacePopupMenu extends StatelessWidget {
  const WorkspacePopupMenu({
    super.key,
    required this.currentLabel,
    required this.workspaces,
    required this.onPathSelected,
    required this.onOpenWorkspace,
    this.width,
  });

  final String currentLabel;
  final List<SavedWorkspaceEntry> workspaces;
  final void Function(String path) onPathSelected;
  final VoidCallback onOpenWorkspace;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final menuWidth = width ?? (context.isCompactWindow ? 100.0 : 130.0);
    final items = <(String, String)>[
      for (final w in workspaces)
        (w.path, w.name.clip(30)),
      (kWorkspaceMenuOpenSentinel, kLabelOpenWorkspaceMenu),
    ];

    return ADPopupMenu<String>(
      value: currentLabel.clip(30),
      values: items,
      width: menuWidth,
      tooltip: kLabelSelectWorkspace,
      isOutlined: true,
      onChanged: (value) {
        if (value == null) {
          return;
        }
        if (value == kWorkspaceMenuOpenSentinel) {
          onOpenWorkspace();
        } else {
          onPathSelected(value);
        }
      },
    );
  }
}
