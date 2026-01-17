import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/services/auth_resolution_service.dart';
import '../../../../common_widgets/common_widgets.dart';

class EditAuthType extends ConsumerWidget {
  final bool readOnly;

  const EditAuthType({
    super.key,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequest = ref.watch(selectedRequestModelProvider);
    if (selectedRequest == null) {
      return const SizedBox.shrink();
    }

    final requestAuth = selectedRequest.httpRequestModel?.authModel;
    final hasRequestAuth =
        requestAuth != null && requestAuth.type != APIAuthType.none;

    // Get resolved auth to determine inheritance source
    final activeEnvironmentId = ref.watch(activeEnvironmentIdStateProvider);
    final environments = ref.watch(environmentsStateNotifierProvider);
    final resolvedAuth = resolveAuth(
      selectedRequest,
      activeEnvironmentId,
      environments,
    );

    // Determine inheritance source
    String? inheritanceSource;
    if (!hasRequestAuth && resolvedAuth != null) {
      if (activeEnvironmentId != null &&
          environments?[activeEnvironmentId]?.authModel != null &&
          environments![activeEnvironmentId]!.authModel!.type !=
              APIAuthType.none) {
        final envName = environments[activeEnvironmentId]?.name ?? 'Environment';
        inheritanceSource = '$envName Environment';
      } else if (environments?[kGlobalEnvironmentId]?.authModel != null &&
          environments![kGlobalEnvironmentId]!.authModel!.type !=
              APIAuthType.none) {
        inheritanceSource = 'Global';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (inheritanceSource != null && !hasRequestAuth)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Inherited from: $inheritanceSource',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (!readOnly)
                  TextButton(
                    onPressed: () {
                      // Override with request-level auth
                      ref.read(collectionStateNotifierProvider.notifier).update(
                            authModel: resolvedAuth,
                          );
                    },
                    child: const Text('Override'),
                  ),
              ],
            ),
          ),
        if (hasRequestAuth && inheritanceSource != null)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Overridden',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                if (!readOnly)
                  TextButton(
                    onPressed: () {
                      // Clear request-level auth to use inherited
                      ref.read(collectionStateNotifierProvider.notifier).update(
                            authModel: AuthModel(type: APIAuthType.none),
                          );
                    },
                    child: const Text('Use Inherited'),
                  ),
              ],
            ),
          ),
        AuthPage(
          authModel: hasRequestAuth ? requestAuth : resolvedAuth,
          readOnly: readOnly,
          onChangedAuthType: (newType) {
            final selectedRequest = ref.read(selectedRequestModelProvider);
            if (newType != null) {
              ref.read(collectionStateNotifierProvider.notifier).update(
                    authModel: selectedRequest?.httpRequestModel?.authModel
                            ?.copyWith(type: newType) ??
                        AuthModel(type: newType),
                  );
            }
          },
          updateAuthData: (model) {
            if (model == null) {
              ref.read(collectionStateNotifierProvider.notifier).update(
                    authModel: AuthModel(type: APIAuthType.none),
                  );
            } else {
              ref.read(collectionStateNotifierProvider.notifier).update(
                    authModel: model,
                  );
            }
          },
        ),
      ],
    );
  }
}
