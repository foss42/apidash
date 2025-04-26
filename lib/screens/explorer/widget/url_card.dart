import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'package:apidash/utils/color_utils.dart';
import 'package:flutter/services.dart';

class ApiExplorerURLCard extends StatelessWidget {
  const ApiExplorerURLCard({
    super.key,
    required this.endpoint,
  });

  final ApiEndpoint endpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final method = endpoint.method.name.toUpperCase();
    final color = getMethodColor(method);
    final fullUrl = '${endpoint.baseUrl}${endpoint.path}';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: colors.outlineVariant,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _copyToClipboard(context, fullUrl),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (endpoint.name.isNotEmpty) ...[
                Text(
                  endpoint.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  _buildMethodBadge(method, color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      fullUrl,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'RobotoMono',
                        color: colors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, size: 18),
                    onPressed: () => _copyToClipboard(context, fullUrl),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Copy URL',
                  ),
                  IconButton(
                    icon: Icon(Icons.rocket_launch, size: 18),
                    onPressed: () => _handleTryNow(context),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Try Now',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodBadge(String method, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        method,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('URL copied to clipboard'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _handleTryNow(BuildContext context) {
    // Implement your "Try Now" functionality here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Importing endpoint...'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}