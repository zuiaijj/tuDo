// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      session: json['session'] as String?,
      name: json['name'] as String,
      gender: (json['gender'] as num).toInt(),
      phone: json['phone'] as String,
      avatar: json['avatar'] as String,
      frameUrl: json['frameUrl'] as String,
      birth: json['birth'] as String,
      height: (json['height'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'session': instance.session,
      'name': instance.name,
      'gender': instance.gender,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'frameUrl': instance.frameUrl,
      'birth': instance.birth,
      'height': instance.height,
      'description': instance.description,
    };
