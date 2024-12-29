// cookie.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cookie.freezed.dart';
part 'cookie.g.dart';

@freezed
class Cookie with _$Cookie {
  const factory Cookie({
    required String name,
    required String value,
  }) = _Cookie;

  factory Cookie.fromJson(Map<String, dynamic> json) => _$CookieFromJson(json);
}
