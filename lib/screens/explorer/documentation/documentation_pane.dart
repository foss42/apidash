import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/consts.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'dart:convert';

class ApiDocumentationPage extends StatelessWidget {
  final ApiEndpoint endpoint;

  const ApiDocumentationPage({super.key, required this.endpoint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(endpoint.name),
            pinned: true,
            floating: true,
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: _EndpointOverview(endpoint: endpoint),
            ),
          ),
          if (endpoint.description != null)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: _DocumentationSection(
                  title: 'Description',
                  child: Text(
                    endpoint.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          if (endpoint.parameters?.isNotEmpty ?? false)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: _DocumentationSection(
                  title: 'Parameters',
                  child: _ParameterTable(parameters: endpoint.parameters!),
                ),
              ),
            ),
          if (endpoint.requestBody != null)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: _DocumentationSection(
                  title: 'Request Body',
                  child: _RequestBodySection(requestBody: endpoint.requestBody!),
                ),
              ),
            ),
          if (endpoint.headers?.isNotEmpty ?? false)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: _DocumentationSection(
                  title: 'Headers',
                  child: _HeaderTable(headers: endpoint.headers!),
                ),
              ),
            ),
          if (endpoint.responses?.isNotEmpty ?? false)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: _DocumentationSection(
                  title: 'Responses',
                  child: _ResponseExamples(responses: endpoint.responses!),
                ),
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
      
    );
  }

  void _tryApi(BuildContext context) {
    
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

class _EndpointOverview extends StatelessWidget {
  final ApiEndpoint endpoint;

  const _EndpointOverview({required this.endpoint});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _MethodBadge(method: endpoint.method),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    endpoint.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Endpoint URL',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.outline.withOpacity(0.1)),
              ),
              child: SelectableText(
                '${endpoint.baseUrl}${endpoint.path}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'RobotoMono',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodBadge extends StatelessWidget {
  final HTTPVerb method;

  const _MethodBadge({required this.method});

  @override
  Widget build(BuildContext context) {
    final color = _getMethodColor(method);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
      child: Text(
        method.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getMethodColor(HTTPVerb method) {
    switch (method) {
      case HTTPVerb.get: return const Color(0xFF10B981); // Green
      case HTTPVerb.post: return const Color(0xFF3B82F6); // Blue
      case HTTPVerb.put: return const Color(0xFFF59E0B); // Amber
      case HTTPVerb.delete: return const Color(0xFFEF4444); // Red
      case HTTPVerb.patch: return const Color(0xFF8B5CF6); // Purple
      case HTTPVerb.head: return const Color(0xFF06B6D4); // Cyan
      default: return const Color(0xFF6B7280); // Gray
    }
  }
}

class _DocumentationSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DocumentationSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _ParameterTable extends StatelessWidget {
  final List<ApiParameter> parameters;

  const _ParameterTable({required this.parameters});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outline.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            horizontalMargin: 16,
            dividerThickness: 1,
            dataRowMinHeight: 48,
            dataRowMaxHeight: 72,
            columns: [
              DataColumn(
                label: Text('Name', style: _headerTextStyle(theme)),
              ),
              DataColumn(
                label: Text('Location', style: _headerTextStyle(theme)),
              ),
              DataColumn(
                label: Text('Required', style: _headerTextStyle(theme)),
              ),
              DataColumn(
                label: Text('Type', style: _headerTextStyle(theme)),
              ),
              DataColumn(
                label: Text('Description', style: _headerTextStyle(theme)),
              ),
            ],
            rows: parameters.map((param) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(param.name, style: _cellTextStyle(theme, true))),
                  DataCell(_ParameterLocation(location: param.inLocation)),
                  DataCell(
                    param.required
                        ? const Icon(Icons.check, size: 18, color: Colors.green)
                        : const Icon(Icons.close, size: 18, color: Colors.grey),
                  ),
                  DataCell(
                    Text(param.schema?.type ?? 'string',
                        style: _cellTextStyle(theme, true)),
                  ),
                  DataCell(
                    Text(param.description ?? '-',
                        style: _cellTextStyle(theme, false)),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  TextStyle _headerTextStyle(ThemeData theme) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withOpacity(0.7),
    );
  }

  TextStyle _cellTextStyle(ThemeData theme, bool monospace) {
    return TextStyle(
      fontFamily: monospace ? 'RobotoMono' : null,
      color: theme.colorScheme.onSurface,
    );
  }
}

class _ParameterLocation extends StatelessWidget {
  final String location;

  const _ParameterLocation({required this.location});

  @override
  Widget build(BuildContext context) {
    final color = _getLocationColor(location);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        location.toLowerCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getLocationColor(String location) {
    switch (location.toLowerCase()) {
      case 'query': return const Color(0xFF3B82F6); // Blue
      case 'path': return const Color(0xFF10B981); // Green
      case 'header': return const Color(0xFF8B5CF6); // Purple
      case 'body': return const Color(0xFFF59E0B); // Amber
      default: return const Color(0xFF6B7280); // Gray
    }
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
        if (requestBody.description != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              requestBody.description!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ...requestBody.content.entries.map(
          (entry) => _ContentTypeCard(
            contentType: entry.key,
            content: entry.value,
          ),
        ),
      ],
    );
  }
}

class _ContentTypeCard extends StatelessWidget {
  final String contentType;
  final ApiContent content;

  const _ContentTypeCard({
    required this.contentType,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          contentType,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _SchemaView(schema: content.schema),
          ),
        ],
      ),
    );
  }
}

