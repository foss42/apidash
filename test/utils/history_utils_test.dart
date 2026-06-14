import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/utils/history_utils.dart';

import '../models/history_models.dart';

void main() {
  group('Testing getRequestModelFromHistoryModel function', () {
    test('returns correct RequestModel', () {
      final model = HistoryRequestModel(
        historyId: 'h1',
        metaData: historyMetaModel1,
        httpRequestModel: const HttpRequestModel(),
        httpResponseModel: const HttpResponseModel(statusCode: 200),
      );
      final result = getRequestModelFromHistoryModel(model);
      expect(result.id, 'h1');
      expect(result.apiType, APIType.rest);
      expect(result.responseStatus, 200);
      expect(result.message, kResponseCodeReasons[200]);
    });
  });

  group('Testing getHistoryRequestName function', () {
    test('returns name when name is not empty', () {
      final model = historyMetaModel1.copyWith(name: 'Social');
      final result = getHistoryRequestName(model);
      expect(result, 'Social');
    });

    test('returns url when name is empty', () {
      final model = historyMetaModel1;
      final result = getHistoryRequestName(model);
      expect(result, 'https://api.apidash.dev/humanize/social');
    });
  });
  group('Testing getHistoryRequestKey function', () {
    test('returns name + method + timestamp when name is not empty', () {
      final model = historyMetaModel1.copyWith(name: 'Social');

      final result = getHistoryRequestKey(model);
      expect(result, 'SocialgetJanuary 1, 2024');
    });

    test('returns url + method + timestamp when name is empty', () {
      final model = historyMetaModel1;

      final result = getHistoryRequestKey(model);
      expect(
          result, 'https://api.apidash.dev/humanize/socialgetJanuary 1, 2024');
    });
  });

  group('Testing getLatestRequestId function', () {
    test('returns null when temporalGroups is empty', () {
      final result = getLatestRequestId({});
      expect(result, isNull);
    });

    test('returns correct historyId for latest group', () {
      final d1 = DateTime(2024, 1, 1);
      final d2 = DateTime(2024, 1, 2);
      final groups = {
        d1: [historyMetaModel1],
        d2: [historyMetaModel2],
      };
      final result = getLatestRequestId(groups);
      expect(result, historyMetaModel2.historyId);
    });
  });

  group('Testing getDateTimeKey function', () {
    test('returns currentKey when keys is empty', () {
      final now = DateTime.now();
      final currentKey = DateTime(now.year, now.month, now.day);
      final result = getDateTimeKey([], currentKey);
      expect(result, currentKey);
    });

    test('returns currentKey when keys does not contain currentKey', () {
      final now = DateTime.now();
      final currentKey = DateTime(now.year, now.month, now.day);
      final keys = [DateTime(2024, 1, 1), DateTime(2024, 1, 2)];

      final result = getDateTimeKey(keys, currentKey);
      expect(result, currentKey);
    });

    test('returns currentKey when keys contains currentKey', () {
      final currentKey = DateTime(2024, 1, 1);
      final keys = [DateTime(2024, 1, 1), DateTime(2024, 1, 2)];

      final result = getDateTimeKey(keys, currentKey);
      expect(result, currentKey);
    });
  });

  group('Testing getTemporalGroups function', () {
    test('returns empty map when models is null', () {
      final result = getTemporalGroups(null);
      expect(result, isEmpty);
    });

    test('returns empty map when models is empty', () {
      final result = getTemporalGroups([]);
      expect(result, isEmpty);
    });

    test('groups models correctly', () {
      final t1 = DateTime(2024, 1, 1, 10);
      final t2 = DateTime(2024, 1, 1, 12);
      final t3 = DateTime(2024, 1, 2, 10);

      final m1 = historyMetaModel1.copyWith(timeStamp: t1);
      final m2 = historyMetaModel1.copyWith(timeStamp: t2);
      final m3 = historyMetaModel1.copyWith(timeStamp: t3);

      final result = getTemporalGroups([m1, m2, m3]);
      expect(result.length, 2);
      expect(result[DateTime(2024, 1, 1)]!.length, 2);
      expect(result[DateTime(2024, 1, 2)]!.length, 1);
      
      // Should be sorted descending by timestamp
      expect(result[DateTime(2024, 1, 1)]![0], m2);
      expect(result[DateTime(2024, 1, 1)]![1], m1);
    });
  });

  group('Testing getRequestGroups function', () {
    test('returns empty map when models is null', () {
      final result = getRequestGroups(null);
      expect(result, isEmpty);
    });

    test('returns empty map when models is empty', () {
      final result = getRequestGroups([]);
      expect(result, isEmpty);
    });

    test('groups models by request key and sorts by timestamp', () {
      final models = [
        historyMetaModel1,
        historyMetaModel1.copyWith(
            historyId: 'historyId1-1',
            timeStamp:
                historyMetaModel1.timeStamp.add(const Duration(seconds: 1))),
        historyMetaModel1.copyWith(
            historyId: 'historyId1-2',
            timeStamp:
                historyMetaModel1.timeStamp.add(const Duration(seconds: 2))),
        historyMetaModel2,
        historyMetaModel2.copyWith(
            historyId: 'historyId2-1',
            timeStamp:
                historyMetaModel2.timeStamp.add(const Duration(seconds: 1))),
        historyMetaModel2.copyWith(
            historyId: 'historyId2-2',
            timeStamp:
                historyMetaModel2.timeStamp.add(const Duration(seconds: 2))),
      ];

      final result = getRequestGroups(models);
      expect(result.keys.length, 2);

      expect(result.values.toList()[0].length, 3);
      expect(result.values.toList()[1].length, 3);

      result.forEach((key, value) {
        for (int i = 0; i < value.length - 1; i++) {
          expect(value[i].timeStamp.isAfter(value[i + 1].timeStamp), isTrue);
        }
      });
    });
  });

  group('Testing getRequestGroup function', () {
    test('returns empty list when models is null', () {
      final result = getRequestGroup(null, historyMetaModel1);
      expect(result, isEmpty);
    });

    test('returns empty list when models is empty', () {
      final result = getRequestGroup([], historyMetaModel1);
      expect(result, isEmpty);
    });

    test('returns empty list when selectedModel is null', () {
      final result = getRequestGroup([historyMetaModel1], null);
      expect(result, isEmpty);
    });

    test('returns empty list when selectedModel is not in models', () {
      final result = getRequestGroup([historyMetaModel1], historyMetaModel2);
      expect(result, isEmpty);
    });

    test(
        'returns list of models with same request key as selectedModel and sorted',
        () {
      final models = [
        historyMetaModel1,
        historyMetaModel1.copyWith(
            historyId: 'historyId1-1',
            timeStamp:
                historyMetaModel1.timeStamp.add(const Duration(seconds: 1))),
        historyMetaModel1.copyWith(
            historyId: 'historyId1-2',
            timeStamp:
                historyMetaModel1.timeStamp.add(const Duration(seconds: 2))),
        historyMetaModel2,
        historyMetaModel2.copyWith(
            historyId: 'historyId2-1',
            timeStamp:
                historyMetaModel2.timeStamp.add(const Duration(seconds: 1))),
        historyMetaModel2.copyWith(
            historyId: 'historyId2-2',
            timeStamp:
                historyMetaModel2.timeStamp.add(const Duration(seconds: 2))),
      ];

      final result = getRequestGroup(models, models[1]);
      expect(result.length, 3);

      for (int i = 0; i < result.length - 1; i++) {
        expect(result[i].timeStamp.isAfter(result[i + 1].timeStamp), isTrue);
      }
    });
  });

  group('Testing getRetentionDate functon', () {
    test('HistoryRetentionPeriod oneWeek', () {
      final result = getRetentionDate(HistoryRetentionPeriod.oneWeek);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final expected = today.subtract(const Duration(days: 7));
      expect(result, expected);
    });

    test('HistoryRetentionPeriod oneMonth', () {
      final result = getRetentionDate(HistoryRetentionPeriod.oneMonth);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final expected = today.subtract(const Duration(days: 30));
      expect(result, expected);
    });

    test('HistoryRetentionPeriod threeMonths', () {
      final result = getRetentionDate(HistoryRetentionPeriod.threeMonths);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final expected = today.subtract(const Duration(days: 90));
      expect(result, expected);
    });

    test('HistoryRetentionPeriod forever', () {
      final result = getRetentionDate(HistoryRetentionPeriod.forever);
      expect(result, null);
    });
  });
}
