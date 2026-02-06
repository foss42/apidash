import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

Future<void> addNewModel(BuildContext context) async {
  final ds = DesignSystemProvider.of(context);
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
              ),
              kVSpacer10(ds.scaleFactor),
              ADOutlinedTextField(
                controller: nC,
                hintText: 'Model Display Name',
              ),
              kVSpacer10(ds.scaleFactor),
              SizedBox(
                width: double.infinity*ds.scaleFactor,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop([
                      iC.value.text,
                      nC.value.text,
                    ]);
                  },
                  child: Text('Add Model'),
                ),
              )
            ],
          ),
        );
      });
  if (z == null) return;
  // TODO: Add logic to add a new model
  // setState(() {});
}
