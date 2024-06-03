import 'package:flutter/material.dart';

class PageBase extends StatelessWidget {
  final String title;
  final Widget scaffoldBody;
  const PageBase({super.key, required this.title, required this.scaffoldBody});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        primary: true,
        title: Text(title),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
        child: scaffoldBody,
      ),
    );
  }
}
