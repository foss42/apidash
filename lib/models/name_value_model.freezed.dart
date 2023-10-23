// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'name_value_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NameValueModel _$NameValueModelFromJson(Map<String, dynamic> json) {
  return _NameValueModel.fromJson(json);
}

/// @nodoc
mixin _$NameValueModel {
  bool get enabled => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NameValueModelCopyWith<NameValueModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NameValueModelCopyWith<$Res> {
  factory $NameValueModelCopyWith(
          NameValueModel value, $Res Function(NameValueModel) then) =
      _$NameValueModelCopyWithImpl<$Res, NameValueModel>;
  @useResult
  $Res call({bool enabled, String name, dynamic value});
}

/// @nodoc
class _$NameValueModelCopyWithImpl<$Res, $Val extends NameValueModel>
    implements $NameValueModelCopyWith<$Res> {
  _$NameValueModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? name = null,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NameValueModelImplCopyWith<$Res>
    implements $NameValueModelCopyWith<$Res> {
  factory _$$NameValueModelImplCopyWith(_$NameValueModelImpl value,
          $Res Function(_$NameValueModelImpl) then) =
      __$$NameValueModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enabled, String name, dynamic value});
}

/// @nodoc
class __$$NameValueModelImplCopyWithImpl<$Res>
    extends _$NameValueModelCopyWithImpl<$Res, _$NameValueModelImpl>
    implements _$$NameValueModelImplCopyWith<$Res> {
  __$$NameValueModelImplCopyWithImpl(
      _$NameValueModelImpl _value, $Res Function(_$NameValueModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? name = null,
    Object? value = freezed,
  }) {
    return _then(_$NameValueModelImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NameValueModelImpl
    with DiagnosticableTreeMixin
    implements _NameValueModel {
  const _$NameValueModelImpl(
      {this.enabled = true, required this.name, required this.value});

  factory _$NameValueModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NameValueModelImplFromJson(json);

  @override
  @JsonKey()
  final bool enabled;
  @override
  final String name;
  @override
  final dynamic value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NameValueModel(enabled: $enabled, name: $name, value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NameValueModel'))
      ..add(DiagnosticsProperty('enabled', enabled))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NameValueModelImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, enabled, name, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NameValueModelImplCopyWith<_$NameValueModelImpl> get copyWith =>
      __$$NameValueModelImplCopyWithImpl<_$NameValueModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NameValueModelImplToJson(
      this,
    );
  }
}

abstract class _NameValueModel implements NameValueModel {
  const factory _NameValueModel(
      {final bool enabled,
      required final String name,
      required final dynamic value}) = _$NameValueModelImpl;

  factory _NameValueModel.fromJson(Map<String, dynamic> json) =
      _$NameValueModelImpl.fromJson;

  @override
  bool get enabled;
  @override
  String get name;
  @override
  dynamic get value;
  @override
  @JsonKey(ignore: true)
  _$$NameValueModelImplCopyWith<_$NameValueModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
