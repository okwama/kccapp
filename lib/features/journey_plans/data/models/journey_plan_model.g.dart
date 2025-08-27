// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleClient _$SimpleClientFromJson(Map<String, dynamic> json) => SimpleClient(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$SimpleClientToJson(SimpleClient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

SimpleSalesRep _$SimpleSalesRepFromJson(Map<String, dynamic> json) =>
    SimpleSalesRep(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$SimpleSalesRepToJson(SimpleSalesRep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

JourneyPlanModel _$JourneyPlanModelFromJson(Map<String, dynamic> json) =>
    JourneyPlanModel(
      id: (json['id'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      userId: (json['userId'] as num).toInt(),
      clientId: (json['clientId'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      checkInTime: json['checkInTime'] == null
          ? null
          : DateTime.parse(json['checkInTime'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      notes: json['notes'] as String?,
      checkoutTime: json['checkoutTime'] == null
          ? null
          : DateTime.parse(json['checkoutTime'] as String),
      checkoutLatitude: (json['checkoutLatitude'] as num?)?.toDouble(),
      checkoutLongitude: (json['checkoutLongitude'] as num?)?.toDouble(),
      showUpdateLocation: json['showUpdateLocation'] == null
          ? true
          : _boolFromInt(json['showUpdateLocation']),
      routeId: (json['routeId'] as num?)?.toInt(),
      client: json['client'] == null
          ? null
          : SimpleClient.fromJson(json['client'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : SimpleSalesRep.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JourneyPlanModelToJson(JourneyPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'userId': instance.userId,
      'clientId': instance.clientId,
      'status': instance.status,
      'checkInTime': instance.checkInTime?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imageUrl': instance.imageUrl,
      'notes': instance.notes,
      'checkoutTime': instance.checkoutTime?.toIso8601String(),
      'checkoutLatitude': instance.checkoutLatitude,
      'checkoutLongitude': instance.checkoutLongitude,
      'showUpdateLocation': _boolToInt(instance.showUpdateLocation),
      'routeId': instance.routeId,
      'client': instance.client,
      'user': instance.user,
    };
