import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MqttConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

class MqttConnectionInfo {
  final MqttConnectionState state;
  final String? errorMessage;

  const MqttConnectionInfo({
    this.state = MqttConnectionState.disconnected,
    this.errorMessage,
  });

  MqttConnectionInfo copyWith({
    MqttConnectionState? state,
    String? errorMessage,
  }) {
    return MqttConnectionInfo(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final mqttConnectionProvider =
    StateProvider.family<MqttConnectionInfo, String>((ref, requestId) {
  return const MqttConnectionInfo();
});

class MqttMessagesNotifier extends StateNotifier<List<MqttMessageModel>> {
  MqttMessagesNotifier() : super([]);

  void addMessage(MqttMessageModel message) {
    state = [...state, message];
  }

  void clear() {
    state = [];
  }
}

final mqttMessagesProvider = StateNotifierProvider.family<MqttMessagesNotifier,
    List<MqttMessageModel>, String>((ref, requestId) {
  return MqttMessagesNotifier();
});

final mqttPublishTopicProvider =
    StateProvider.family<String, String>((ref, requestId) => "");

final mqttPublishQosProvider =
    StateProvider.family<MqttQos, String>((ref, requestId) => MqttQos.atMostOnce);

final mqttPublishRetainProvider =
    StateProvider.family<bool, String>((ref, requestId) => false);

final mqttPublishPayloadProvider =
    StateProvider.family<String, String>((ref, requestId) => "");

final mqttPublishContentTypeProvider =
    StateProvider.family<ContentType, String>(
        (ref, requestId) => ContentType.json);
