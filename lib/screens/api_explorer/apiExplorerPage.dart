// api_explorer_page.dart
import 'package:apidash/screens/api_explorer/api_explorer_widget/methods_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'api_explorer_browse_view.dart';
import 'api_explorer_sidebar.dart';
import 'api_explorer_widget/api_explorer_detail_view.dart';

class ApiExplorerPage extends ConsumerStatefulWidget {
  const ApiExplorerPage({super.key});

  @override
  ConsumerState<ApiExplorerPage> createState() => _ApiExplorerPageState();
}

class _ApiExplorerPageState extends ConsumerState<ApiExplorerPage> {
  final _searchController = TextEditingController();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(apiCatalogProvider.notifier);
      await notifier.loadApis();
      if (ref.read(apiCatalogProvider).isEmpty) {
        await notifier.refreshApis();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildContent(bool isMediumWindow) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedApi = ref.watch(selectedEndpointProvider);
        final selectedCatalog = ref.watch(selectedCatalogProvider);

        return AnimatedSwitcher(
          duration: kTabAnimationDuration,
          child: selectedApi != null
              ? ApiExplorerDetailView(
                  key: ValueKey(selectedApi.id),
                  isMediumWindow: isMediumWindow,
                  searchController: TextEditingController(),
                  endpoint: selectedApi,
                )
              : selectedCatalog != null
                  ? MethodsList(
                      key: ValueKey(selectedCatalog.id),
                      catalog: selectedCatalog,
                    )
                  : ApiExplorerBrowseView(
                      key: const ValueKey('browse'),
                      searchController: _searchController,
                    ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMediumWindow = context.isMediumWindow;

    return Scaffold(
      key: kApiExplorerScaffoldKey,
      body: isMediumWindow
          ? _buildDrawerView(isMediumWindow)
          : _buildSplitView(isMediumWindow),
    );
  }

  Widget _buildDrawerView(bool isMediumWindow) {
    return DrawerSplitView(
      scaffoldKey: kApiExplorerScaffoldKey,
      mainContent: _buildContent(isMediumWindow),
      title: Consumer(
        builder: (context, ref, _) {
          final selectedApi = ref.watch(selectedEndpointProvider);
          return Text(selectedApi?.name ?? kWindowTitle);
        },
      ),
      leftDrawerContent: const ApiExplorerSidebar(),
    );
  }

  Widget _buildSplitView(bool isMediumWindow) {
    return DashboardSplitView(
      sidebarWidget: const ApiExplorerSidebar(),
      mainWidget: _buildContent(isMediumWindow),
    );
  }
}
