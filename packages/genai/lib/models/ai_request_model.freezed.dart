// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIRequestModel {

 ModelAPIProvider? get modelApiProvider; String get url; String? get model; String? get apiKey;@JsonKey(name: "system_prompt") String get systemPrompt;@JsonKey(name: "user_prompt") String get userPrompt;@JsonKey(name: "model_configs") List<ModelConfig> get modelConfigs; bool? get stream;
/// Create a copy of AIRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIRequestModelCopyWith<AIRequestModel> get copyWith => _$AIRequestModelCopyWithImpl<AIRequestModel>(this as AIRequestModel, _$identity);

  /// Serializes this AIRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIRequestModel&&(identical(other.modelApiProvider, modelApiProvider) || other.modelApiProvider == modelApiProvider)&&(identical(other.url, url) || other.url == url)&&(identical(other.model, model) || other.model == model)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.userPrompt, userPrompt) || other.userPrompt == userPrompt)&&const DeepCollectionEquality().equals(other.modelConfigs, modelConfigs)&&(identical(other.stream, stream) || other.stream == stream));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,modelApiProvider,url,model,apiKey,systemPrompt,userPrompt,const DeepCollectionEquality().hash(modelConfigs),stream);

@override
String toString() {
  return 'AIRequestModel(modelApiProvider: $modelApiProvider, url: $url, model: $model, apiKey: $apiKey, systemPrompt: $systemPrompt, userPrompt: $userPrompt, modelConfigs: $modelConfigs, stream: $stream)';
}


}

