// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'available_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvailableModels {

@JsonKey(name: "version") double get version;@JsonKey(name: "model_providers") List<AIModelProvider> get modelProviders;
/// Create a copy of AvailableModels
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailableModelsCopyWith<AvailableModels> get copyWith => _$AvailableModelsCopyWithImpl<AvailableModels>(this as AvailableModels, _$identity);

  /// Serializes this AvailableModels to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailableModels&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.modelProviders, modelProviders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(modelProviders));

@override
String toString() {
  return 'AvailableModels(version: $version, modelProviders: $modelProviders)';
}


}

/// @nodoc
abstract mixin class $AvailableModelsCopyWith<$Res>  {
  factory $AvailableModelsCopyWith(AvailableModels value, $Res Function(AvailableModels) _then) = _$AvailableModelsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "version") double version,@JsonKey(name: "model_providers") List<AIModelProvider> modelProviders
});




}
/// @nodoc
class _$AvailableModelsCopyWithImpl<$Res>
    implements $AvailableModelsCopyWith<$Res> {
  _$AvailableModelsCopyWithImpl(this._self, this._then);

  final AvailableModels _self;
  final $Res Function(AvailableModels) _then;

/// Create a copy of AvailableModels
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? modelProviders = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as double,modelProviders: null == modelProviders ? _self.modelProviders : modelProviders // ignore: cast_nullable_to_non_nullable
as List<AIModelProvider>,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailableModels].
extension AvailableModelsPatterns on AvailableModels {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailableModels value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailableModels() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailableModels value)  $default,){
final _that = this;
switch (_that) {
case _AvailableModels():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailableModels value)?  $default,){
final _that = this;
switch (_that) {
case _AvailableModels() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "version")  double version, @JsonKey(name: "model_providers")  List<AIModelProvider> modelProviders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailableModels() when $default != null:
return $default(_that.version,_that.modelProviders);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "version")  double version, @JsonKey(name: "model_providers")  List<AIModelProvider> modelProviders)  $default,) {final _that = this;
switch (_that) {
case _AvailableModels():
return $default(_that.version,_that.modelProviders);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "version")  double version, @JsonKey(name: "model_providers")  List<AIModelProvider> modelProviders)?  $default,) {final _that = this;
switch (_that) {
case _AvailableModels() when $default != null:
return $default(_that.version,_that.modelProviders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailableModels extends AvailableModels {
  const _AvailableModels({@JsonKey(name: "version") required this.version, @JsonKey(name: "model_providers") required final  List<AIModelProvider> modelProviders}): _modelProviders = modelProviders,super._();
  factory _AvailableModels.fromJson(Map<String, dynamic> json) => _$AvailableModelsFromJson(json);

@override@JsonKey(name: "version") final  double version;
 final  List<AIModelProvider> _modelProviders;
@override@JsonKey(name: "model_providers") List<AIModelProvider> get modelProviders {
  if (_modelProviders is EqualUnmodifiableListView) return _modelProviders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modelProviders);
}


/// Create a copy of AvailableModels
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailableModelsCopyWith<_AvailableModels> get copyWith => __$AvailableModelsCopyWithImpl<_AvailableModels>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailableModelsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailableModels&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._modelProviders, _modelProviders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_modelProviders));

@override
String toString() {
  return 'AvailableModels(version: $version, modelProviders: $modelProviders)';
}


}

/// @nodoc
abstract mixin class _$AvailableModelsCopyWith<$Res> implements $AvailableModelsCopyWith<$Res> {
  factory _$AvailableModelsCopyWith(_AvailableModels value, $Res Function(_AvailableModels) _then) = __$AvailableModelsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "version") double version,@JsonKey(name: "model_providers") List<AIModelProvider> modelProviders
});




}
/// @nodoc
class __$AvailableModelsCopyWithImpl<$Res>
    implements _$AvailableModelsCopyWith<$Res> {
  __$AvailableModelsCopyWithImpl(this._self, this._then);

  final _AvailableModels _self;
  final $Res Function(_AvailableModels) _then;

/// Create a copy of AvailableModels
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? modelProviders = null,}) {
  return _then(_AvailableModels(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as double,modelProviders: null == modelProviders ? _self._modelProviders : modelProviders // ignore: cast_nullable_to_non_nullable
as List<AIModelProvider>,
  ));
}


}


