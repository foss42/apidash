import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../utils/utils.dart';

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
      appBar: isStandalone
          ? AppBar(
              title: Text(selectedApi['name']?.toString() ?? 'API Documentation'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRequestHeader(context, selectedApi),
            const SizedBox(height: 28),
            
            if (selectedApi['description'] != null) ...[
              _buildSectionTitle(context, 'Description', Icons.description),
              const SizedBox(height: 12),
              _buildDescription(context, selectedApi['description'].toString()),
              const SizedBox(height: 28),
            ],

            if ((selectedApi['parameters'] as List?)?.isNotEmpty ?? false) ...[
              _buildSectionTitle(context, 'Parameters', Icons.tune),
              const SizedBox(height: 12),
              _buildParametersList(context, selectedApi['parameters']),
              const SizedBox(height: 28),
            ],

            if (selectedApi['requestBody'] != null) ...[
              _buildSectionTitle(context, 'Request Body', Icons.input),
              const SizedBox(height: 12),
              _buildRequestBody(context, selectedApi['requestBody']),
              const SizedBox(height: 28),
            ],

            if ((selectedApi['headers'] as Map?)?.isNotEmpty ?? false) ...[
              _buildSectionTitle(context, 'Headers', Icons.list_alt),
              const SizedBox(height: 12),
              _buildHeadersList(context, selectedApi['headers']),
              const SizedBox(height: 28),
            ],

            if ((selectedApi['responses'] as Map?)?.isNotEmpty ?? false) ...[
              _buildSectionTitle(context, 'Responses', Icons.assignment_returned),
              const SizedBox(height: 12),
              _buildResponsesList(context, selectedApi['responses']),
              const SizedBox(height: 28),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRequestHeader(BuildContext context, Map<String, dynamic> endpoint) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final method = (endpoint['method']?.toString() ?? 'GET').toUpperCase();
    final path = endpoint['path']?.toString() ?? '';
    final baseUrl = endpoint['baseUrl']?.toString() ?? '';

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
                endpoint['name']?.toString() ?? 'Unnamed Endpoint',
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
            color: colors.surfaceVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(
                  '$baseUrl$path',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontFamily: 'RobotoMono',
                    color: colors.onSurface,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, size: 20, color: colors.primary),
                onPressed: () => _copyToClipboard(context, '$baseUrl$path'),
                tooltip: 'Copy URL',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
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
    );
  }

  Widget _buildDescription(BuildContext context, String description) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
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

  Widget _buildParametersList(BuildContext context, List<dynamic> parameters) {
    return Column(
      children: parameters.map((param) => _buildParameterItem(context, param)).toList(),
    );
  }

  Widget _buildParameterItem(BuildContext context, Map<String, dynamic> param) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isRequired = param['required'] == true;
    final inType = param['in']?.toString() ?? 'query';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  param['name']?.toString() ?? 'Parameter',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getParamTypeColor(inType).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _getParamTypeColor(inType).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  inType,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getParamTypeColor(inType),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    'required',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (param['description'] != null) ...[
            const SizedBox(height: 12),
            Text(
              param['description'].toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ],
          if (param['type'] != null || param['example'] != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (param['type'] != null)
                  _buildDetailChip(context, 'Type: ${param['type']}'),
                if (param['example'] != null)
                  _buildDetailChip(context, 'Example: ${param['example']}'),
                if (param['default'] != null)
                  _buildDetailChip(context, 'Default: ${param['default']}'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequestBody(BuildContext context, Map<String, dynamic> requestBody) {
    final content = requestBody['content'] as Map<String, dynamic>? ?? {};
    final description = requestBody['description']?.toString();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null) ...[
          _buildDescription(context, description),
          const SizedBox(height: 16),
        ],
        
        for (final entry in content.entries)
          _buildContentTypeSection(context, entry.key, entry.value),
      ],
    );
  }

  Widget _buildContentTypeSection(BuildContext context, String contentType, dynamic content) {
    final theme = Theme.of(context);
    final schema = content['schema'] as Map<String, dynamic>? ?? {};
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
        ),
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
            child: _buildSchemaDetails(context, schema),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemaDetails(BuildContext context, Map<String, dynamic> schema) {
    if (schema['type'] == 'object' && schema['properties'] != null) {
      return _buildObjectSchema(context, schema);
    } else if (schema['type'] == 'array' && schema['items'] != null) {
      return _buildArraySchema(context, schema);
    } else {
      return _buildBasicSchema(context, schema);
    }
  }

  Widget _buildObjectSchema(BuildContext context, Map<String, dynamic> schema) {
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
        ...properties.entries.map((entry) {
          final isRequired = requiredFields.contains(entry.key);
          return _buildPropertyItem(context, entry.key, entry.value, isRequired);
        }),
      ],
    );
  }

  Widget _buildPropertyItem(BuildContext context, String name, dynamic property, bool isRequired) {
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
              if (isRequired)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'required',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
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

  Widget _buildArraySchema(BuildContext context, Map<String, dynamic> schema) {
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
          child: _buildSchemaDetails(context, items),
        ),
      ],
    );
  }

  Widget _buildBasicSchema(BuildContext context, Map<String, dynamic> schema) {
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
            _buildDetailChip(context, 'Type: $type'),
            if (format != null) _buildDetailChip(context, 'Format: $format'),
            if (schema['enum'] != null)
              _buildDetailChip(context, 'Enum: ${schema['enum'].join(', ')}'),
          ],
        ),
      ],
    );
  }

  Widget _buildHeadersList(BuildContext context, Map<String, dynamic> headers) {
    final theme = Theme.of(context);
    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withOpacity(0.1),
                ),
              ),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Header', style: TextStyle(fontWeight: FontWeight.w600))),
                Expanded(flex: 3, child: Text('Description', style: TextStyle(fontWeight: FontWeight.w600))),
                Expanded(flex: 1, child: Center(child: Text('Required', style: TextStyle(fontWeight: FontWeight.w600)))),
              ],
            ),
          ),
          ...headers.entries.map((entry) {
            final header = entry.value as Map<String, dynamic>;
            final isRequired = header['required'] == true;
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
                      entry.key,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      header['description']?.toString() ?? '',
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
          }),
        ],
      ),
    );
  }

  Widget _buildResponsesList(BuildContext context, Map<String, dynamic> responses) {
    return Column(
      children: responses.entries.map((entry) {
        return _buildResponseItem(context, entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildResponseItem(BuildContext context, String statusCode, dynamic response) {
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
              color: _getStatusCodeColor(statusCode).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusCodeColor(statusCode).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusCode,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getStatusCodeColor(statusCode),
                    ),
                  ),
                ),
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
                children: content.entries.map((entry) {
                  return _buildContentTypeSection(context, entry.key, entry.value);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
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

  Color _getParamTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'path':
        return const Color(0xFFEF6C00);
      case 'query':
        return const Color(0xFF0277BD);
      case 'header':
        return const Color(0xFF7B1FA2);
      case 'body':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF424242);
    }
  }

  Color _getStatusCodeColor(String statusCode) {
    final code = int.tryParse(statusCode) ?? 0;
    if (code >= 200 && code < 300) return Colors.green;
    if (code >= 300 && code < 400) return Colors.blue;
    if (code >= 400 && code < 500) return Colors.orange;
    if (code >= 500) return Colors.red;
    return Colors.grey;
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}