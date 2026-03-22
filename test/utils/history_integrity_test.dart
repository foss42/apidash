dimport 'package:test/test.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/history_utils.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('History Integrity Tests', () {
    test('getTemporalGroups handles null timestamps with Epoch fallback', () {
      final models = [
        const HistoryMetaModel(
          historyId: 'h1',
          requestId: 'r1',
          url: 'https://api.apidash.dev',
          method: HTTPVerb.get,
          timeStamp: null, // Corrupted/Missing
        ),
      ];

      final groups = getTemporalGroups(models);
      
      // Should be grouped under Jan 1, 1970
      final epoch = DateTime.fromMillisecondsSinceEpoch(0);
      final epochKey = DateTime(epoch.year, epoch.month, epoch.day);
      
      expect(groups.containsKey(epochKey), isTrue);
      expect(groups[epochKey]!.length, 1);
      expect(groups[epochKey]!.first.historyId, 'h1');
    });

    test('getHistoryRequestKey handles null timestamp', () {
      final model = const HistoryMetaModel(
        historyId: 'h1',
        requestId: 'r1',
        url: 'https://api.apidash.dev',
        method: HTTPVerb.get,
        timeStamp: null,
      );

      // humanizeDate(null) returns ""
      final result = getHistoryRequestKey(model);
      expect(result, 'https://api.apidash.devget');
    });

    test('Sorting handles null timestamps by placing them at the bottom', () {
      final now = DateTime.now();
      final models = [
        HistoryMetaModel(
          historyId: 'h_old',
          timeStamp: null, // Will fallback to Epoch 0
        ),
        HistoryMetaModel(
          historyId: 'h_new',
          timeStamp: now,
        ),
      ];

      final groups = getTemporalGroups(models);
      
      // When grouped, they will be in different keys. 
      // But within a group, they are sorted.
      // Let's check sort across groups implicitly by getLatestRequestId
      final latestId = getLatestRequestId(groups);
      expect(latestId, 'h_new');
    });
  });
}
