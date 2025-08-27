// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_journey_plan_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateJourneyPlanRequest _$CreateJourneyPlanRequestFromJson(
        Map<String, dynamic> json) =>
    CreateJourneyPlanRequest(
      clientId: (json['clientId'] as num).toInt(),
      date: json['date'] as String,
      time: json['time'] as String,
      notes: json['notes'] as String?,
      routeId: (json['routeId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateJourneyPlanRequestToJson(
        CreateJourneyPlanRequest instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'date': instance.date,
      'time': instance.time,
      'notes': instance.notes,
      'routeId': instance.routeId,
    };
