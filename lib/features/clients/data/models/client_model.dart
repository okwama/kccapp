import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/client.dart';
import '../../../../core/models/auth_models.dart';

part 'client_model.g.dart';

@JsonSerializable()
class ClientModel {
  final int id;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'balance')
  final double? balance;
  final String? email;
  @JsonKey(name: 'region_id')
  final int regionId;
  final String region;
  @JsonKey(name: 'route_id')
  final int? routeId;
  @JsonKey(name: 'route_name')
  final String? routeName;
  final String? contact;
  @JsonKey(name: 'tax_pin')
  final String? taxPin;
  final String? location;
  final int status;
  @JsonKey(name: 'client_type')
  final int? clientType;
  @JsonKey(name: 'outlet_account')
  final int? outletAccount;
  final int countryId;
  @JsonKey(name: 'added_by')
  final int? addedBy;
  @JsonKey(name: 'addedByUser')
  final SalesRep? addedByUser;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const ClientModel({
    required this.id,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.balance,
    this.email,
    required this.regionId,
    required this.region,
    this.routeId,
    this.routeName,
    this.contact,
    this.taxPin,
    this.location,
    required this.status,
    this.clientType,
    this.outletAccount,
    required this.countryId,
    this.addedBy,
    this.addedByUser,
    this.createdAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) =>
      _$ClientModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClientModelToJson(this);

  Client toEntity() {
    return Client(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      balance: balance,
      email: email,
      regionId: regionId,
      region: region,
      routeId: routeId,
      routeName: routeName,
      contact: contact,
      taxPin: taxPin,
      location: location,
      status: status,
      clientType: clientType,
      outletAccount: outletAccount,
      countryId: countryId,
      addedBy: addedBy,
      addedByUser: addedByUser,
      createdAt: createdAt,
    );
  }

  factory ClientModel.fromEntity(Client entity) {
    return ClientModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      balance: entity.balance,
      email: entity.email,
      regionId: entity.regionId,
      region: entity.region,
      routeId: entity.routeId,
      routeName: entity.routeName,
      contact: entity.contact,
      taxPin: entity.taxPin,
      location: entity.location,
      status: entity.status,
      clientType: entity.clientType,
      outletAccount: entity.outletAccount,
      countryId: entity.countryId,
      addedBy: entity.addedBy,
      addedByUser: entity.addedByUser,
      createdAt: entity.createdAt,
    );
  }
}
