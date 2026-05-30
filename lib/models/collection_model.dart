import 'package:apidash/consts.dart';

class CollectionModel {
  const CollectionModel({
    required this.id,
    required this.name,
    this.requestIds = const [],
  });

  final String id;
  final String name;
  final List<String> requestIds;

  CollectionModel copyWith({
    String? name,
    List<String>? requestIds,
  }) {
    return CollectionModel(
      id: id,
      name: name ?? this.name,
      requestIds: requestIds ?? this.requestIds,
    );
  }

  factory CollectionModel.fromJson(Map<String, Object?> json) {
    final ids = json[kWorkspaceRequestIdsKey];
    return CollectionModel(
      id: json[kWorkspaceCollectionIdKey] as String? ?? '',
      name: json[kWorkspaceCollectionNameKey] as String? ?? '',
      requestIds: ids is List ? ids.map((e) => e.toString()).toList() : [],
    );
  }

  Map<String, Object?> toJson() {
    return {
      kWorkspaceCollectionIdKey: id,
      kWorkspaceCollectionNameKey: name,
      kWorkspaceRequestIdsKey: requestIds,
    };
  }
}
