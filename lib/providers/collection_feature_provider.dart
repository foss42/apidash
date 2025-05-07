import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import '../screens/home_page/collection_pane.dart';
import 'providers.dart';
import '../models/models.dart';
import '../services/services.dart' show hiveHandler, HiveHandler;
import '../utils/utils.dart'
    show getNewUuid, collectionToHAR, substituteHttpRequestModel;



// Existing providers that should be defined elsewhere in the app
final collectionsProvider = StateNotifierProvider<CollectionsNotifier, List<Collection>>((ref) {
  return CollectionsNotifier();
});

class CollectionsNotifier extends StateNotifier<List<Collection>> {
  CollectionsNotifier() : super([]);

  void updateCollection(Collection updatedCollection) {
    final index = state.indexWhere((c) => c.id == updatedCollection.id);
    if (index >= 0) {
      final newList = List<Collection>.from(state);
      newList[index] = updatedCollection;
      state = newList;
    }
  }

  void addCollection(Collection collection) {
    state = [...state, collection];
  }

  void removeCollection(String id) {
    state = state.where((collection) => collection.id != id).toList();
  }
}