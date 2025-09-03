// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientModelAdapter extends TypeAdapter<ClientModel> {
  @override
  final int typeId = 0;

  @override
  ClientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientModel(
      id: fields[0] as int,
      name: fields[1] as String,
      address: fields[2] as String?,
      latitude: fields[3] as double?,
      longitude: fields[4] as double?,
      balance: fields[5] as double?,
      email: fields[6] as String?,
      regionId: fields[7] as int,
      region: fields[8] as String,
      routeId: fields[9] as int?,
      routeName: fields[10] as String?,
      contact: fields[11] as String?,
      taxPin: fields[12] as String?,
      location: fields[13] as String?,
      status: fields[14] as int,
      clientType: fields[15] as int?,
      outletAccount: fields[16] as int?,
      countryId: fields[17] as int,
      addedBy: fields[18] as int?,
      addedByUser: fields[19] as SalesRep?,
      createdAt: fields[20] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ClientModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.balance)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.regionId)
      ..writeByte(8)
      ..write(obj.region)
      ..writeByte(9)
      ..write(obj.routeId)
      ..writeByte(10)
      ..write(obj.routeName)
      ..writeByte(11)
      ..write(obj.contact)
      ..writeByte(12)
      ..write(obj.taxPin)
      ..writeByte(13)
      ..write(obj.location)
      ..writeByte(14)
      ..write(obj.status)
      ..writeByte(15)
      ..write(obj.clientType)
      ..writeByte(16)
      ..write(obj.outletAccount)
      ..writeByte(17)
      ..write(obj.countryId)
      ..writeByte(18)
      ..write(obj.addedBy)
      ..writeByte(19)
      ..write(obj.addedByUser)
      ..writeByte(20)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