/// @nodoc
mixin _$AIModelProvider {

@JsonKey(name: "provider_id") ModelAPIProvider? get providerId;@JsonKey(name: "provider_name") String? get providerName;@JsonKey(name: "source_url") String? get sourceUrl;@JsonKey(name: "models") List<Model>? get models;
/// Create a copy of AIModelProvider
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIModelProviderCopyWith<AIModelProvider> get copyWith => _$AIModelProviderCopyWithImpl<AIModelProvider>(this as AIModelProvider, _$identity);

  /// Serializes this AIModelProvider to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIModelProvider&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&const DeepCollectionEquality().equals(other.models, models));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,providerId,providerName,sourceUrl,const DeepCollectionEquality().hash(models));

@override
String toString() {
  return 'AIModelProvider(providerId: $providerId, providerName: $providerName, sourceUrl: $sourceUrl, models: $models)';
}


}

/// @nodoc
abstract mixin class $AIModelProviderCopyWith<$Res>  {
  factory $AIModelProviderCopyWith(AIModelProvider value, $Res Function(AIModelProvider) _then) = _$AIModelProviderCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "provider_id") ModelAPIProvider? providerId,@JsonKey(name: "provider_name") String? providerName,@JsonKey(name: "source_url") String? sourceUrl,@JsonKey(name: "models") List<Model>? models
});




}
/// @nodoc
class _$AIModelProviderCopyWithImpl<$Res>
    implements $AIModelProviderCopyWith<$Res> {
  _$AIModelProviderCopyWithImpl(this._self, this._then);

  final AIModelProvider _self;
  final $Res Function(AIModelProvider) _then;

/// Create a copy of AIModelProvider
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? providerId = freezed,Object? providerName = freezed,Object? sourceUrl = freezed,Object? models = freezed,}) {
  return _then(_self.copyWith(
providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as ModelAPIProvider?,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,models: freezed == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<Model>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AIModelProvider].
extension AIModelProviderPatterns on AIModelProvider {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIModelProvider value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIModelProvider() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIModelProvider value)  $default,){
final _that = this;
switch (_that) {
case _AIModelProvider():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIModelProvider value)?  $default,){
final _that = this;
switch (_that) {
case _AIModelProvider() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "provider_id")  ModelAPIProvider? providerId, @JsonKey(name: "provider_name")  String? providerName, @JsonKey(name: "source_url")  String? sourceUrl, @JsonKey(name: "models")  List<Model>? models)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIModelProvider() when $default != null:
return $default(_that.providerId,_that.providerName,_that.sourceUrl,_that.models);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "provider_id")  ModelAPIProvider? providerId, @JsonKey(name: "provider_name")  String? providerName, @JsonKey(name: "source_url")  String? sourceUrl, @JsonKey(name: "models")  List<Model>? models)  $default,) {final _that = this;
switch (_that) {
case _AIModelProvider():
return $default(_that.providerId,_that.providerName,_that.sourceUrl,_that.models);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "provider_id")  ModelAPIProvider? providerId, @JsonKey(name: "provider_name")  String? providerName, @JsonKey(name: "source_url")  String? sourceUrl, @JsonKey(name: "models")  List<Model>? models)?  $default,) {final _that = this;
switch (_that) {
case _AIModelProvider() when $default != null:
return $default(_that.providerId,_that.providerName,_that.sourceUrl,_that.models);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIModelProvider extends AIModelProvider {
  const _AIModelProvider({@JsonKey(name: "provider_id") this.providerId, @JsonKey(name: "provider_name") this.providerName, @JsonKey(name: "source_url") this.sourceUrl, @JsonKey(name: "models") final  List<Model>? models}): _models = models,super._();
  factory _AIModelProvider.fromJson(Map<String, dynamic> json) => _$AIModelProviderFromJson(json);

@override@JsonKey(name: "provider_id") final  ModelAPIProvider? providerId;
@override@JsonKey(name: "provider_name") final  String? providerName;
@override@JsonKey(name: "source_url") final  String? sourceUrl;
 final  List<Model>? _models;
@override@JsonKey(name: "models") List<Model>? get models {
  final value = _models;
  if (value == null) return null;
  if (_models is EqualUnmodifiableListView) return _models;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AIModelProvider
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIModelProviderCopyWith<_AIModelProvider> get copyWith => __$AIModelProviderCopyWithImpl<_AIModelProvider>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIModelProviderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIModelProvider&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&const DeepCollectionEquality().equals(other._models, _models));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,providerId,providerName,sourceUrl,const DeepCollectionEquality().hash(_models));

@override
String toString() {
  return 'AIModelProvider(providerId: $providerId, providerName: $providerName, sourceUrl: $sourceUrl, models: $models)';
}


}

/// @nodoc
abstract mixin class _$AIModelProviderCopyWith<$Res> implements $AIModelProviderCopyWith<$Res> {
  factory _$AIModelProviderCopyWith(_AIModelProvider value, $Res Function(_AIModelProvider) _then) = __$AIModelProviderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "provider_id") ModelAPIProvider? providerId,@JsonKey(name: "provider_name") String? providerName,@JsonKey(name: "source_url") String? sourceUrl,@JsonKey(name: "models") List<Model>? models
});




}
/// @nodoc
class __$AIModelProviderCopyWithImpl<$Res>
    implements _$AIModelProviderCopyWith<$Res> {
  __$AIModelProviderCopyWithImpl(this._self, this._then);

  final _AIModelProvider _self;
  final $Res Function(_AIModelProvider) _then;

/// Create a copy of AIModelProvider
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? providerId = freezed,Object? providerName = freezed,Object? sourceUrl = freezed,Object? models = freezed,}) {
  return _then(_AIModelProvider(
providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as ModelAPIProvider?,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,models: freezed == models ? _self._models : models // ignore: cast_nullable_to_non_nullable
as List<Model>?,
  ));
}


}


