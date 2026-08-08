import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'mqtt_help_icon.dart';

/// MQTT v5 User Properties editor.
///
/// A key/value table (the same idiom as HTTP/WS headers and the MQTT Topics
/// tab) for the v5 User Properties attached to CONNECT and PUBLISH packets.
/// Shown only when the request is MQTT 5.0 (gated by the caller), so v3 users
/// never see it.
class EditMQTTUserProperties extends ConsumerStatefulWidget {
  const EditMQTTUserProperties({super.key});

  @override
  ConsumerState<EditMQTTUserProperties> createState() =>
      _EditMQTTUserPropertiesState();
}

class _EditMQTTUserPropertiesState
    extends ConsumerState<EditMQTTUserProperties> {
  late int seed;
  final random = Random.secure();
  late List<NameValueModel> rows;
  late List<bool> isRowEnabledList;
  bool isAddingRow = false;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange() {
    final mqttModel = ref.read(selectedRequestModelProvider)?.mqttRequestModel;
    if (mqttModel != null) {
      ref
          .read(collectionStateNotifierProvider.notifier)
          .update(
            mqttRequestModel: mqttModel.copyWith(
              userProperties: rows.sublist(0, rows.length - 1),
              isUserPropertyEnabledList: isRowEnabledList.sublist(
                0,
                rows.length - 1,
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedIdStateProvider);
    final mqttModel = ref.watch(selectedRequestModelProvider)?.mqttRequestModel;

    if (mqttModel == null) return kSizedBoxEmpty;

    final props = mqttModel.userProperties;
    final isEmpty = props.isEmpty;

    rows = isEmpty ? [kNameValueEmptyModel] : props + [kNameValueEmptyModel];

    isRowEnabledList = [...mqttModel.isUserPropertyEnabledList];
    if (isRowEnabledList.length < props.length) {
      isRowEnabledList.addAll(
        List.filled(props.length - isRowEnabledList.length, true),
      );
    }
    isRowEnabledList.add(false);
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(label: SizedBox.shrink(), fixedWidth: 30),
      DataColumn2(
        label: Row(
          children: [
            Text("Key"),
            MqttHelpIcon("Extra custom labels you can attach to a message."),
          ],
        ),
      ),
      DataColumn2(label: Text("Value")),
      DataColumn2(label: Text(''), fixedWidth: 32),
    ];

    List<DataRow> dataRows = List<DataRow>.generate(rows.length, (index) {
      bool isLast = index + 1 == rows.length;
      return DataRow(
        key: ValueKey("$selectedId-$index-mqtt-userprop-row-$seed"),
        cells: <DataCell>[
          DataCell(
            ADCheckBox(
              keyId: "$selectedId-$index-mqtt-userprop-c-$seed",
              value: isRowEnabledList[index],
              onChanged: isLast
                  ? null
                  : (value) {
                      setState(() => isRowEnabledList[index] = value!);
                      _onFieldChange();
                    },
              colorScheme: Theme.of(context).colorScheme,
            ),
          ),
          DataCell(
            EnvCellField(
              keyId: "$selectedId-$index-mqtt-userprop-k-$seed",
              initialValue: rows[index].name,
              hintText: "Add Key...",
              onChanged: (value) {
                rows[index] = rows[index].copyWith(name: value);
                if (isLast && !isAddingRow) {
                  isAddingRow = true;
                  rows.add(kNameValueEmptyModel);
                  isRowEnabledList.add(false);
                }
                _onFieldChange();
              },
              colorScheme: Theme.of(context).colorScheme,
            ),
          ),
          DataCell(
            EnvCellField(
              keyId: "$selectedId-$index-mqtt-userprop-v-$seed",
              initialValue: rows[index].value?.toString(),
              hintText: "Add Value...",
              onChanged: (value) {
                rows[index] = rows[index].copyWith(value: value);
                if (isLast && !isAddingRow) {
                  isAddingRow = true;
                  rows.add(kNameValueEmptyModel);
                  isRowEnabledList.add(false);
                }
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
                      if (rows.length == 2) {
                        setState(() {
                          rows = [kNameValueEmptyModel];
                          isRowEnabledList = [false];
                        });
                      } else {
                        rows.removeAt(index);
                        isRowEnabledList.removeAt(index);
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
    });

    return Stack(
      children: [
        Container(
          margin: kPh10t10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(scrollbarTheme: kDataTableScrollbarTheme),
                  child: DataTable2(
                    columnSpacing: 12,
                    dividerThickness: 0,
                    horizontalMargin: 0,
                    headingRowHeight: kDataTableRowHeight,
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
                    rows.add(kNameValueEmptyModel);
                    isRowEnabledList.add(false);
                  });
                  _onFieldChange();
                },
                icon: const Icon(Icons.add),
                label: const Text("Add User Property", style: kTextStyleButton),
              ),
            ),
          ),
      ],
    );
  }
}
