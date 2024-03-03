import 'dart:math';
import 'package:apidash/models/mqtt/mqtt_topic_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:davi/davi.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class MQTTTopicsPane extends ConsumerStatefulWidget {
  const MQTTTopicsPane({super.key});

  @override
  ConsumerState<MQTTTopicsPane> createState() => MQTTTopicsPaneState();
}

class MQTTTopicsPaneState extends ConsumerState<MQTTTopicsPane> {
  final random = Random.secure();
  late List<MQTTTopicModel> rows = [
    const MQTTTopicModel(name: '', qos: 0, subscribe: false, description: ''),
    // Add more topics as needed
  ];
  late List<bool> isRowEnabledList;
  late int seed;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    // ref.read(collectionStateNotifierProvider.notifier).update(
    //       selectedId,
    //       requestHeaders: rows,
    //       isHeaderEnabledList: isRowEnabledList,
    //     );
    ref.read(subscribedTopicsStateProvider.notifier).state = rows;
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final length = ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestHeaders?.length));
    var rH = ref.read(selectedRequestModelProvider)?.requestHeaders;
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isHeaderEnabledList ??
            List.filled(rows.length, true, growable: true);

    DaviModel<MQTTTopicModel> model = DaviModel<MQTTTopicModel>(
      rows: rows,
      columns: [
        DaviColumn(
          name: 'Topics',
          width: 70,
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            return CellField(
                keyId: "$selectedId-$idx-description-$seed",
                initialValue: rows[idx].description,
                hintText: "Add Topic Name",
                onChanged: (value) {
                  setState(() {
                    rows[idx] = rows[idx].copyWith(description: value);
                  });
                },
                colorScheme: Theme.of(context).colorScheme);
          },
          sortable: false,
        ),
        DaviColumn(
          name: 'QoS',
          width: 50,
          cellBuilder: (_, row) {
            int idx = row.index;
            return DropdownButtonQos(
              qos: rows[idx].qos,
              onChanged: (value) {
                setState(() {
                  rows[idx] = rows[idx].copyWith(qos: value!);
                });
                _onFieldChange(selectedId!);
              },
            );
          },
        ),
        DaviColumn(
            name: 'Subscribe',
            width: 50,
            cellBuilder: (_, row) {
              int idx = row.index;
              return CheckBox(
                keyId: "$selectedId-$idx-subscribe-c-$seed",
                value: isRowEnabledList[idx],
                onChanged: (value) {
                  isRowEnabledList[idx] = value!;
                  _onFieldChange(selectedId!);
                },
                colorScheme: Theme.of(context).colorScheme,
              );
            }),
        DaviColumn(
          name: 'Description',
          width: 10,
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            return CellField(
                keyId: "$selectedId-$idx-description-$seed",
                initialValue: rows[idx].description,
                hintText: "Add description",
                onChanged: (value) {
                  setState(() {
                    rows[idx] = rows[idx].copyWith(description: value);
                  });
                },
                colorScheme: Theme.of(context).colorScheme);
          },
        )
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
                  child: Davi<MQTTTopicModel>(model),
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
                setState(() {
                  rows.add(kMQTTTopicEmptyModel);
                  isRowEnabledList.add(false);
                  _onFieldChange(selectedId!);
                });
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Topics",
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
