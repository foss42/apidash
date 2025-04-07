import 'package:apidash/screens/api_explorer/api_explorer_widget/api_CollectionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/consts.dart';
import 'api_explorer_widget/api_explorer_sidebar_header.dart';

class ApiExplorerSidebar extends ConsumerWidget {
  const ApiExplorerSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: (!context.isMediumWindow && kIsMacOS ? kPt24 : kPt8) +
          (context.isMediumWindow ? kPb70 : EdgeInsets.zero),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ApiExplorerSidebarHeader(),
          Expanded(child: ApiCollectionList()),
          kHSpacer5,
        ],
      ),
    );
  }
}
