// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proxy_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProxySettings _$ProxySettingsFromJson(Map<String, dynamic> json) {
  return _ProxySettings.fromJson(json);
}

/// @nodoc
mixin _$ProxySettings {
  String get host => throw _privateConstructorUsedError;
  String get port => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;

  /// Serializes this ProxySettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProxySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProxySettingsCopyWith<ProxySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProxySettingsCopyWith<$Res> {
  factory $ProxySettingsCopyWith(
          ProxySettings value, $Res Function(ProxySettings) then) =
      _$ProxySettingsCopyWithImpl<$Res, ProxySettings>;
  @useResult
  $Res call({String host, String port, String? username, String? password});
}

/// @nodoc
class _$ProxySettingsCopyWithImpl<$Res, $Val extends ProxySettings>
    implements $ProxySettingsCopyWith<$Res> {
  _$ProxySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProxySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? port = null,
    Object? username = freezed,
    Object? password = freezed,
  }) {
    return _then(_value.copyWith(
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProxySettingsImplCopyWith<$Res>
    implements $ProxySettingsCopyWith<$Res> {
  factory _$$ProxySettingsImplCopyWith(
          _$ProxySettingsImpl value, $Res Function(_$ProxySettingsImpl) then) =
      __$$ProxySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String host, String port, String? username, String? password});
}

/// @nodoc
class __$$ProxySettingsImplCopyWithImpl<$Res>
    extends _$ProxySettingsCopyWithImpl<$Res, _$ProxySettingsImpl>
    implements _$$ProxySettingsImplCopyWith<$Res> {
  __$$ProxySettingsImplCopyWithImpl(
      _$ProxySettingsImpl _value, $Res Function(_$ProxySettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProxySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? port = null,
    Object? username = freezed,
    Object? password = freezed,
  }) {
    return _then(_$ProxySettingsImpl(
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProxySettingsImpl implements _ProxySettings {
  const _$ProxySettingsImpl(
      {this.host = '', this.port = '', this.username, this.password});

  factory _$ProxySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProxySettingsImplFromJson(json);

  @override
  @JsonKey()
  final String host;
  @override
  @JsonKey()
  final String port;
  @override
  final String? username;
  @override
  final String? password;

  @override
  String toString() {
    return 'ProxySettings(host: $host, port: $port, username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProxySettingsImpl &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, host, port, username, password);

  /// Create a copy of ProxySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProxySettingsImplCopyWith<_$ProxySettingsImpl> get copyWith =>
      __$$ProxySettingsImplCopyWithImpl<_$ProxySettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProxySettingsImplToJson(
      this,
    );
  }
}

abstract class _ProxySettings implements ProxySettings {
  const factory _ProxySettings(
      {final String host,
      final String port,
      final String? username,
      final String? password}) = _$ProxySettingsImpl;

  factory _ProxySettings.fromJson(Map<String, dynamic> json) =
      _$ProxySettingsImpl.fromJson;

  @override
  String get host;
  @override
  String get port;
  @override
  String? get username;
  @override
  String? get password;

  /// Create a copy of ProxySettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProxySettingsImplCopyWith<_$ProxySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
