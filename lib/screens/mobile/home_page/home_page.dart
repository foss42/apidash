import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/code_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/response_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/screens/mobile/drawer.dart';
import 'package:apidash/widgets/mobile_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileHomePage extends ConsumerStatefulWidget {
  const MobileHomePage({super.key});

  @override
  ConsumerState<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends ConsumerState<MobileHomePage> {
  final navPages = const [
    EditRequestPane(),
    ResponsePane(),
    CodePane(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          child: MobileAppBarRequestTile(),
        ),
      ),
      drawer: const MobileAppDrawer(),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.73,
            child: navPages[ref.watch(mobileBottomNavIndexStateProvider)],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: const MobileRequestEditor(),
          ),
        ],
      ),
      bottomNavigationBar: const MobileBottomNavBar(),
    );
  }
}

class MobileAppBarRequestTile extends ConsumerWidget {
  const MobileAppBarRequestTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestItem = ref.watch(selectedRequestModelProvider)!;
    String name =
        requestItem.name.trim().isNotEmpty ? requestItem.name : "untitled";
    return Row(
      children: [
        const DropdownButtonHTTPMethod(),
        const SizedBox(width: 10),
        Text(name),
      ],
    );
  }
}

class MobileRequestEditor extends StatelessWidget {
  const MobileRequestEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        kHSpacer10,
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              borderRadius: kBorderRadius12,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: URLTextField(),
            ),
          ),
        ),
        kHSpacer10,
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1 / 2,
          child: const SendButton(),
        ),
        kHSpacer10,
      ],
    );
  }
}
