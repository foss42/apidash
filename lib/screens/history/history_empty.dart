import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class HistoryEmpty extends StatelessWidget {
  const HistoryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 40,
            color: Theme.of(context).colorScheme.outline,
          ),
          kVSpacer10,
          Text(
            'No history requests',
            style: kTextStyleMedium.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
