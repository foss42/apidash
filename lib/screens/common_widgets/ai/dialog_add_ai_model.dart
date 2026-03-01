import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

Future<void> addNewModel(BuildContext context) async {
  TextEditingController iC = TextEditingController();
  TextEditingController nC = TextEditingController();
  final z = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Custom Model'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ADOutlinedTextField(
                controller: iC,
                hintText: 'Model ID',
              ), // ADOutlinedTextField
              kVSpacer10,
              ADOutlinedTextField(
                controller: nC,
                hintText: 'Model Display Name',
              ), // ADOutlinedTextField
              kVSpacer10,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop([
                      iC.value.text,
                      nC.value.text,
                    ]);
                  },
                  child: Text('Add Model'),
                ), // ElevatedButton
              ) // SizedBox
            ],
          ), // Column
        ); // AlertDialog
      });
  if (z == null) return;
  // TODO: Add logic to add a new model
  // setState(() {});
}
