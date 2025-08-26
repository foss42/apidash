// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_request_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ModelRequestData _$ModelRequestDataFromJson(Map<String, dynamic> json) {
  return _ModelRequestData.fromJson(json);
}

/// @nodoc
mixin _$ModelRequestData {
  String get url => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get apiKey => throw _privateConstructorUsedError;
  @JsonKey(name: "system_prompt")
  String get systemPrompt => throw _privateConstructorUsedError;
  @JsonKey(name: "user_prompt")
  String get userPrompt => throw _privateConstructorUsedError;
  @JsonKey(name: "model_configs")
  List<ModelConfig> get modelConfigs => throw _privateConstructorUsedError;
  bool? get stream => throw _privateConstructorUsedError;

  /// Serializes this ModelRequestData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModelRequestData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelRequestDataCopyWith<ModelRequestData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelRequestDataCopyWith<$Res> {
  factory $ModelRequestDataCopyWith(
    ModelRequestData value,
    $Res Function(ModelRequestData) then,
  ) = _$ModelRequestDataCopyWithImpl<$Res, ModelRequestData>;
  @useResult
  $Res call({
    String url,
    String model,
    String apiKey,
    @JsonKey(name: "system_prompt") String systemPrompt,
    @JsonKey(name: "user_prompt") String userPrompt,
    @JsonKey(name: "model_configs") List<ModelConfig> modelConfigs,
    bool? stream,
  });
}

