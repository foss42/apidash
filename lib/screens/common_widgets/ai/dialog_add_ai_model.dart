import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';

Future<Model?> addNewModel(BuildContext context) async {
  final z = await showDialog<List<String>>(
    context: context,
    builder: (context) {
      return const AddCustomModelDialog();
    },
  );
  if (z == null || z[0].trim().isEmpty) return null;
  final modelId = z[0].trim();
  final modelName = z[1].trim().isNotEmpty ? z[1].trim() : modelId;
  return Model(id: modelId, name: modelName);
}

class AddCustomModelDialog extends StatefulWidget {
  const AddCustomModelDialog({super.key});

  @override
  State<AddCustomModelDialog> createState() => _AddCustomModelDialogState();
}

class _AddCustomModelDialogState extends State<AddCustomModelDialog> {
  late TextEditingController iC;
  late TextEditingController nC;

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(kLabelAddCustomModel),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ADOutlinedTextField(controller: iC, hintText: kHintModelId),
          kVSpacer10,
          ADOutlinedTextField(controller: nC, hintText: kHintModelDisplayName),
          kVSpacer10,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop([iC.value.text, nC.value.text]);
              },
              child: const Text(kLabelAddModel),
            ),
          ),
        ],
      ),
    );
  }
}
