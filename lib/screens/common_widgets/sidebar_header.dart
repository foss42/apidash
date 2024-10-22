import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'sidebar_save_button.dart';

class SidebarHeader extends ConsumerWidget {
  const SidebarHeader({
    super.key,
    this.onAddNew,
    this.onImport,
  });
  final VoidCallback? onAddNew;
  final VoidCallback? onImport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobileScaffoldKey = ref.read(mobileScaffoldKeyStateProvider);

    return Padding(
      padding: kPe8,
      child: Row(
        children: [
          const SaveButton(),
          const Spacer(),
          ElevatedButton(
            onPressed: onAddNew,
            style: kButtonSidebarStyle,
            child: const Text(
              kLabelPlusNew,
              style: kTextStyleButton,
            ),
          ),
          kHSpacer4,
          SizedBox(
            width: 24,
            child: SidebarTopMenu(
              tooltip: kLabelMoreOptions,
              onSelected: (option) => switch (option) {
                SidebarMenuOption.import => onImport?.call(),
              },
            ),
          ),
          context.width <= kMinWindowSize.width
              ? IconButton(
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(36, 36),
                  ),
                  onPressed: () {
                    mobileScaffoldKey.currentState?.closeDrawer();
                  },
                  icon: const Icon(Icons.chevron_left),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
