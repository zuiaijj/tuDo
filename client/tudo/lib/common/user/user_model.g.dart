// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['uid'] as num).toInt(),
      session: json['access_token'] as String,
      name: json['nick_name'] as String,
      gender: (json['gender'] as num).toInt(),
      phone: json['phone'] as String,
      avatar: json['avatar'] as String,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.id,
      'access_token': instance.session,
      'nick_name': instance.name,
      'gender': instance.gender,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'is_active': instance.isActive,
    };
