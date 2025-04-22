import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Main widget that composes all the documentation sections
class ApiDocumentationPane extends ConsumerWidget {
  const ApiDocumentationPane({
    super.key,
    this.endpoint,
    this.isStandalone = false,
  });

  final Map<String, dynamic>? endpoint;
  final bool isStandalone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedApi = endpoint;

    return Scaffold(
      appBar: isStandalone ? _buildAppBar(context) : null,
      body: selectedApi == null
          ? _EmptyStateWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _DocumentationContent(endpoint: selectedApi),
            ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('API Documentation'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareDocumentation(context),
        ),
      ],
    );
  }

  void _shareDocumentation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing documentation...')),
    );
  }
}

// Widget for showing empty state when no endpoint is selected
class _EmptyStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.api_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No endpoint selected',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Select an API endpoint to view documentation',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// Main content widget that organizes all documentation sections
class _DocumentationContent extends StatelessWidget {
  final Map<String, dynamic> endpoint;

  const _DocumentationContent({required this.endpoint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EndpointHeaderWidget(endpoint: endpoint),
        const SizedBox(height: 32),
        if (endpoint['description'] != null) ...[
          _DescriptionSection(description: endpoint['description']),
          const SizedBox(height: 32),
        ],
        if ((endpoint['parameters'] as List?)?.isNotEmpty ?? false) ...[
          _ParametersSection(parameters: endpoint['parameters']),
          const SizedBox(height: 32),
        ],
        if (endpoint['requestBody'] != null) ...[
          _RequestBodySection(requestBody: endpoint['requestBody']),
          const SizedBox(height: 32),
        ],
        if ((endpoint['headers'] as Map?)?.isNotEmpty ?? false) ...[
          _HeadersSection(headers: endpoint['headers']),
          const SizedBox(height: 32),
        ],
        if ((endpoint['responses'] as Map?)?.isNotEmpty ?? false) ...[
          _ResponsesSection(responses: endpoint['responses']),
        ],
      ],
    );
  }
}

// Widget for displaying the endpoint header section
class _EndpointHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> endpoint;

  const _EndpointHeaderWidget({required this.endpoint});

  @override
  Widget build(BuildContext context) {
    final method = (endpoint['method']?.toString() ?? 'GET').toUpperCase();
    final path = endpoint['path']?.toString() ?? '';
    final baseUrl = endpoint['baseUrl']?.toString() ?? '';
    final fullUrl = '$baseUrl$path';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _MethodChip(method: method),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                endpoint['name']?.toString() ?? 'Unnamed Endpoint',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _UrlDisplayWidget(url: fullUrl),
      ],
    );
  }
}

// Widget for displaying the method chip
class _MethodChip extends StatelessWidget {
  final String method;

  const _MethodChip({required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getMethodColor(method).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getMethodColor(method).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        method,
        style: TextStyle(
          color: _getMethodColor(method),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'GET': return Colors.green;
      case 'POST': return Colors.blue;
      case 'PUT': return Colors.orange;
      case 'DELETE': return Colors.red;
      case 'PATCH': return Colors.purple;
      default: return Colors.grey;
    }
  }
}

// Widget for displaying and copying the URL
class _UrlDisplayWidget extends StatelessWidget {
  final String url;

  const _UrlDisplayWidget({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SelectableText(
              url,
              style: const TextStyle(fontFamily: 'RobotoMono'),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.copy,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => _copyToClipboard(context, url),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}

// Widget for displaying a section header
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? count;

  const _SectionHeader({
    required this.icon,
    required this.title,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Widget for the description section
class _DescriptionSection extends StatelessWidget {
  final String description;

  const _DescriptionSection({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.description_outlined,
          title: 'Description',
        ),
        const SizedBox(height: 16),
        _DescriptionCard(description: description),
      ],
    );
  }
}

// Widget for the description card
class _DescriptionCard extends StatelessWidget {
  final String description;

  const _DescriptionCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
      ),
    );
  }
}

// Widget for the parameters section
class _ParametersSection extends StatelessWidget {
  final List<dynamic> parameters;

  const _ParametersSection({required this.parameters});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.tune_rounded,
          title: 'Parameters',
          count: parameters.length,
        ),
        const SizedBox(height: 16),
        _ParametersGrid(parameters: parameters),
      ],
    );
  }
}

// Widget for the parameters grid
class _ParametersGrid extends StatelessWidget {
  final List<dynamic> parameters;

