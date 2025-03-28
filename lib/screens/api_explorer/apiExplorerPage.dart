import 'package:apidash/screens/api_explorer/api_explorer_browse_view.dart';
import 'package:apidash/screens/api_explorer/api_explorer_sidebar.dart';
import 'package:apidash/screens/api_explorer/api_explorer_widget/api_explorer_detail_view.dart';
import 'package:apidash/screens/api_explorer/api_explorer_widget/methods_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/consts.dart';

class ApiExplorerPage extends ConsumerStatefulWidget {
  const ApiExplorerPage({super.key});

  @override
  ConsumerState<ApiExplorerPage> createState() => _ApiExplorerPageState();
}

class _ApiExplorerPageState extends ConsumerState<ApiExplorerPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(apiExplorerProvider.notifier).loadApis(ref);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedApi = ref.watch(selectedEndpointProvider);
    final selectedCollection = ref.watch(selectedCollectionProvider);
    final isMediumWindow = context.isMediumWindow;

    Widget buildMainContent() {
      if (selectedApi != null) {
        return ApiExplorerDetailView(
          api: selectedApi,
          isMediumWindow: isMediumWindow,
          searchController: _searchController,
        );
      } else if (selectedCollection != null) {
        return MethodsList(collection: selectedCollection);
      } else {
        return ApiExplorerBrowseView(
          scrollController: _scrollController,
          searchController: _searchController,
        );
      }
    }

    return Scaffold(
      body: isMediumWindow
          ? DrawerSplitView(
              scaffoldKey: kApiExplorerScaffoldKey,
              mainContent: buildMainContent(),
              title: Text(selectedApi?['name']?.toString() ?? 'API Explorer'),
              leftDrawerContent: const ApiExplorerSidebar(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () =>
                      ref.read(apiExplorerProvider.notifier).refreshApis(ref),
                ),
              ],
            )
          : DashboardSplitView(
              sidebarWidget: const ApiExplorerSidebar(),
              mainWidget: buildMainContent(),
            ),
    );
  }
}