import 'dart:async';

import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

/// Provider-level write-path test for gRPC app-level History.
///
/// DETERMINISTIC and OFFLINE. The gRPC history record is created SYNCHRONOUSLY
/// at the start of the gRPC branch of `sendRequest()` (via `addHistoryRequest`)
/// BEFORE the first `await` that drives `_connectGrpc`. So `sendRequest()` is
/// invoked WITHOUT `await`: the synchronous slice mutates
/// `historyMetaStateNotifier` and we assert on that immediately, never waiting
/// on (or depending on) the real connect.
///
/// The target host is unreachable (`localhost:1`) so any downstream connect
/// attempt fails fast. That attempt runs in the background after our
/// assertions; its stream callbacks can fire after the container is disposed
/// ("Tried to use CollectionStateNotifier after dispose"). To keep the test
/// deterministic we (a) run the send inside a guarded zone that swallows those
/// late connect errors, and (b) terminate the channel and briefly flush the
/// event loop while the notifier is still mounted.
const kUnreachableGrpcUrl = 'localhost:1';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
    // Start every test from a clean history so the grpc meta we assert on is
    // unambiguous.
    await hiveHandler.clearAllHistory();
  });

  tearDown(() async {
    ConnectionManager.instance.disconnectAll();
  });

  group('sendRequest() gRPC branch writes app-level history', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;
    late String id;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
      id = notifier.state!.entries.first.key;
      // Switch the request to gRPC (installs a fresh const GrpcRequestModel()),
      // then set the target url + a service/method in a second update call.
      notifier.update(id: id, apiType: APIType.grpc);
      notifier.update(
        id: id,
        grpcRequestModel: const GrpcRequestModel(
          url: kUnreachableGrpcUrl,
          service: 'GreeterService',
          method: 'SayHello',
        ),
      );
      // sendRequest reads selectedIdStateProvider.
      container.read(selectedIdStateProvider.notifier).state = id;
    });

    /// Kicks off `sendRequest()` inside a guarded zone (so late errors from the
    /// unreachable background connect are swallowed), then terminates the
    /// channel and flushes the event loop while the notifier is still mounted.
    Future<void> sendAndSettle() async {
      await runZonedGuarded(
        () async {
          // Fire-and-forget: the history record is created in the synchronous
          // slice of sendRequest, before the first await.
          // ignore: unawaited_futures
          notifier.sendRequest();
          // Tear the (unreachable) connection down and let any pending stream
          // callbacks run while the notifier is still mounted.
          ConnectionManager.instance.disconnectGrpc(id);
          await Future.delayed(const Duration(milliseconds: 200));
        },
        (error, stack) {
          // Swallow late async errors from the real (unreachable) connect
          // attempt, e.g. "Tried to use CollectionStateNotifier after dispose".
        },
      );
    }

    test(
      'a HistoryMetaModel with apiType == APIType.grpc is added synchronously',
      () async {
        // No gRPC history before send.
        final before = container.read(historyMetaStateNotifier);
        expect(
          (before?.values ?? []).where((m) => m.apiType == APIType.grpc),
          isEmpty,
        );

        await runZonedGuarded(() async {
          // ignore: unawaited_futures
          notifier.sendRequest();

          // Assert on the SYNCHRONOUS slice immediately (no await in between).
          final metas = container.read(historyMetaStateNotifier);
          expect(metas, isNotNull);
          final grpcMetas = metas!.values
              .where((m) => m.apiType == APIType.grpc)
              .toList();
          expect(
            grpcMetas.length,
            1,
            reason: 'exactly one gRPC history meta should be recorded',
          );
          final meta = grpcMetas.single;
          expect(meta.apiType, APIType.grpc);
          expect(meta.url, kUnreachableGrpcUrl);
          expect(meta.requestId, id);

          // Settle the background connect while still mounted.
          ConnectionManager.instance.disconnectGrpc(id);
          await Future.delayed(const Duration(milliseconds: 200));
        }, (error, stack) {});
      },
    );

    test(
      'the persisted HistoryRequestModel carries a non-null grpcRequestModel',
      () async {
        await sendAndSettle();

        // Grab the recorded meta to learn the historyId.
        final metas = container.read(historyMetaStateNotifier)!;
        final meta = metas.values.firstWhere((m) => m.apiType == APIType.grpc);

        // The full model is written to Hive inside addHistoryRequest; read it
        // back directly (deterministic, offline).
        final storedJson = await hiveHandler.getHistoryRequest(meta.historyId);
        expect(storedJson, isNotNull);

        final stored = HistoryRequestModel.fromJson(
          Map<String, Object?>.from(storedJson as Map),
        );

        expect(stored.metaData.apiType, APIType.grpc);
        expect(stored.grpcRequestModel, isNotNull);
        expect(stored.grpcRequestModel!.url, kUnreachableGrpcUrl);
        expect(stored.grpcRequestModel!.service, 'GreeterService');
        expect(stored.grpcRequestModel!.method, 'SayHello');
        // Sibling protocol models are absent.
        expect(stored.httpRequestModel, isNull);
        expect(stored.wsRequestModel, isNull);
      },
    );
  });
}
