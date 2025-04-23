import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/utils/color_utils.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'api_explorer_action_buttons.dart';

class ApiExplorerURLCard extends StatelessWidget {
  const ApiExplorerURLCard({
    super.key,
    required this.endpoint,
  });

  final ApiEndpoint endpoint;

  @override
  Widget build(BuildContext context) {
    final method = endpoint.method.name.toUpperCase();
    final color = getMethodColor(method);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: kBorderRadius8,
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (endpoint.name.isNotEmpty) ...[
              Text(
                endpoint.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                  child: ReadOnlyTextField(
                    initialValue: '${endpoint.baseUrl}${endpoint.path}',
                    style: kCodeStyle.copyWith(
                      fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ApiExplorerActionButtons(endpoint: endpoint),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodBadge(String method, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: kBorderRadius4,
      ),
      child: Text(
        method,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}