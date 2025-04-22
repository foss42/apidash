import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import '../common_widgets/url_card.dart';
import 'package:apidash/models/models.dart';

class DescriptionPane extends StatelessWidget {
  final RequestModel? selectedRequest;

  const DescriptionPane({super.key, this.selectedRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          UrlCard(url: selectedRequest?.httpRequestModel?.url),
        ],
      ),
    );
  }
}