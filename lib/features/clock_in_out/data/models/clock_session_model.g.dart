// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClockSessionModel _$ClockSessionModelFromJson(Map<String, dynamic> json) =>
    ClockSessionModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      timezone: json['timezone'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      status: (json['status'] as num).toInt(),
      sessionEnd: json['sessionEnd'] as String?,
      sessionStart: json['sessionStart'] as String,
    );

Map<String, dynamic> _$ClockSessionModelToJson(ClockSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'timezone': instance.timezone,
      'duration': instance.duration,
      'status': instance.status,
      'sessionEnd': instance.sessionEnd,
      'sessionStart': instance.sessionStart,
    };
