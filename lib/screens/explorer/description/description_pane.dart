import 'package:flutter/material.dart';

class DescriptionPane extends StatelessWidget {
  const DescriptionPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'Description Pane',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}