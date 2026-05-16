import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/models/protocols/grpc_model.dart';

class EditGrpcRequestMetadata extends ConsumerStatefulWidget {
  const EditGrpcRequestMetadata({super.key});

  @override
  ConsumerState<EditGrpcRequestMetadata> createState() => EditGrpcRequestMetadataState();
}

class EditGrpcRequestMetadataState extends ConsumerState<EditGrpcRequestMetadata> {
  late int seed;
  final random = Random.secure();
  late List<NameValueModel> metadataRows;
  late List<bool> isRowEnabledList;
  bool isAddingRow = false;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange() {
    ref.read(collectionStateNotifierProvider.notifier).update(
          headers: metadataRows.sublist(0, metadataRows.length - 1),
          isHeaderEnabledList:
              isRowEnabledList.sublist(0, metadataRows.length - 1),
        );
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref.watch(selectedRequestModelProvider);
    final protocolModel = requestModel?.protocolModel;
    final grpcModel = protocolModel is GrpcRequestModel ? protocolModel : null;

    if (grpcModel == null) return kSizedBoxEmpty;

    var rH = grpcModel.metadata;
    bool isMetadataEmpty = rH == null || rH.isEmpty;
    metadataRows = isMetadataEmpty
        ? [
            kNameValueEmptyModel,
          ]
        : rH + [kNameValueEmptyModel];
    isRowEnabledList = [
      ...(grpcModel.isMetadataEnabled ??
          List.filled(rH?.length ?? 0, true, growable: true))
    ];
    isRowEnabledList.add(false);
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text(kNameCheckbox),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text(kNameHeader),
      ),
      DataColumn2(
        label: Text('='),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text(kNameValue),
      ),
      DataColumn2(
        label: Text(''),
        fixedWidth: 32,
      ),
    ];

    List<DataRow> dataRows = List<DataRow>.generate(
      metadataRows.length,
      (index) {
        bool isLast = index + 1 == metadataRows.length;
        return DataRow(
          key: ValueKey("$selectedId-$index-grpc-metadata-row-$seed"),
          cells: <DataCell>[
            DataCell(
              ADCheckBox(
                keyId: "$selectedId-$index-grpc-metadata-c-$seed",
                value: isRowEnabledList[index],
                onChanged: isLast
                    ? null
                    : (value) {
                        setState(() {
                          isRowEnabledList[index] = value!;
                        });
                        _onFieldChange();
                      },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              EnvHeaderField(
                keyId: "$selectedId-$index-grpc-metadata-k-$seed",
                initialValue: metadataRows[index].name,
                hintText: kHintAddName,
                onChanged: (value) {
                  metadataRows[index] = metadataRows[index].copyWith(name: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    isRowEnabledList[index] = true;
                    metadataRows.add(kNameValueEmptyModel);
                    isRowEnabledList.add(false);
                  }
                  _onFieldChange();
                },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  "=",
                  style: kCodeStyle,
                ),
              ),
            ),
            DataCell(
              EnvCellField(
                keyId: "$selectedId-$index-grpc-metadata-v-$seed",
                initialValue: metadataRows[index].value,
                hintText: kHintAddValue,
                onChanged: (value) {
                  metadataRows[index] = metadataRows[index].copyWith(value: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    isRowEnabledList[index] = true;
                    metadataRows.add(kNameValueEmptyModel);
                    isRowEnabledList.add(false);
                  }
                  _onFieldChange();
                },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              InkWell(
                onTap: isLast
                    ? null
                    : () {
                        seed = random.nextInt(kRandMax);
                        if (metadataRows.length == 2) {
                          setState(() {
                            metadataRows = [
                              kNameValueEmptyModel,
                            ];
                            isRowEnabledList = [false];
                          });
                        } else {
                          metadataRows.removeAt(index);
                          isRowEnabledList.removeAt(index);
                        }
                        _onFieldChange();
                      },
                child: Theme.of(context).brightness == Brightness.dark
                    ? kIconRemoveDark
                    : kIconRemoveLight,
              ),
            ),
          ],
        );
      },
    );

    return Stack(
      children: [
        Container(
          margin: kPh10t10,
          child: Column(
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(scrollbarTheme: kDataTableScrollbarTheme),
                  child: DataTable2(
                    columnSpacing: 12,
                    dividerThickness: 0,
                    horizontalMargin: 0,
                    headingRowHeight: 0,
                    dataRowHeight: kDataTableRowHeight,
                    bottomMargin: kDataTableBottomPadding,
                    isVerticalScrollBarVisible: true,
                    columns: columns,
                    rows: dataRows,
                  ),
                ),
              ),
              if (!kIsMobile) kVSpacer40,
            ],
          ),
        ),
        if (!kIsMobile)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: kPb15,
              child: ElevatedButton.icon(
                onPressed: () {
                  metadataRows.add(kNameValueEmptyModel);
                  isRowEnabledList.add(false);
                  _onFieldChange();
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  "Add Metadata",
                  style: kTextStyleButton,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
