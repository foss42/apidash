import 'package:apidash/screens/explorer/browse_pane/browse_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'sidebar.dart';
import 'widget/detail_view.dart';
import 'widget/methods_list.dart';

class ApiExplorerPage extends ConsumerStatefulWidget {
  const ApiExplorerPage({super.key});

  @override
  ConsumerState<ApiExplorerPage> createState() => _ApiExplorerPageState();
}

class _ApiExplorerPageState extends ConsumerState<ApiExplorerPage> {
  final _searchController = TextEditingController();

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
    super.dispose();
  }

Widget _buildContent(bool isMediumWindow) {
  final selectedEndpoint = ref.watch(selectedEndpointProvider);
  final selectedCollection = ref.watch(selectedCollectionProvider);

  return AnimatedSwitcher(
    duration: kTabAnimationDuration,
    child: selectedEndpoint != null
        ? ApiExplorerDetailView(
            key: ValueKey('detail_${selectedEndpoint.id}'),
            endpoint: selectedEndpoint,
            isMediumWindow: isMediumWindow,
          )
        : selectedCollection != null
            ? MethodsList(
                key: ValueKey('methods_${selectedCollection.id}'),
                collection: selectedCollection,
              )
            : ApiExplorerBrowseView(
                key: const ValueKey('browse'),
                searchController: _searchController,
              ),
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
          final selectedEndpoint = ref.watch(selectedEndpointProvider);
          return Text(selectedEndpoint?.name ?? kWindowTitle);
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