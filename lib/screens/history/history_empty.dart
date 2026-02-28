import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class HistoryEmpty extends StatelessWidget {
  const HistoryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 40,
            color: Theme.of(context).colorScheme.outline,
          ),
          kVSpacer10(ds.scaleFactor),
          Text(
            'No history requests',
            style: kTextStyleMedium(ds.scaleFactor).copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
