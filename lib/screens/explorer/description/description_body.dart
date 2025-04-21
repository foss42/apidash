import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'request_pane.dart';
import 'description_pane.dart';

class DescriptionBody extends StatelessWidget {
  final ApiTemplate template;

  const DescriptionBody({
    super.key,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: RequestsPane(requests: template.requests),
          ),
          const Expanded(
            child: DescriptionPane(),
          ),
        ],
      ),
    );
  }
}