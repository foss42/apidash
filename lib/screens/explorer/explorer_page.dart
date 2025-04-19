import 'package:flutter/material.dart';
import 'explorer_header.dart';
import 'explorer_body.dart';

class ExplorerPage extends StatelessWidget {
  const ExplorerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 60, 
            child: ExplorerHeader(),
          ),
          const Expanded(
            child: ExplorerBody(),
          ),
        ],
      ),
    );
  }
}