/// @nodoc
class _$ModelRequestDataCopyWithImpl<$Res, $Val extends ModelRequestData>
    implements $ModelRequestDataCopyWith<$Res> {
  _$ModelRequestDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModelRequestData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? model = null,
    Object? apiKey = null,
    Object? systemPrompt = null,
    Object? userPrompt = null,
    Object? modelConfigs = null,
    Object? stream = freezed,
  }) {
    return _then(
      _value.copyWith(
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            model: null == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                      as String,
            apiKey: null == apiKey
                ? _value.apiKey
                : apiKey // ignore: cast_nullable_to_non_nullable
                      as String,
            systemPrompt: null == systemPrompt
                ? _value.systemPrompt
                : systemPrompt // ignore: cast_nullable_to_non_nullable
                      as String,
            userPrompt: null == userPrompt
                ? _value.userPrompt
                : userPrompt // ignore: cast_nullable_to_non_nullable
                      as String,
            modelConfigs: null == modelConfigs
                ? _value.modelConfigs
                : modelConfigs // ignore: cast_nullable_to_non_nullable
                      as List<ModelConfig>,
            stream: freezed == stream
                ? _value.stream
                : stream // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ModelRequestDataImplCopyWith<$Res>
    implements $ModelRequestDataCopyWith<$Res> {
  factory _$$ModelRequestDataImplCopyWith(
    _$ModelRequestDataImpl value,
    $Res Function(_$ModelRequestDataImpl) then,
  ) = __$$ModelRequestDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String url,
    String model,
    String apiKey,
    @JsonKey(name: "system_prompt") String systemPrompt,
    @JsonKey(name: "user_prompt") String userPrompt,
    @JsonKey(name: "model_configs") List<ModelConfig> modelConfigs,
    bool? stream,
  });
}

/// @nodoc
class __$$ModelRequestDataImplCopyWithImpl<$Res>
    extends _$ModelRequestDataCopyWithImpl<$Res, _$ModelRequestDataImpl>
    implements _$$ModelRequestDataImplCopyWith<$Res> {
  __$$ModelRequestDataImplCopyWithImpl(
    _$ModelRequestDataImpl _value,
    $Res Function(_$ModelRequestDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ModelRequestData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? model = null,
    Object? apiKey = null,
    Object? systemPrompt = null,
    Object? userPrompt = null,
    Object? modelConfigs = null,
    Object? stream = freezed,
  }) {
    return _then(
      _$ModelRequestDataImpl(
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        model: null == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String,
        apiKey: null == apiKey
            ? _value.apiKey
            : apiKey // ignore: cast_nullable_to_non_nullable
                  as String,
        systemPrompt: null == systemPrompt
            ? _value.systemPrompt
            : systemPrompt // ignore: cast_nullable_to_non_nullable
                  as String,
        userPrompt: null == userPrompt
            ? _value.userPrompt
            : userPrompt // ignore: cast_nullable_to_non_nullable
                  as String,
        modelConfigs: null == modelConfigs
            ? _value._modelConfigs
            : modelConfigs // ignore: cast_nullable_to_non_nullable
                  as List<ModelConfig>,
        stream: freezed == stream
            ? _value.stream
            : stream // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$ModelRequestDataImpl extends _ModelRequestData {
  const _$ModelRequestDataImpl({
    this.url = "",
    this.model = "",
    this.apiKey = "",
    @JsonKey(name: "system_prompt") this.systemPrompt = "",
    @JsonKey(name: "user_prompt") this.userPrompt = "",
    @JsonKey(name: "model_configs")
    final List<ModelConfig> modelConfigs = const <ModelConfig>[],
    this.stream = null,
  }) : _modelConfigs = modelConfigs,
       super._();

  factory _$ModelRequestDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelRequestDataImplFromJson(json);

  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey()
  final String model;
  @override
  @JsonKey()
  final String apiKey;
  @override
  @JsonKey(name: "system_prompt")
  final String systemPrompt;
  @override
  @JsonKey(name: "user_prompt")
  final String userPrompt;
  final List<ModelConfig> _modelConfigs;
  @override
  @JsonKey(name: "model_configs")
  List<ModelConfig> get modelConfigs {
    if (_modelConfigs is EqualUnmodifiableListView) return _modelConfigs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modelConfigs);
  }

  @override
  @JsonKey()
  final bool? stream;

  @override
  String toString() {
    return 'ModelRequestData(url: $url, model: $model, apiKey: $apiKey, systemPrompt: $systemPrompt, userPrompt: $userPrompt, modelConfigs: $modelConfigs, stream: $stream)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelRequestDataImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.systemPrompt, systemPrompt) ||
                other.systemPrompt == systemPrompt) &&
            (identical(other.userPrompt, userPrompt) ||
                other.userPrompt == userPrompt) &&
            const DeepCollectionEquality().equals(
              other._modelConfigs,
              _modelConfigs,
            ) &&
            (identical(other.stream, stream) || other.stream == stream));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    url,
    model,
    apiKey,
    systemPrompt,
    userPrompt,
    const DeepCollectionEquality().hash(_modelConfigs),
    stream,
  );

  /// Create a copy of ModelRequestData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelRequestDataImplCopyWith<_$ModelRequestDataImpl> get copyWith =>
      __$$ModelRequestDataImplCopyWithImpl<_$ModelRequestDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelRequestDataImplToJson(this);
  }
}

abstract class _ModelRequestData extends ModelRequestData {
  const factory _ModelRequestData({
    final String url,
    final String model,
    final String apiKey,
    @JsonKey(name: "system_prompt") final String systemPrompt,
    @JsonKey(name: "user_prompt") final String userPrompt,
    @JsonKey(name: "model_configs") final List<ModelConfig> modelConfigs,
    final bool? stream,
  }) = _$ModelRequestDataImpl;
  const _ModelRequestData._() : super._();

  factory _ModelRequestData.fromJson(Map<String, dynamic> json) =
      _$ModelRequestDataImpl.fromJson;

  @override
  String get url;
  @override
  String get model;
  @override
  String get apiKey;
  @override
  @JsonKey(name: "system_prompt")
  String get systemPrompt;
  @override
  @JsonKey(name: "user_prompt")
  String get userPrompt;
  @override
  @JsonKey(name: "model_configs")
  List<ModelConfig> get modelConfigs;
  @override
  bool? get stream;

  /// Create a copy of ModelRequestData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModelRequestDataImplCopyWith<_$ModelRequestDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
