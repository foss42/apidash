import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
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
    final ds = DesignSystemProvider.of(context);
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
            child: Text(
              kLabelPlusNew,
              style: kTextStyleButton(ds.scaleFactor),
            ),
          ),
          kHSpacer4(ds.scaleFactor),
          SizedBox(
            width: 24*ds.scaleFactor,
            child: SidebarTopMenu(
              tooltip: kLabelMoreOptions,
              onSelected: (option) => switch (option) {
                SidebarMenuOption.import => onImport?.call(),
              },
            ),
          ),
          context.width <= kMinWindowSize.width*ds.scaleFactor
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
