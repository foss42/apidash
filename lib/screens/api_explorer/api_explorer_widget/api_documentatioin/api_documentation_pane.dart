import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/models/models.dart';
import '../../../../utils/clipboard_utils.dart';
import '../../../../utils/utils.dart';

class ApiDocumentationPane extends ConsumerWidget {
  const ApiDocumentationPane({
    super.key,
    this.endpoint,
    this.isStandalone = false,
  });

  final ApiExplorerModel? endpoint;
  final bool isStandalone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final selectedApi = endpoint;

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
          child: DocumentationContent(endpoint: selectedApi),
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
  final ApiExplorerModel endpoint;

  const DocumentationContent({super.key, required this.endpoint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequestHeader(endpoint: endpoint),
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
          ParametersList(parameters: endpoint.parameters, schemas: endpoint.parameterSchemas),
          const SizedBox(height: 28),
        ],

        if (endpoint.requestBody != null) ...[
          SectionTitle(title: 'Request Body', icon: Icons.input),
          const SizedBox(height: 12),
          RequestBodyWidget(requestBody: endpoint.requestBody!),
          const SizedBox(height: 28),
        ],

        if (endpoint.headers.isNotEmpty) ...[
          SectionTitle(title: 'Headers', icon: Icons.list_alt),
          const SizedBox(height: 12),
          HeadersList(headers: endpoint.headers, schemas: endpoint.headerSchemas),
          const SizedBox(height: 28),
        ],

        if (endpoint.responses?.isNotEmpty ?? false) ...[
          SectionTitle(title: 'Responses', icon: Icons.assignment_returned),
          const SizedBox(height: 12),
          ResponsesList(responses: endpoint.responses!),
          const SizedBox(height: 28),
        ],
      ],
    );
  }
}

class RequestHeader extends StatelessWidget {
  final ApiExplorerModel endpoint;

  const RequestHeader({super.key, required this.endpoint});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final method = endpoint.method.name.toUpperCase();
    final path = endpoint.path;
    final baseUrl = endpoint.baseUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MethodChip(method: method),
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
        UrlDisplay(baseUrl: baseUrl, path: path),
      ],
    );
  }
}

class MethodChip extends StatelessWidget {
  final String method;

  const MethodChip({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
    );
  }
}

class UrlDisplay extends StatelessWidget {
  final String baseUrl;
  final String path;

  const UrlDisplay({super.key, required this.baseUrl, required this.path});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final fullUrl = '$baseUrl$path';

    return Container(
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
          CopyButton(content: fullUrl),
        ],
      ),
    );
  }
}

class CopyButton extends StatelessWidget {
  final String content;

