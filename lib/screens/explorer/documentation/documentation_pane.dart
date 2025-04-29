import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'widgets/endpoint_overview.dart';
import 'widgets/documentation_section.dart';
import 'widgets/parameter_table.dart';
import 'widgets/request_body_section.dart';
import 'widgets/header_table.dart';
import 'widgets/response_examples.dart';

class ApiDocumentationPage extends StatelessWidget {
  final ApiEndpoint endpoint;

  const ApiDocumentationPage({super.key, required this.endpoint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(endpoint.name),
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () => _copyEndpointUrl(context),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () => _openInBrowser(context),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          overscroll: false, 
          scrollbars: false,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(), // Removes bounce effect
          child: Column(
            children: [
              
              kHSpacer12,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: EndpointOverview(endpoint: endpoint),
              ),
              if (endpoint.description != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: DocumentationSection(
                    title: 'Description',
                    child: Text(
                      endpoint.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              if (endpoint.parameters?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: DocumentationSection(
                    title: 'Parameters',
                    child: ParameterTable(parameters: endpoint.parameters!),
                  ),
                ),
              if (endpoint.requestBody != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: DocumentationSection(
                    title: 'Request Body',
                    child: RequestBodySection(requestBody: endpoint.requestBody!),
                  ),
                ),
              if (endpoint.headers?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: DocumentationSection(
                    title: 'Headers',
                    child: HeaderTable(headers: endpoint.headers!),
                  ),
                ),
              if (endpoint.responses?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: DocumentationSection(
                    title: 'Responses',
                    child: ResponseExamples(responses: endpoint.responses!),
                  ),
                ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _copyEndpointUrl(BuildContext context) {
    final url = '${endpoint.baseUrl}${endpoint.path}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $url'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openInBrowser(BuildContext context) {
    final url = '${endpoint.baseUrl}${endpoint.path}';
    debugPrint('Would open: $url');
  }
}