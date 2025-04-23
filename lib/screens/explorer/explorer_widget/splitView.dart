import 'package:apidash/screens/explorer/documentation/documentation_pane.dart';
import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';

class ApiExplorerSplitView extends StatelessWidget {
  final ApiEndpoint endpoint;

  const ApiExplorerSplitView({
    super.key, 
    required this.endpoint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: ApiDocumentationPane(endpoint: endpoint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}