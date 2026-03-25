import 'package:apidash_core/apidash_core.dart';

class RequestPatchApplier {
  /// Applies a set of property patches to a base HttpRequestModel
  static HttpRequestModel apply(HttpRequestModel baseRequest, Map<String, dynamic> patch) {
    if (patch.isEmpty) return baseRequest;
    
    // Start with a clone of the base request
    var patchedRequest = baseRequest;

    if (patch.containsKey('url')) {
      patchedRequest = patchedRequest.copyWith(url: patch['url'] as String);
    }

    if (patch.containsKey('body')) {
      patchedRequest = patchedRequest.copyWith(body: patch['body'] as String);
    }

    if (patch.containsKey('headers')) {
      final patchHeaders = Map<String, dynamic>.from(patch['headers'] as Map);
      final existingModels = baseRequest.headers ?? const <NameValueModel>[];
      final List<NameValueModel> updatedHeaders = [];

      // Evaluate existing headers against the patch
      for (final header in existingModels) {
        if (patchHeaders.containsKey(header.name)) {
          final newValue = patchHeaders[header.name];
          if (newValue != null) {
            // Modify existing header
            updatedHeaders.add(header.copyWith(value: newValue.toString()));
          }
          // Remove from tracking map so we don't double-add
          patchHeaders.remove(header.name);
        } else {
          // Keep untouched header
          updatedHeaders.add(header);
        }
      }

      // Add any remaining completely new headers
      patchHeaders.forEach((key, value) {
        if (value != null) {
          updatedHeaders.add(NameValueModel(name: key, value: value.toString()));
        }
      });

      patchedRequest = patchedRequest.copyWith(headers: updatedHeaders);
    }

    if (patch.containsKey('upsertHeaders')) {
      final toUpsert =
          Map<String, String>.from(patch['upsertHeaders'] as Map);
      final existing =
          List<NameValueModel>.from(patchedRequest.headers ?? []);
      final existingEnabled =
          List<bool>.from(patchedRequest.isHeaderEnabledList ?? []);

      for (final entry in toUpsert.entries) {
        final idx = existing.indexWhere(
            (h) => h.name.toLowerCase() == entry.key.toLowerCase());
        if (idx >= 0) {
          existing[idx] = existing[idx].copyWith(value: entry.value);
        } else {
          existing.add(NameValueModel(name: entry.key, value: entry.value));
          existingEnabled.add(true);
        }
      }
      patchedRequest = patchedRequest.copyWith(
        headers: existing,
        isHeaderEnabledList: existingEnabled,
      );
    }

    return patchedRequest;
  }
}