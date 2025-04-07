import 'package:apidash/models/api_endpoint.dart';
import 'package:apidash/screens/api_explorer/api_explorer_widget/api_documentatioin/api_documentation_pane.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';

class ApiExplorerSplitView extends StatelessWidget {
  final ApiEndpointModel api;

  const ApiExplorerSplitView({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: ClipRRect(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ApiDocumentationPane(endpoint: api),
              ),
            ],
          ),
        ),
      ),
    );
  }
}