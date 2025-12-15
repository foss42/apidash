// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'environment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnvironmentModel {
  String get id;
  String get name;
  List<EnvironmentVariableModel> get values;
  int? get color;

  /// Create a copy of EnvironmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnvironmentModelCopyWith<EnvironmentModel> get copyWith =>
      _$EnvironmentModelCopyWithImpl<EnvironmentModel>(
          this as EnvironmentModel, _$identity);

  /// Serializes this EnvironmentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvironmentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.values, values) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name,
      const DeepCollectionEquality().hash(values), color);

  @override
  String toString() {
    return 'EnvironmentModel(id: $id, name: $name, values: $values, color: $color)';
  }
}

/// @nodoc
abstract mixin class $EnvironmentModelCopyWith<$Res> {
  factory $EnvironmentModelCopyWith(
          EnvironmentModel value, $Res Function(EnvironmentModel) _then) =
      _$EnvironmentModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      List<EnvironmentVariableModel> values,
      int? color});
}

/// @nodoc
class _$EnvironmentModelCopyWithImpl<$Res>
    implements $EnvironmentModelCopyWith<$Res> {
  _$EnvironmentModelCopyWithImpl(this._self, this._then);

  final EnvironmentModel _self;
  final $Res Function(EnvironmentModel) _then;

  /// Create a copy of EnvironmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? values = null,
    Object? color = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _self.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<EnvironmentVariableModel>,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [EnvironmentModel].
extension EnvironmentModelPatterns on EnvironmentModel {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_EnvironmentModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EnvironmentModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_EnvironmentModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvironmentModel():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_EnvironmentModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvironmentModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String name,
            List<EnvironmentVariableModel> values, int? color)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EnvironmentModel() when $default != null:
        return $default(_that.id, _that.name, _that.values, _that.color);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String name,
            List<EnvironmentVariableModel> values, int? color)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvironmentModel():
        return $default(_that.id, _that.name, _that.values, _that.color);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String name,
            List<EnvironmentVariableModel> values, int? color)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvironmentModel() when $default != null:
        return $default(_that.id, _that.name, _that.values, _that.color);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _EnvironmentModel implements EnvironmentModel {
  const _EnvironmentModel(
      {required this.id,
      this.name = "",
      final List<EnvironmentVariableModel> values = const [],
      this.color = null})
      : _values = values;
  factory _EnvironmentModel.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentModelFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String name;
  final List<EnvironmentVariableModel> _values;
  @override
  @JsonKey()
  List<EnvironmentVariableModel> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @override
  @JsonKey()
  final int? color;

  /// Create a copy of EnvironmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnvironmentModelCopyWith<_EnvironmentModel> get copyWith =>
      __$EnvironmentModelCopyWithImpl<_EnvironmentModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EnvironmentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnvironmentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name,
      const DeepCollectionEquality().hash(_values), color);

  @override
  String toString() {
    return 'EnvironmentModel(id: $id, name: $name, values: $values, color: $color)';
  }
}

/// @nodoc
abstract mixin class _$EnvironmentModelCopyWith<$Res>
    implements $EnvironmentModelCopyWith<$Res> {
  factory _$EnvironmentModelCopyWith(
          _EnvironmentModel value, $Res Function(_EnvironmentModel) _then) =
      __$EnvironmentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      List<EnvironmentVariableModel> values,
      int? color});
}

