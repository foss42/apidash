import 'package:apidash/models/api_catalog.dart';
import 'package:apidash/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';

class ApiCard extends ConsumerWidget {
  final ApiCatalogModel catalog;
  final ThemeData theme;

  const ApiCard({
    super.key,
    required this.catalog,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endpointCount = catalog.endpoints?.length;
    final methodCounts = catalog.methodCounts;
    final primaryMethod = methodCounts!.isNotEmpty 
        ? methodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'get';

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: _cardShape(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleTap(ref),
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 180,
            maxWidth: 300,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardHeader(theme: theme, endpointCount: endpointCount ?? 0),
                  const SizedBox(height: 12),
                  _CardTitle(theme: theme, name: catalog.name),
                  const SizedBox(height: 8),
                  _CardDescription(
                      theme: theme, description: catalog.description),
                ],
              ),
              if (endpointCount! > 0) ...[
                const SizedBox(height: 12),
                _MethodChip(
                  method: primaryMethod,
                  theme: theme,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  RoundedRectangleBorder _cardShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: theme.colorScheme.outline.withOpacity(0.2),
        width: 1,
      ),
    );
  }

  void _handleTap(WidgetRef ref) {
    ref.read(selectedEndpointIdProvider.notifier).state = null;
    ref.read(selectedCatalogIdProvider.notifier).state = catalog.id;
  }
}

// ... (Keep the remaining helper widget classes unchanged)

class _CardHeader extends StatelessWidget {
  final ThemeData theme;
  final int endpointCount;

  const _CardHeader({
    required this.theme,
    required this.endpointCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.api_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$endpointCount ${endpointCount == 1 ? 'Endpoint' : 'Endpoints'}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  final ThemeData theme;
  final String? name;

  const _CardTitle({
    required this.theme,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name ?? 'Unnamed API',
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _CardDescription extends StatelessWidget {
  final ThemeData theme;
  final String? description;

  const _CardDescription({
    required this.theme,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description ?? 'No description provided',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.8),
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _MethodChip extends StatelessWidget {
  final String method;
  final ThemeData theme;

  const _MethodChip({
    required this.method,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final color = getMethodColor(method);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        method.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}