import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../widgets/mqtt/mqtt_connection_config.dart';
import 'mqtt_properties_table.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/mqtt_request_model.dart';
import 'package:apidash/services/mqtt_service.dart' show MQTTConnectionState;
import 'package:flutter/foundation.dart' show kIsMobile;
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:apidash_design_system/tokens/typography.dart';
import 'package:apidash/widgets/request_pane.dart';

class EditMQTTRequestPane extends ConsumerStatefulWidget {
  const EditMQTTRequestPane({super.key});

  @override
  ConsumerState<EditMQTTRequestPane> createState() => _EditMQTTRequestPaneState();
}

class _EditMQTTRequestPaneState extends ConsumerState<EditMQTTRequestPane> with SingleTickerProviderStateMixin {
  final clientIdController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final topicController = TextEditingController();
  final payloadController = TextEditingController();
  late TabController _tabController;
  String? _sendToTopic;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeControllers();
  }

  void _initializeControllers() {
    final selectedRequestModel = ref.read(selectedRequestModelProvider);
    final mqttModel = selectedRequestModel?.mqttRequestModel;
    if (mqttModel != null) {
      clientIdController.text = mqttModel.clientId;
      usernameController.text = mqttModel.username;
      passwordController.text = mqttModel.password;
    }
  }

  @override
  void dispose() {
    clientIdController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    topicController.dispose();
    payloadController.dispose();
    _tabController.dispose();
    super.dispose();
  }



  void _handlePublish() async {
    final selectedId = ref.read(selectedIdStateProvider);
    if (selectedId == null) {
      return;
    }

    final mqttService = ref.read(mqttServiceProvider);
    final mqttModel = ref.read(selectedRequestModelProvider)?.mqttRequestModel;
    
    final sendTopic = _selectedSendTopic(mqttModel?.topics ?? []);
    if (mqttModel == null || sendTopic == null || payloadController.text.isEmpty) {
      return;
    }

    try {
      final success = await mqttService.publish(
        sendTopic,
        payloadController.text,
        qos: 0,
        retain: false,
      );

      if (success) {
        // Update the MQTT state in RequestModel
        ref.read(collectionStateNotifierProvider.notifier).updateMQTTState(
          id: selectedId,
          mqttConnectionState: mqttService.currentState,
        );
        
        // Clear the form after successful publish
        topicController.clear();
        payloadController.clear();
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _addTopicRow() {
    final selectedId = ref.read(selectedIdStateProvider);
    if (selectedId != null) {
      final currentModel = ref.read(selectedRequestModelProvider);
      final topics = List<MQTTTopicModel>.from(currentModel?.mqttRequestModel?.topics ?? []);
      topics.add(const MQTTTopicModel(topic: '', qos: 0, subscribe: true));
      final updatedModel = currentModel!.mqttRequestModel!.copyWith(topics: topics);
      ref.read(collectionStateNotifierProvider.notifier).updateMQTTState(
        id: selectedId,
        mqttRequestModel: updatedModel,
      );
    }
  }

  void _updateTopicField(int index, {String? topic, int? qos, bool? subscribe, String? description}) {
    final selectedId = ref.read(selectedIdStateProvider);
    if (selectedId != null) {
      final currentModel = ref.read(selectedRequestModelProvider);
      final topics = List<MQTTTopicModel>.from(currentModel?.mqttRequestModel?.topics ?? []);
      final old = topics[index];
      final updated = old.copyWith(
        topic: topic ?? old.topic,
        qos: qos ?? old.qos,
        subscribe: subscribe ?? old.subscribe,
        description: description ?? old.description,
      );
      topics[index] = updated;
      final updatedModel = currentModel!.mqttRequestModel!.copyWith(topics: topics);
      ref.read(collectionStateNotifierProvider.notifier).updateMQTTState(
        id: selectedId,
        mqttRequestModel: updatedModel,
      );
      // Subscribe/unsubscribe immediately if connected, but do NOT disconnect
      final mqttService = ref.read(mqttServiceProvider);
      if (mqttService.isConnected && subscribe != null && subscribe != old.subscribe) {
        if (subscribe) {
          mqttService.subscribe(updated.topic, updated.qos);
        } else {
          mqttService.unsubscribe(updated.topic);
        }
      }
    }
  }

  void _removeTopic(int index) {
    final selectedId = ref.read(selectedIdStateProvider);
    if (selectedId != null) {
      final currentModel = ref.read(selectedRequestModelProvider);
      final topics = List<MQTTTopicModel>.from(currentModel?.mqttRequestModel?.topics ?? []);
      topics.removeAt(index);
      final updatedModel = currentModel!.mqttRequestModel!.copyWith(topics: topics);
      ref.read(collectionStateNotifierProvider.notifier).updateMQTTState(
        id: selectedId,
        mqttRequestModel: updatedModel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedRequestModel = ref.watch(selectedRequestModelProvider);
    final mqttState = selectedRequestModel?.mqttConnectionState;
    final mqttModel = selectedRequestModel?.mqttRequestModel;
    final isConnected = mqttState?.isConnected ?? false;
    final topics = mqttModel?.topics ?? [];

    // Consume the MQTT state updater provider to ensure state updates
    ref.watch(mqttStateUpdaterProvider);

    // Listen to MQTT state changes and update RequestModel
    ref.listen(mqttConnectionStateProvider, (previous, next) {
      if (next.hasValue && next.value != previous?.value) {
        final selectedId = ref.read(selectedIdStateProvider);
        if (selectedId != null) {
          ref.read(collectionStateNotifierProvider.notifier).updateMQTTState(
            id: selectedId,
            mqttConnectionState: next.value,
          );
        }
      }
    });

    return RequestPane(
      selectedId: ref.watch(selectedIdStateProvider),
      codePaneVisible: false, // MQTT does not have code view toggle
      tabIndex: _tabController.index,
      onTapTabBar: (index) {
        setState(() {
          _tabController.index = index;
        });
      },
      tabLabels: const [
        'Message',
        'Connection Configuration',
        'Properties',
      ],
      showIndicators: const [false, false, false],
      children: [
        // Message Tab
        Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Content Type Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Select Content Type: "),
                      DropdownButton<String>(
                        value: "json", 
                        items: const [
                          DropdownMenuItem(value: "json", child: Text("json")),
                          DropdownMenuItem(value: "text", child: Text("text")),
                        ],
                        onChanged: (val) {
                          // TODO: Handle content type change( in another PR content types were present thats why this dropdown is added)
                        },
                      ),
                      const SizedBox(width: 16),
                      // Send-to topic dropdown
                      DropdownButton<String>(
                        value: _selectedSendTopic(topics),
                        hint: const Text('Send to topic'),
                        items: topics.where((t) => t.subscribe).map((t) => DropdownMenuItem(
                          value: t.topic,
                          child: Text(t.topic),
                        )).toList(),
                        onChanged: (val) {
                          setState(() {
                            _sendToTopic = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Message Body Editor
                  TextField(
                    controller: payloadController,
                    decoration: const InputDecoration(
                      hintText: '{"name":"John", "age":30, "car":2}',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 6,
                    maxLines: 12,
                    enabled: isConnected,
                  ),
                  const SizedBox(height: 12),
                  // Connect/Disconnect and Send Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isConnected)
                        ElevatedButton(
                          onPressed: () {
                            ref.read(collectionStateNotifierProvider.notifier).sendRequest();
                          },
                          child: const Text('Connect'),
                        ),
                      if (isConnected)
                        ElevatedButton(
                          onPressed: () async {
                            final selectedId = ref.read(selectedIdStateProvider);
                            if (selectedId != null) {
                              final mqttService = ref.read(mqttServiceProvider);
                              await mqttService.disconnect();
                              ref.read(collectionStateNotifierProvider.notifier).updateMQTTState(
                                id: selectedId,
                                mqttConnectionState: mqttService.currentState,
                              );
                            }
                          },
                          child: const Text('Disconnect'),
                        ),
                      if (isConnected)
                        const SizedBox(width: 16),
                      if (isConnected)
                        ElevatedButton(
                          onPressed: _handlePublish,
                          child: const Text('Send'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: MQTTTopicsTable(
                      topics: topics,
                      onUpdate: _updateTopicField,
                      onAdd: _addTopicRow,
                      isMobile: kIsMobile,
                      onDelete: _removeTopic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Connection Configuration Tab
        Padding(
          padding: const EdgeInsets.all(8),
          child: MQTTConnectionConfig(
            clientIdController: clientIdController,
            usernameController: usernameController,
            passwordController: passwordController,
            isConnected: isConnected,
            onConnect: () {
              // Connect functionality
            },
            onDisconnect: () {
              // Disconnect functionality
            },
          ),
        ),
        // Properties Tab
        const Padding(
          padding: EdgeInsets.all(8),
          child: MQTTPropertiesTable(),
        ),
      ],
    );
  }


  String? _selectedSendTopic(List<MQTTTopicModel> topics) {
    if (_sendToTopic != null && topics.any((t) => t.topic == _sendToTopic && t.subscribe)) {
      return _sendToTopic;
    }
    final first = topics.firstWhere((t) => t.subscribe, orElse: () => const MQTTTopicModel(topic: ''));
    return first.topic.isNotEmpty ? first.topic : null;
  }
} 

class MQTTTopicsTable extends StatelessWidget {
  final List<MQTTTopicModel> topics;
  final void Function(int, {String? topic, int? qos, bool? subscribe, String? description}) onUpdate;
  final VoidCallback onAdd;
  final bool isMobile;
  final void Function(int) onDelete;

  const MQTTTopicsTable({
    super.key,
    required this.topics,
    required this.onUpdate,
    required this.onAdd,
    required this.isMobile,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: kPh10t10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(scrollbarTheme: kDataTableScrollbarTheme),
                  child: DataTable2(
                    columnSpacing: 12,
                    dividerThickness: 0,
                    horizontalMargin: 0,
                    headingRowHeight: 0,
                    dataRowHeight: kDataTableRowHeight,
                    bottomMargin: kDataTableBottomPadding,
                    isVerticalScrollBarVisible: true,
                    columns: const [
                      DataColumn2(label: Text('Topics')),
                      DataColumn2(label: Text('QoS'), fixedWidth: 60),
                      DataColumn2(label: Text('Subscribe'), fixedWidth: 90),
                      DataColumn2(label: Text('Description')),
                      DataColumn2(label: Text(''), fixedWidth: 32),
                    ],
                    rows: topics.isEmpty
                        ? [
                            const DataRow(cells: [
                              DataCell(Text('No topics configured')),
                              DataCell.empty,
                              DataCell.empty,
                              DataCell.empty,
                              DataCell.empty,
                            ]),
                          ]
                        : List<DataRow>.generate(
                            topics.length,
                            (index) {
                              final topic = topics[index];
                              return DataRow(
                                cells: [
                                  DataCell(
                                    TextFormField(
                                      initialValue: topic.topic,
                                      decoration: const InputDecoration(
                                        hintText: 'Topic',
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (val) => onUpdate(index, topic: val),
                                    ),
                                  ),
                                  DataCell(
                                    DropdownButton<int>(
                                      value: topic.qos,
                                      items: const [
                                        DropdownMenuItem(value: 0, child: Text('0')),
                                        DropdownMenuItem(value: 1, child: Text('1')),
                                        DropdownMenuItem(value: 2, child: Text('2')),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) onUpdate(index, qos: val);
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    Switch(
                                      value: topic.subscribe,
                                      onChanged: (val) => onUpdate(index, subscribe: val),
                                    ),
                                  ),
                                  DataCell(
                                    TextFormField(
                                      initialValue: topic.description,
                                      decoration: const InputDecoration(
                                        hintText: 'Add description',
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (val) => onUpdate(index, description: val),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () => onDelete(index),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ),
              if (!isMobile) kVSpacer40,
            ],
          ),
        ),
        if (!isMobile)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: kPb15,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Add Topics'),
              ),
            ),
          ),
      ],
    );
  }
} 