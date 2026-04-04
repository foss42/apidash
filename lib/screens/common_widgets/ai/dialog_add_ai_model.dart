import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

Future<Model?> addNewModel(BuildContext context) {
  return showDialog<Model?>(
    context: context,
    builder: (_) => const _AddNewModelDialog(),
  );
}

class _AddNewModelDialog extends StatefulWidget {
  const _AddNewModelDialog();

  @override
  State<_AddNewModelDialog> createState() => _AddNewModelDialogState();
}

class _AddNewModelDialogState extends State<_AddNewModelDialog> {
  late final TextEditingController iC;
  late final TextEditingController nC;
  String? errorText;

  @override
  void initState() {
    super.initState();
    iC = TextEditingController();
    nC = TextEditingController();
  }

  @override
  void dispose() {
    iC.dispose();
    nC.dispose();
    super.dispose();
  }

  void _submit() {
    final modelId = iC.text.trim();
    final displayName = nC.text.trim();

    if (modelId.isEmpty) {
      setState(() {
        errorText = 'Model ID is required';
      });
      return;
    }

    Navigator.of(context).pop(
      Model(
        id: modelId,
        name: displayName.isEmpty ? modelId : displayName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(kLabelAddCustomModel),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ADOutlinedTextField(
                controller: iC,
                hintText: kHintModelId,
              ),
              if (errorText != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ],
              kVSpacer10,
              ADOutlinedTextField(
                controller: nC,
                hintText: kHintModelDisplayName,
              ),
              kVSpacer10,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(kLabelAddModel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
