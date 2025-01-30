// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insomnia_environment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InsomniaEnvironment _$InsomniaEnvironmentFromJson(Map<String, dynamic> json) {
  return _InsomniaEnvironment.fromJson(json);
}

/// @nodoc
mixin _$InsomniaEnvironment {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'kvPairData')
  List<EnvironmentVariable>? get resources =>
      throw _privateConstructorUsedError;
  @JsonKey(name: '_type')
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this InsomniaEnvironment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsomniaEnvironment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsomniaEnvironmentCopyWith<InsomniaEnvironment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsomniaEnvironmentCopyWith<$Res> {
  factory $InsomniaEnvironmentCopyWith(
          InsomniaEnvironment value, $Res Function(InsomniaEnvironment) then) =
      _$InsomniaEnvironmentCopyWithImpl<$Res, InsomniaEnvironment>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? name,
      @JsonKey(name: 'kvPairData') List<EnvironmentVariable>? resources,
      @JsonKey(name: '_type') String? type});
}

/// @nodoc
class _$InsomniaEnvironmentCopyWithImpl<$Res, $Val extends InsomniaEnvironment>
    implements $InsomniaEnvironmentCopyWith<$Res> {
  _$InsomniaEnvironmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsomniaEnvironment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? resources = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      resources: freezed == resources
          ? _value.resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<EnvironmentVariable>?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsomniaEnvironmentImplCopyWith<$Res>
    implements $InsomniaEnvironmentCopyWith<$Res> {
  factory _$$InsomniaEnvironmentImplCopyWith(_$InsomniaEnvironmentImpl value,
          $Res Function(_$InsomniaEnvironmentImpl) then) =
      __$$InsomniaEnvironmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? name,
      @JsonKey(name: 'kvPairData') List<EnvironmentVariable>? resources,
      @JsonKey(name: '_type') String? type});
}

/// @nodoc
class __$$InsomniaEnvironmentImplCopyWithImpl<$Res>
    extends _$InsomniaEnvironmentCopyWithImpl<$Res, _$InsomniaEnvironmentImpl>
    implements _$$InsomniaEnvironmentImplCopyWith<$Res> {
  __$$InsomniaEnvironmentImplCopyWithImpl(_$InsomniaEnvironmentImpl _value,
      $Res Function(_$InsomniaEnvironmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of InsomniaEnvironment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? resources = freezed,
    Object? type = freezed,
  }) {
    return _then(_$InsomniaEnvironmentImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      resources: freezed == resources
          ? _value._resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<EnvironmentVariable>?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$InsomniaEnvironmentImpl implements _InsomniaEnvironment {
  const _$InsomniaEnvironmentImpl(
      {@JsonKey(name: '_id') this.id,
      this.name,
      @JsonKey(name: 'kvPairData') final List<EnvironmentVariable>? resources,
      @JsonKey(name: '_type') this.type})
      : _resources = resources;

  factory _$InsomniaEnvironmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsomniaEnvironmentImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? name;
  final List<EnvironmentVariable>? _resources;
  @override
  @JsonKey(name: 'kvPairData')
  List<EnvironmentVariable>? get resources {
    final value = _resources;
    if (value == null) return null;
    if (_resources is EqualUnmodifiableListView) return _resources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: '_type')
  final String? type;

  @override
  String toString() {
    return 'InsomniaEnvironment(id: $id, name: $name, resources: $resources, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsomniaEnvironmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._resources, _resources) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name,
      const DeepCollectionEquality().hash(_resources), type);

  /// Create a copy of InsomniaEnvironment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsomniaEnvironmentImplCopyWith<_$InsomniaEnvironmentImpl> get copyWith =>
      __$$InsomniaEnvironmentImplCopyWithImpl<_$InsomniaEnvironmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsomniaEnvironmentImplToJson(
      this,
    );
  }
}

abstract class _InsomniaEnvironment implements InsomniaEnvironment {
  const factory _InsomniaEnvironment(
      {@JsonKey(name: '_id') final String? id,
      final String? name,
      @JsonKey(name: 'kvPairData') final List<EnvironmentVariable>? resources,
      @JsonKey(name: '_type') final String? type}) = _$InsomniaEnvironmentImpl;

  factory _InsomniaEnvironment.fromJson(Map<String, dynamic> json) =
      _$InsomniaEnvironmentImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get name;
  @override
  @JsonKey(name: 'kvPairData')
  List<EnvironmentVariable>? get resources;
  @override
  @JsonKey(name: '_type')
  String? get type;

  /// Create a copy of InsomniaEnvironment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsomniaEnvironmentImplCopyWith<_$InsomniaEnvironmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EnvironmentVariable _$EnvironmentVariableFromJson(Map<String, dynamic> json) {
  return _EnvironmentVariable.fromJson(json);
}

/// @nodoc
mixin _$EnvironmentVariable {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get key => throw _privateConstructorUsedError;
  @JsonKey(name: 'value')
  String get value => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'enabled')
  bool? get enabled => throw _privateConstructorUsedError;

  /// Serializes this EnvironmentVariable to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnvironmentVariable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnvironmentVariableCopyWith<EnvironmentVariable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnvironmentVariableCopyWith<$Res> {
  factory $EnvironmentVariableCopyWith(
          EnvironmentVariable value, $Res Function(EnvironmentVariable) then) =
      _$EnvironmentVariableCopyWithImpl<$Res, EnvironmentVariable>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'name') String key,
      @JsonKey(name: 'value') String value,
      String? type,
      @JsonKey(name: 'enabled') bool? enabled});
}

