import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:davi/davi.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class EditRequestURLParams extends ConsumerStatefulWidget {
  const EditRequestURLParams({super.key});

  @override
  ConsumerState<EditRequestURLParams> createState() =>
      EditRequestURLParamsState();
}

class EditRequestURLParamsState extends ConsumerState<EditRequestURLParams> {
  late int seed;
  final random = Random.secure();
  late List<NameValueModel> paramRows;
  late List<bool> isRowEnabledList;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
          selectedId,
          requestParams: paramRows.sublist(0, paramRows.length - 1),
          isParamEnabledList: isRowEnabledList.sublist(0, paramRows.length - 1),
        );
    debugPrint("URL Params Updated");
    for (var i = 0; i < paramRows.length - 1; i++) {
      debugPrint(
          "URL Param $i: (${paramRows[i].name}=${paramRows[i].value})  ==> ${isRowEnabledList[i]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestParams?.length));
    var rP = ref.read(selectedRequestModelProvider)?.requestParams;
    bool isParamsEmpty = rP == null || rP.isEmpty;
    List<NameValueModel> rows = (isParamsEmpty)
        ? [
            kNameValueEmptyModel,
          ]
        : rP;
    paramRows = isParamsEmpty ? rows : rows + [kNameValueEmptyModel];
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isParamEnabledList ??
            List.filled(rP?.length ?? 0, true, growable: true);
    isRowEnabledList.add(false);

    DaviModel<NameValueModel> model = DaviModel<NameValueModel>(
      rows: paramRows,
      columns: [
        DaviColumn(
          name: 'Checkbox',
          width: 30,
          cellBuilder: (_, row) {
            int idx = row.index;
            bool isLast = idx + 1 == paramRows.length;
            return CheckBox(
              keyId: "$selectedId-$idx-params-c-$seed",
              value: isRowEnabledList[idx],
              onChanged: isLast
                  ? null
                  : (value) {
                      setState(() {
                        isRowEnabledList[idx] = value!;
                      });
                      _onFieldChange(selectedId!);
                    },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
        ),
        DaviColumn(
          name: 'URL Parameter',
          width: 70,
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            bool isLast = idx + 1 == paramRows.length;
            return CellField(
              keyId: "$selectedId-$idx-params-k-$seed",
              initialValue: paramRows[idx].name,
              hintText: "Add URL Parameter",
              onChanged: (value) {
                paramRows[idx] = paramRows[idx].copyWith(name: value);
                if (isLast) {
                  isRowEnabledList[idx] = true;
                  paramRows.add(kNameValueEmptyModel);
                  isRowEnabledList.add(false);
                }
                _onFieldChange(selectedId!);
              },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
          sortable: false,
        ),
        DaviColumn(
          width: 30,
          cellBuilder: (_, row) {
            return Text(
              "=",
              style: kCodeStyle,
            );
          },
        ),
        DaviColumn(
          name: 'Value',
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            bool isLast = idx + 1 == paramRows.length;
            return CellField(
              keyId: "$selectedId-$idx-params-v-$seed",
              initialValue: paramRows[idx].value,
              hintText: "Add Value",
              onChanged: (value) {
                paramRows[idx] = paramRows[idx].copyWith(value: value);
                if (isLast) {
                  isRowEnabledList[idx] = true;
                  paramRows.add(kNameValueEmptyModel);
                  isRowEnabledList.add(false);
                }
                _onFieldChange(selectedId!);
              },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
          sortable: false,
        ),
        DaviColumn(
          pinStatus: PinStatus.none,
          width: 30,
          cellBuilder: (_, row) {
            bool isLast = row.index + 1 == paramRows.length;
            return InkWell(
              onTap: isLast
                  ? null
                  : () {
                      seed = random.nextInt(kRandMax);
                      if (paramRows.length == 2) {
                        setState(() {
                          paramRows = [
                            kNameValueEmptyModel,
                          ];
                          isRowEnabledList = [false];
                        });
                      } else {
                        paramRows.removeAt(row.index);
                        isRowEnabledList.removeAt(row.index);
                      }
                      _onFieldChange(selectedId!);
                    },
              child: Theme.of(context).brightness == Brightness.dark
                  ? kIconRemoveDark
                  : kIconRemoveLight,
            );
          },
        ),
      ],
    );
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
                child: DaviTheme(
                  data: kTableThemeData,
                  child: Davi<NameValueModel>(model),
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
                paramRows.add(kNameValueEmptyModel);
                isRowEnabledList.add(false);
                _onFieldChange(selectedId!);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Param",
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
