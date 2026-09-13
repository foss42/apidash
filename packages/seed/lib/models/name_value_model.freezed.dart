// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'name_value_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NameValueModel {

 String get name; dynamic get value;
/// Create a copy of NameValueModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NameValueModelCopyWith<NameValueModel> get copyWith => _$NameValueModelCopyWithImpl<NameValueModel>(this as NameValueModel, _$identity);

  /// Serializes this NameValueModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NameValueModel&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'NameValueModel(name: $name, value: $value)';
}


}

/// @nodoc
abstract mixin class $NameValueModelCopyWith<$Res>  {
  factory $NameValueModelCopyWith(NameValueModel value, $Res Function(NameValueModel) _then) = _$NameValueModelCopyWithImpl;
@useResult
$Res call({
 String name, dynamic value
});




}
/// @nodoc
class _$NameValueModelCopyWithImpl<$Res>
    implements $NameValueModelCopyWith<$Res> {
  _$NameValueModelCopyWithImpl(this._self, this._then);

  final NameValueModel _self;
  final $Res Function(NameValueModel) _then;

/// Create a copy of NameValueModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? value = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [NameValueModel].
extension NameValueModelPatterns on NameValueModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NameValueModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NameValueModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NameValueModel value)  $default,){
final _that = this;
switch (_that) {
case _NameValueModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NameValueModel value)?  $default,){
final _that = this;
switch (_that) {
case _NameValueModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  dynamic value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NameValueModel() when $default != null:
return $default(_that.name,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  dynamic value)  $default,) {final _that = this;
switch (_that) {
case _NameValueModel():
return $default(_that.name,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  dynamic value)?  $default,) {final _that = this;
switch (_that) {
case _NameValueModel() when $default != null:
return $default(_that.name,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NameValueModel implements NameValueModel {
  const _NameValueModel({required this.name, required this.value});
  factory _NameValueModel.fromJson(Map<String, dynamic> json) => _$NameValueModelFromJson(json);

@override final  String name;
@override final  dynamic value;

/// Create a copy of NameValueModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameValueModelCopyWith<_NameValueModel> get copyWith => __$NameValueModelCopyWithImpl<_NameValueModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NameValueModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameValueModel&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'NameValueModel(name: $name, value: $value)';
}


}

/// @nodoc
abstract mixin class _$NameValueModelCopyWith<$Res> implements $NameValueModelCopyWith<$Res> {
  factory _$NameValueModelCopyWith(_NameValueModel value, $Res Function(_NameValueModel) _then) = __$NameValueModelCopyWithImpl;
@override @useResult
$Res call({
 String name, dynamic value
});




}
/// @nodoc
class __$NameValueModelCopyWithImpl<$Res>
    implements _$NameValueModelCopyWith<$Res> {
  __$NameValueModelCopyWithImpl(this._self, this._then);

  final _NameValueModel _self;
  final $Res Function(_NameValueModel) _then;

/// Create a copy of NameValueModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? value = freezed,}) {
  return _then(_NameValueModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