  const _ParametersGrid({required this.parameters});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3,
        mainAxisSpacing: 12,
      ),
      itemCount: parameters.length,
      itemBuilder: (context, index) {
        return _ParameterCard(parameter: parameters[index]);
      },
    );
  }
}

// Widget for a single parameter card
class _ParameterCard extends StatelessWidget {
  final Map<String, dynamic> parameter;

  const _ParameterCard({required this.parameter});

  @override
  Widget build(BuildContext context) {
    final isRequired = parameter['required'] == true;
    final paramType = parameter['in']?.toString() ?? 'query';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    parameter['name']?.toString() ?? 'Parameter',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _ParamTypeChip(type: paramType),
                if (isRequired) const SizedBox(width: 8),
                if (isRequired) _RequiredChip(),
              ],
            ),
            const SizedBox(height: 8),
            if (parameter['description'] != null) ...[
              Text(
                parameter['description'].toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 12),
            ],
            _ParameterMetadata(parameter: parameter),
          ],
        ),
      ),
    );
  }
}

// Widget for parameter type chip
class _ParamTypeChip extends StatelessWidget {
  final String type;

  const _ParamTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(type),
      visualDensity: VisualDensity.compact,
      backgroundColor: _getParamTypeColor(type).withOpacity(0.1),
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: _getParamTypeColor(type),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Color _getParamTypeColor(String type) {
    switch (type) {
      case 'query': return Colors.blue;
      case 'path': return Colors.green;
      case 'header': return Colors.purple;
      case 'body': return Colors.orange;
      default: return Colors.grey;
    }
  }
}

// Widget for required chip
class _RequiredChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: const Text('Required'),
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.red.withOpacity(0.1),
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Colors.red,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// Widget for parameter metadata
class _ParameterMetadata extends StatelessWidget {
  final Map<String, dynamic> parameter;

  const _ParameterMetadata({required this.parameter});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (parameter['type'] != null)
          _MetadataChip(text: 'Type: ${parameter['type']}'),
        if (parameter['example'] != null)
          _MetadataChip(text: 'Example: ${parameter['example']}'),
        if (parameter['default'] != null)
          _MetadataChip(text: 'Default: ${parameter['default']}'),
      ],
    );
  }
}

// Widget for metadata chip
class _MetadataChip extends StatelessWidget {
  final String text;

  const _MetadataChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      visualDensity: VisualDensity.compact,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
      labelStyle: Theme.of(context).textTheme.labelSmall,
    );
  }
}

// Widget for request body section
class _RequestBodySection extends StatelessWidget {
  final Map<String, dynamic> requestBody;

  const _RequestBodySection({required this.requestBody});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.input_rounded,
          title: 'Request Body',
        ),
        const SizedBox(height: 16),
        _RequestBodyCard(requestBody: requestBody),
      ],
    );
  }
}

// Widget for request body card
class _RequestBodyCard extends StatelessWidget {
  final Map<String, dynamic> requestBody;

  const _RequestBodyCard({required this.requestBody});

  @override
  Widget build(BuildContext context) {
    final content = requestBody['content'] as Map<String, dynamic>? ?? {};
    final description = requestBody['description']?.toString();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Divider(height: 1),
          ],
          ...content.entries.map((entry) {
            return _ContentTypeSection(
              contentType: entry.key,
              content: entry.value,
            );
          }),
        ],
      ),
    );
  }
}

// Widget for content type section
class _ContentTypeSection extends StatelessWidget {
  final String contentType;
  final Map<String, dynamic> content;

  const _ContentTypeSection({
    required this.contentType,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final schema = content['schema'] as Map<String, dynamic>? ?? {};

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code_rounded, size: 20),
              const SizedBox(width: 8),
              Text(
                contentType,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SchemaDetails(schema: schema),
        ],
      ),
    );
  }
}

// Widget for schema details
class _SchemaDetails extends StatelessWidget {
  final Map<String, dynamic> schema;

  const _SchemaDetails({required this.schema});

  @override
  Widget build(BuildContext context) {
    if (schema['type'] == 'object' && schema['properties'] != null) {
      return _ObjectSchema(schema: schema);
    } else if (schema['type'] == 'array' && schema['items'] != null) {
      return _ArraySchema(schema: schema);
    } else {
      return _BasicSchema(schema: schema);
    }
  }
}

