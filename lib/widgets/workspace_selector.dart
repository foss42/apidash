import 'package:apidash/consts.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
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
    final ds = DesignSystemProvider.of(context);
    var selectedDirectory = useState<String?>(null);
    var selectedDirectoryTextController = useTextEditingController();
    var workspaceName = useState<String?>(null);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400*ds.scaleFactor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                kMsgSelectWorkspace,
                style: kTextStyleButton(ds.scaleFactor),
              ),
              kVSpacer20(ds.scaleFactor),
              Row(
                children: [
                  Text(
                    "CHOOSE DIRECTORY",
                    style: kCodeStyle.copyWith(
                      fontSize: 12*ds.scaleFactor,
                    ),
                  ),
                ],
              ),
              kVSpacer5(ds.scaleFactor),
              Row(
                children: [
                  Expanded(
                    child: ADOutlinedTextField(
                      keyId: "workspace-path",
                      controller: selectedDirectoryTextController,
                      textStyle: kTextStyleButtonSmall(ds.scaleFactor),
                      readOnly: true,
                      isDense: true,
                      maxLines: null,
                    ),
                  ),
                  kHSpacer10(ds.scaleFactor),
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
              kVSpacer40(ds.scaleFactor),
              Row(
                children: [
                  Text(
                    "WORKSPACE NAME [OPTIONAL]\n(FOLDER WILL BE CREATED IN THE SELECTED DIRECTORY)",
                    style: kCodeStyle.copyWith(
                      fontSize: 12*ds.scaleFactor,
                    ),
                  ),
                ],
              ),
              kVSpacer5(ds.scaleFactor),
              ADOutlinedTextField(
                keyId: "workspace-name",
                onChanged: (value) {
                  workspaceName.value = value.trim();
                },
                isDense: true,
              ),
              kVSpacer40(ds.scaleFactor),
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
                  kHSpacer10(ds.scaleFactor),
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