/// @nodoc
abstract mixin class $AIRequestModelCopyWith<$Res>  {
  factory $AIRequestModelCopyWith(AIRequestModel value, $Res Function(AIRequestModel) _then) = _$AIRequestModelCopyWithImpl;
@useResult
$Res call({
 ModelAPIProvider? modelApiProvider, String url, String? model, String? apiKey,@JsonKey(name: "system_prompt") String systemPrompt,@JsonKey(name: "user_prompt") String userPrompt,@JsonKey(name: "model_configs") List<ModelConfig> modelConfigs, bool? stream
});




}
/// @nodoc
class _$AIRequestModelCopyWithImpl<$Res>
    implements $AIRequestModelCopyWith<$Res> {
  _$AIRequestModelCopyWithImpl(this._self, this._then);

  final AIRequestModel _self;
  final $Res Function(AIRequestModel) _then;

/// Create a copy of AIRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? modelApiProvider = freezed,Object? url = null,Object? model = freezed,Object? apiKey = freezed,Object? systemPrompt = null,Object? userPrompt = null,Object? modelConfigs = null,Object? stream = freezed,}) {
  return _then(_self.copyWith(
modelApiProvider: freezed == modelApiProvider ? _self.modelApiProvider : modelApiProvider // ignore: cast_nullable_to_non_nullable
as ModelAPIProvider?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,systemPrompt: null == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String,userPrompt: null == userPrompt ? _self.userPrompt : userPrompt // ignore: cast_nullable_to_non_nullable
as String,modelConfigs: null == modelConfigs ? _self.modelConfigs : modelConfigs // ignore: cast_nullable_to_non_nullable
as List<ModelConfig>,stream: freezed == stream ? _self.stream : stream // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AIRequestModel].
extension AIRequestModelPatterns on AIRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _AIRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _AIRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ModelAPIProvider? modelApiProvider,  String url,  String? model,  String? apiKey, @JsonKey(name: "system_prompt")  String systemPrompt, @JsonKey(name: "user_prompt")  String userPrompt, @JsonKey(name: "model_configs")  List<ModelConfig> modelConfigs,  bool? stream)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIRequestModel() when $default != null:
return $default(_that.modelApiProvider,_that.url,_that.model,_that.apiKey,_that.systemPrompt,_that.userPrompt,_that.modelConfigs,_that.stream);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ModelAPIProvider? modelApiProvider,  String url,  String? model,  String? apiKey, @JsonKey(name: "system_prompt")  String systemPrompt, @JsonKey(name: "user_prompt")  String userPrompt, @JsonKey(name: "model_configs")  List<ModelConfig> modelConfigs,  bool? stream)  $default,) {final _that = this;
switch (_that) {
case _AIRequestModel():
return $default(_that.modelApiProvider,_that.url,_that.model,_that.apiKey,_that.systemPrompt,_that.userPrompt,_that.modelConfigs,_that.stream);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ModelAPIProvider? modelApiProvider,  String url,  String? model,  String? apiKey, @JsonKey(name: "system_prompt")  String systemPrompt, @JsonKey(name: "user_prompt")  String userPrompt, @JsonKey(name: "model_configs")  List<ModelConfig> modelConfigs,  bool? stream)?  $default,) {final _that = this;
switch (_that) {
case _AIRequestModel() when $default != null:
return $default(_that.modelApiProvider,_that.url,_that.model,_that.apiKey,_that.systemPrompt,_that.userPrompt,_that.modelConfigs,_that.stream);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _AIRequestModel extends AIRequestModel {
  const _AIRequestModel({this.modelApiProvider, this.url = "", this.model = null, this.apiKey = null, @JsonKey(name: "system_prompt") this.systemPrompt = "", @JsonKey(name: "user_prompt") this.userPrompt = "", @JsonKey(name: "model_configs") final  List<ModelConfig> modelConfigs = const <ModelConfig>[], this.stream = null}): _modelConfigs = modelConfigs,super._();
  factory _AIRequestModel.fromJson(Map<String, dynamic> json) => _$AIRequestModelFromJson(json);

@override final  ModelAPIProvider? modelApiProvider;
@override@JsonKey() final  String url;
@override@JsonKey() final  String? model;
@override@JsonKey() final  String? apiKey;
@override@JsonKey(name: "system_prompt") final  String systemPrompt;
@override@JsonKey(name: "user_prompt") final  String userPrompt;
 final  List<ModelConfig> _modelConfigs;
@override@JsonKey(name: "model_configs") List<ModelConfig> get modelConfigs {
  if (_modelConfigs is EqualUnmodifiableListView) return _modelConfigs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modelConfigs);
}

@override@JsonKey() final  bool? stream;

/// Create a copy of AIRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIRequestModelCopyWith<_AIRequestModel> get copyWith => __$AIRequestModelCopyWithImpl<_AIRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIRequestModel&&(identical(other.modelApiProvider, modelApiProvider) || other.modelApiProvider == modelApiProvider)&&(identical(other.url, url) || other.url == url)&&(identical(other.model, model) || other.model == model)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.userPrompt, userPrompt) || other.userPrompt == userPrompt)&&const DeepCollectionEquality().equals(other._modelConfigs, _modelConfigs)&&(identical(other.stream, stream) || other.stream == stream));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,modelApiProvider,url,model,apiKey,systemPrompt,userPrompt,const DeepCollectionEquality().hash(_modelConfigs),stream);

@override
String toString() {
  return 'AIRequestModel(modelApiProvider: $modelApiProvider, url: $url, model: $model, apiKey: $apiKey, systemPrompt: $systemPrompt, userPrompt: $userPrompt, modelConfigs: $modelConfigs, stream: $stream)';
}


}

/// @nodoc
abstract mixin class _$AIRequestModelCopyWith<$Res> implements $AIRequestModelCopyWith<$Res> {
  factory _$AIRequestModelCopyWith(_AIRequestModel value, $Res Function(_AIRequestModel) _then) = __$AIRequestModelCopyWithImpl;
@override @useResult
$Res call({
 ModelAPIProvider? modelApiProvider, String url, String? model, String? apiKey,@JsonKey(name: "system_prompt") String systemPrompt,@JsonKey(name: "user_prompt") String userPrompt,@JsonKey(name: "model_configs") List<ModelConfig> modelConfigs, bool? stream
});




}
/// @nodoc
class __$AIRequestModelCopyWithImpl<$Res>
    implements _$AIRequestModelCopyWith<$Res> {
  __$AIRequestModelCopyWithImpl(this._self, this._then);

  final _AIRequestModel _self;
  final $Res Function(_AIRequestModel) _then;

/// Create a copy of AIRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? modelApiProvider = freezed,Object? url = null,Object? model = freezed,Object? apiKey = freezed,Object? systemPrompt = null,Object? userPrompt = null,Object? modelConfigs = null,Object? stream = freezed,}) {
  return _then(_AIRequestModel(
modelApiProvider: freezed == modelApiProvider ? _self.modelApiProvider : modelApiProvider // ignore: cast_nullable_to_non_nullable
as ModelAPIProvider?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,systemPrompt: null == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String,userPrompt: null == userPrompt ? _self.userPrompt : userPrompt // ignore: cast_nullable_to_non_nullable
as String,modelConfigs: null == modelConfigs ? _self._modelConfigs : modelConfigs // ignore: cast_nullable_to_non_nullable
as List<ModelConfig>,stream: freezed == stream ? _self.stream : stream // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
