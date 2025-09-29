import 'dart:developer';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/services.dart';
import '../dashbot_action.dart';
import '../openapi_operation_picker_dialog.dart';

class DashbotImportNowButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotImportNowButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      icon: const Icon(Icons.playlist_add_check, size: 16),
      label: const Text('Import Now'),
      onPressed: () async {
        try {
          OpenApi? spec;
          String? sourceName;
          final overlayNotifier =
              ref.read(dashbotWindowNotifierProvider.notifier);
          final chatNotifier = ref.read(chatViewmodelProvider.notifier);
          if (action.value is Map<String, dynamic>) {
            final map = action.value as Map<String, dynamic>;
            sourceName = map['sourceName'] as String?;
            if (map['spec'] is OpenApi) {
              spec = map['spec'] as OpenApi;
            } else if (map['content'] is String) {
              spec =
                  OpenApiImportService.tryParseSpec(map['content'] as String);
            }
          }
          if (spec == null) return;

          final servers = spec.servers ?? const [];
          final baseUrl = servers.isNotEmpty ? (servers.first.url ?? '/') : '/';
          overlayNotifier.hide();
          final selected = await showOpenApiOperationPickerDialog(
            context: context,
            spec: spec,
            sourceName: sourceName,
          );
          overlayNotifier.show();
          if (selected == null || selected.isEmpty) return;
          for (final s in selected) {
            final payload = OpenApiImportService.payloadForOperation(
              baseUrl: baseUrl,
              path: s.path,
              method: s.method,
              op: s.op,
            );
            log("SorceName: $sourceName");
            payload['sourceName'] =
                (sourceName != null && sourceName.trim().isNotEmpty)
                    ? sourceName
                    : spec.info.title;
            await chatNotifier.applyAutoFix(ChatAction.fromJson({
              'action': 'apply_openapi',
              'actionType': 'apply_openapi',
              'target': 'httpRequestModel',
              'targetType': 'httpRequestModel',
              'field': 'apply_to_new',
              'value': payload,
            }));
          }
        } catch (_) {}
      },
    );
  }
}
