import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path/path.dart' as p;

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
    var selectedDirectoryTextController = useTextEditingController();
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
                    child: ADOutlinedTextField(
                      keyId: "workspace-path",
                      controller: selectedDirectoryTextController,
                      textStyle: kTextStyleButtonSmall,
                      readOnly: true,
                      isDense: true,
                      maxLines: null,
                    ),
                  ),
                  kHSpacer10,
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      selectedDirectory.value = await getDirectoryPath();
                      selectedDirectoryTextController.text =
                          selectedDirectory.value ?? "";
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
              ADOutlinedTextField(
                keyId: "workspace-name",
                onChanged: (value) {
                  workspaceName.value = value.trim();
                },
                isDense: true,
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
