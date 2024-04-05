import 'dart:math';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class MQTTConnectionConfigParams extends ConsumerStatefulWidget {
  const MQTTConnectionConfigParams({super.key});

  @override
  ConsumerState<MQTTConnectionConfigParams> createState() =>
      EditRequestURLParamsState();
}

class EditRequestURLParamsState
    extends ConsumerState<MQTTConnectionConfigParams> {
  final random = Random.secure();
  List<NameValueModel> headerRows = [
    const NameValueModel(name: 'Username', value: ''),
    const NameValueModel(name: 'Password', value: ''),
    const NameValueModel(name: 'Keep Alive', value: ''),
    const NameValueModel(name: 'Last-Will Topic', value: ''),
    const NameValueModel(name: 'Last-Will Message', value: ''),
    const NameValueModel(name: 'Last-Will QoS', value: ''),
  ];
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
          requestParams: headerRows,
          isParamEnabledList: isRowEnabledList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final length = ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestParams?.length));
    var rP = ref.read(selectedRequestModelProvider)?.requestParams;
    bool isHeadersEmpty = rP == null || rP.isEmpty;
    headerRows = isHeadersEmpty ? headerRows : rP;
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isParamEnabledList ??
            List.filled(headerRows.length, true, growable: true);
    List<DataColumn> columns = const [
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
    ];

    List<DataRow> dataRows = List<DataRow>.generate(headerRows.length, (index) {
      return DataRow(cells: <DataCell>[
        DataCell(
          Text(
            headerRows[index].name,
            style: kCodeStyle,
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
            keyId: "$selectedId-$index-params-v-$seed",
            initialValue: headerRows[index].value,
            hintText: "Add Value",
            onChanged: (value) {
              headerRows[index] = headerRows[index].copyWith(value: value);
              _onFieldChange(selectedId!);
              debugPrint("headerRows: $headerRows");
            },
            colorScheme: Theme.of(context).colorScheme,
          ),
        ),
      ]);
    });
    // // DaviModel<NameValueModel> model = DaviModel<NameValueModel>(
    //   rows: rows,
    //   columns: [
    //     DaviColumn(
    //       name: 'URL Parameter',
    //       width: 70,
    //       grow: 1,
    //       cellBuilder: (_, row) {
    //         int idx = row.index;
    //         return Text(
    //           rows[idx].name,
    //           style: kCodeStyle,
    //         );
    //       },
    //       sortable: false,
    //     ),
    //     DaviColumn(
    //       width: 30,
    //       cellBuilder: (_, row) {
    //         return Text(
    //           "=",
    //           style: kCodeStyle,
    //         );
    //       },
    //     ),
    //     DaviColumn(
    //       name: 'Value',
    //       grow: 1,
    //       cellBuilder: (_, row) {
    //         int idx = row.index;
    //         return CellField(
    //           keyId: "$selectedId-$idx-params-v-$seed",
    //           initialValue: rows[idx].value,
    //           hintText: "Add Value",
    //           onChanged: (value) {
    //             rows[idx] = rows[idx].copyWith(value: value);
    //             _onFieldChange(selectedId!);
    //           },
    //           colorScheme: Theme.of(context).colorScheme,
    //         );
    //       },
    //       sortable: false,
    //     ),
    //   ],
    // );
    return Container(
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
                dataRowHeight: kDataTableRowHeight,
                bottomMargin: kDataTableBottomPadding,
                isVerticalScrollBarVisible: true,
                columns: columns,
                rows: dataRows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
