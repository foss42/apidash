import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/consts.dart';
import 'package:apidash/models/api_explorer_models.dart';

class ApiDocumentationView extends ConsumerWidget {
  const ApiDocumentationView({
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
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _EndpointHeader(endpoint: endpoint),
                      const SizedBox(height: 32),
                      if (endpoint.description != null)
                        _DocumentationSection(
                          title: 'Description',
                          child: Text(
                            endpoint.description!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                    ]),
                  ),
                ),
                if (endpoint.parameters?.isNotEmpty ?? false)
                  _SectionSliver(
                    title: 'Parameters',
                    count: endpoint.parameters!.length,
                    child: _ParametersList(parameters: endpoint.parameters!),
                  ),
                if (endpoint.requestBody != null)
                  _SectionSliver(
                    title: 'Request Body',
                    child: _RequestBodyView(requestBody: endpoint.requestBody!),
                  ),
                if (endpoint.headers?.isNotEmpty ?? false)
                  _SectionSliver(
                    title: 'Headers',
                    count: endpoint.headers!.length,
                    child: _HeadersList(headers: endpoint.headers!),
                  ),
                if (endpoint.responses?.isNotEmpty ?? false)
                  _SectionSliver(
                    title: 'Responses',
                    count: endpoint.responses!.length,
                    child: _ResponsesView(responses: endpoint.responses!),
                  ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            ),
          ),
          if (isStandalone)
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () => _tryApi(context),
                child: const Text('Try this API'),
              ),
            ),
        ],
      ),
    );
  }

  void _tryApi(BuildContext context) {
    // Implement API testing functionality
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApiTesterView(endpoint: endpoint),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(endpoint.name),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareEndpoint(context),
          tooltip: 'Share endpoint',
        ),
      ],
    );
  }

  void _shareEndpoint(BuildContext context) {
    // Implement share functionality
    final url = '${endpoint.baseUrl}${endpoint.path}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard: $url')),
    );
  }
}

// Helper widget for endpoint header
class _EndpointHeader extends StatelessWidget {
  const _EndpointHeader({required this.endpoint});

  final ApiEndpoint endpoint;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _MethodChip(method: endpoint.method),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    endpoint.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Endpoint URL',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              '${endpoint.baseUrl}${endpoint.path}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'RobotoMono',
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// HTTP Method visual indicator
class _MethodChip extends StatelessWidget {
  const _MethodChip({required this.method});

  final HTTPVerb method;

  @override
  Widget build(BuildContext context) {
    final color = _getMethodColor(method);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        method.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getMethodColor(HTTPVerb method) {
    switch (method) {
      case HTTPVerb.get:
        return Colors.green;
      case HTTPVerb.post:
        return Colors.blue;
      case HTTPVerb.put:
        return Colors.orange;
      case HTTPVerb.delete:
        return Colors.red;
      case HTTPVerb.patch:
        return Colors.purple;
      case HTTPVerb.head:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

// Section wrapper with title and count
class _SectionSliver extends StatelessWidget {
  const _SectionSliver({
    required this.title,
    this.count,
    required this.child,
  });

  final String title;
  final int? count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 16),
          _DocumentationSection(
            title: title,
            count: count,
            child: child,
          ),
        ]),
      ),
    );
  }
}

// Documentation section layout
class _DocumentationSection extends StatelessWidget {
  const _DocumentationSection({
    required this.title,
    this.count,
    required this.child,
  });

  final String title;
  final int? count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

// Parameters list view
class _ParametersList extends StatelessWidget {
  const _ParametersList({required this.parameters});

  final List<ApiParameter> parameters;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: parameters.length,
      itemBuilder: (context, index) {
        final param = parameters[index];
        return _ParameterItem(parameter: param);
      },
    );
  }
}

// Single parameter item
class _ParameterItem extends StatelessWidget {
  const _ParameterItem({required this.parameter});

  final ApiParameter parameter;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    parameter.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _ParameterBadge(location: parameter.inLocation),
                if (parameter.required)
                  const SizedBox(width: 8),
                if (parameter.required)
                  const Chip(
                    label: Text('Required'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
            if (parameter.description != null) ...[
              const SizedBox(height: 8),
              Text(
                parameter.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (parameter.schema != null) ...[
              const SizedBox(height: 8),
              _SchemaView(schema: parameter.schema!),
            ],
          ],
        ),
      ),
    );
  }
}

