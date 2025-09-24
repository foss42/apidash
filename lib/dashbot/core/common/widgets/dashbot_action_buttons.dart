import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/chat/models/chat_models.dart';
import '../../../features/chat/viewmodel/chat_viewmodel.dart';
import '../../providers/attachments_provider.dart';
import 'package:file_selector/file_selector.dart';
import '../../services/openapi_import_service.dart';
import '../../../features/chat/view/widgets/openapi_operation_picker_dialog.dart';
import 'package:openapi_spec/openapi_spec.dart';
import '../../providers/dashbot_window_notifier.dart';
import '../../../../utils/save_utils.dart';
import '../../../../utils/utils.dart';

/// Base mixin for action widgets.
mixin DashbotActionMixin {
  ChatAction get action;
}

class DashbotUploadRequestButton extends ConsumerWidget
    with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotUploadRequestButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = action.value is Map && (action.value['purpose'] is String)
        ? 'Upload: ${action.value['purpose'] as String}'
        : 'Upload Attachment';
    return OutlinedButton.icon(
      icon: const Icon(Icons.upload_file, size: 16),
      label: Text(label, overflow: TextOverflow.ellipsis),
      onPressed: () async {
        final types = <XTypeGroup>[];
        if (action.value is Map && action.value['accepted_types'] is List) {
          final exts = (action.value['accepted_types'] as List)
              .whereType<String>()
              .map((e) => e.trim())
              .toList();
          if (exts.isNotEmpty) {
            types.add(XTypeGroup(label: 'Allowed', mimeTypes: exts));
          }
        }
        final file = await openFile(
            acceptedTypeGroups:
                types.isEmpty ? [const XTypeGroup(label: 'Any')] : types);
        if (file == null) return;
        final bytes = await file.readAsBytes();
        final att = ref.read(attachmentsProvider.notifier).add(
              name: file.name,
              mimeType: file.mimeType ?? 'application/octet-stream',
              data: bytes,
            );
        if (action.field == 'openapi_spec') {
          await ref
              .read(chatViewmodelProvider.notifier)
              .handleOpenApiAttachment(att);
        } else {
          ref.read(chatViewmodelProvider.notifier).sendMessage(
                text:
                    'Attached file ${att.name} (id=${att.id}, mime=${att.mimeType}, size=${att.sizeBytes}). You can request its content if needed.',
                type: ChatMessageType.general,
              );
        }
      },
    );
  }
}

class DashbotAutoFixButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotAutoFixButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      icon: const Icon(Icons.auto_fix_high, size: 16),
      label: const Text('Auto Fix'),
    );
  }
}

class DashbotAddTestButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotAddTestButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      icon: const Icon(Icons.playlist_add_check, size: 16),
      label: const Text('Add Test'),
    );
  }
}

class DashbotApplyCurlButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotApplyCurlButton({super.key, required this.action});

  String _labelForField(String? field, String? path) {
    switch (field) {
      case 'apply_to_selected':
        return 'Apply to Selected';
      case 'apply_to_new':
        return 'Create New Request';
      case 'select_operation':
        return path == null || path.isEmpty ? 'Select Operation' : path;
      default:
        return 'Apply';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = _labelForField(action.field, action.path);
    return ElevatedButton(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      child: Text(label),
    );
  }
}

class DashbotGenerateLanguagePicker extends ConsumerWidget
    with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotGenerateLanguagePicker({super.key, required this.action});

  List<String> _extractLanguages(dynamic value) {
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return const [
      'JavaScript (fetch)',
      'Python (requests)',
      'Dart (http)',
      'Go (net/http)',
      'cURL',
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langs = _extractLanguages(action.value);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final l in langs)
          OutlinedButton(
            onPressed: () {
              ref.read(chatViewmodelProvider.notifier).sendMessage(
                    text: 'Please generate code in $l',
                    type: ChatMessageType.generateCode,
                  );
            },
            child: Text(l, style: const TextStyle(fontSize: 12)),
          ),
      ],
    );
  }
}

class DashbotApplyOpenApiButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotApplyOpenApiButton({super.key, required this.action});

  String _labelForField(String? field) {
    switch (field) {
      case 'apply_to_selected':
        return 'Apply to Selected';
      case 'apply_to_new':
        return 'Create New Request';
      default:
        return 'Apply';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = _labelForField(action.field);
    return ElevatedButton(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      child: Text(label),
    );
  }
}

