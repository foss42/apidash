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
          requestParams: rows,
          isParamEnabledList: isRowEnabledList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestParams?.length));
    var rP = ref.read(selectedRequestModelProvider)?.requestParams;
    rows = (rP == null || rP.isEmpty)
        ? [
            kNameValueEmptyModel,
          ]
        : rP;
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isParamEnabledList ??
            List.filled(rows.length, true, growable: true);

    DaviModel<NameValueModel> model = DaviModel<NameValueModel>(
      rows: rows,
      columns: [
        DaviColumn(
          name: 'Checkbox',
          width: 30,
          cellBuilder: (_, row) {
            int idx = row.index;
            return CheckBox(
              keyId: "$selectedId-$idx-params-c-$seed",
              value: isRowEnabledList[idx],
              onChanged: (value) {
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
            return CellField(
              keyId: "$selectedId-$idx-params-k-$seed",
              initialValue: rows[idx].name,
              hintText: "Add URL Parameter",
              onChanged: (value) {
                rows[idx] = rows[idx].copyWith(name: value);
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
            return CellField(
              keyId: "$selectedId-$idx-params-v-$seed",
              initialValue: rows[idx].value,
              hintText: "Add Value",
              onChanged: (value) {
                rows[idx] = rows[idx].copyWith(value: value);
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
            return InkWell(
              child: Theme.of(context).brightness == Brightness.dark
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
                  rows.removeAt(row.index);
                  isRowEnabledList.removeAt(row.index);
                }
                _onFieldChange(selectedId!);
              },
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
                rows.add(kNameValueEmptyModel);
                isRowEnabledList.add(true);
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
