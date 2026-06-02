// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'protocol_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ProtocolModel _$ProtocolModelFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'rest':
          return _RestProtocolModel.fromJson(
            json
          );
                case 'graphql':
          return _GraphqlProtocolModel.fromJson(
            json
          );
                case 'ai':
          return _AiProtocolModel.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'ProtocolModel',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$ProtocolModel {



  /// Serializes this ProtocolModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProtocolModel);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProtocolModel()';
}


}

/// @nodoc
class $ProtocolModelCopyWith<$Res>  {
$ProtocolModelCopyWith(ProtocolModel _, $Res Function(ProtocolModel) __);
}


/// Adds pattern-matching-related methods to [ProtocolModel].
extension ProtocolModelPatterns on ProtocolModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _RestProtocolModel value)?  rest,TResult Function( _GraphqlProtocolModel value)?  graphql,TResult Function( _AiProtocolModel value)?  ai,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestProtocolModel() when rest != null:
return rest(_that);case _GraphqlProtocolModel() when graphql != null:
return graphql(_that);case _AiProtocolModel() when ai != null:
return ai(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _RestProtocolModel value)  rest,required TResult Function( _GraphqlProtocolModel value)  graphql,required TResult Function( _AiProtocolModel value)  ai,}){
final _that = this;
switch (_that) {
case _RestProtocolModel():
return rest(_that);case _GraphqlProtocolModel():
return graphql(_that);case _AiProtocolModel():
return ai(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _RestProtocolModel value)?  rest,TResult? Function( _GraphqlProtocolModel value)?  graphql,TResult? Function( _AiProtocolModel value)?  ai,}){
final _that = this;
switch (_that) {
case _RestProtocolModel() when rest != null:
return rest(_that);case _GraphqlProtocolModel() when graphql != null:
return graphql(_that);case _AiProtocolModel() when ai != null:
return ai(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( HttpRequestModel? httpRequestModel,  HttpResponseModel? httpResponseModel)?  rest,TResult Function( HttpRequestModel? httpRequestModel,  HttpResponseModel? httpResponseModel)?  graphql,TResult Function( AIRequestModel? aiRequestModel)?  ai,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestProtocolModel() when rest != null:
return rest(_that.httpRequestModel,_that.httpResponseModel);case _GraphqlProtocolModel() when graphql != null:
return graphql(_that.httpRequestModel,_that.httpResponseModel);case _AiProtocolModel() when ai != null:
return ai(_that.aiRequestModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( HttpRequestModel? httpRequestModel,  HttpResponseModel? httpResponseModel)  rest,required TResult Function( HttpRequestModel? httpRequestModel,  HttpResponseModel? httpResponseModel)  graphql,required TResult Function( AIRequestModel? aiRequestModel)  ai,}) {final _that = this;
switch (_that) {
case _RestProtocolModel():
return rest(_that.httpRequestModel,_that.httpResponseModel);case _GraphqlProtocolModel():
return graphql(_that.httpRequestModel,_that.httpResponseModel);case _AiProtocolModel():
return ai(_that.aiRequestModel);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( HttpRequestModel? httpRequestModel,  HttpResponseModel? httpResponseModel)?  rest,TResult? Function( HttpRequestModel? httpRequestModel,  HttpResponseModel? httpResponseModel)?  graphql,TResult? Function( AIRequestModel? aiRequestModel)?  ai,}) {final _that = this;
switch (_that) {
case _RestProtocolModel() when rest != null:
return rest(_that.httpRequestModel,_that.httpResponseModel);case _GraphqlProtocolModel() when graphql != null:
return graphql(_that.httpRequestModel,_that.httpResponseModel);case _AiProtocolModel() when ai != null:
return ai(_that.aiRequestModel);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _RestProtocolModel implements ProtocolModel {
  const _RestProtocolModel({this.httpRequestModel, this.httpResponseModel, final  String? $type}): $type = $type ?? 'rest';
  factory _RestProtocolModel.fromJson(Map<String, dynamic> json) => _$RestProtocolModelFromJson(json);

 final  HttpRequestModel? httpRequestModel;
 final  HttpResponseModel? httpResponseModel;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestProtocolModelCopyWith<_RestProtocolModel> get copyWith => __$RestProtocolModelCopyWithImpl<_RestProtocolModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestProtocolModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestProtocolModel&&(identical(other.httpRequestModel, httpRequestModel) || other.httpRequestModel == httpRequestModel)&&(identical(other.httpResponseModel, httpResponseModel) || other.httpResponseModel == httpResponseModel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,httpRequestModel,httpResponseModel);

@override
String toString() {
  return 'ProtocolModel.rest(httpRequestModel: $httpRequestModel, httpResponseModel: $httpResponseModel)';
}


}

/// @nodoc
abstract mixin class _$RestProtocolModelCopyWith<$Res> implements $ProtocolModelCopyWith<$Res> {
  factory _$RestProtocolModelCopyWith(_RestProtocolModel value, $Res Function(_RestProtocolModel) _then) = __$RestProtocolModelCopyWithImpl;
@useResult
$Res call({
 HttpRequestModel? httpRequestModel, HttpResponseModel? httpResponseModel
});


$HttpRequestModelCopyWith<$Res>? get httpRequestModel;$HttpResponseModelCopyWith<$Res>? get httpResponseModel;

}
/// @nodoc
class __$RestProtocolModelCopyWithImpl<$Res>
    implements _$RestProtocolModelCopyWith<$Res> {
  __$RestProtocolModelCopyWithImpl(this._self, this._then);

  final _RestProtocolModel _self;
  final $Res Function(_RestProtocolModel) _then;

/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? httpRequestModel = freezed,Object? httpResponseModel = freezed,}) {
  return _then(_RestProtocolModel(
httpRequestModel: freezed == httpRequestModel ? _self.httpRequestModel : httpRequestModel // ignore: cast_nullable_to_non_nullable
as HttpRequestModel?,httpResponseModel: freezed == httpResponseModel ? _self.httpResponseModel : httpResponseModel // ignore: cast_nullable_to_non_nullable
as HttpResponseModel?,
  ));
}

/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HttpRequestModelCopyWith<$Res>? get httpRequestModel {
    if (_self.httpRequestModel == null) {
    return null;
  }

  return $HttpRequestModelCopyWith<$Res>(_self.httpRequestModel!, (value) {
    return _then(_self.copyWith(httpRequestModel: value));
  });
}/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HttpResponseModelCopyWith<$Res>? get httpResponseModel {
    if (_self.httpResponseModel == null) {
    return null;
  }

  return $HttpResponseModelCopyWith<$Res>(_self.httpResponseModel!, (value) {
    return _then(_self.copyWith(httpResponseModel: value));
  });
}
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _GraphqlProtocolModel implements ProtocolModel {
  const _GraphqlProtocolModel({this.httpRequestModel, this.httpResponseModel, final  String? $type}): $type = $type ?? 'graphql';
  factory _GraphqlProtocolModel.fromJson(Map<String, dynamic> json) => _$GraphqlProtocolModelFromJson(json);

 final  HttpRequestModel? httpRequestModel;
 final  HttpResponseModel? httpResponseModel;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GraphqlProtocolModelCopyWith<_GraphqlProtocolModel> get copyWith => __$GraphqlProtocolModelCopyWithImpl<_GraphqlProtocolModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GraphqlProtocolModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GraphqlProtocolModel&&(identical(other.httpRequestModel, httpRequestModel) || other.httpRequestModel == httpRequestModel)&&(identical(other.httpResponseModel, httpResponseModel) || other.httpResponseModel == httpResponseModel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,httpRequestModel,httpResponseModel);

@override
String toString() {
  return 'ProtocolModel.graphql(httpRequestModel: $httpRequestModel, httpResponseModel: $httpResponseModel)';
}


}

/// @nodoc
abstract mixin class _$GraphqlProtocolModelCopyWith<$Res> implements $ProtocolModelCopyWith<$Res> {
  factory _$GraphqlProtocolModelCopyWith(_GraphqlProtocolModel value, $Res Function(_GraphqlProtocolModel) _then) = __$GraphqlProtocolModelCopyWithImpl;
@useResult
$Res call({
 HttpRequestModel? httpRequestModel, HttpResponseModel? httpResponseModel
});


$HttpRequestModelCopyWith<$Res>? get httpRequestModel;$HttpResponseModelCopyWith<$Res>? get httpResponseModel;

}
/// @nodoc
class __$GraphqlProtocolModelCopyWithImpl<$Res>
    implements _$GraphqlProtocolModelCopyWith<$Res> {
  __$GraphqlProtocolModelCopyWithImpl(this._self, this._then);

  final _GraphqlProtocolModel _self;
  final $Res Function(_GraphqlProtocolModel) _then;

/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? httpRequestModel = freezed,Object? httpResponseModel = freezed,}) {
  return _then(_GraphqlProtocolModel(
httpRequestModel: freezed == httpRequestModel ? _self.httpRequestModel : httpRequestModel // ignore: cast_nullable_to_non_nullable
as HttpRequestModel?,httpResponseModel: freezed == httpResponseModel ? _self.httpResponseModel : httpResponseModel // ignore: cast_nullable_to_non_nullable
as HttpResponseModel?,
  ));
}

/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HttpRequestModelCopyWith<$Res>? get httpRequestModel {
    if (_self.httpRequestModel == null) {
    return null;
  }

  return $HttpRequestModelCopyWith<$Res>(_self.httpRequestModel!, (value) {
    return _then(_self.copyWith(httpRequestModel: value));
  });
}/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HttpResponseModelCopyWith<$Res>? get httpResponseModel {
    if (_self.httpResponseModel == null) {
    return null;
  }

  return $HttpResponseModelCopyWith<$Res>(_self.httpResponseModel!, (value) {
    return _then(_self.copyWith(httpResponseModel: value));
  });
}
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _AiProtocolModel implements ProtocolModel {
  const _AiProtocolModel({this.aiRequestModel, final  String? $type}): $type = $type ?? 'ai';
  factory _AiProtocolModel.fromJson(Map<String, dynamic> json) => _$AiProtocolModelFromJson(json);

 final  AIRequestModel? aiRequestModel;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiProtocolModelCopyWith<_AiProtocolModel> get copyWith => __$AiProtocolModelCopyWithImpl<_AiProtocolModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiProtocolModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiProtocolModel&&(identical(other.aiRequestModel, aiRequestModel) || other.aiRequestModel == aiRequestModel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aiRequestModel);

@override
String toString() {
  return 'ProtocolModel.ai(aiRequestModel: $aiRequestModel)';
}


}

/// @nodoc
abstract mixin class _$AiProtocolModelCopyWith<$Res> implements $ProtocolModelCopyWith<$Res> {
  factory _$AiProtocolModelCopyWith(_AiProtocolModel value, $Res Function(_AiProtocolModel) _then) = __$AiProtocolModelCopyWithImpl;
@useResult
$Res call({
 AIRequestModel? aiRequestModel
});


$AIRequestModelCopyWith<$Res>? get aiRequestModel;

}
/// @nodoc
class __$AiProtocolModelCopyWithImpl<$Res>
    implements _$AiProtocolModelCopyWith<$Res> {
  __$AiProtocolModelCopyWithImpl(this._self, this._then);

  final _AiProtocolModel _self;
  final $Res Function(_AiProtocolModel) _then;

/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? aiRequestModel = freezed,}) {
  return _then(_AiProtocolModel(
aiRequestModel: freezed == aiRequestModel ? _self.aiRequestModel : aiRequestModel // ignore: cast_nullable_to_non_nullable
as AIRequestModel?,
  ));
}

/// Create a copy of ProtocolModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AIRequestModelCopyWith<$Res>? get aiRequestModel {
    if (_self.aiRequestModel == null) {
    return null;
  }

  return $AIRequestModelCopyWith<$Res>(_self.aiRequestModel!, (value) {
    return _then(_self.copyWith(aiRequestModel: value));
  });
}
}

// dart format on
