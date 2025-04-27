import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart'; // Ensure this is imported
import 'chip.dart';

class ImportButton extends StatelessWidget {
  const ImportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: const Text(
        'Import',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class UrlCard extends StatelessWidget {
  final String? url;
  final String method;

  const UrlCard({
    super.key,
    required this.url,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          children: [
            CustomChip.httpMethod(method),
            kHSpacer10,
            Expanded(
              child: Text(
                url ?? '',
                style: const TextStyle(color: Colors.blue),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            kHSpacer20,
            const ImportButton(),
          ],
        ),
      ),
    );
  }
}