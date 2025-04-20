import 'package:flutter/material.dart';
import 'explorer_header.dart';
import 'explorer_body.dart';
import 'description/description_page.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({super.key});

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  bool _showDescription = false;

  void _navigateToDescription() {
    setState(() {
      _showDescription = true;
    });
  }

  void _navigateBackToExplorer() {
    setState(() {
      _showDescription = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showDescription 
          ? DescriptionPage(onBack: _navigateBackToExplorer)
          : Column(
              children: [
                const SizedBox(
                  height: 60, 
                  child: ExplorerHeader(),
                ),
                Expanded(
                  child: ExplorerBody(
                    onCardTap: _navigateToDescription,
                  ),
                ),
              ],
            ),
    );
  }
}