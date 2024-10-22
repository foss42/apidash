import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path/path.dart' as p;
import 'field_outlined.dart';

class WorkspaceSelector extends HookWidget {
  const WorkspaceSelector({
    super.key,
    required this.onContinue,
    this.onCancel,
  });

  final Future<void> Function(String)? onContinue;
  final Future<void> Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    var selectedDirectory = useState<String?>(null);
    var workspaceName = useState<String?>(null);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                kMsgSelectWorkspace,
                style: kTextStyleButton,
              ),
              kVSpacer20,
              Row(
                children: [
                  Text(
                    "CHOOSE DIRECTORY",
                    style: kCodeStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              kVSpacer5,
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        borderRadius: kBorderRadius6,
                      ),
                      padding: kP4,
                      child: Text(
                        style: kTextStyleButtonSmall,
                        selectedDirectory.value ?? "",
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  kHSpacer10,
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      selectedDirectory.value = await getDirectoryPath();
                    },
                    label: const Text(kLabelSelect),
                    icon: const Icon(Icons.folder_rounded),
                  ),
                ],
              ),
              kVSpacer10,
              Row(
                children: [
                  Text(
                    "WORKSPACE NAME [OPTIONAL]\n(FOLDER WILL BE CREATED IN THE SELECTED DIRECTORY)",
                    style: kCodeStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              kVSpacer5,
              OutlinedField(
                keyId: "workspace-name",
                onChanged: (value) {
                  workspaceName.value = value.trim();
                },
                colorScheme: Theme.of(context).colorScheme,
              ),
              kVSpacer40,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton(
                    onPressed: selectedDirectory.value == null
                        ? null
                        : () async {
                            String finalPath = selectedDirectory.value!;
                            if (workspaceName.value != null &&
                                workspaceName.value!.trim().isNotEmpty) {
                              finalPath =
                                  p.join(finalPath, workspaceName.value);
                            }
                            await onContinue?.call(finalPath);
                          },
                    child: const Text(kLabelContinue),
                  ),
                  kHSpacer10,
                  FilledButton(
                    onPressed: onCancel,
                    style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? kColorDarkDanger
                                : kColorLightDanger,
                        surfaceTintColor: kColorRed,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary),
                    child: const Text(kLabelCancel),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
