import 'package:apidash/consts.dart';

import 'request_summary_model.dart';

class CollectionModel {
  const CollectionModel({
    required this.id,
    required this.name,
    this.requests = const [],
  });

  final String id;
  final String name;
  final List<RequestSummary> requests;

  List<String> get requestIds => requests.map((r) => r.id).toList();

  CollectionModel copyWith({
    String? name,
    List<RequestSummary>? requests,
  }) {
    return CollectionModel(
      id: id,
      name: name ?? this.name,
      requests: requests ?? this.requests,
    );
  }

  factory CollectionModel.fromJson(Map<String, Object?> json) {
    final requestsJson = json[kWorkspaceRequestsKey];
    final requests = <RequestSummary>[];
    if (requestsJson is List) {
      for (final item in requestsJson) {
        if (item is Map) {
          requests.add(
            RequestSummary.fromJson(Map<String, Object?>.from(item)),
          );
        }
      }
    }
    return CollectionModel(
      id: json[kWorkspaceCollectionIdKey] as String? ?? '',
      name: json[kWorkspaceCollectionNameKey] as String? ?? '',
      requests: requests,
    );
  }

  Map<String, Object?> toJson() {
    return {
      kWorkspaceCollectionIdKey: id,
      kWorkspaceCollectionNameKey: name,
      kWorkspaceRequestsKey: requests.map((r) => r.toJson()).toList(),
    };
  }
}
