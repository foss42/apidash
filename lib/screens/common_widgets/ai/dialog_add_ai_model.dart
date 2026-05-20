import 'package:apidash_core/apidash_core.dart' as ref;
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';

Future<ref.Model?> addNewModel(BuildContext context) async {
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
  if (z == null || z.length < 2) return null;
  return ref.Model(id: z[0], name: z[1]);
}
