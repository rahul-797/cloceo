// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  List<Map<String, dynamic>> get habitDetails => throw _privateConstructorUsedError;

  set habitDetails(List<Map<String, dynamic>> value) => throw _privateConstructorUsedError;

  List<Map<String, dynamic>> get habitRecords => throw _privateConstructorUsedError;

  set habitRecords(List<Map<String, dynamic>> value) => throw _privateConstructorUsedError;

  List<Map<String, dynamic>> get habitBreakDetails => throw _privateConstructorUsedError;

  set habitBreakDetails(List<Map<String, dynamic>> value) => throw _privateConstructorUsedError;

  List<Map<String, dynamic>> get habitBreakRecords => throw _privateConstructorUsedError;

  set habitBreakRecords(List<Map<String, dynamic>> value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) = _$UserModelCopyWithImpl<$Res>;

  $Res call(
      {List<Map<String, dynamic>> habitDetails,
      List<Map<String, dynamic>> habitRecords,
      List<Map<String, dynamic>> habitBreakDetails,
      List<Map<String, dynamic>> habitBreakRecords});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res> implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  final UserModel _value;
  // ignore: unused_field
  final $Res Function(UserModel) _then;

  @override
  $Res call({
    Object? habitDetails = freezed,
    Object? habitRecords = freezed,
    Object? habitBreakDetails = freezed,
    Object? habitBreakRecords = freezed,
  }) {
    return _then(_value.copyWith(
      habitDetails: habitDetails == freezed
          ? _value.habitDetails
          : habitDetails // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      habitRecords: habitRecords == freezed
          ? _value.habitRecords
          : habitRecords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      habitBreakDetails: habitBreakDetails == freezed
          ? _value.habitBreakDetails
          : habitBreakDetails // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      habitBreakRecords: habitBreakRecords == freezed
          ? _value.habitBreakRecords
          : habitBreakRecords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
abstract class _$$_UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$$_UserModelCopyWith(_$_UserModel value, $Res Function(_$_UserModel) then) =
      __$$_UserModelCopyWithImpl<$Res>;

  @override
  $Res call(
      {List<Map<String, dynamic>> habitDetails,
      List<Map<String, dynamic>> habitRecords,
      List<Map<String, dynamic>> habitBreakDetails,
      List<Map<String, dynamic>> habitBreakRecords});
}

/// @nodoc
class __$$_UserModelCopyWithImpl<$Res> extends _$UserModelCopyWithImpl<$Res> implements _$$_UserModelCopyWith<$Res> {
  __$$_UserModelCopyWithImpl(_$_UserModel _value, $Res Function(_$_UserModel) _then)
      : super(_value, (v) => _then(v as _$_UserModel));

  @override
  _$_UserModel get _value => super._value as _$_UserModel;

  @override
  $Res call({
    Object? habitDetails = freezed,
    Object? habitRecords = freezed,
    Object? habitBreakDetails = freezed,
    Object? habitBreakRecords = freezed,
  }) {
    return _then(_$_UserModel(
      habitDetails: habitDetails == freezed
          ? _value.habitDetails
          : habitDetails // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      habitRecords: habitRecords == freezed
          ? _value.habitRecords
          : habitRecords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      habitBreakDetails: habitBreakDetails == freezed
          ? _value.habitBreakDetails
          : habitBreakDetails // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      habitBreakRecords: habitBreakRecords == freezed
          ? _value.habitBreakRecords
          : habitBreakRecords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserModel implements _UserModel {
  _$_UserModel(
      {required this.habitDetails,
      required this.habitRecords,
      required this.habitBreakDetails,
      required this.habitBreakRecords});

  factory _$_UserModel.fromJson(Map<String, dynamic> json) => _$$_UserModelFromJson(json);

  @override
  List<Map<String, dynamic>> habitDetails;
  @override
  List<Map<String, dynamic>> habitRecords;
  @override
  List<Map<String, dynamic>> habitBreakDetails;
  @override
  List<Map<String, dynamic>> habitBreakRecords;

  @override
  String toString() {
    return 'UserModel(habitDetails: $habitDetails, habitRecords: $habitRecords, habitBreakDetails: $habitBreakDetails, habitBreakRecords: $habitBreakRecords)';
  }

  @JsonKey(ignore: true)
  @override
  _$$_UserModelCopyWith<_$_UserModel> get copyWith => __$$_UserModelCopyWithImpl<_$_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserModelToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  factory _UserModel(
      {required List<Map<String, dynamic>> habitDetails,
      required List<Map<String, dynamic>> habitRecords,
      required List<Map<String, dynamic>> habitBreakDetails,
      required List<Map<String, dynamic>> habitBreakRecords}) = _$_UserModel;

  factory _UserModel.fromJson(Map<String, dynamic> json) = _$_UserModel.fromJson;

  @override
  List<Map<String, dynamic>> get habitDetails;

  set habitDetails(List<Map<String, dynamic>> value);

  @override
  List<Map<String, dynamic>> get habitRecords;

  set habitRecords(List<Map<String, dynamic>> value);

  @override
  List<Map<String, dynamic>> get habitBreakDetails;

  set habitBreakDetails(List<Map<String, dynamic>> value);

  @override
  List<Map<String, dynamic>> get habitBreakRecords;

  set habitBreakRecords(List<Map<String, dynamic>> value);

  @override
  @JsonKey(ignore: true)
  _$$_UserModelCopyWith<_$_UserModel> get copyWith => throw _privateConstructorUsedError;
}
