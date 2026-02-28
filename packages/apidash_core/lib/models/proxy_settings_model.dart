
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class ProxySettings {
  const ProxySettings({
    required this.host,
    required this.port,
    this.username,
    this.password,
  });

  final String host;
  final String port;
  final String? username;
  final String? password;

  ProxySettings copyWith({
    String? host,
    String? port,
    String? username,
    String? password,
  }) {
    return ProxySettings(
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  factory ProxySettings.fromJson(Map<String, dynamic> json) {
    return ProxySettings(
      host: json["host"] as String,
      port: json["port"] as String,
      username: json["username"] as String?,
      password: json["password"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "host": host,
      "port": port,
      "username": username,
      "password": password,
    };
  }

  @override
  String toString() {
    return 'ProxySettings(host: $host, port: $port, username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProxySettings &&
        other.host == host &&
        other.port == port &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode {
    return Object.hash(host, port, username, password);
  }
}
