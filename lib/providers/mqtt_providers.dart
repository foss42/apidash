import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import '../services/mqtt_service.dart';
import '../models/mqtt_request_model.dart';
import '../services/mqtt_service.dart' show MQTTConnectionState;
import 'collection_providers.dart';

final mqttServiceProvider = Provider<MQTTService>((ref) {
  final service = MQTTService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

final mqttConnectionStateProvider = StreamProvider<MQTTConnectionState>((ref) {
  final mqttService = ref.watch(mqttServiceProvider);
  return mqttService.stateStream;
});

final mqttRequestProvider = StateProvider<MQTTRequestModel>((ref) {
  return kMQTTRequestEmptyModel;
});

final mqttTopicsProvider = StateProvider<List<MQTTTopicModel>>((ref) {
  final request = ref.watch(mqttRequestProvider);
  return request.topics;
});

final mqttMessagesProvider = StateProvider<List<MQTTMessage>>((ref) {
  final connectionState = ref.watch(mqttConnectionStateProvider);
  return connectionState.value?.messages ?? [];
});

// Provider to update RequestModel with MQTT state changes
final mqttStateUpdaterProvider = Provider((ref) {
  final mqttService = ref.watch(mqttServiceProvider);
  final collectionNotifier = ref.watch(collectionStateNotifierProvider.notifier);
  final selectedId = ref.watch(selectedIdStateProvider);
  
  // Listen to MQTT state changes and update the current RequestModel
  ref.listen(mqttConnectionStateProvider, (previous, next) {
    if (next.hasValue && selectedId != null) {
      final currentState = ref.read(collectionStateNotifierProvider);
      final currentModel = currentState?[selectedId];
      
      if (currentModel != null && currentModel.apiType == APIType.mqtt) {
        collectionNotifier.updateMQTTState(
          id: selectedId,
          mqttConnectionState: next.value,
        );
      }
    }
  });
  
  return mqttService;
}); 