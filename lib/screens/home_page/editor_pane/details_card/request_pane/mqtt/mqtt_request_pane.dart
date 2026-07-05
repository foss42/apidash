import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'mqtt_request_topics.dart';
import 'mqtt_user_properties.dart';

class EditMQTTRequestPane extends ConsumerStatefulWidget {
  const EditMQTTRequestPane({super.key, this.showViewCodeButton = true});

  final bool showViewCodeButton;

  @override
  ConsumerState<EditMQTTRequestPane> createState() =>
      _EditMQTTRequestPaneState();
}

class _EditMQTTRequestPaneState extends ConsumerState<EditMQTTRequestPane> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  /// Reads the LATEST mqttRequestModel inside the callback before writing.
  /// Never write a build-time-captured sub-model back to the notifier: it
  /// goes stale when non-watched fields change (e.g. a live broker appending
  /// to messageHistory) and would clobber them. Same convention as
  /// _WsConnectionSettings._updateWsModel in request_pane_ws.dart.
  void _updateMqttModel(MQTTRequestModel Function(MQTTRequestModel) updater) {
    final mqttModel = ref.read(selectedRequestModelProvider)?.mqttRequestModel;
    if (mqttModel == null) return;
    ref
        .read(collectionStateNotifierProvider.notifier)
        .update(mqttRequestModel: updater(mqttModel));
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref.watch(selectedRequestModelProvider);
    final mqttModel = requestModel?.mqttRequestModel;

    if (mqttModel == null) return kSizedBoxEmpty;

    // Progressive disclosure: the v5-only surfaces (User Properties tab,
    // Request/Response + Message Expiry on publish, Session Expiry seconds)
    // appear ONLY when MQTT 5.0 is selected, so v3 users never see the extra
    // clutter. The clean-session/persistent switch shows for BOTH versions
    // (one model field: v3 cleanSession = (sessionExpiryInterval == 0)).
    final isV5 = mqttModel.version == MQTTVersion.v5;

    // Sync controllers if model changes from outside (e.g. selection)
    if (_messageController.text != mqttModel.message) {
      _messageController.text = mqttModel.message;
    }

    final tabs = <Tab>[
      const Tab(text: "Message"),
      const Tab(text: "Topics"),
      if (isV5) const Tab(text: "Properties"),
      const Tab(text: "Auth"),
      const Tab(text: "Settings"),
    ];

    final views = <Widget>[
      _buildMessageTab(context, selectedId, requestModel, mqttModel, isV5),
      const EditMQTTTopics(),
      if (isV5) const EditMQTTUserProperties(),
      _buildAuthTab(selectedId, mqttModel),
      _buildSettingsTab(selectedId, mqttModel, isV5),
    ];

    return DefaultTabController(
      length: tabs.length,
      // ValueKey forces the controller to rebuild when v5 toggles the tab
      // count, avoiding a length/controller mismatch.
      key: ValueKey('mqtt-tabs-${isV5 ? 5 : 4}'),
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant,
            isScrollable: false,
            tabs: tabs,
          ),
          Expanded(child: TabBarView(children: views)),
        ],
      ),
    );
  }

  Widget _buildMessageTab(
    BuildContext context,
    String? selectedId,
    dynamic requestModel,
    MQTTRequestModel mqttModel,
    bool isV5,
  ) {
    return Padding(
      // Keyed per request so text fields re-seed from the selected request's
      // model on tab switch instead of showing the previous request's values.
      key: ValueKey("$selectedId-mqtt-message"),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Autocomplete<String>(
            initialValue: TextEditingValue(text: mqttModel.publishTopic),
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return mqttModel.subscribedTopics
                    .map((e) => e.name)
                    .where((e) => e.isNotEmpty);
              }
              return mqttModel.subscribedTopics
                  .map((e) => e.name)
                  .where(
                    (e) =>
                        e.isNotEmpty &&
                        e.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                  );
            },
            onSelected: (String selection) {
              _updateMqttModel((m) => m.copyWith(publishTopic: selection));
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  if (controller.text != mqttModel.publishTopic) {
                    controller.text = mqttModel.publishTopic;
                  }
                  return EnvironmentTriggerField(
                    keyId: "mqtt-publish-topic-$selectedId",
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: "Send to topic:",
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (val) {
                      _updateMqttModel((m) => m.copyWith(publishTopic: val));
                    },
                  );
                },
          ),
          kVSpacer20,
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: kCodeStyle,
              decoration: InputDecoration(
                hintText: "Enter message...",
                hintStyle: kCodeStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (val) {
                _updateMqttModel((m) => m.copyWith(message: val));
              },
            ),
          ),
          // ── v5-only: Request/Response + Message Expiry (collapsed) ──────
          if (isV5) _buildV5PublishOptions(mqttModel),
          kVSpacer20,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Retain"),
              Switch(
                value: mqttModel.retainMessage,
                onChanged: (val) {
                  _updateMqttModel((m) => m.copyWith(retainMessage: val));
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed:
                    (requestModel?.isStreaming ?? false) &&
                        selectedId != null &&
                        mqttModel.publishTopic.isNotEmpty
                    ? () {
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .sendMqttMessage(
                              selectedId,
                              _messageController.text,
                              mqttModel.publishTopic,
                            );
                      }
                    : null,
                child: const Text("Publish"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// v5-only publish options, tucked into a collapsed ExpansionTile so they
  /// stay out of the way until needed (one tap to reveal).
  Widget _buildV5PublishOptions(MQTTRequestModel mqttModel) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(
          "Request / Response & Expiry (v5)",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        children: [
          EnvAuthField(
            initialValue: mqttModel.responseTopic,
            hintText: "Topic the responder should reply to",
            title: "Response Topic",
            onChanged: (val) {
              _updateMqttModel((m) => m.copyWith(responseTopic: val));
            },
          ),
          kVSpacer8,
          EnvAuthField(
            initialValue: mqttModel.correlationData,
            hintText: "Opaque token to match request ↔ response",
            title: "Correlation Data",
            onChanged: (val) {
              _updateMqttModel((m) => m.copyWith(correlationData: val));
            },
          ),
          kVSpacer8,
          EnvAuthField(
            initialValue: mqttModel.messageExpiryInterval == 0
                ? ""
                : mqttModel.messageExpiryInterval.toString(),
            hintText: "0 / empty = no expiry",
            title: "Message Expiry Interval (seconds)",
            onChanged: (val) {
              final parsed = int.tryParse(val) ?? 0;
              _updateMqttModel(
                (m) => m.copyWith(messageExpiryInterval: parsed),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAuthTab(String? selectedId, MQTTRequestModel mqttModel) {
    return Padding(
      // Keyed per request: EnvAuthField only seeds its text in initState (and
      // won't re-sync when the new request's value is null), so without a
      // fresh subtree per request the previous request's username/password
      // would keep showing after a tab switch.
      key: ValueKey("$selectedId-mqtt-auth"),
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          EnvAuthField(
            initialValue: mqttModel.username,
            hintText: "Username",
            title: "Username",
            onChanged: (val) {
              _updateMqttModel((m) => m.copyWith(username: val));
            },
          ),
          EnvAuthField(
            initialValue: mqttModel.password,
            isObscureText: true,
            hintText: "Password",
            title: "Password",
            onChanged: (val) {
              _updateMqttModel((m) => m.copyWith(password: val));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(
    String? selectedId,
    MQTTRequestModel mqttModel,
    bool isV5,
  ) {
    return Padding(
      // Keyed per request: EnvAuthField only seeds its text in initState (and
      // won't re-sync when the new request's value is null), so without a
      // fresh subtree per request the previous request's Client ID would keep
      // showing after a tab switch.
      key: ValueKey("$selectedId-mqtt-settings"),
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // Row 1: Client ID & Port
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: EnvAuthField(
                  initialValue: mqttModel.clientId,
                  hintText: "Client ID",
                  title: "Client ID",
                  onChanged: (val) {
                    _updateMqttModel((m) => m.copyWith(clientId: val));
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: EnvAuthField(
                  initialValue: mqttModel.port.toString(),
                  hintText: "1883",
                  title: "Port",
                  onChanged: (val) {
                    final port = int.tryParse(val) ?? 1883;
                    _updateMqttModel((m) => m.copyWith(port: port));
                  },
                ),
              ),
            ],
          ),
          kVSpacer16,
          // Row 2: Keep Alive & Default QoS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EnvAuthField(
                  initialValue: mqttModel.keepAlivePeriod.toString(),
                  hintText: "60",
                  title: "Keep Alive (s)",
                  onChanged: (val) {
                    final parsed = int.tryParse(val) ?? 60;
                    _updateMqttModel(
                      (m) => m.copyWith(keepAlivePeriod: parsed),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: mqttModel.qos,
                  decoration: const InputDecoration(labelText: "Default QoS"),
                  items: [0, 1, 2]
                      .map(
                        (q) =>
                            DropdownMenuItem(value: q, child: Text("QoS $q")),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _updateMqttModel((m) => m.copyWith(qos: val));
                    }
                  },
                ),
              ),
            ],
          ),
          kVSpacer16,
          // Row 3: Session persistence. ONE model field serves both versions:
          // v3 connects with cleanSession == (sessionExpiryInterval == 0);
          // v5 additionally sends the interval as the broker-side session
          // retention time (the seconds field is v5-only).
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(isV5 ? "Clean Start" : "Clean Session"),
                  subtitle: const Text("Session ends on disconnect"),
                  value: mqttModel.sessionExpiryInterval == 0,
                  onChanged: (val) {
                    _updateMqttModel(
                      (m) => m.copyWith(sessionExpiryInterval: val ? 0 : 3600),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              if (isV5 && mqttModel.sessionExpiryInterval > 0)
                Expanded(
                  child: EnvAuthField(
                    initialValue: mqttModel.sessionExpiryInterval.toString(),
                    hintText: "3600",
                    title: "Session Expiry (s)",
                    onChanged: (val) {
                      final parsed = int.tryParse(val) ?? 0;
                      _updateMqttModel(
                        (m) => m.copyWith(sessionExpiryInterval: parsed),
                      );
                    },
                  ),
                )
              else
                const Spacer(),
            ],
          ),
          kVSpacer16,

          // Security / Transport Options
          ExpansionTile(
            title: const Text("Transport & Security"),
            initiallyExpanded: mqttModel.useTLS || mqttModel.useWebSocket,
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Use TLS"),
                subtitle: const Text("Encrypt the connection (TLS/SSL)"),
                value: mqttModel.useTLS,
                onChanged: (val) {
                  _updateMqttModel((m) {
                    int newPort = m.port;
                    if (val) {
                      if (newPort == 1883) {
                        newPort = 8883;
                      } else if (newPort == 8083) {
                        newPort = 8084;
                      }
                    } else {
                      if (newPort == 8883) {
                        newPort = 1883;
                      } else if (newPort == 8084) {
                        newPort = 8083;
                      }
                    }
                    return m.copyWith(useTLS: val, port: newPort);
                  });
                },
              ),
              if (mqttModel.useTLS)
                SwitchListTile(
                  contentPadding: const EdgeInsets.only(left: 16),
                  title: const Text("Allow Invalid Certificates"),
                  subtitle: const Text("Accept self-signed / untrusted certs"),
                  value: mqttModel.allowInvalidCertificates,
                  onChanged: (val) {
                    _updateMqttModel(
                      (m) => m.copyWith(allowInvalidCertificates: val),
                    );
                  },
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Use WebSocket"),
                subtitle: const Text("Tunnel MQTT over a WebSocket transport"),
                value: mqttModel.useWebSocket,
                onChanged: (val) {
                  _updateMqttModel((m) {
                    int newPort = m.port;
                    if (val) {
                      if (newPort == 1883) {
                        newPort = 8083;
                      } else if (newPort == 8883) {
                        newPort = 8084;
                      }
                    } else {
                      if (newPort == 8083) {
                        newPort = 1883;
                      } else if (newPort == 8084) {
                        newPort = 8883;
                      }
                    }
                    return m.copyWith(useWebSocket: val, port: newPort);
                  });
                },
              ),
              kVSpacer8,
            ],
          ),
          kVSpacer16,

          // LWT Options
          ExpansionTile(
            title: const Text("Last Will & Testament (LWT)"),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: EnvAuthField(
                      initialValue: mqttModel.willTopic,
                      hintText: "Will Topic",
                      title: "Will Topic",
                      onChanged: (val) {
                        _updateMqttModel((m) => m.copyWith(willTopic: val));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: EnvAuthField(
                      initialValue: mqttModel.willMessage,
                      hintText: "Will Message",
                      title: "Will Message",
                      onChanged: (val) {
                        _updateMqttModel((m) => m.copyWith(willMessage: val));
                      },
                    ),
                  ),
                ],
              ),
              kVSpacer8,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: mqttModel.willQos,
                      decoration: const InputDecoration(labelText: "Will QoS"),
                      items: [0, 1, 2]
                          .map(
                            (q) => DropdownMenuItem(
                              value: q,
                              child: Text("QoS $q"),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          _updateMqttModel((m) => m.copyWith(willQos: val));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Retain Will"),
                      value: mqttModel.willRetain,
                      onChanged: (val) {
                        _updateMqttModel((m) => m.copyWith(willRetain: val));
                      },
                    ),
                  ),
                ],
              ),
              kVSpacer8,
            ],
          ),
          kVSpacer16,
        ],
      ),
    );
  }
}
