// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mqtt_topic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MQTTTopicModel _$MQTTTopicModelFromJson(Map<String, dynamic> json) {
  return _MQTTTopicModel.fromJson(json);
}

/// @nodoc
mixin _$MQTTTopicModel {
  String get name => throw _privateConstructorUsedError;
  int get qos => throw _privateConstructorUsedError;
  bool get subscribe => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MQTTTopicModelCopyWith<MQTTTopicModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MQTTTopicModelCopyWith<$Res> {
  factory $MQTTTopicModelCopyWith(
          MQTTTopicModel value, $Res Function(MQTTTopicModel) then) =
      _$MQTTTopicModelCopyWithImpl<$Res, MQTTTopicModel>;
  @useResult
  $Res call({String name, int qos, bool subscribe, String description});
}

/// @nodoc
class _$MQTTTopicModelCopyWithImpl<$Res, $Val extends MQTTTopicModel>
    implements $MQTTTopicModelCopyWith<$Res> {
  _$MQTTTopicModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? qos = null,
    Object? subscribe = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      qos: null == qos
          ? _value.qos
          : qos // ignore: cast_nullable_to_non_nullable
              as int,
      subscribe: null == subscribe
          ? _value.subscribe
          : subscribe // ignore: cast_nullable_to_non_nullable
              as bool,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MQTTTopicModelImplCopyWith<$Res>
    implements $MQTTTopicModelCopyWith<$Res> {
  factory _$$MQTTTopicModelImplCopyWith(_$MQTTTopicModelImpl value,
          $Res Function(_$MQTTTopicModelImpl) then) =
      __$$MQTTTopicModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int qos, bool subscribe, String description});
}

/// @nodoc
class __$$MQTTTopicModelImplCopyWithImpl<$Res>
    extends _$MQTTTopicModelCopyWithImpl<$Res, _$MQTTTopicModelImpl>
    implements _$$MQTTTopicModelImplCopyWith<$Res> {
  __$$MQTTTopicModelImplCopyWithImpl(
      _$MQTTTopicModelImpl _value, $Res Function(_$MQTTTopicModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? qos = null,
    Object? subscribe = null,
    Object? description = null,
  }) {
    return _then(_$MQTTTopicModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      qos: null == qos
          ? _value.qos
          : qos // ignore: cast_nullable_to_non_nullable
              as int,
      subscribe: null == subscribe
          ? _value.subscribe
          : subscribe // ignore: cast_nullable_to_non_nullable
              as bool,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MQTTTopicModelImpl
    with DiagnosticableTreeMixin
    implements _MQTTTopicModel {
  const _$MQTTTopicModelImpl(
      {required this.name,
      required this.qos,
      required this.subscribe,
      required this.description});

  factory _$MQTTTopicModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MQTTTopicModelImplFromJson(json);

  @override
  final String name;
  @override
  final int qos;
  @override
  final bool subscribe;
  @override
  final String description;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MQTTTopicModel(name: $name, qos: $qos, subscribe: $subscribe, description: $description)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MQTTTopicModel'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('qos', qos))
      ..add(DiagnosticsProperty('subscribe', subscribe))
      ..add(DiagnosticsProperty('description', description));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MQTTTopicModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.qos, qos) || other.qos == qos) &&
            (identical(other.subscribe, subscribe) ||
                other.subscribe == subscribe) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, qos, subscribe, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MQTTTopicModelImplCopyWith<_$MQTTTopicModelImpl> get copyWith =>
      __$$MQTTTopicModelImplCopyWithImpl<_$MQTTTopicModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MQTTTopicModelImplToJson(
      this,
    );
  }
}

abstract class _MQTTTopicModel implements MQTTTopicModel {
  const factory _MQTTTopicModel(
      {required final String name,
      required final int qos,
      required final bool subscribe,
      required final String description}) = _$MQTTTopicModelImpl;

  factory _MQTTTopicModel.fromJson(Map<String, dynamic> json) =
      _$MQTTTopicModelImpl.fromJson;

  @override
  String get name;
  @override
  int get qos;
  @override
  bool get subscribe;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$MQTTTopicModelImplCopyWith<_$MQTTTopicModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
