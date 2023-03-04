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

Map<String, String>? rowsToMap(List<KVRow>? kvRows, {bool isHeader = false}) {
  if (kvRows == null) {
    return null;
  }
  Map<String, String> finalMap = {};
  for (var row in kvRows) {
    if (row.k.trim() != "") {
      String key = row.k;
      if (isHeader) {
        key = key.toLowerCase();
      }
      finalMap[key] = row.v;
    }
  }
  return finalMap;
}
