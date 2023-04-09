import 'package:flutter/material.dart';

@immutable
class KVRow {
  const KVRow(this.k, this.v);

  final String k;
  final dynamic v;

  KVRow copyWith({
    String? k,
    dynamic v,
  }) {
    return KVRow(k ?? this.k, v ?? this.v);
  }

  @override
  String toString() {
    return {k: v}.toString();
  }

  @override
  bool operator ==(Object other) {
    return other is KVRow &&
        other.runtimeType == runtimeType &&
        other.k == k &&
        other.v == v;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      k,
      v,
    );
  }
}
