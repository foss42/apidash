import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/models/protocols/mqtt_model.dart';

class EditMQTTTopics extends ConsumerStatefulWidget {
  const EditMQTTTopics({super.key});

  @override
  ConsumerState<EditMQTTTopics> createState() => EditMQTTTopicsState();
}

class EditMQTTTopicsState extends ConsumerState<EditMQTTTopics> {
  late int seed;
  final random = Random.secure();
  late List<NameValueModel> topicRows;
  late List<bool> isRowEnabledList;
  bool isAddingRow = false;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange() {
    final requestModel = ref.read(selectedRequestModelProvider);
    final mqttModel = requestModel?.protocolModel as MQTTRequestModel?;
    if (mqttModel != null) {
        ref.read(collectionStateNotifierProvider.notifier).update(
          protocolModel: mqttModel.copyWith(
            subscribedTopics: topicRows.sublist(0, topicRows.length - 1),
            isTopicEnabledList: isRowEnabledList.sublist(0, topicRows.length - 1),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref.watch(selectedRequestModelProvider);
    final mqttModel = requestModel?.protocolModel as MQTTRequestModel?;
    
    if (mqttModel == null) return kSizedBoxEmpty;

    final subTopics = mqttModel.subscribedTopics;
    bool isTopicsEmpty = subTopics.isEmpty;
    
    topicRows = isTopicsEmpty
        ? [kNameValueEmptyModel]
        : subTopics + [kNameValueEmptyModel];

    isRowEnabledList = [
      ...mqttModel.isTopicEnabledList,
    ];
    if (isRowEnabledList.length < subTopics.length) {
        isRowEnabledList.addAll(List.filled(subTopics.length - isRowEnabledList.length, true));
    }
    isRowEnabledList.add(false);
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text(kNameCheckbox),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text("Topic"),
      ),
      DataColumn2(
        label: Text(''),
        fixedWidth: 32,
      ),
    ];

    List<DataRow> dataRows = List<DataRow>.generate(
      topicRows.length,
      (index) {
        bool isLast = index + 1 == topicRows.length;
        return DataRow(
          key: ValueKey("$selectedId-$index-mqtt-topics-row-$seed"),
          cells: <DataCell>[
            DataCell(
              ADCheckBox(
                keyId: "$selectedId-$index-mqtt-topics-c-$seed",
                value: isRowEnabledList[index],
                onChanged: isLast
                    ? null
                    : (value) {
                        setState(() {
                          isRowEnabledList[index] = value!;
                        });
                        _onFieldChange();
                        
                        // Handle live subscription/unsubscription
                        if (requestModel?.isStreaming ?? false) {
                            if (value!) {
                                ref.read(collectionStateNotifierProvider.notifier).subscribeMqttTopic(selectedId!, topicRows[index].name, mqttModel.qos);
                            } else {
                                ref.read(collectionStateNotifierProvider.notifier).unsubscribeMqttTopic(selectedId!, topicRows[index].name);
                            }
                        }
                      },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              EnvCellField(
                keyId: "$selectedId-$index-mqtt-topics-k-$seed",
                initialValue: topicRows[index].name,
                hintText: "Add topic to subscribe...",
                onChanged: (value) {
                  final oldTopic = topicRows[index].name;
                  topicRows[index] = topicRows[index].copyWith(name: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    topicRows.add(kNameValueEmptyModel);
                    isRowEnabledList.add(false);
                  }
                  _onFieldChange();

                  // Handle live subscription change
                  if ((requestModel?.isStreaming ?? false) && isRowEnabledList[index]) {
                      if (oldTopic.isNotEmpty) {
                        ref.read(collectionStateNotifierProvider.notifier).unsubscribeMqttTopic(selectedId!, oldTopic);
                      }
                      if (value.isNotEmpty) {
                        ref.read(collectionStateNotifierProvider.notifier).subscribeMqttTopic(selectedId!, value, mqttModel.qos);
                      }
                  }
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
                        final topicToRemove = topicRows[index].name;
                        if (topicRows.length == 2) {
                          setState(() {
                            topicRows = [kNameValueEmptyModel];
                            isRowEnabledList = [false];
                          });
                        } else {
                          topicRows.removeAt(index);
                          isRowEnabledList.removeAt(index);
                        }
                        _onFieldChange();

                        if ((requestModel?.isStreaming ?? false) && topicToRemove.isNotEmpty) {
                             ref.read(collectionStateNotifierProvider.notifier).unsubscribeMqttTopic(selectedId!, topicToRemove);
                        }
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  setState(() {
                    topicRows.add(kNameValueEmptyModel);
                    isRowEnabledList.add(false);
                  });
                  _onFieldChange();
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  "Add Topic",
                  style: kTextStyleButton,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
