import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/consts.dart';
import 'sidebar_save_button.dart';

class SidebarHeader extends ConsumerWidget {
  const SidebarHeader({super.key, this.onAddNew});
  final Function()? onAddNew;

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
            child: const Text(
              kLabelPlusNew,
              style: kTextStyleButton,
            ),
          ),
          context.width <= kMinWindowSize.width
              ? IconButton(
                  style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(4),
                      minimumSize: const Size(30, 30)),
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
