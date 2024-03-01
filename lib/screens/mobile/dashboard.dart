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
      drawer: const Drawer(
        child: Padding(
          padding: EdgeInsets.only(top: kTabHeight),
          child: CollectionPane(),
        ),
      ),
      body: SafeArea(
        child: widget.scaffoldBody,
      ),
    );
  }
}
