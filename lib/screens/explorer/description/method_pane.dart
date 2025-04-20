import 'package:flutter/material.dart';

class MethodPane extends StatelessWidget {
  const MethodPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(12.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Method Pane', // Placeholder
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'This pane will display API method details (e.g., GET, POST).', // Placeholder
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}