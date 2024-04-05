import 'dart:math';
import 'package:apidash/models/mqtt/mqtt_topic_model.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MQTTTopicsPane extends ConsumerStatefulWidget {
  const MQTTTopicsPane({super.key});

  @override
  ConsumerState<MQTTTopicsPane> createState() => MQTTTopicsPaneState();
}

class MQTTTopicsPaneState extends ConsumerState<MQTTTopicsPane> {
  final random = Random.secure();
  List<MQTTTopicModel> rows = [
    const MQTTTopicModel(name: '', qos: 0, subscribe: false, description: ''),
    // Add more topics as needed
  ];
  late int seed;
  List<TextEditingController> descriptionControllers = [];
  List<TextEditingController> nameControllers = [];
  late List<bool> isRowEnabledList;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
    for (var row in rows) {
      descriptionControllers.add(TextEditingController(text: row.description));
    }
    for (var row in rows) {
      nameControllers.add(TextEditingController(text: row.description));
    }
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
  void dispose() {
    for (var controller in descriptionControllers) {
      controller.dispose();
    }
    for (var controller in nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final realtimeConnectionState = ref.watch(realtimeConnectionStateProvider);
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isHeaderEnabledList ??
            List.filled(rows.length, true, growable: true);
    List<DataColumn> columns = const [
      DataColumn2(
        size: ColumnSize.L,
        label: Text(
          'Topics',
        ),
      ),
      DataColumn2(
        size: ColumnSize.S,
        label: Text('QoS'),
      ),
      DataColumn2(label: Text('Subscribe'), size: ColumnSize.S),
      DataColumn2(
        label: Text('Description'),
      ),
    ];
    List<DataRow> dataRows = List<DataRow>.generate(
      rows.length,
      (index) => DataRow(
        cells: <DataCell>[
          DataCell(
            TextField(
              decoration: const InputDecoration(
                hintText: 'Add Topic Name',
              ),
              controller: nameControllers[index], // Use topic name controller

              onChanged: (value) {
                setState(() {
                  rows[index] = rows[index].copyWith(name: value);
                });
              },
            ),
          ),
          DataCell(
            DropdownButtonQos(
              qos: rows[index].qos,
              onChanged: (value) {
                setState(() {
                  rows[index] = rows[index].copyWith(qos: value!);
                });
                _onFieldChange(selectedId!);
              },
            ),
          ),
          DataCell(
            Switch(
              value: rows[index].subscribe,
              onChanged: (value) {
                MqttQos qos = rows[index].qos == 0
                    ? MqttQos.atMostOnce
                    : rows[index].qos == 1
                        ? MqttQos.atLeastOnce
                        : MqttQos.exactlyOnce;
                String topicName = rows[index].name;
                setState(() {
                  if (realtimeConnectionState ==
                          RealtimeConnectionState.connected &&
                      topicName.isNotEmpty) {
                    rows[index] = rows[index].copyWith(subscribe: value);
                    _onFieldChange(selectedId!);
                    if (value) {
                      ref
                          .read(collectionStateNotifierProvider.notifier)
                          .subscribeTopic(topicName, qos);
                    } else {
                      ref
                          .read(collectionStateNotifierProvider.notifier)
                          .unsubscribeTopic(topicName);
                    }
                  }
                });
              },
            ),
          ),
          DataCell(
            TextField(
              decoration: const InputDecoration(
                hintText: 'Add Description',
              ),
              controller: descriptionControllers[index],
              onChanged: (value) {
                setState(() {
                  rows[index] = rows[index].copyWith(description: value);
                });
              },
            ),
          ),
        ],
      ),
    );
    // DaviModel<MQTTTopicModel> model = DaviModel<MQTTTopicModel>(
    // rows: rows,
    // columns: [
    //   DaviColumn(
    //     name: 'Topics',
    //     width: 70,
    //     grow: 1,
    //     cellBuilder: (_, row) {
    //       int idx = row.index;
    //       return CellField(
    //           keyId: "$selectedId-$idx-description-$seed",
    //           initialValue: rows[idx].description,
    //           hintText: "Add Topic Name",
    //           onChanged: (value) {
    //             setState(() {
    //               rows[idx] = rows[idx].copyWith(name: value);
    //               // print(rows);
    //             });
    //           },
    //           colorScheme: Theme.of(context).colorScheme);
    //     },
    //     sortable: false,
    //   ),
    //   DaviColumn(
    //     resizable: false,
    //     name: 'QoS',
    //     width: 50,
    //     cellBuilder: (_, row) {
    //       int idx = row.index;
    //       return DropdownButtonQos(
    //         qos: rows[idx].qos,
    //         onChanged: (value) {
    //           setState(() {
    //             rows[idx] = rows[idx].copyWith(qos: value!);
    //           });
    //           _onFieldChange(selectedId!);
    //         },
    //       );
    //     },
    //   ),
    //   DaviColumn(
    //       resizable: false,
    //       name: 'Subscribe',
    //       width: 100,
    //       cellBuilder: (_, row) {
    //         int idx = row.index;
    //         return Switch(
    //           value: rows[idx].subscribe,
    //           onChanged: (value) {
    //             MqttQos qos = rows[idx].qos == 0
    //                 ? MqttQos.atMostOnce
    //                 : rows[idx].qos == 1
    //                     ? MqttQos.atLeastOnce
    //                     : MqttQos.exactlyOnce;
    //             String topicName = rows[idx].name;
    //             setState(() {
    //               if (realtimeConnectionState ==
    //                       RealtimeConnectionState.connected &&
    //                   topicName.isNotEmpty) {
    //                 rows[idx] = rows[idx].copyWith(subscribe: value);
    //                 _onFieldChange(selectedId!);
    //                 if (value) {
    //                   ref
    //                       .read(collectionStateNotifierProvider.notifier)
    //                       .subscribeTopic(topicName, qos);
    //                 } else {
    //                   ref
    //                       .read(collectionStateNotifierProvider.notifier)
    //                       .unsubscribeTopic(topicName);
    //                 }
    //               }
    //             });
    //           },
    //         );
    //         // return CheckBox(
    //         //   keyId: "$selectedId-$idx-subscribe-c-$seed",
    //         //   value: isRowEnabledList[idx],
    //         //   onChanged: (value) {
    //         //     isRowEnabledList[idx] = value!;
    //         //     _onFieldChange(selectedId!);
    //         //   },
    //         //   colorScheme: Theme.of(context).colorScheme,
    //         // );
    //       }),
    //   DaviColumn(
    //     name: 'Description',
    //     width: 10,
    //     grow: 1,
    //     cellBuilder: (_, row) {
    //       int idx = row.index;
    //       return CellField(
    //           keyId: "$selectedId-$idx-description-$seed",
    //           initialValue: rows[idx].description,
    //           hintText: "Add description",
    //           onChanged: (value) {
    //             setState(() {
    //               rows[idx] = rows[idx].copyWith(description: value);
    //             });
    //           },
    //           colorScheme: Theme.of(context).colorScheme);
    //     },
    //   )
    // ],
    // );
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
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  rows.add(kMQTTTopicEmptyModel);
                  nameControllers.add(TextEditingController());
                  descriptionControllers.add(TextEditingController());
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