/// @nodoc
class __$EnvironmentModelCopyWithImpl<$Res>
    implements _$EnvironmentModelCopyWith<$Res> {
  __$EnvironmentModelCopyWithImpl(this._self, this._then);

  final _EnvironmentModel _self;
  final $Res Function(_EnvironmentModel) _then;

  /// Create a copy of EnvironmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? values = null,
    Object? color = freezed,
  }) {
    return _then(_EnvironmentModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _self._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<EnvironmentVariableModel>,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$EnvironmentVariableModel {
  String get key;
  String get value;
  EnvironmentVariableType get type;
  bool get enabled;

  /// Create a copy of EnvironmentVariableModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnvironmentVariableModelCopyWith<EnvironmentVariableModel> get copyWith =>
      _$EnvironmentVariableModelCopyWithImpl<EnvironmentVariableModel>(
          this as EnvironmentVariableModel, _$identity);

  /// Serializes this EnvironmentVariableModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvironmentVariableModel &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value, type, enabled);

  @override
  String toString() {
    return 'EnvironmentVariableModel(key: $key, value: $value, type: $type, enabled: $enabled)';
  }
}

/// @nodoc
abstract mixin class $EnvironmentVariableModelCopyWith<$Res> {
  factory $EnvironmentVariableModelCopyWith(EnvironmentVariableModel value,
          $Res Function(EnvironmentVariableModel) _then) =
      _$EnvironmentVariableModelCopyWithImpl;
  @useResult
  $Res call(
      {String key, String value, EnvironmentVariableType type, bool enabled});
}

/// @nodoc
class _$EnvironmentVariableModelCopyWithImpl<$Res>
    implements $EnvironmentVariableModelCopyWith<$Res> {
  _$EnvironmentVariableModelCopyWithImpl(this._self, this._then);

  final EnvironmentVariableModel _self;
  final $Res Function(EnvironmentVariableModel) _then;

  /// Create a copy of EnvironmentVariableModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? type = null,
    Object? enabled = null,
  }) {
    return _then(_self.copyWith(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as EnvironmentVariableType,
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [EnvironmentVariableModel].
extension EnvironmentVariableModelPatterns on EnvironmentVariableModel {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_EnvironmentVariableModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EnvironmentVariableModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_EnvironmentVariableModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvironmentVariableModel():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_EnvironmentVariableModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvironmentVariableModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String key, String value, EnvironmentVariableType type,
            bool enabled)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EnvironmentVariableModel() when $default != null:
        return $default(_that.key, _that.value, _that.type, _that.enabled);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String key, String value, EnvironmentVariableType type,
            bool enabled)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvironmentVariableModel():
        return $default(_that.key, _that.value, _that.type, _that.enabled);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String key, String value, EnvironmentVariableType type,
            bool enabled)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvironmentVariableModel() when $default != null:
        return $default(_that.key, _that.value, _that.type, _that.enabled);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _EnvironmentVariableModel implements EnvironmentVariableModel {
  const _EnvironmentVariableModel(
      {required this.key,
      required this.value,
      this.type = EnvironmentVariableType.variable,
      this.enabled = false});
  factory _EnvironmentVariableModel.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentVariableModelFromJson(json);

  @override
  final String key;
  @override
  final String value;
  @override
  @JsonKey()
  final EnvironmentVariableType type;
  @override
  @JsonKey()
  final bool enabled;

  /// Create a copy of EnvironmentVariableModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnvironmentVariableModelCopyWith<_EnvironmentVariableModel> get copyWith =>
      __$EnvironmentVariableModelCopyWithImpl<_EnvironmentVariableModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EnvironmentVariableModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnvironmentVariableModel &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value, type, enabled);

  @override
  String toString() {
    return 'EnvironmentVariableModel(key: $key, value: $value, type: $type, enabled: $enabled)';
  }
}

/// @nodoc
abstract mixin class _$EnvironmentVariableModelCopyWith<$Res>
    implements $EnvironmentVariableModelCopyWith<$Res> {
  factory _$EnvironmentVariableModelCopyWith(_EnvironmentVariableModel value,
          $Res Function(_EnvironmentVariableModel) _then) =
      __$EnvironmentVariableModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String key, String value, EnvironmentVariableType type, bool enabled});
}

/// @nodoc
class __$EnvironmentVariableModelCopyWithImpl<$Res>
    implements _$EnvironmentVariableModelCopyWith<$Res> {
  __$EnvironmentVariableModelCopyWithImpl(this._self, this._then);

  final _EnvironmentVariableModel _self;
  final $Res Function(_EnvironmentVariableModel) _then;

  /// Create a copy of EnvironmentVariableModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? type = null,
    Object? enabled = null,
  }) {
    return _then(_EnvironmentVariableModel(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as EnvironmentVariableType,
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
