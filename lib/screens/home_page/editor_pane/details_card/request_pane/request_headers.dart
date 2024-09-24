import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';

class EditRequestHeaders extends ConsumerStatefulWidget {
  const EditRequestHeaders({super.key});

  @override
  ConsumerState<EditRequestHeaders> createState() => EditRequestHeadersState();
}

class EditRequestHeadersState extends ConsumerState<EditRequestHeaders> {
  late int seed;
  final random = Random.secure();
  late List<NameValueModel> headerRows;
  late List<bool> isRowEnabledList;
  bool isAddingRow = false;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
      selectedId,
      headers: headerRows.sublist(0, headerRows.length - 1),
      isHeaderEnabledList: isRowEnabledList.sublist(0, headerRows.length - 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider.select((value) =>
    value?.httpRequestModel?.headers?.length));
    var rH = ref.read(selectedRequestModelProvider)?.httpRequestModel?.headers;
    bool isHeadersEmpty = rH == null || rH.isEmpty;
    headerRows = isHeadersEmpty
        ? [kNameValueEmptyModel]
        : rH + [kNameValueEmptyModel];
    isRowEnabledList = [
      ...(ref.read(selectedRequestModelProvider)?.httpRequestModel
          ?.isHeaderEnabledList ??
          List.filled(rH?.length ?? 0, true, growable: true))
    ];
    isRowEnabledList.add(false);
    isAddingRow = false;

    List<DataColumn> columns = [
      DataColumn2(
        label: const Text(kNameCheckbox),
        fixedWidth: 30 * scaleFactor,
      ),
      const DataColumn2(
        label: Text(kNameHeader),
      ),
      DataColumn2(
        label: const Text('='),
        fixedWidth: 30 * scaleFactor,
      ),
      const DataColumn2(
        label: Text(kNameValue),
      ),
      DataColumn2(
        label: const Text(''),
        fixedWidth: 32 * scaleFactor,
      ),
    ];

    List<DataRow> dataRows = List<DataRow>.generate(
      headerRows.length,
          (index) {
        bool isLast = index + 1 == headerRows.length;
        return DataRow(
          key: ValueKey("$selectedId-$index-headers-row-$seed"),
          cells: <DataCell>[
            DataCell(
              Center(
                child: CheckBox(
                  keyId: "$selectedId-$index-headers-c-$seed",
                  value: isRowEnabledList[index],
                  onChanged: isLast
                      ? null
                      : (value) {
                    setState(() {
                      isRowEnabledList[index] = value!;
                    });
                    _onFieldChange(selectedId!);
                  },
                  colorScheme: Theme.of(context).colorScheme,
                ),
              ),
            ),
            DataCell(
              Center(
                child: HeaderField(
                  scaleFactor: scaleFactor,
                  keyId: "$selectedId-$index-headers-k-$seed",
                  initialValue: headerRows[index].name,
                  hintText: kHintAddName,
                  onChanged: (value) {
                    headerRows[index] =
                        headerRows[index].copyWith(name: value);
                    if (isLast && !isAddingRow) {
                      isAddingRow = true;
                      isRowEnabledList[index] = true;
                      headerRows.add(kNameValueEmptyModel);
                      isRowEnabledList.add(false);
                    }
                    _onFieldChange(selectedId!);
                  },
                  colorScheme: Theme.of(context).colorScheme,
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  "=",
                  style: kCodeStyle.copyWith(fontSize: 10 * scaleFactor),
                ),
              ),
            ),
            DataCell(
              Center(
                child: EnvCellField(
                  keyId: "$selectedId-$index-headers-v-$seed",
                  initialValue: headerRows[index].value,
                  hintText: kHintAddValue,
                  onChanged: (value) {
                    headerRows[index] =
                        headerRows[index].copyWith(value: value);
                    if (isLast && !isAddingRow) {
                      isAddingRow = true;
                      isRowEnabledList[index] = true;
                      headerRows.add(kNameValueEmptyModel);
                      isRowEnabledList.add(false);
                    }
                    _onFieldChange(selectedId!);
                  },
                  colorScheme: Theme.of(context).colorScheme,
                ),
              ),
            ),
            DataCell(
              Center(
                child: InkWell(
                  onTap: isLast
                      ? null
                      : () {
                    seed = random.nextInt(kRandMax);
                    if (headerRows.length == 2) {
                      setState(() {
                        headerRows = [
                          kNameValueEmptyModel,
                        ];
                        isRowEnabledList = [false];
                      });
                    } else {
                      headerRows.removeAt(index);
                      isRowEnabledList.removeAt(index);
                    }
                    _onFieldChange(selectedId!);
                  },
                  child: Theme.of(context).brightness == Brightness.dark
                      ? kIconRemoveDark
                      : kIconRemoveLight,
                ),
              ),
            ),
          ],
        );
      },
    );
    SizedBox(height: 16 * scaleFactor);
    return Stack(
      children: [
        Container(
          margin: kP10 * scaleFactor, // Scale margin
          child: Column(
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(scrollbarTheme: kDataTableScrollbarTheme),
                  child: DataTable2(
                    columnSpacing: 12 * scaleFactor, // Scale column spacing
                    dividerThickness: 0,
                    horizontalMargin: 0,
                    headingRowHeight: 0,
                    dataRowHeight:
                    (kDataTableRowHeight + 10) * scaleFactor, // Scale data row height
                    bottomMargin:
                    kDataTableBottomPadding * scaleFactor, // Scale bottom margin
                    isVerticalScrollBarVisible: true,
                    columns: columns,
                    rows: dataRows.map((dataRow) {
                      return DataRow(
                        key: dataRow.key,
                        cells: dataRow.cells,
                        selected: false,
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 40 * scaleFactor), // Scale vertical spacer
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: kPb15 * scaleFactor, // Scale bottom padding
            child: ElevatedButton.icon(
              onPressed: () {
                headerRows.add(kNameValueEmptyModel);
                isRowEnabledList.add(false);
                _onFieldChange(selectedId!);
              },
              icon: Icon(Icons.add, size: 24 * scaleFactor), // Scale icon size
              label: Text(
                kLabelAddHeader,
                style: kTextStyleButton.copyWith(fontSize: 16 * scaleFactor), // Scale text size
              ),
            ),
          ),
        ),
      ],
    );
  }
}
