import 'package:flutter/material.dart';
import 'description_header.dart';
import 'description_body.dart';

class DescriptionPage extends StatelessWidget {
  final VoidCallback onBack;

  const DescriptionPage({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: DescriptionHeader(onBack: onBack),
        ),
        const Expanded(
          child: DescriptionBody(),
        ),
      ],
    );
  }
}