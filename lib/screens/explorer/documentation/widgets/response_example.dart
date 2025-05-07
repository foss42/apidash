import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'response_content.dart';

class ResponseExample extends StatelessWidget {
  final String statusCode;
  final ApiResponse response;

  const ResponseExample({
    super.key,
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
              (entry) => ResponseContent(
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
      case '2': return const Color(0xFF10B981);
      case '3': return const Color(0xFF06B6D4);
      case '4': return const Color(0xFFF59E0B);
      case '5': return const Color(0xFFEF4444);
      default: return const Color(0xFF6B7280);
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