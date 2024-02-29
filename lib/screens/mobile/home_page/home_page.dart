import 'package:apidash/consts.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/screens/mobile/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  int navIndex = 0;
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
            child: const EditRequestPane(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: const MobileRequestEditor(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_mosaic_outlined),
            label: "request",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.north_east_rounded),
            label: "response",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: "code",
          ),
        ],
        currentIndex: navIndex,
        onTap: (value) {
          setState(() {
            navIndex = value;
          });
        },
      ),
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
