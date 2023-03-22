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
}
