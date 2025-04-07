import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../../utils/color_utils.dart';
import 'api_explorer_action_buttons.dart';

class ApiExplorerURLCard extends StatelessWidget {
  const ApiExplorerURLCard({
    super.key,
    required this.apiEndpoint,
  });

  final Map<String, dynamic>? apiEndpoint;

  @override
  Widget build(BuildContext context) {
    final method = apiEndpoint?['method']?.toString().toUpperCase() ?? 'GET';
    final path = apiEndpoint?['path']?.toString() ?? '';
    final baseUrl =
        apiEndpoint?['baseUrl']?.toString() ?? 'https://api.example.com';
    final name = apiEndpoint?['name']?.toString() ?? '';
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
            if (name.isNotEmpty) ...[
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getMethodColor(method).withOpacity(0.15),
                    borderRadius: kBorderRadius4,
                  ),
                  child: Text(
                    method,
                    style: TextStyle(
                      color: getMethodColor(method),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ReadOnlyTextField(
                    initialValue: '$baseUrl$path',
                    style: kCodeStyle.copyWith(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium?.fontSize,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ApiExplorerActionButtons(endpoint: apiEndpoint),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
