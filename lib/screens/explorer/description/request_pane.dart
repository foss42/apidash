import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'requests_card.dart';

class RequestsPane extends StatelessWidget {
  final List requests;

  const RequestsPane({
    super.key,
    required this.requests,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return RequestCard(
            title: request.name,
          );
        },
      ),
    );
  }
}