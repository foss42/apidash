// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'available_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AvailableModels _$AvailableModelsFromJson(Map<String, dynamic> json) {
  return _AvailableModels.fromJson(json);
}

/// @nodoc
mixin _$AvailableModels {
  @JsonKey(name: "version")
  double get version => throw _privateConstructorUsedError;
  @JsonKey(name: "model_providers")
  List<AIModelProvider> get modelProviders =>
      throw _privateConstructorUsedError;

  /// Serializes this AvailableModels to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableModels
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableModelsCopyWith<AvailableModels> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableModelsCopyWith<$Res> {
  factory $AvailableModelsCopyWith(
    AvailableModels value,
    $Res Function(AvailableModels) then,
  ) = _$AvailableModelsCopyWithImpl<$Res, AvailableModels>;
  @useResult
  $Res call({
    @JsonKey(name: "version") double version,
    @JsonKey(name: "model_providers") List<AIModelProvider> modelProviders,
  });
}

/// @nodoc
class _$AvailableModelsCopyWithImpl<$Res, $Val extends AvailableModels>
    implements $AvailableModelsCopyWith<$Res> {
  _$AvailableModelsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableModels
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? version = null, Object? modelProviders = null}) {
    return _then(
      _value.copyWith(
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as double,
            modelProviders: null == modelProviders
                ? _value.modelProviders
                : modelProviders // ignore: cast_nullable_to_non_nullable
                      as List<AIModelProvider>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvailableModelsImplCopyWith<$Res>
    implements $AvailableModelsCopyWith<$Res> {
  factory _$$AvailableModelsImplCopyWith(
    _$AvailableModelsImpl value,
    $Res Function(_$AvailableModelsImpl) then,
  ) = __$$AvailableModelsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: "version") double version,
    @JsonKey(name: "model_providers") List<AIModelProvider> modelProviders,
  });
}

