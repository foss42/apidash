import 'package:flutter/material.dart';
import 'package:apidash/models/models.dart';
import 'description_header.dart';
import 'description_body.dart';

class DescriptionPage extends StatelessWidget {
  final ApiTemplate template;
  final VoidCallback onBack;

  const DescriptionPage({
    super.key,
    required this.template,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DescriptionHeader(
          info: template.info,
          onBack: onBack,
        ),
        Expanded(
          child: DescriptionBody(template: template),
        ),
      ],
    );
  }
}