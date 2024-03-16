import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class EditRequestHeaders extends ConsumerStatefulWidget {
  const EditRequestHeaders({super.key});

  @override
  ConsumerState<EditRequestHeaders> createState() => EditRequestHeadersState();
}

class EditRequestHeadersState extends ConsumerState<EditRequestHeaders> {
  final random = Random.secure();
  late List<NameValueModel> rows;
  late List<bool> isRowEnabledList;
  late int seed;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
          selectedId,
          requestHeaders: rows,
          isHeaderEnabledList: isRowEnabledList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestHeaders?.length));
    var rH = ref.read(selectedRequestModelProvider)?.requestHeaders;
    rows = (rH == null || rH.isEmpty)
        ? [
            kNameValueEmptyModel,
          ]
        : rH;
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isHeaderEnabledList ??
            List.filled(rows.length, true, growable: true);

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text('Checkbox'),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text('Header Name'),
      ),
      DataColumn2(
        label: Text('='),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text('Header Value'),
      ),
      DataColumn2(
        label: Text('Remove'),
        fixedWidth: 32,
      ),
    ];

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: kBorderRadius12,
          ),
          margin: kP10,
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
                    dataRowHeight: kDataRowHeight,
                    bottomMargin: kDataTableBottomPadding,
                    isVerticalScrollBarVisible: true,
                    columns: columns,
                    rows: List<DataRow>.generate(
                      rows.length,
                      (index) {
                        return DataRow(
                          key: ValueKey("$selectedId-$index-headers-row-$seed"),
                          cells: <DataCell>[
                            DataCell(
                              CheckBox(
                                keyId: "$selectedId-$index-headers-c-$seed",
                                value: isRowEnabledList[index],
                                onChanged: (value) {
                                  setState(() {
                                    isRowEnabledList[index] = value!;
                                  });
                                  _onFieldChange(selectedId!);
                                },
                                colorScheme: Theme.of(context).colorScheme,
                              ),
                            ),
                            DataCell(
                              HeaderField(
                                keyId: "$selectedId-$index-headers-k-$seed",
                                initialValue: rows[index].name,
                                hintText: "Add Header Name",
                                onChanged: (value) {
                                  rows[index] =
                                      rows[index].copyWith(name: value);
                                  _onFieldChange(selectedId!);
                                },
                                colorScheme: Theme.of(context).colorScheme,
                              ),
                            ),
                            DataCell(
                              Text(
                                "=",
                                style: kCodeStyle,
                              ),
                            ),
                            DataCell(
                              CellField(
                                keyId: "$selectedId-$index-headers-v-$seed",
                                initialValue: rows[index].value,
                                hintText: " Add Header Value",
                                onChanged: (value) {
                                  rows[index] =
                                      rows[index].copyWith(value: value);
                                  _onFieldChange(selectedId!);
                                },
                                colorScheme: Theme.of(context).colorScheme,
                              ),
                            ),
                            DataCell(
                              InkWell(
                                child: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? kIconRemoveDark
                                    : kIconRemoveLight,
                                onTap: () {
                                  seed = random.nextInt(kRandMax);
                                  if (rows.length == 1) {
                                    setState(() {
                                      rows = [
                                        kNameValueEmptyModel,
                                      ];
                                      isRowEnabledList = [true];
                                    });
                                  } else {
                                    rows.removeAt(index);
                                    isRowEnabledList.removeAt(index);
                                  }
                                  _onFieldChange(selectedId!);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton.icon(
              onPressed: () {
                rows.add(kNameValueEmptyModel);
                isRowEnabledList.add(true);
                _onFieldChange(selectedId!);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Header",
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