/// @nodoc
mixin _$Model {

@JsonKey(name: "id") String? get id;@JsonKey(name: "name") String? get name;
/// Create a copy of Model
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelCopyWith<Model> get copyWith => _$ModelCopyWithImpl<Model>(this as Model, _$identity);

  /// Serializes this Model to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Model&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'Model(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $ModelCopyWith<$Res>  {
  factory $ModelCopyWith(Model value, $Res Function(Model) _then) = _$ModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String? id,@JsonKey(name: "name") String? name
});




}
/// @nodoc
class _$ModelCopyWithImpl<$Res>
    implements $ModelCopyWith<$Res> {
  _$ModelCopyWithImpl(this._self, this._then);

  final Model _self;
  final $Res Function(Model) _then;

/// Create a copy of Model
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Model].
extension ModelPatterns on Model {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Model value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Model() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Model value)  $default,){
final _that = this;
switch (_that) {
case _Model():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Model value)?  $default,){
final _that = this;
switch (_that) {
case _Model() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String? id, @JsonKey(name: "name")  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Model() when $default != null:
return $default(_that.id,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String? id, @JsonKey(name: "name")  String? name)  $default,) {final _that = this;
switch (_that) {
case _Model():
return $default(_that.id,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  String? id, @JsonKey(name: "name")  String? name)?  $default,) {final _that = this;
switch (_that) {
case _Model() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Model implements Model {
  const _Model({@JsonKey(name: "id") this.id, @JsonKey(name: "name") this.name});
  factory _Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

@override@JsonKey(name: "id") final  String? id;
@override@JsonKey(name: "name") final  String? name;

/// Create a copy of Model
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelCopyWith<_Model> get copyWith => __$ModelCopyWithImpl<_Model>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Model&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'Model(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ModelCopyWith<$Res> implements $ModelCopyWith<$Res> {
  factory _$ModelCopyWith(_Model value, $Res Function(_Model) _then) = __$ModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String? id,@JsonKey(name: "name") String? name
});




}
/// @nodoc
class __$ModelCopyWithImpl<$Res>
    implements _$ModelCopyWith<$Res> {
  __$ModelCopyWithImpl(this._self, this._then);

  final _Model _self;
  final $Res Function(_Model) _then;

/// Create a copy of Model
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(_Model(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