  const CopyButton({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      icon: Icon(Icons.copy, size: 20, color: colors.primary),
      onPressed: () => copyToClipboard(context, content),
      tooltip: 'Copy URL',
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
  final List<NameValueModel> parameters;
  final Map<String, dynamic> schemas;

  const ParametersList({
    super.key,
    required this.parameters,
    required this.schemas,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: parameters.map((param) => ParameterItem(
        param: param,
        schema: schemas[param.name] ?? {},
      )).toList(),
    );
  }
}

class ParameterItem extends StatelessWidget {
  final NameValueModel param;
  final Map<String, dynamic> schema;

  const ParameterItem({
    super.key,
    required this.param,
    required this.schema,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isRequired = schema['required'] == true;
    final inType = schema['in']?.toString() ?? 'query';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(theme, colors, isRequired, inType),
            if (schema['description'] != null) ...[
              const SizedBox(height: 12),
              Text(
                schema['description'].toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
            ],
            if (schema['type'] != null || schema['example'] != null) ...[
              const SizedBox(height: 12),
              _buildSchemaDetails(theme, schema),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(ThemeData theme, ColorScheme colors, bool isRequired, String inType) {
    return Row(
      children: [
        Expanded(
          child: Text(
            param.name,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
        ),
        ParamTypeChip(inType: inType),
        if (isRequired) const RequiredChip(),
      ],
    );
  }

  Widget _buildSchemaDetails(ThemeData theme, Map<String, dynamic> schema) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (schema['type'] != null)
          DetailChip(text: 'Type: ${schema['type']}'),
        if (schema['example'] != null)
          DetailChip(text: 'Example: ${schema['example']}'),
        if (schema['default'] != null)
          DetailChip(text: 'Default: ${schema['default']}'),
      ],
    );
  }
}

class ParamTypeChip extends StatelessWidget {
  final String inType;

  const ParamTypeChip({super.key, required this.inType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
      margin: const EdgeInsets.only(left: 8),
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

// Similar widget breakdown for RequestBodyWidget, HeadersList, ResponsesList etc...

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

// Request Body Section
class RequestBodyWidget extends StatelessWidget {
  final Map<String, dynamic> requestBody;

  const RequestBodyWidget({super.key, required this.requestBody});

  @override
  Widget build(BuildContext context) {
    final content = requestBody['content'] as Map<String, dynamic>? ?? {};
    final description = requestBody['description']?.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null) ...[
          DescriptionContent(description: description),
          const SizedBox(height: 16),
        ],
        ...content.entries.map((entry) => ContentTypeSection(
          contentType: entry.key,
          content: entry.value,
        )),
      ],
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

class SchemaDetails extends StatelessWidget {
  final Map<String, dynamic> schema;

  const SchemaDetails({super.key, required this.schema});

  @override
  Widget build(BuildContext context) {
    if (schema['type'] == 'object' && schema['properties'] != null) {
      return ObjectSchema(schema: schema);
    }
    if (schema['type'] == 'array' && schema['items'] != null) {
      return ArraySchema(schema: schema);
    }
    return BasicSchema(schema: schema);
  }
}

class ObjectSchema extends StatelessWidget {
  final Map<String, dynamic> schema;

  const ObjectSchema({super.key, required this.schema});

  @override
  Widget build(BuildContext context) {
    final properties = schema['properties'] as Map<String, dynamic>? ?? {};
    final requiredFields = List<String>.from(schema['required'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (schema['description'] != null) ...[
          Text(
            schema['description'].toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
        ],
        ...properties.entries.map((entry) => PropertyItem(
          name: entry.key,
          property: entry.value,
          isRequired: requiredFields.contains(entry.key),
        )),
      ],
    );
  }
}

class PropertyItem extends StatelessWidget {
  final String name;
  final dynamic property;
  final bool isRequired;

  const PropertyItem({
    super.key,
    required this.name,
    required this.property,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = property['type']?.toString() ?? 'unknown';
    final description = property['description']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isRequired) const RequiredChip(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Type: $type',
            style: theme.textTheme.bodySmall,
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ArraySchema extends StatelessWidget {
  final Map<String, dynamic> schema;

  const ArraySchema({super.key, required this.schema});

  @override
  Widget build(BuildContext context) {
    final items = schema['items'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (schema['description'] != null) ...[
          Text(
            schema['description'].toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
        ],
        Text(
          'Array of:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SchemaDetails(schema: items),
        ),
      ],
    );
  }
}

class BasicSchema extends StatelessWidget {
  final Map<String, dynamic> schema;

  const BasicSchema({super.key, required this.schema});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = schema['type']?.toString() ?? 'unknown';
    final format = schema['format']?.toString();
    final description = schema['description']?.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null) ...[
          Text(
            description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 8,
          children: [
            DetailChip(text: 'Type: $type'),
            if (format != null) DetailChip(text: 'Format: $format'),
            if (schema['enum'] != null)
              DetailChip(text: 'Enum: ${schema['enum'].join(', ')}'),
          ],
        ),
      ],
    );
  }
}

// Headers Section
class HeadersList extends StatelessWidget {
  final List<NameValueModel> headers;
  final Map<String, dynamic> schemas;

  const HeadersList({
    super.key,
    required this.headers,
    required this.schemas,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const HeaderListHeader(),
          ...headers.map((header) => HeaderItem(
            header: header,
            schema: schemas[header.name] ?? {},
          )),
        ],
      ),
    );
  }
}

class HeaderListHeader extends StatelessWidget {
  const HeaderListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.1),
          ),
        ),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Header')),
          Expanded(flex: 3, child: Text('Description')),
          Expanded(flex: 1, child: Center(child: Text('Required'))),
        ],
      ),
    );
  }
}

class HeaderItem extends StatelessWidget {
  final NameValueModel header;
  final Map<String, dynamic> schema;

  const HeaderItem({
    super.key,
    required this.header,
    required this.schema,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRequired = schema['required'] == true;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              header.name,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              schema['description']?.toString() ?? '',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isRequired
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isRequired ? Icons.check : Icons.close,
                  size: 16,
                  color: isRequired ? Colors.green : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Responses Section
class ResponsesList extends StatelessWidget {
  final Map<String, dynamic> responses;

  const ResponsesList({super.key, required this.responses});

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
    final content = response['content'] as Map<String, dynamic>? ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                StatusCodeChip(statusCode: statusCode),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    description,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          if (content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content.entries.map((entry) => ContentTypeSection(
                  contentType: entry.key,
                  content: entry.value,
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class StatusCodeChip extends StatelessWidget {
  final String statusCode;

  const StatusCodeChip({super.key, required this.statusCode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
    );
  }
}

// Helper function examples (should be in a separate utils file)
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