// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'environment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EnvironmentModel _$EnvironmentModelFromJson(Map<String, dynamic> json) {
  return _EnvironmentModel.fromJson(json);
}

/// @nodoc
mixin _$EnvironmentModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<EnvironmentVariableModel> get values =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EnvironmentModelCopyWith<EnvironmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnvironmentModelCopyWith<$Res> {
  factory $EnvironmentModelCopyWith(
          EnvironmentModel value, $Res Function(EnvironmentModel) then) =
      _$EnvironmentModelCopyWithImpl<$Res, EnvironmentModel>;
  @useResult
  $Res call({String id, String name, List<EnvironmentVariableModel> values});
}

/// @nodoc
class _$EnvironmentModelCopyWithImpl<$Res, $Val extends EnvironmentModel>
    implements $EnvironmentModelCopyWith<$Res> {
  _$EnvironmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? values = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<EnvironmentVariableModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EnvironmentModelImplCopyWith<$Res>
    implements $EnvironmentModelCopyWith<$Res> {
  factory _$$EnvironmentModelImplCopyWith(_$EnvironmentModelImpl value,
          $Res Function(_$EnvironmentModelImpl) then) =
      __$$EnvironmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, List<EnvironmentVariableModel> values});
}

/// @nodoc
class __$$EnvironmentModelImplCopyWithImpl<$Res>
    extends _$EnvironmentModelCopyWithImpl<$Res, _$EnvironmentModelImpl>
    implements _$$EnvironmentModelImplCopyWith<$Res> {
  __$$EnvironmentModelImplCopyWithImpl(_$EnvironmentModelImpl _value,
      $Res Function(_$EnvironmentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? values = null,
  }) {
    return _then(_$EnvironmentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<EnvironmentVariableModel>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$EnvironmentModelImpl implements _EnvironmentModel {
  const _$EnvironmentModelImpl(
      {required this.id,
      this.name = "",
      final List<EnvironmentVariableModel> values = const []})
      : _values = values;

  factory _$EnvironmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnvironmentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String name;
  final List<EnvironmentVariableModel> _values;
  @override
  @JsonKey()
  List<EnvironmentVariableModel> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @override
  String toString() {
    return 'EnvironmentModel(id: $id, name: $name, values: $values)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnvironmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, const DeepCollectionEquality().hash(_values));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EnvironmentModelImplCopyWith<_$EnvironmentModelImpl> get copyWith =>
      __$$EnvironmentModelImplCopyWithImpl<_$EnvironmentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnvironmentModelImplToJson(
      this,
    );
  }
}

abstract class _EnvironmentModel implements EnvironmentModel {
  const factory _EnvironmentModel(
      {required final String id,
      final String name,
      final List<EnvironmentVariableModel> values}) = _$EnvironmentModelImpl;

  factory _EnvironmentModel.fromJson(Map<String, dynamic> json) =
      _$EnvironmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<EnvironmentVariableModel> get values;
  @override
  @JsonKey(ignore: true)
  _$$EnvironmentModelImplCopyWith<_$EnvironmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EnvironmentVariableModel _$EnvironmentVariableModelFromJson(
    Map<String, dynamic> json) {
  return _EnvironmentVariableModel.fromJson(json);
}

/// @nodoc
mixin _$EnvironmentVariableModel {
  String get key => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  EnvironmentVariableType get type => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EnvironmentVariableModelCopyWith<EnvironmentVariableModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnvironmentVariableModelCopyWith<$Res> {
  factory $EnvironmentVariableModelCopyWith(EnvironmentVariableModel value,
          $Res Function(EnvironmentVariableModel) then) =
      _$EnvironmentVariableModelCopyWithImpl<$Res, EnvironmentVariableModel>;
  @useResult
  $Res call(
      {String key, String value, EnvironmentVariableType type, bool enabled});
}

/// @nodoc
class _$EnvironmentVariableModelCopyWithImpl<$Res,
        $Val extends EnvironmentVariableModel>
    implements $EnvironmentVariableModelCopyWith<$Res> {
  _$EnvironmentVariableModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? type = null,
    Object? enabled = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EnvironmentVariableType,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EnvironmentVariableModelImplCopyWith<$Res>
    implements $EnvironmentVariableModelCopyWith<$Res> {
  factory _$$EnvironmentVariableModelImplCopyWith(
          _$EnvironmentVariableModelImpl value,
          $Res Function(_$EnvironmentVariableModelImpl) then) =
      __$$EnvironmentVariableModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key, String value, EnvironmentVariableType type, bool enabled});
}

/// @nodoc
class __$$EnvironmentVariableModelImplCopyWithImpl<$Res>
    extends _$EnvironmentVariableModelCopyWithImpl<$Res,
        _$EnvironmentVariableModelImpl>
    implements _$$EnvironmentVariableModelImplCopyWith<$Res> {
  __$$EnvironmentVariableModelImplCopyWithImpl(
      _$EnvironmentVariableModelImpl _value,
      $Res Function(_$EnvironmentVariableModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? type = null,
    Object? enabled = null,
  }) {
    return _then(_$EnvironmentVariableModelImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EnvironmentVariableType,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$EnvironmentVariableModelImpl implements _EnvironmentVariableModel {
  const _$EnvironmentVariableModelImpl(
      {required this.key,
      required this.value,
      this.type = EnvironmentVariableType.variable,
      this.enabled = false});

  factory _$EnvironmentVariableModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnvironmentVariableModelImplFromJson(json);

  @override
  final String key;
  @override
  final String value;
  @override
  @JsonKey()
  final EnvironmentVariableType type;
  @override
  @JsonKey()
  final bool enabled;

  @override
  String toString() {
    return 'EnvironmentVariableModel(key: $key, value: $value, type: $type, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnvironmentVariableModelImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, key, value, type, enabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EnvironmentVariableModelImplCopyWith<_$EnvironmentVariableModelImpl>
      get copyWith => __$$EnvironmentVariableModelImplCopyWithImpl<
          _$EnvironmentVariableModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnvironmentVariableModelImplToJson(
      this,
    );
  }
}

abstract class _EnvironmentVariableModel implements EnvironmentVariableModel {
  const factory _EnvironmentVariableModel(
      {required final String key,
      required final String value,
      final EnvironmentVariableType type,
      final bool enabled}) = _$EnvironmentVariableModelImpl;

  factory _EnvironmentVariableModel.fromJson(Map<String, dynamic> json) =
      _$EnvironmentVariableModelImpl.fromJson;

  @override
  String get key;
  @override
  String get value;
  @override
  EnvironmentVariableType get type;
  @override
  bool get enabled;
  @override
  @JsonKey(ignore: true)
  _$$EnvironmentVariableModelImplCopyWith<_$EnvironmentVariableModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