// Widget for object schema
class _ObjectSchema extends StatelessWidget {
  final Map<String, dynamic> schema;

  const _ObjectSchema({required this.schema});

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
          const SizedBox(height: 16),
        ],
        ...properties.entries.map((entry) {
          final isRequired = requiredFields.contains(entry.key);
          return _PropertyItem(
            name: entry.key,
            property: entry.value,
            isRequired: isRequired,
          );
        }),
      ],
    );
  }
}

// Widget for property item
class _PropertyItem extends StatelessWidget {
  final String name;
  final dynamic property;
  final bool isRequired;

  const _PropertyItem({
    required this.name,
    required this.property,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (isRequired) _RequiredChip(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Type: ${property['type'] ?? 'unknown'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (property['description'] != null) ...[
            const SizedBox(height: 8),
            Text(
              property['description'].toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Widget for array schema
class _ArraySchema extends StatelessWidget {
  final Map<String, dynamic> schema;

  const _ArraySchema({required this.schema});

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
          const SizedBox(height: 16),
        ],
        Text(
          'Array Items:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _SchemaDetails(schema: items),
        ),
      ],
    );
  }
}

// Widget for basic schema
class _BasicSchema extends StatelessWidget {
  final Map<String, dynamic> schema;

  const _BasicSchema({required this.schema});

  @override
  Widget build(BuildContext context) {
    final type = schema['type']?.toString() ?? 'unknown';
    final format = schema['format']?.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (schema['description'] != null) ...[
          Text(
            schema['description'].toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
        ],
        Wrap(
          spacing: 8,
          children: [
            _MetadataChip(text: 'Type: $type'),
            if (format != null) _MetadataChip(text: 'Format: $format'),
            if (schema['example'] != null)
              _MetadataChip(text: 'Example: ${schema['example']}'),
          ],
        ),
      ],
    );
  }
}

// Widget for headers section
class _HeadersSection extends StatelessWidget {
  final Map<String, dynamic> headers;

  const _HeadersSection({required this.headers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.list_alt_rounded,
          title: 'Headers',
          count: headers.length,
        ),
        const SizedBox(height: 16),
        _HeadersTable(headers: headers),
      ],
    );
  }
}

// Widget for headers table
class _HeadersTable extends StatelessWidget {
  final Map<String, dynamic> headers;

  const _HeadersTable({required this.headers});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
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
          ),
          // Table Rows
          ...headers.entries.map((entry) {
            final header = entry.value as Map<String, dynamic>;
            final isRequired = header['required'] == true;
            return _HeaderRow(
              name: entry.key,
              description: header['description']?.toString() ?? '',
              isRequired: isRequired,
            );
          }),
        ],
      ),
    );
  }
}

// Widget for a single header row
class _HeaderRow extends StatelessWidget {
  final String name;
  final String description;
  final bool isRequired;

  const _HeaderRow({
    required this.name,
    required this.description,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Icon(
                isRequired ? Icons.check_circle : Icons.cancel,
                color: isRequired ? Colors.green : Colors.grey,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for responses section
class _ResponsesSection extends StatelessWidget {
  final Map<String, dynamic> responses;

  const _ResponsesSection({required this.responses});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.assignment_returned_rounded,
          title: 'Responses',
          count: responses.length,
        ),
        const SizedBox(height: 16),
        Column(
          children: responses.entries.map((entry) {
            return _ResponseCard(
              statusCode: entry.key,
              response: entry.value,
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Widget for a single response card
class _ResponseCard extends StatelessWidget {
  final String statusCode;
  final Map<String, dynamic> response;

  const _ResponseCard({
    required this.statusCode,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final description = response['description']?.toString() ?? 'No description';
    final content = response['content'] as Map<String, dynamic>? ?? {};

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Code Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _getStatusCodeColor(statusCode).withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusCodeColor(statusCode).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusCode,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getStatusCodeColor(statusCode),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          // Response Content
          if (content.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content.entries.map((entry) {
                  return _ContentTypeSection(
                    contentType: entry.key,
                    content: entry.value,
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusCodeColor(String code) {
    final firstDigit = code.isNotEmpty ? code[0] : '0';
    switch (firstDigit) {
      case '2': return Colors.green;
      case '3': return Colors.blue;
      case '4': return Colors.orange;
      case '5': return Colors.red;
      default: return Colors.grey;
    }
  }
}