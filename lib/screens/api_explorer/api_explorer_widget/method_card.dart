import 'package:apidash/screens/api_explorer/api_explorer_widget/api_explorer_detail_view.dart';
import 'package:apidash/utils/color_utils.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';

class MethodCard extends ConsumerWidget {
  final ApiExplorerModel endpoint;
  
  const MethodCard({super.key, required this.endpoint});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final method = endpoint.method.name;
    final color = getMethodColor(method);

    return Card(
      child: InkWell(
        onTap: () => _navigateToEndpointDetail(context, ref, endpoint),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildMethodBadge(context, method, color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      endpoint.name,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                endpoint.fullUrl,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'RobotoMono',
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodBadge(BuildContext context, String method, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        method.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _navigateToEndpointDetail(BuildContext context, WidgetRef ref, ApiExplorerModel endpoint) {
    ref.read(selectedEndpointIdProvider.notifier).state = endpoint.id;
    
    if (context.isMediumWindow) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ApiExplorerDetailView(
            api: endpoint,
            isMediumWindow: true,
            searchController: TextEditingController(),
          ),
        ),
      );
    }
  }
}