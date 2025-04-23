import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/api_explorer_models.dart';

class ApiDocumentationPane extends ConsumerWidget {
  const ApiDocumentationPane({
    super.key,
    required this.endpoint,
    this.isStandalone = false,
  });

  final ApiEndpoint endpoint;
  final bool isStandalone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: isStandalone ? _buildAppBar(context) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _DocumentationContent(endpoint: endpoint),
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

class _DocumentationContent extends StatelessWidget {
  final ApiEndpoint endpoint;

  const _DocumentationContent({required this.endpoint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EndpointHeaderWidget(endpoint: endpoint),
        const SizedBox(height: 32),
        if (endpoint.description != null) ...[
          _DescriptionSection(description: endpoint.description!),
          const SizedBox(height: 32),
        ],
        if (endpoint.parameters?.isNotEmpty ?? false) ...[
          _ParametersSection(parameters: endpoint.parameters!),
          const SizedBox(height: 32),
        ],
        if (endpoint.requestBody != null) ...[
          _RequestBodySection(requestBody: endpoint.requestBody!),
          const SizedBox(height: 32),
        ],
        if (endpoint.headers?.isNotEmpty ?? false) ...[
          _HeadersSection(headers: endpoint.headers!),
          const SizedBox(height: 32),
        ],
        if (endpoint.responses?.isNotEmpty ?? false) ...[
          _ResponsesSection(responses: endpoint.responses!),
        ],
      ],
    );
  }
}

class _EndpointHeaderWidget extends StatelessWidget {
  final ApiEndpoint endpoint;

  const _EndpointHeaderWidget({required this.endpoint});

  @override
  Widget build(BuildContext context) {
    final fullUrl = '${endpoint.baseUrl}${endpoint.path}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _MethodChip(method: endpoint.method.name.toUpperCase()),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                endpoint.name,
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

class _ParametersSection extends StatelessWidget {
  final List<ApiParameter> parameters;

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

class _ParametersGrid extends StatelessWidget {
  final List<ApiParameter> parameters;

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

class _ParameterCard extends StatelessWidget {
  final ApiParameter parameter;

  const _ParameterCard({required this.parameter});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    parameter.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _ParamTypeChip(type: parameter.inLocation),
                if (parameter.required) const SizedBox(width: 8),
                if (parameter.required) _RequiredChip(),
              ],
            ),
            const SizedBox(height: 8),
            if (parameter.description != null) ...[
              Text(
                parameter.description!,
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

class _ParameterMetadata extends StatelessWidget {
  final ApiParameter parameter;

  const _ParameterMetadata({required this.parameter});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (parameter.schema?.type != null)
          _MetadataChip(text: 'Type: ${parameter.schema!.type}'),
        if (parameter.example != null)
          _MetadataChip(text: 'Example: $parameter.example'),
      ],
    );
  }
}

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

class _RequestBodySection extends StatelessWidget {
  final ApiRequestBody requestBody;

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

class _RequestBodyCard extends StatelessWidget {
  final ApiRequestBody requestBody;

  const _RequestBodyCard({required this.requestBody});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (requestBody.description != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                requestBody.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Divider(height: 1),
          ],
          if (requestBody.content != null && requestBody.content!.isNotEmpty) ...[
            ...requestBody.content!.entries.map((entry) {
              return _ContentTypeSection(
                contentType: entry.key,
                content: entry.value,
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _ContentTypeSection extends StatelessWidget {
  final String contentType;
  final ApiContent content;

  const _ContentTypeSection({
    required this.contentType,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
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
          _SchemaDetails(schema: content.schema),
        ],
      ),
    );
  }
}

class _SchemaDetails extends StatelessWidget {
  final ApiSchema schema;

  const _SchemaDetails({required this.schema});

  @override
  Widget build(BuildContext context) {
    if (schema.type == 'object' && schema.properties != null) {
      return _ObjectSchema(schema: schema);
    } else if (schema.type == 'array' && schema.items != null) {
      return _ArraySchema(schema: schema);
    } else {
      return _BasicSchema(schema: schema);
    }
  }
}

class _ObjectSchema extends StatelessWidget {
  final ApiSchema schema;

  const _ObjectSchema({required this.schema});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (schema.description != null) ...[
          Text(
            schema.description!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
        ],
        ...schema.properties!.entries.map((entry) {
          return _PropertyItem(
            name: entry.key,
            property: entry.value,
          );
        }),
      ],
    );
  }
}

class _PropertyItem extends StatelessWidget {
  final String name;
  final ApiSchema property;

  const _PropertyItem({
    required this.name,
    required this.property,
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
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Type: ${property.type ?? 'unknown'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (property.description != null) ...[
            const SizedBox(height: 8),
            Text(
              property.description!,
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

class _ArraySchema extends StatelessWidget {
  final ApiSchema schema;

  const _ArraySchema({required this.schema});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (schema.description != null) ...[
          Text(
            schema.description!,
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
          child: _SchemaDetails(schema: schema.items!),
        ),
      ],
    );
  }
}

class _BasicSchema extends StatelessWidget {
  final ApiSchema schema;

  const _BasicSchema({required this.schema});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (schema.description != null) ...[
          Text(
            schema.description!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
        ],
        Wrap(
          spacing: 8,
          children: [
            _MetadataChip(text: 'Type: ${schema.type}'),
            if (schema.format != null) _MetadataChip(text: 'Format: ${schema.format}'),
            if (schema.example != null) _MetadataChip(text: 'Example: ${schema.example}'),
          ],
        ),
      ],
    );
  }
}

class _HeadersSection extends StatelessWidget {
  final Map<String, ApiHeader> headers;

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

class _HeadersTable extends StatelessWidget {
  final Map<String, ApiHeader> headers;

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
            return _HeaderRow(
              name: entry.key,
              description: entry.value.description ?? '',
              isRequired: entry.value.required,
            );
          }),
        ],
      ),
    );
  }
}

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

class _ResponsesSection extends StatelessWidget {
  final Map<String, ApiResponse> responses;

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

class _ResponseCard extends StatelessWidget {
  final String statusCode;
  final ApiResponse response;

  const _ResponseCard({
    required this.statusCode,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
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
                    response.description ?? 'No description',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          // Response Content
          if (response.content != null && response.content!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: response.content!.entries.map((entry) {
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