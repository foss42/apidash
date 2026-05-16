import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/protocols/grpc_model.dart';
import 'package:apidash/utils/grpc_utils.dart';

class EditGrpcRequestParameters extends ConsumerWidget {
  const EditGrpcRequestParameters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestModel = ref.watch(selectedRequestModelProvider);
    final protocolModel = requestModel?.protocolModel;
    final grpcModel = protocolModel is GrpcRequestModel ? protocolModel : null;

    if (grpcModel == null || grpcModel.parameters.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No parameters defined for this method."),
        ),
      );
    }

    return ListView.builder(
      itemCount: grpcModel.parameters.length,
      itemBuilder: (context, index) {
        final param = grpcModel.parameters[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  param.name,
                  style: kTextStyleButtonSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(" : "),
              Expanded(
                flex: 5,
                child: _buildParamInput(context, ref, grpcModel, index, param),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildParamInput(BuildContext context, WidgetRef ref,
      GrpcRequestModel grpcModel, int index, GrpcParameterModel param) {
    switch (param.type) {
      case "bool":
        return Switch(
          value: param.value.toLowerCase() == "true",
          onChanged: (val) => _updateParamValue(ref, grpcModel, index, val.toString()),
        );
      case "enum":
        return DropdownButtonFormField<String>(
          value: param.value.isEmpty ? (param.enumValues?.first) : param.value,
          items: param.enumValues?.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),
          onChanged: (val) => _updateParamValue(ref, grpcModel, index, val ?? ""),
        );
      default:
        return TextFormField(
          initialValue: param.value,
          decoration: InputDecoration(
            hintText: "Enter ${param.type}...",
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: (val) => _updateParamValue(ref, grpcModel, index, val),
        );
    }
  }

  void _updateParamValue(
      WidgetRef ref, GrpcRequestModel grpcModel, int index, String value) {
    final newParams = List<GrpcParameterModel>.from(grpcModel.parameters);
    newParams[index] = newParams[index].copyWith(value: value);
    ref.read(collectionStateNotifierProvider.notifier).update(
          protocolModel: grpcModel.copyWith(
            parameters: newParams,
            requestBody: GrpcUtils.paramsToJson(newParams),
          ),
        );
  }
}
