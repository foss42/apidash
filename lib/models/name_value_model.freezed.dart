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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NameValueModel _$NameValueModelFromJson(Map<String, dynamic> json) {
  return _NameValueModel.fromJson(json);
}

/// @nodoc
mixin _$NameValueModel {
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
  $Res call({String name, dynamic value});
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
    Object? name = null,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
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
  $Res call({String name, dynamic value});
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
    Object? name = null,
    Object? value = freezed,
  }) {
    return _then(_$NameValueModelImpl(
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
  const _$NameValueModelImpl({required this.name, required this.value});

  factory _$NameValueModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NameValueModelImplFromJson(json);

  @override
  final String name;
  @override
  final dynamic value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NameValueModel(name: $name, value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NameValueModel'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NameValueModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(value));

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
      {required final String name,
      required final dynamic value}) = _$NameValueModelImpl;

  factory _NameValueModel.fromJson(Map<String, dynamic> json) =
      _$NameValueModelImpl.fromJson;

  @override
  String get name;
  @override
  dynamic get value;
  @override
  @JsonKey(ignore: true)
  _$$NameValueModelImplCopyWith<_$NameValueModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
