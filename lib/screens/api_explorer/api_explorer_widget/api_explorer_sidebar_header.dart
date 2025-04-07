import 'package:apidash/screens/api_explorer/api_explorer_widget/api_documentatioin/Openapispecfileadd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/providers/providers.dart';
import '../../../consts.dart';

class ApiExplorerSidebarHeader extends ConsumerWidget {
  const ApiExplorerSidebarHeader({super.key});

  Future<void> showAddApiDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) => AddApiDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobileScaffoldKey = ref.read(mobileScaffoldKeyStateProvider);
    final sm = ScaffoldMessenger.of(context);
    return Padding(
      padding: kPe4,
      child: Row(
        children: [
          kHSpacer10,
          Text(
            "API Explorer",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          ADIconButton(
            icon: Icons.add,
            iconSize: kButtonIconSizeLarge,
            tooltip: "Add API Spec",
            onPressed: () => showAddApiDialog(context, ref),
          ),
          ADIconButton(
            icon: Icons.refresh,
            iconSize: kButtonIconSizeLarge,
            tooltip: "Refresh APIs",
            onPressed: () {
              ref.read(apiCatalogProvider.notifier).refreshApis();
              sm.showSnackBar(
                const SnackBar(content: Text('Refreshing API collections')),
              );
            },
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