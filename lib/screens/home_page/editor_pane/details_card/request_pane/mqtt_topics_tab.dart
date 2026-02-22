import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import '../../../../common_widgets/common_widgets.dart';

class MqttTopicsTab extends ConsumerStatefulWidget {
  const MqttTopicsTab({super.key});

  @override
  ConsumerState<MqttTopicsTab> createState() => _MqttTopicsTabState();
}

class _MqttTopicsTabState extends ConsumerState<MqttTopicsTab> {
  late int seed;
  final random = Random.secure();
  late List<MqttTopicModel> topicRows;
  bool isAddingRow = false;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange() {
    ref.read(collectionStateNotifierProvider.notifier).update(
          mqttRequestModel: ref
              .read(selectedRequestModelProvider)
              ?.mqttRequestModel
              ?.copyWith(
                topics: topicRows.sublist(0, topicRows.length - 1),
              ),
        );
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.mqttRequestModel?.topics.length));
    var topics =
        ref.read(selectedRequestModelProvider)?.mqttRequestModel?.topics;
    bool isTopicsEmpty = topics == null || topics.isEmpty;
    topicRows = isTopicsEmpty
        ? [kMqttTopicEmptyModel]
        : topics + [kMqttTopicEmptyModel];
    isAddingRow = false;

    final connectionInfo = selectedId != null
        ? ref.watch(mqttConnectionProvider(selectedId))
        : null;
    final isConnected =
        connectionInfo?.state == MqttConnectionState.connected;

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text(kLabelTopic),
      ),
      DataColumn2(
        label: Text(kLabelQos),
        fixedWidth: 80,
      ),
      DataColumn2(
        label: Text(kLabelSubscribe),
        fixedWidth: 80,
      ),
      DataColumn2(
        label: Text(kLabelDescription),
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
        final topicModel = topicRows[index];
        final manager = selectedId != null
            ? MqttClientManager.getOrCreate(selectedId)
            : null;
        final isSubscribed =
            manager?.subscribedTopics.contains(topicModel.topic) ?? false;

        return DataRow(
          key: ValueKey("$selectedId-$index-topics-row-$seed"),
          cells: <DataCell>[
            DataCell(
              EnvCellField(
                keyId: "$selectedId-$index-topic-k-$seed",
                initialValue: topicModel.topic,
                hintText: kHintAddTopic,
                onChanged: (value) {
                  topicRows[index] =
                      topicRows[index].copyWith(topic: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    topicRows.add(kMqttTopicEmptyModel);
                  }
                  _onFieldChange();
                },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              DropdownButton<MqttQos>(
                value: topicModel.qos,
                isExpanded: true,
                underline: kSizedBoxEmpty,
                items: MqttQos.values
                    .map((q) => DropdownMenuItem(
                          value: q,
                          child: Text(q.label,
                              style: kCodeStyle.copyWith(fontSize: 12)),
                        ))
                    .toList(),
                onChanged: isLast
                    ? null
                    : (value) {
                        if (value != null) {
                          topicRows[index] =
                              topicRows[index].copyWith(qos: value);
                          _onFieldChange();
                        }
                      },
              ),
            ),
            DataCell(
              Center(
                child: Switch(
                  value: isSubscribed,
                  onChanged: isLast || !isConnected
                      ? null
                      : (value) {
                          if (value) {
                            ref
                                .read(
                                    collectionStateNotifierProvider.notifier)
                                .subscribeMqttTopic(
                                    topicModel.topic, topicModel.qos);
                          } else {
                            ref
                                .read(
                                    collectionStateNotifierProvider.notifier)
                                .unsubscribeMqttTopic(topicModel.topic);
                          }
                          setState(() {});
                        },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            DataCell(
              EnvCellField(
                keyId: "$selectedId-$index-topic-desc-$seed",
                initialValue: topicModel.description,
                hintText: "Description",
                onChanged: isLast
                    ? null
                    : (value) {
                        topicRows[index] =
                            topicRows[index].copyWith(description: value);
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
                        if (topicRows.length == 2) {
                          setState(() {
                            topicRows = [kMqttTopicEmptyModel];
                          });
                        } else {
                          topicRows.removeAt(index);
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
                    headingRowHeight: 32,
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
                  topicRows.add(kMqttTopicEmptyModel);
                  _onFieldChange();
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  kLabelAddTopic,
                  style: kTextStyleButton,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
