import 'dart:async';

import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../consts.dart';
import '../models/models.dart';
import 'collection_providers.dart';
import 'collections_providers.dart';
import 'environment_providers.dart';
import 'ui_providers.dart';

final autoSaveNotifierProvider =
    NotifierProvider<AutoSaveNotifier, void>(AutoSaveNotifier.new);

/// Debounces workspace persistence after collection/environment mutations.
class AutoSaveNotifier extends Notifier<void> {
  Timer? _timer;

  @override
  void build() {
    void onWorkspaceDataChanged() {
      if (ref.read(saveDataStateProvider)) {
        return;
      }
      _schedule();
    }

    ref.listen<Map<String, RequestModel>?>(
      collectionStateNotifierProvider,
      (previous, next) {
        if (previous == null) {
          return;
        }
        onWorkspaceDataChanged();
      },
    );

    ref.listen<Map<String, EnvironmentModel>?>(
      environmentsStateNotifierProvider,
      (previous, next) {
        if (previous == null) {
          return;
        }
        onWorkspaceDataChanged();
      },
    );

    ref.listen<Map<String, CollectionModel>?>(
      collectionsStateNotifierProvider,
      (previous, next) {
        if (previous == null) {
          return;
        }
        onWorkspaceDataChanged();
      },
    );

    ref.listen<List<String>>(collectionSequenceProvider, (previous, next) {
      if (previous == null) {
        return;
      }
      onWorkspaceDataChanged();
    });

    ref.listen<List<String>>(requestSequenceProvider, (previous, next) {
      if (previous == null) {
        return;
      }
      onWorkspaceDataChanged();
    });

    ref.listen<List<String>>(environmentSequenceProvider, (previous, next) {
      if (previous == null) {
        return;
      }
      onWorkspaceDataChanged();
    });

    ref.onDispose(() {
      _timer?.cancel();
    });
  }

  void cancelPending() {
    _timer?.cancel();
    _timer = null;
  }

  void _schedule() {
    ref.read(hasUnsavedChangesProvider.notifier).state = true;
    _timer?.cancel();
    _timer = Timer(kAutoSaveDebounceDuration, () {
      unawaited(_flush());
    });
  }

  Future<void> _flush() async {
    cancelPending();
    if (!ref.read(hasUnsavedChangesProvider)) {
      return;
    }
    if (ref.read(saveDataStateProvider)) {
      return;
    }
    await ref.read(collectionStateNotifierProvider.notifier).saveData();
    await ref.read(collectionsStateNotifierProvider.notifier).saveCollections();
    await ref.read(environmentsStateNotifierProvider.notifier).saveEnvironments();
  }
}
