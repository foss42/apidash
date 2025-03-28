import 'package:apidash/screens/api_explorer/api_explorer_widget/api_documentatioin/api_documentation_pane.dart';
import 'package:flutter/material.dart';

class ApiExplorerSplitView extends StatelessWidget {
  final Map<String, dynamic> api;

  const ApiExplorerSplitView({super.key, required this.api});

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
                child: ApiDocumentationPane(endpoint: api),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