/// @nodoc
class _$EnvironmentVariableCopyWithImpl<$Res, $Val extends EnvironmentVariable>
    implements $EnvironmentVariableCopyWith<$Res> {
  _$EnvironmentVariableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnvironmentVariable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? key = null,
    Object? value = null,
    Object? type = freezed,
    Object? enabled = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      enabled: freezed == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EnvironmentVariableImplCopyWith<$Res>
    implements $EnvironmentVariableCopyWith<$Res> {
  factory _$$EnvironmentVariableImplCopyWith(_$EnvironmentVariableImpl value,
          $Res Function(_$EnvironmentVariableImpl) then) =
      __$$EnvironmentVariableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'name') String key,
      @JsonKey(name: 'value') String value,
      String? type,
      @JsonKey(name: 'enabled') bool? enabled});
}

/// @nodoc
class __$$EnvironmentVariableImplCopyWithImpl<$Res>
    extends _$EnvironmentVariableCopyWithImpl<$Res, _$EnvironmentVariableImpl>
    implements _$$EnvironmentVariableImplCopyWith<$Res> {
  __$$EnvironmentVariableImplCopyWithImpl(_$EnvironmentVariableImpl _value,
      $Res Function(_$EnvironmentVariableImpl) _then)
      : super(_value, _then);

  /// Create a copy of EnvironmentVariable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? key = null,
    Object? value = null,
    Object? type = freezed,
    Object? enabled = freezed,
  }) {
    return _then(_$EnvironmentVariableImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      enabled: freezed == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$EnvironmentVariableImpl implements _EnvironmentVariable {
  const _$EnvironmentVariableImpl(
      {this.id,
      @JsonKey(name: 'name') required this.key,
      @JsonKey(name: 'value') required this.value,
      this.type,
      @JsonKey(name: 'enabled') this.enabled});

  factory _$EnvironmentVariableImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnvironmentVariableImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'name')
  final String key;
  @override
  @JsonKey(name: 'value')
  final String value;
  @override
  final String? type;
  @override
  @JsonKey(name: 'enabled')
  final bool? enabled;

  @override
  String toString() {
    return 'EnvironmentVariable(id: $id, key: $key, value: $value, type: $type, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnvironmentVariableImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, key, value, type, enabled);

  /// Create a copy of EnvironmentVariable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnvironmentVariableImplCopyWith<_$EnvironmentVariableImpl> get copyWith =>
      __$$EnvironmentVariableImplCopyWithImpl<_$EnvironmentVariableImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnvironmentVariableImplToJson(
      this,
    );
  }
}

abstract class _EnvironmentVariable implements EnvironmentVariable {
  const factory _EnvironmentVariable(
          {final String? id,
          @JsonKey(name: 'name') required final String key,
          @JsonKey(name: 'value') required final String value,
          final String? type,
          @JsonKey(name: 'enabled') final bool? enabled}) =
      _$EnvironmentVariableImpl;

  factory _EnvironmentVariable.fromJson(Map<String, dynamic> json) =
      _$EnvironmentVariableImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'name')
  String get key;
  @override
  @JsonKey(name: 'value')
  String get value;
  @override
  String? get type;
  @override
  @JsonKey(name: 'enabled')
  bool? get enabled;

  /// Create a copy of EnvironmentVariable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnvironmentVariableImplCopyWith<_$EnvironmentVariableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
