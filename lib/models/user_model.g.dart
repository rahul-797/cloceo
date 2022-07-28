// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      habitDetails: (json['habitDetails'] as List<dynamic>).map((e) => e as Map<String, dynamic>).toList(),
      habitRecords: (json['habitRecords'] as List<dynamic>).map((e) => e as Map<String, dynamic>).toList(),
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) => <String, dynamic>{
      'habitDetails': instance.habitDetails,
      'habitRecords': instance.habitRecords,
    };
