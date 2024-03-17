import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:davi/davi.dart';
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
  final List<NameValueModel> rows = [
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
          requestParams: rows,
          isParamEnabledList: isRowEnabledList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final length = ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestParams?.length));
    var rP = ref.read(selectedRequestModelProvider)?.requestParams;
    // rows = (rP == null || rP.isEmpty)
    //     ? [
    //         kNameValueEmptyModel,
    //       ]
    //     : rP;
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isParamEnabledList ??
            List.filled(rows.length, true, growable: true);

    DaviModel<NameValueModel> model = DaviModel<NameValueModel>(
      rows: rows,
      columns: [
        DaviColumn(
          name: 'URL Parameter',
          width: 70,
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            return Text(
              rows[idx].name,
              style: kCodeStyle,
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
      ],
    );
    return Container(
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
    );
  }
}
