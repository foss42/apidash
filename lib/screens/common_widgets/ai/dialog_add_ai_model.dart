import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';

Future<Model?> addNewModel(BuildContext context) async {
  TextEditingController iC = TextEditingController();
  TextEditingController nC = TextEditingController();
  final z = await showDialog<List<String>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(kLabelAddCustomModel),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ADOutlinedTextField(controller: iC, hintText: kHintModelId),
            kVSpacer10,
            ADOutlinedTextField(
              controller: nC,
              hintText: kHintModelDisplayName,
            ),
            kVSpacer10,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop([iC.value.text, nC.value.text]);
                },
                child: Text(kLabelAddModel),
              ),
            ),
          ],
        ),
      );
    },
  );
  iC.dispose();
  nC.dispose();
  if (z == null || z[0].trim().isEmpty) return null;
  final modelId = z[0].trim();
  final modelName = z[1].trim().isNotEmpty ? z[1].trim() : modelId;
  return Model(id: modelId, name: modelName);
}
