import 'package:apidash/models/api_explorer_models.dart';
import 'package:apidash/utils/color_utils.dart';
import 'package:apidash_core/consts.dart';
import 'package:code_builder/code_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

class ApiCard extends ConsumerWidget {
  final ApiCollection collection;
  final ThemeData theme;

  const ApiCard({
    super.key,
    required this.collection,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endpoints = collection.endpoints;

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
                  _CardHeader(
                      theme: theme,
                      endpointCount: endpoints?.length ?? 0),
                  const SizedBox(height: 12),
                  _CardTitle(theme: theme, name: collection.name),
                  const SizedBox(height: 8),
                  _CardDescription(
                      theme: theme, description: collection.description),
                ],
              ),
              if (endpoints != null && endpoints.isNotEmpty) ...[
                const SizedBox(height: 12),
                _MethodChips(theme: theme, endpoints: endpoints),
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
    ref.read(selectedCollectionIdProvider.notifier).state = collection.id;
  }
}

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
  final String name;

  const _CardTitle({
    required this.theme,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
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

class _MethodChips extends StatelessWidget {
  final ThemeData theme;
  final List<ApiEndpoint> endpoints;

  const _MethodChips({
    required this.theme,
    required this.endpoints,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: endpoints.length > 4 ? 4 : endpoints.length,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final method = endpoints[index].method;
          return _MethodChip(
            method: method,
            theme: theme,
          );
        },
      ),
    );
  }
}

class _MethodChip extends StatelessWidget {
  final HTTPVerb method;
  final ThemeData theme;

  const _MethodChip({
    required this.method,
    required this.theme,
  });
  @override
  Widget build(BuildContext context) {
    final color = getMethodColor(method.toString());

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
        method.name.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}