class MemoryEntry {
  final String id;
  final String ruleType;
  final String note;
  final DateTime createdAt;
  final bool isVerified;

  const MemoryEntry({
    required this.id,
    required this.ruleType,
    required this.note,
    required this.createdAt,
    this.isVerified = false,
  });

  MemoryEntry copyWith({
    String? id,
    String? ruleType,
    String? note,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return MemoryEntry(
      id: id ?? this.id,
      ruleType: ruleType ?? this.ruleType,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ruleType': ruleType,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
    };
  }

  factory MemoryEntry.fromJson(Map<String, dynamic> json) {
    return MemoryEntry(
      id: json['id'] as String,
      ruleType: json['ruleType'] as String,
      note: json['note'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isVerified: json['isVerified'] as bool,
    );
  }
}