class _SchemaView extends StatelessWidget {
  final ApiSchema schema;

  const _SchemaView({required this.schema});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (schema.description != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              schema.description!,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (schema.type != null)
              _PropertyChip(label: 'Type: ${schema.type}'),
            if (schema.format != null)
              _PropertyChip(label: 'Format: ${schema.format}'),
          ],
        ),
        if (schema.example != null) ...[
          const SizedBox(height: 16),
          _CodeBlock(code: schema.example!),
        ],
        if (schema.properties != null) ...[
          const SizedBox(height: 16),
          Text(
            'Properties',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _PropertiesTable(properties: schema.properties!),
        ],
      ],
    );
  }
}

class _PropertyChip extends StatelessWidget {
  final String label;

  const _PropertyChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SelectableText(
        _formatJson(code),
        style: const TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 13,
        ),
      ),
    );
  }

  String _formatJson(String jsonString) {
    try {
      final parsed = jsonDecode(jsonString);
      return JsonEncoder.withIndent('  ').convert(parsed);
    } catch (e) {
      return jsonString;
    }
  }
}

class _PropertiesTable extends StatelessWidget {
  final Map<String, ApiSchema> properties;

  const _PropertiesTable({required this.properties});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outline.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(3),
          },
          border: TableBorder(
            horizontalInside: BorderSide(
              color: colors.outline.withOpacity(0.1),
            ),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: colors.surfaceVariant.withOpacity(0.3),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Type',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            ...properties.entries.map((entry) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      entry.value.type ?? 'unknown',
                      style: const TextStyle(fontFamily: 'RobotoMono'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      entry.value.description ?? '-',
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _HeaderTable extends StatelessWidget {
  final Map<String, ApiHeader> headers;

  const _HeaderTable({required this.headers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outline.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            horizontalMargin: 16,
            dividerThickness: 1,
            dataRowMinHeight: 48,
            columns: [
              DataColumn(
                label: Text('Header', style: _headerTextStyle(theme)),
              ),
              DataColumn(
                label: Text('Required', style: _headerTextStyle(theme)),
              ),
              DataColumn(
                label: Text('Type', style: _headerTextStyle(theme)),
              ),
              DataColumn(
                label: Text('Example', style: _headerTextStyle(theme)),
              ),
            ],
            rows: headers.entries.map((entry) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(entry.key, style: _cellTextStyle(theme, true))),
                  DataCell(
                    entry.value.required
                        ? const Icon(Icons.check, size: 18, color: Colors.green)
                        : const Icon(Icons.close, size: 18, color: Colors.grey),
                  ),
                  DataCell(
                    Text(entry.value.schema?.type ?? 'string',
                        style: _cellTextStyle(theme, true)),
                  ),
                  DataCell(
                    Text(entry.value.example ?? entry.value.schema?.example ?? '-',
                        style: _cellTextStyle(theme, true)),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  TextStyle _headerTextStyle(ThemeData theme) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withOpacity(0.7),
    );
  }

  TextStyle _cellTextStyle(ThemeData theme, bool monospace) {
    return TextStyle(
      fontFamily: monospace ? 'RobotoMono' : null,
      color: theme.colorScheme.onSurface,
    );
  }
}

class _ResponseExamples extends StatelessWidget {
  final Map<String, ApiResponse> responses;

  const _ResponseExamples({required this.responses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: responses.entries.map((entry) {
        return _ResponseExample(
          statusCode: entry.key,
          response: entry.value,
        );
      }).toList(),
    );
  }
}

class _ResponseExample extends StatelessWidget {
  final String statusCode;
  final ApiResponse response;

  const _ResponseExample({
    required this.statusCode,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colors.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(statusCode).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _getStatusColor(statusCode),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  statusCode,
                  style: TextStyle(
                    color: _getStatusColor(statusCode),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            title: Text(
              _getStatusMessage(statusCode),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: response.description != null
                ? Text(response.description!)
                : null,
          ),
          if (response.content?.isNotEmpty ?? false)
            ...response.content!.entries.map(
              (entry) => _ResponseContent(
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
      case '2': return const Color(0xFF10B981); // Green
      case '3': return const Color(0xFF06B6D4); // Cyan
      case '4': return const Color(0xFFF59E0B); // Amber
      case '5': return const Color(0xFFEF4444); // Red
      default: return const Color(0xFF6B7280); // Gray
    }
  }

  String _getStatusMessage(String code) {
    switch (code) {
      case '200': return 'OK - Successful operation';
      case '201': return 'Created - Resource created';
      case '204': return 'No Content - Success with no body';
      case '400': return 'Bad Request - Invalid request';
      case '401': return 'Unauthorized - Authentication required';
      case '403': return 'Forbidden - Permission denied';
      case '404': return 'Not Found - Resource not found';
      case '500': return 'Internal Server Error - Server error';
      default: return 'HTTP Status $code';
    }
  }
}

class _ResponseContent extends StatelessWidget {
  final String contentType;
  final ApiContent content;

  const _ResponseContent({
    required this.contentType,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contentType,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (content.schema.example != null)
            _CodeBlock(code: content.schema.example!),
          if (content.schema.properties != null)
            _SchemaView(schema: content.schema),
        ],
      ),
    );
  }
}