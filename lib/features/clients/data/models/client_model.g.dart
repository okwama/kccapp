// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientModel _$ClientModelFromJson(Map<String, dynamic> json) => ClientModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      balance: (json['balance'] as num?)?.toDouble(),
      email: json['email'] as String?,
      regionId: (json['region_id'] as num).toInt(),
      region: json['region'] as String,
      routeId: (json['route_id'] as num?)?.toInt(),
      routeName: json['route_name'] as String?,
      contact: json['contact'] as String?,
      taxPin: json['tax_pin'] as String?,
      location: json['location'] as String?,
      status: (json['status'] as num).toInt(),
      clientType: (json['client_type'] as num?)?.toInt(),
      outletAccount: (json['outlet_account'] as num?)?.toInt(),
      countryId: (json['countryId'] as num).toInt(),
      addedBy: (json['added_by'] as num?)?.toInt(),
      addedByUser: json['addedByUser'] == null
          ? null
          : SalesRep.fromJson(json['addedByUser'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ClientModelToJson(ClientModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'balance': instance.balance,
      'email': instance.email,
      'region_id': instance.regionId,
      'region': instance.region,
      'route_id': instance.routeId,
      'route_name': instance.routeName,
      'contact': instance.contact,
      'tax_pin': instance.taxPin,
      'location': instance.location,
      'status': instance.status,
      'client_type': instance.clientType,
      'outlet_account': instance.outletAccount,
      'countryId': instance.countryId,
      'added_by': instance.addedBy,
      'addedByUser': instance.addedByUser,
      'created_at': instance.createdAt?.toIso8601String(),
    };
