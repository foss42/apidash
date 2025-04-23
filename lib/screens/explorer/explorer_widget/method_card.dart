import 'package:apidash/screens/explorer/explorer_widget/api_explorer_detail_view.dart';
import 'package:apidash/utils/color_utils.dart';
import 'package:apidash_core/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/api_explorer_models.dart';

class MethodCard extends ConsumerWidget {
  final ApiEndpoint endpoint;
  
  const MethodCard({
    super.key, 
    required this.endpoint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = getMethodColor(endpoint.method.name.toUpperCase());

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleEndpointTap(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildMethodBadge(method: endpoint.method, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      endpoint.name,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${endpoint.baseUrl}${endpoint.path}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'RobotoMono',
                  color: theme.colorScheme.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodBadge({
    required HTTPVerb method,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        method.name.toUpperCase(),
        // style: Theme.of(context).textTheme.labelMedium?.copyWith(
        //   color: color,
        //   fontWeight: FontWeight.w600,
        // ),
      ),
    );
  }

  void _handleEndpointTap(BuildContext context, WidgetRef ref) {
    ref.read(selectedEndpointIdProvider.notifier).state = endpoint.id;
    
    if (context.isMediumWindow) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ApiExplorerDetailView(
            endpoint: endpoint,
            isMediumWindow: true,
          ),
        ),
      );
    }
  }
}