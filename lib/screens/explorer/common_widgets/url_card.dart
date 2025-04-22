import 'package:flutter/material.dart';

class MethodWidget extends StatelessWidget {
  final String method;

  const MethodWidget({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        method,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }
}

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

  const UrlCard({super.key, this.url, this.method = 'GET'});

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
            MethodWidget(method: method),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                url ?? '',
                style: const TextStyle(color: Colors.blue),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 20),
            const ImportButton(),
          ],
        ),
      ),
    );
  }
}