/// @nodoc
class __$$AvailableModelsImplCopyWithImpl<$Res>
    extends _$AvailableModelsCopyWithImpl<$Res, _$AvailableModelsImpl>
    implements _$$AvailableModelsImplCopyWith<$Res> {
  __$$AvailableModelsImplCopyWithImpl(
    _$AvailableModelsImpl _value,
    $Res Function(_$AvailableModelsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AvailableModels
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? version = null, Object? modelProviders = null}) {
    return _then(
      _$AvailableModelsImpl(
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as double,
        modelProviders: null == modelProviders
            ? _value._modelProviders
            : modelProviders // ignore: cast_nullable_to_non_nullable
                  as List<AIModelProvider>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableModelsImpl extends _AvailableModels {
  const _$AvailableModelsImpl({
    @JsonKey(name: "version") required this.version,
    @JsonKey(name: "model_providers")
    required final List<AIModelProvider> modelProviders,
  }) : _modelProviders = modelProviders,
       super._();

  factory _$AvailableModelsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableModelsImplFromJson(json);

  @override
  @JsonKey(name: "version")
  final double version;
  final List<AIModelProvider> _modelProviders;
  @override
  @JsonKey(name: "model_providers")
  List<AIModelProvider> get modelProviders {
    if (_modelProviders is EqualUnmodifiableListView) return _modelProviders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modelProviders);
  }

  @override
  String toString() {
    return 'AvailableModels(version: $version, modelProviders: $modelProviders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableModelsImpl &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(
              other._modelProviders,
              _modelProviders,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    version,
    const DeepCollectionEquality().hash(_modelProviders),
  );

  /// Create a copy of AvailableModels
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableModelsImplCopyWith<_$AvailableModelsImpl> get copyWith =>
      __$$AvailableModelsImplCopyWithImpl<_$AvailableModelsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableModelsImplToJson(this);
  }
}

abstract class _AvailableModels extends AvailableModels {
  const factory _AvailableModels({
    @JsonKey(name: "version") required final double version,
    @JsonKey(name: "model_providers")
    required final List<AIModelProvider> modelProviders,
  }) = _$AvailableModelsImpl;
  const _AvailableModels._() : super._();

  factory _AvailableModels.fromJson(Map<String, dynamic> json) =
      _$AvailableModelsImpl.fromJson;

  @override
  @JsonKey(name: "version")
  double get version;
  @override
  @JsonKey(name: "model_providers")
  List<AIModelProvider> get modelProviders;

  /// Create a copy of AvailableModels
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableModelsImplCopyWith<_$AvailableModelsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIModelProvider _$AIModelProviderFromJson(Map<String, dynamic> json) {
  return _AIModelProvider.fromJson(json);
}

/// @nodoc
mixin _$AIModelProvider {
  @JsonKey(name: "provider_id")
  ModelAPIProvider? get providerId => throw _privateConstructorUsedError;
  @JsonKey(name: "provider_name")
  String? get providerName => throw _privateConstructorUsedError;
  @JsonKey(name: "source_url")
  String? get sourceUrl => throw _privateConstructorUsedError;
  @JsonKey(name: "models")
  List<Model>? get models => throw _privateConstructorUsedError;

  /// Serializes this AIModelProvider to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIModelProvider
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIModelProviderCopyWith<AIModelProvider> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIModelProviderCopyWith<$Res> {
  factory $AIModelProviderCopyWith(
    AIModelProvider value,
    $Res Function(AIModelProvider) then,
  ) = _$AIModelProviderCopyWithImpl<$Res, AIModelProvider>;
  @useResult
  $Res call({
    @JsonKey(name: "provider_id") ModelAPIProvider? providerId,
    @JsonKey(name: "provider_name") String? providerName,
    @JsonKey(name: "source_url") String? sourceUrl,
    @JsonKey(name: "models") List<Model>? models,
  });
}

/// @nodoc
class _$AIModelProviderCopyWithImpl<$Res, $Val extends AIModelProvider>
    implements $AIModelProviderCopyWith<$Res> {
  _$AIModelProviderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIModelProvider
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providerId = freezed,
    Object? providerName = freezed,
    Object? sourceUrl = freezed,
    Object? models = freezed,
  }) {
    return _then(
      _value.copyWith(
            providerId: freezed == providerId
                ? _value.providerId
                : providerId // ignore: cast_nullable_to_non_nullable
                      as ModelAPIProvider?,
            providerName: freezed == providerName
                ? _value.providerName
                : providerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            sourceUrl: freezed == sourceUrl
                ? _value.sourceUrl
                : sourceUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            models: freezed == models
                ? _value.models
                : models // ignore: cast_nullable_to_non_nullable
                      as List<Model>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIModelProviderImplCopyWith<$Res>
    implements $AIModelProviderCopyWith<$Res> {
  factory _$$AIModelProviderImplCopyWith(
    _$AIModelProviderImpl value,
    $Res Function(_$AIModelProviderImpl) then,
  ) = __$$AIModelProviderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: "provider_id") ModelAPIProvider? providerId,
    @JsonKey(name: "provider_name") String? providerName,
    @JsonKey(name: "source_url") String? sourceUrl,
    @JsonKey(name: "models") List<Model>? models,
  });
}

/// @nodoc
class __$$AIModelProviderImplCopyWithImpl<$Res>
    extends _$AIModelProviderCopyWithImpl<$Res, _$AIModelProviderImpl>
    implements _$$AIModelProviderImplCopyWith<$Res> {
  __$$AIModelProviderImplCopyWithImpl(
    _$AIModelProviderImpl _value,
    $Res Function(_$AIModelProviderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIModelProvider
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providerId = freezed,
    Object? providerName = freezed,
    Object? sourceUrl = freezed,
    Object? models = freezed,
  }) {
    return _then(
      _$AIModelProviderImpl(
        providerId: freezed == providerId
            ? _value.providerId
            : providerId // ignore: cast_nullable_to_non_nullable
                  as ModelAPIProvider?,
        providerName: freezed == providerName
            ? _value.providerName
            : providerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        sourceUrl: freezed == sourceUrl
            ? _value.sourceUrl
            : sourceUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        models: freezed == models
            ? _value._models
            : models // ignore: cast_nullable_to_non_nullable
                  as List<Model>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIModelProviderImpl extends _AIModelProvider {
  const _$AIModelProviderImpl({
    @JsonKey(name: "provider_id") this.providerId,
    @JsonKey(name: "provider_name") this.providerName,
    @JsonKey(name: "source_url") this.sourceUrl,
    @JsonKey(name: "models") final List<Model>? models,
  }) : _models = models,
       super._();

  factory _$AIModelProviderImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIModelProviderImplFromJson(json);

  @override
  @JsonKey(name: "provider_id")
  final ModelAPIProvider? providerId;
  @override
  @JsonKey(name: "provider_name")
  final String? providerName;
  @override
  @JsonKey(name: "source_url")
  final String? sourceUrl;
  final List<Model>? _models;
  @override
  @JsonKey(name: "models")
  List<Model>? get models {
    final value = _models;
    if (value == null) return null;
    if (_models is EqualUnmodifiableListView) return _models;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AIModelProvider(providerId: $providerId, providerName: $providerName, sourceUrl: $sourceUrl, models: $models)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIModelProviderImpl &&
            (identical(other.providerId, providerId) ||
                other.providerId == providerId) &&
            (identical(other.providerName, providerName) ||
                other.providerName == providerName) &&
            (identical(other.sourceUrl, sourceUrl) ||
                other.sourceUrl == sourceUrl) &&
            const DeepCollectionEquality().equals(other._models, _models));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    providerId,
    providerName,
    sourceUrl,
    const DeepCollectionEquality().hash(_models),
  );

  /// Create a copy of AIModelProvider
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIModelProviderImplCopyWith<_$AIModelProviderImpl> get copyWith =>
      __$$AIModelProviderImplCopyWithImpl<_$AIModelProviderImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AIModelProviderImplToJson(this);
  }
}

abstract class _AIModelProvider extends AIModelProvider {
  const factory _AIModelProvider({
    @JsonKey(name: "provider_id") final ModelAPIProvider? providerId,
    @JsonKey(name: "provider_name") final String? providerName,
    @JsonKey(name: "source_url") final String? sourceUrl,
    @JsonKey(name: "models") final List<Model>? models,
  }) = _$AIModelProviderImpl;
  const _AIModelProvider._() : super._();

  factory _AIModelProvider.fromJson(Map<String, dynamic> json) =
      _$AIModelProviderImpl.fromJson;

  @override
  @JsonKey(name: "provider_id")
  ModelAPIProvider? get providerId;
  @override
  @JsonKey(name: "provider_name")
  String? get providerName;
  @override
  @JsonKey(name: "source_url")
  String? get sourceUrl;
  @override
  @JsonKey(name: "models")
  List<Model>? get models;

  /// Create a copy of AIModelProvider
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIModelProviderImplCopyWith<_$AIModelProviderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Model _$ModelFromJson(Map<String, dynamic> json) {
  return _Model.fromJson(json);
}

/// @nodoc
mixin _$Model {
  @JsonKey(name: "id")
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "name")
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this Model to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelCopyWith<Model> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelCopyWith<$Res> {
  factory $ModelCopyWith(Model value, $Res Function(Model) then) =
      _$ModelCopyWithImpl<$Res, Model>;
  @useResult
  $Res call({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
  });
}

/// @nodoc
class _$ModelCopyWithImpl<$Res, $Val extends Model>
    implements $ModelCopyWith<$Res> {
  _$ModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? name = freezed}) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ModelImplCopyWith<$Res> implements $ModelCopyWith<$Res> {
  factory _$$ModelImplCopyWith(
    _$ModelImpl value,
    $Res Function(_$ModelImpl) then,
  ) = __$$ModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
  });
}

/// @nodoc
class __$$ModelImplCopyWithImpl<$Res>
    extends _$ModelCopyWithImpl<$Res, _$ModelImpl>
    implements _$$ModelImplCopyWith<$Res> {
  __$$ModelImplCopyWithImpl(
    _$ModelImpl _value,
    $Res Function(_$ModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? name = freezed}) {
    return _then(
      _$ModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ModelImpl implements _Model {
  const _$ModelImpl({
    @JsonKey(name: "id") this.id,
    @JsonKey(name: "name") this.name,
  });

  factory _$ModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final String? id;
  @override
  @JsonKey(name: "name")
  final String? name;

  @override
  String toString() {
    return 'Model(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelImplCopyWith<_$ModelImpl> get copyWith =>
      __$$ModelImplCopyWithImpl<_$ModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelImplToJson(this);
  }
}

abstract class _Model implements Model {
  const factory _Model({
    @JsonKey(name: "id") final String? id,
    @JsonKey(name: "name") final String? name,
  }) = _$ModelImpl;

  factory _Model.fromJson(Map<String, dynamic> json) = _$ModelImpl.fromJson;

  @override
  @JsonKey(name: "id")
  String? get id;
  @override
  @JsonKey(name: "name")
  String? get name;

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModelImplCopyWith<_$ModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
