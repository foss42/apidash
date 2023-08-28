import 'package:flutter/material.dart';

@immutable
class NameValueModel {
  const NameValueModel(this.k, this.v);

  final String k;
  final dynamic v;

  NameValueModel copyWith({
    String? k,
    dynamic v,
  }) {
    return NameValueModel(k ?? this.k, v ?? this.v);
  }

  @override
  String toString() {
    return {k: v}.toString();
  }

  @override
  bool operator ==(Object other) {
    return other is NameValueModel &&
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
