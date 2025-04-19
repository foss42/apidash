import 'package:apidash_core/apidash_core.dart';



class Collection {
  final String id;
  final String name;
  final List<String> requests;


  Collection({
    required this.id,
    required this.name,
    this.requests = const [],
  });

  // Creates a new Collection instance with specific properties changed while preserving all other existing values
  Collection copyWith({
    String? id,
    String? name,
    List<String>? requests,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      requests: requests ?? this.requests,
    );
  }
}