import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/screens/mobile/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileHomePage extends ConsumerWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestItem = ref.watch(selectedRequestModelProvider)!;
    String name =
        requestItem.name.trim().isNotEmpty ? requestItem.name : "untitled";
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          child: Row(
            children: [
              const DropdownButtonHTTPMethod(),
              const SizedBox(width: 10),
              Text(name),
            ],
          ),
        ),
      ),
      drawer: const MobileAppDrawer(),
      body: const EditRequestPane(),
    );
  }
}
