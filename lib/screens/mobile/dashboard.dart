import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../intro_page.dart';
import '../settings_page.dart';
import '../home_page/collection_pane.dart';

class MobileDashboard extends ConsumerStatefulWidget {
  const MobileDashboard(
      {required this.scaffoldBody, required this.title, super.key});

  final Widget scaffoldBody;
  final String title;

  @override
  ConsumerState<MobileDashboard> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends ConsumerState<MobileDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 70,
            ),
            ListTile(
              title: const Text(kLabelHome),
              leading: const Icon(Icons.home_outlined),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MobileDashboard(
                        title: kLabelHome,
                        scaffoldBody: IntroPage(),
                      ),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              title: const Text(kLabelRequests),
              leading: const Icon(Icons.auto_awesome_mosaic_outlined),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MobileDashboard(
                        title: kLabelRequests,
                        scaffoldBody: CollectionPane(),
                      ),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              title: const Text(kLabelSettings),
              leading: const Icon(Icons.settings_outlined),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MobileDashboard(
                        title: kLabelSettings,
                        scaffoldBody: SettingsPage(),
                      ),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),
            const Divider(),
          ],
        ),
      ),
      body: SafeArea(
        child: widget.scaffoldBody,
      ),
    );
  }
}
