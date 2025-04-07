import 'package:apidash/models/api_endpoint.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/clipboard_utils.dart';
import '../../../../utils/utils.dart';

class ApiDocumentationPane extends ConsumerWidget {
  const ApiDocumentationPane({
    super.key,
    this.endpoint,
    this.isStandalone = false,
  });

  final ApiEndpointModel? endpoint;
  final bool isStandalone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final selectedApi = endpoint;
    final catalog = ref.watch(selectedCatalogProvider);
    final baseUrl = catalog?.baseUrl ?? '';

    if (selectedApi == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.api,
              size: 48,
              color: colors.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Select an API endpoint to view documentation',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: isStandalone ? const DocumentationAppBar() : null,
      body: Container(
        color: colors.surface,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: DocumentationContent(
            endpoint: selectedApi,
            baseUrl: baseUrl,
          ),
        ),
      ),
    );
  }
}

class DocumentationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DocumentationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DocumentationContent extends StatelessWidget {
  final ApiEndpointModel endpoint;
  final String baseUrl;

  const DocumentationContent({
    super.key,
    required this.endpoint,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequestHeader(endpoint: endpoint, baseUrl: baseUrl),
        const SizedBox(height: 28),
        
        if (endpoint.description.isNotEmpty) ...[
          SectionTitle(title: 'Description', icon: Icons.description),
          const SizedBox(height: 16),
          DescriptionContent(description: endpoint.description),
          const SizedBox(height: 28),
        ],

        if (endpoint.parameters.isNotEmpty) ...[
          SectionTitle(title: 'Parameters', icon: Icons.tune),
          const SizedBox(height: 12),
          ParametersList(parameters: endpoint.parameters),
          const SizedBox(height: 28),
        ],

        if (endpoint.responses.isNotEmpty) ...[
          SectionTitle(title: 'Responses', icon: Icons.assignment_returned),
          const SizedBox(height: 12),
          ResponsesList(responses: endpoint.responses),
          const SizedBox(height: 28),
        ],
      ],
    );
  }
}

class RequestHeader extends StatelessWidget {
  final ApiEndpointModel endpoint;
  final String baseUrl;

  const RequestHeader({
    super.key, 
    required this.endpoint,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final method = endpoint.method.name.toUpperCase();
    final path = endpoint.path;
    final fullUrl = '$baseUrl$path';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: getMethodColor(method).withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: getMethodColor(method).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Text(
                method,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: getMethodColor(method),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                endpoint.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.outline.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(
                  fullUrl,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontFamily: 'RobotoMono',
                    color: colors.onSurface,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, size: 20, color: colors.primary),
                onPressed: () => copyToClipboard(context, fullUrl),
                tooltip: 'Copy URL',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class DescriptionContent extends StatelessWidget {
  final String description;

  const DescriptionContent({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Text(
        description,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.9),
          height: 1.5,
        ),
      ),
    );
  }
}

class ParametersList extends StatelessWidget {
  final Map<String, dynamic> parameters;

  const ParametersList({
    super.key,
    required this.parameters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: parameters.entries.map((entry) => ParameterItem(
        name: entry.key,
        param: entry.value,
      )).toList(),
    );
  }
}

class ParameterItem extends StatelessWidget {
  final String name;
  final dynamic param;

  const ParameterItem({
    super.key,
    required this.name,
    required this.param,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final description = param['description']?.toString();
    final required = param['required'] == true;
    final inType = param['in']?.toString() ?? 'query';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(name, style: theme.textTheme.bodyLarge)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getParamTypeColor(inType).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: getParamTypeColor(inType).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    inType,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: getParamTypeColor(inType),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (required) ...[
                  const SizedBox(width: 8),
                  const RequiredChip(),
                ],
              ],
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(description, style: theme.textTheme.bodyMedium),
            ],
            if (param['schema'] != null) ...[
              const SizedBox(height: 8),
              SchemaDetails(schema: param['schema']),
            ]
          ],
        ),
      ),
    );
  }
}

class RequiredChip extends StatelessWidget {
  const RequiredChip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Text(
        'required',
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SchemaDetails extends StatelessWidget {
  final Map<String, dynamic> schema;

  const SchemaDetails({super.key, required this.schema});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = schema['type']?.toString() ?? 'unknown';
    final format = schema['format']?.toString();
    final example = schema['example']?.toString();
    final defaultValue = schema['default']?.toString();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (schema['description'] != null) ...[
            Text(
              schema['description'].toString(),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              DetailChip(text: 'Type: $type'),
              if (format != null) DetailChip(text: 'Format: $format'),
              if (example != null) DetailChip(text: 'Example: $example'),
              if (defaultValue != null) DetailChip(text: 'Default: $defaultValue'),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailChip extends StatelessWidget {
  final String text;

  const DetailChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }
}

class ResponsesList extends StatelessWidget {
  final Map<String, dynamic> responses;

  const ResponsesList({
    super.key,
    required this.responses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: responses.entries.map((entry) => ResponseItem(
        statusCode: entry.key,
        response: entry.value,
      )).toList(),
    );
  }
}

class ResponseItem extends StatelessWidget {
  final String statusCode;
  final dynamic response;

  const ResponseItem({
    super.key,
    required this.statusCode,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = response['description']?.toString() ?? 'No description';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: getStatusCodeColor(statusCode).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusCodeColor(statusCode).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusCode,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: getStatusCodeColor(statusCode),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(description)),
              ],
            ),
          ),
          if (response['content'] != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: ContentTypeSection(
                contentType: response['content'].keys.first,
                content: response['content'].values.first,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ContentTypeSection extends StatelessWidget {
  final String contentType;
  final dynamic content;

  const ContentTypeSection({
    super.key,
    required this.contentType,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final schema = content['schema'] as Map<String, dynamic>? ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text(
                  contentType,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SchemaDetails(schema: schema),
          ),
        ],
      ),
    );
  }
}

Color getMethodColor(String method) {
  switch (method.toLowerCase()) {
    case 'get': return Colors.green;
    case 'post': return Colors.blue;
    case 'put': return Colors.orange;
    case 'patch': return Colors.purple;
    case 'delete': return Colors.red;
    default: return Colors.grey;
  }
}

Color getStatusCodeColor(String statusCode) {
  final code = int.tryParse(statusCode) ?? 200;
  if (code >= 200 && code < 300) return Colors.green;
  if (code >= 300 && code < 400) return Colors.orange;
  if (code >= 400 && code < 500) return Colors.red;
  return Colors.blue;
}

Color getParamTypeColor(String inType) {
  switch (inType) {
    case 'query': return Colors.blue;
    case 'path': return Colors.purple;
    case 'header': return Colors.orange;
    default: return Colors.grey;
  }
}