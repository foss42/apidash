import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_ce_flutter/adapters.dart';
class AgenticHistoryNotifier extends StateNotifier<Map<String, RequestModel>> {
  AgenticHistoryNotifier() : super({}) {
    _init();
  }

  void _init() {
    final box = Hive.box('internal_agent_history');
    final Map<String, RequestModel> items = {};

    for (final key in box.keys) {
      final val = box.get(key);
      if (val != null) {
        try {
          items[key.toString()] = RequestModel.fromJson(Map<String, dynamic>.from(val));
        } catch (_) {
          // Ignore malformed data
        }
      }
    }
    state = items;
  }

  void addRequest(RequestModel request) {
    state = {...state, request.id: request};
    Hive.box('internal_agent_history').put(request.id, request.toJson());
  }

  void addRequests(List<RequestModel> requests) {
    final Map<String, RequestModel> newItems = {};
    for (var req in requests) {
      newItems[req.id] = req;
    }

    // Update state once
    state = {...state, ...newItems};

    // Batch write to Hive to prevent UI stuttering
    final box = Hive.box('internal_agent_history');
    box.putAll(newItems.map((key, value) => MapEntry(key, value.toJson())));
  }

  void deleteRequest(String id) {
    final newState = Map<String, RequestModel>.from(state);
    newState.remove(id);
    state = newState;
    Hive.box('internal_agent_history').delete(id);
  }

  void clearAllHistory() {
    state = {};
    Hive.box('internal_agent_history').clear();
  }
}

/// Shared provider for the Agentic History collection
final agenticCollectionStateNotifierProvider =
StateNotifierProvider<AgenticHistoryNotifier, Map<String, RequestModel>>((ref) {
  return AgenticHistoryNotifier();
});

/// Shared provider for tracking the active selected request
final activeAgenticIdStateProvider = StateProvider<String?>((ref) => null);

final agenticHistoryGroupedProvider = Provider<Map<String, List<RequestModel>>>((ref) {
  final collection = ref.watch(agenticCollectionStateNotifierProvider);
  final grouped = <String, List<RequestModel>>{};

  for (final req in collection.values) {
    final parts = req.name.split('::');
    final groupName = parts.length > 1 ? parts[0] : 'Ungrouped AI Tests';
    final cleanReq = req.copyWith(name: parts.length > 1 ? parts.sublist(1).join('::') : req.name);

    grouped.putIfAbsent(groupName, () => []).add(cleanReq);
  }

  return grouped;
});