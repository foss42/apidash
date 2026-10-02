// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'name_path_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NamePathModel {

 String get name; String get path;
/// Create a copy of NamePathModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NamePathModelCopyWith<NamePathModel> get copyWith => _$NamePathModelCopyWithImpl<NamePathModel>(this as NamePathModel, _$identity);

  /// Serializes this NamePathModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NamePathModel&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path);

@override
String toString() {
  return 'NamePathModel(name: $name, path: $path)';
}


}

/// @nodoc
abstract mixin class $NamePathModelCopyWith<$Res>  {
  factory $NamePathModelCopyWith(NamePathModel value, $Res Function(NamePathModel) _then) = _$NamePathModelCopyWithImpl;
@useResult
$Res call({
 String name, String path
});




}
/// @nodoc
class _$NamePathModelCopyWithImpl<$Res>
    implements $NamePathModelCopyWith<$Res> {
  _$NamePathModelCopyWithImpl(this._self, this._then);

  final NamePathModel _self;
  final $Res Function(NamePathModel) _then;

/// Create a copy of NamePathModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? path = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NamePathModel].
extension NamePathModelPatterns on NamePathModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NamePathModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NamePathModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NamePathModel value)  $default,){
final _that = this;
switch (_that) {
case _NamePathModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NamePathModel value)?  $default,){
final _that = this;
switch (_that) {
case _NamePathModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String path)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NamePathModel() when $default != null:
return $default(_that.name,_that.path);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String path)  $default,) {final _that = this;
switch (_that) {
case _NamePathModel():
return $default(_that.name,_that.path);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String path)?  $default,) {final _that = this;
switch (_that) {
case _NamePathModel() when $default != null:
return $default(_that.name,_that.path);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NamePathModel implements NamePathModel {
  const _NamePathModel({required this.name, required this.path});
  factory _NamePathModel.fromJson(Map<String, dynamic> json) => _$NamePathModelFromJson(json);

@override final  String name;
@override final  String path;

/// Create a copy of NamePathModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NamePathModelCopyWith<_NamePathModel> get copyWith => __$NamePathModelCopyWithImpl<_NamePathModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NamePathModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NamePathModel&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path);

@override
String toString() {
  return 'NamePathModel(name: $name, path: $path)';
}


}

/// @nodoc
abstract mixin class _$NamePathModelCopyWith<$Res> implements $NamePathModelCopyWith<$Res> {
  factory _$NamePathModelCopyWith(_NamePathModel value, $Res Function(_NamePathModel) _then) = __$NamePathModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String path
});




}
/// @nodoc
class __$NamePathModelCopyWithImpl<$Res>
    implements _$NamePathModelCopyWith<$Res> {
  __$NamePathModelCopyWithImpl(this._self, this._then);

  final _NamePathModel _self;
  final $Res Function(_NamePathModel) _then;

/// Create a copy of NamePathModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,}) {
  return _then(_NamePathModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