class DashbotSelectOperationButton extends ConsumerWidget
    with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotSelectOperationButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operationName = action.path ?? 'Unknown';
    return OutlinedButton(
      onPressed: () async {
        await ref.read(chatViewmodelProvider.notifier).applyAutoFix(action);
      },
      child: Text(operationName, style: const TextStyle(fontSize: 12)),
    );
  }
}

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

          final overlayNotifier =
              ref.read(dashbotWindowNotifierProvider.notifier);
          overlayNotifier.hide();
          final selected = await showOpenApiOperationPickerDialog(
            context: context,
            spec: spec,
            sourceName: sourceName,
          );
          overlayNotifier.show();
          if (selected == null || selected.isEmpty) return;

          final notifier = ref.read(chatViewmodelProvider.notifier);
          for (final s in selected) {
            final payload = OpenApiImportService.payloadForOperation(
              baseUrl: baseUrl,
              path: s.path,
              method: s.method,
              op: s.op,
            );
            await notifier.applyAutoFix(ChatAction.fromJson({
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

class DashbotGeneratedCodeBlock extends StatelessWidget
    with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotGeneratedCodeBlock({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final code = (action.value is String) ? action.value as String : '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: SelectableText(
        code.isEmpty ? '// No code returned' : code,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
      ),
    );
  }
}

class DashbotDownloadDocButton extends ConsumerWidget with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotDownloadDocButton({super.key, required this.action});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docContent = (action.value is String) ? action.value as String : '';
    final filename = action.path ?? 'api-documentation';

    return ElevatedButton.icon(
      icon: const Icon(Icons.download, size: 16),
      label: const Text('Download Documentation'),
      onPressed: docContent.isEmpty
          ? null
          : () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final contentBytes = Uint8List.fromList(docContent.codeUnits);

              await saveToDownloads(
                scaffoldMessenger,
                content: contentBytes,
                mimeType: 'text/markdown',
                ext: 'md',
                name: filename,
              );
            },
    );
  }
}

/// Factory to map an action to a widget.
class DashbotActionWidgetFactory {
  static Widget? build(ChatAction action) {
    switch (action.actionType) {
      case ChatActionType.other:
        if (action.action == 'import_now_openapi') {
          return DashbotImportNowButton(action: action);
        }
        if (action.field == 'select_operation') {
          return DashbotSelectOperationButton(action: action);
        }
        if (action.targetType == ChatActionTarget.test) {
          return DashbotAddTestButton(action: action);
        }
        if (action.targetType == ChatActionTarget.code) {
          return DashbotGeneratedCodeBlock(action: action);
        }
        break;
      case ChatActionType.showLanguages:
        if (action.targetType == ChatActionTarget.codegen) {
          return DashbotGenerateLanguagePicker(action: action);
        }
        break;
      case ChatActionType.applyCurl:
        return DashbotApplyCurlButton(action: action);
      case ChatActionType.applyOpenApi:
        return DashbotApplyOpenApiButton(action: action);
      case ChatActionType.downloadDoc:
        return DashbotDownloadDocButton(action: action);
      case ChatActionType.noAction:
        // If downstream requests, render an Import Now for OpenAPI contexts
        if (action.action == 'import_now_openapi') {
          return DashbotImportNowButton(action: action);
        }
        return null;
      case ChatActionType.updateField:
      case ChatActionType.addHeader:
      case ChatActionType.updateHeader:
      case ChatActionType.deleteHeader:
      case ChatActionType.updateBody:
      case ChatActionType.updateUrl:
      case ChatActionType.updateMethod:
        return DashbotAutoFixButton(action: action);

      case ChatActionType.uploadAsset:
        if (action.targetType == ChatActionTarget.attachment) {
          return DashbotUploadRequestButton(action: action);
        }
        return null;
    }

    if (action.action == 'other' && action.target == 'test') {
      return DashbotAddTestButton(action: action);
    }
    if (action.action == 'other' && action.target == 'code') {
      return DashbotGeneratedCodeBlock(action: action);
    }
    if (action.action == 'show_languages' && action.target == 'codegen') {
      return DashbotGenerateLanguagePicker(action: action);
    }
    if (action.action == 'apply_curl') {
      return DashbotApplyCurlButton(action: action);
    }
    if (action.action == 'apply_openapi') {
      return DashbotApplyOpenApiButton(action: action);
    }
    if (action.action.contains('update') ||
        action.action.contains('add') ||
        action.action.contains('delete')) {
      return DashbotAutoFixButton(action: action);
    }
    return null;
  }
}