// Parameter location badge
class _ParameterBadge extends StatelessWidget {
  const _ParameterBadge({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final color = _getLocationColor(location);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        location,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getLocationColor(String location) {
    switch (location.toLowerCase()) {
      case 'query':
        return Colors.blue;
      case 'path':
        return Colors.green;
      case 'header':
        return Colors.purple;
      case 'body':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

// Schema documentation view
class _SchemaView extends StatelessWidget {
  const _SchemaView({required this.schema});

  final ApiSchema schema;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (schema.type != null)
            Text(
              'Type: ${schema.type}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (schema.format != null)
            Text(
              'Format: ${schema.format}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (schema.description != null)
            Text(
              'Description: ${schema.description}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (schema.example != null)
            Text(
              'Example: ${schema.example}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (schema.properties != null) ...[
            const SizedBox(height: 8),
            Text(
              'Properties:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ...schema.properties!.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text(
                  '${entry.key}: ${entry.value.type ?? 'unknown'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Request body documentation
class _RequestBodyView extends StatelessWidget {
  const _RequestBodyView({required this.requestBody});

  final ApiRequestBody requestBody;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          if (requestBody.description != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                requestBody.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          if (requestBody.content.isNotEmpty)
            ...requestBody.content.entries.map(
              (entry) => _ContentTypeSection(
                contentType: entry.key,
                content: entry.value,
              ),
            ),
        ],
      ),
    );
  }
}

// Content type section (expandable)
class _ContentTypeSection extends StatelessWidget {
  const _ContentTypeSection({
    required this.contentType,
    required this.content,
  });

  final String contentType;
  final ApiContent content;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(contentType),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: _SchemaView(schema: content.schema),
        ),
      ],
    );
  }
}

// Headers list view
class _HeadersList extends StatelessWidget {
  const _HeadersList({required this.headers});

  final Map<String, ApiHeader> headers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: headers.length,
      itemBuilder: (context, index) {
        final entry = headers.entries.elementAt(index);
        return _HeaderItem(
          name: entry.key,
          header: entry.value,
        );
      },
    );
  }
}

// Single header item
class _HeaderItem extends StatelessWidget {
  const _HeaderItem({
    required this.name,
    required this.header,
  });

  final String name;
  final ApiHeader header;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Chip(
                  label: Text(header.required ? 'Required' : 'Optional'),
                  backgroundColor: header.required
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: header.required ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            if (header.description != null) ...[
              const SizedBox(height: 8),
              Text(
                header.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (header.schema != null) ...[
              const SizedBox(height: 8),
              _SchemaView(schema: header.schema!),
            ],
          ],
        ),
      ),
    );
  }
}

// Responses list view
class _ResponsesView extends StatelessWidget {
  const _ResponsesView({required this.responses});

  final Map<String, ApiResponse> responses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: responses.length,
      itemBuilder: (context, index) {
        final entry = responses.entries.elementAt(index);
        return _ResponseItem(
          statusCode: entry.key,
          response: entry.value,
        );
      },
    );
  }
}

// Single response item
class _ResponseItem extends StatelessWidget {
  const _ResponseItem({
    required this.statusCode,
    required this.response,
  });

  final String statusCode;
  final ApiResponse response;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(statusCode).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                statusCode,
                style: TextStyle(
                  color: _getStatusColor(statusCode),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              response.description ?? 'No description',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          if (response.content?.isNotEmpty ?? false)
            ...response.content!.entries.map(
              (entry) => _ContentTypeSection(
                contentType: entry.key,
                content: entry.value,
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String code) {
    final firstDigit = code.isNotEmpty ? code[0] : '0';
    switch (firstDigit) {
      case '2':
        return Colors.green;
      case '3':
        return Colors.blue;
      case '4':
        return Colors.orange;
      case '5':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// API Tester View (placeholder)
class ApiTesterView extends StatelessWidget {
  final ApiEndpoint endpoint;

  const ApiTesterView({super.key, required this.endpoint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test ${endpoint.name}'),
      ),
      body: Center(
        child: Text('API Testing functionality for ${endpoint.method.name} ${endpoint.path}'),
      ),
    );
  }
}