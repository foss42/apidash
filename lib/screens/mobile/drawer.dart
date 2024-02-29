import 'package:apidash/screens/home_page/collection_pane.dart';
import 'package:apidash/screens/intro_page.dart';
import 'package:apidash/screens/mobile/home_page/home_page.dart';
import 'package:apidash/screens/settings_page.dart';
import 'package:flutter/material.dart';

class MobileAppDrawer extends StatelessWidget {
  const MobileAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: ListTile(
              title: const Text("Requests"),
              leading: const Icon(
                Icons.auto_awesome_mosaic,
              ),
              trailing: SizedBox(
                width: 65,
                child: Row(
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.home_outlined),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: const Text("Home"),
                              ),
                              drawer: const MobileAppDrawer(),
                              body: const IntroPage(),
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      child: const Icon(Icons.settings_outlined),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: const Text("Settings"),
                              ),
                              drawer: const MobileAppDrawer(),
                              body: const SettingsPage(),
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MobileHomePage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: CollectionPane(),
          )
        ],
      ),
    );
  }
}

