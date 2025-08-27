import '../../../../core/models/auth_models.dart';

class Client {
  final int id;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? balance;
  final String? email;
  final int regionId;
  final String region;
  final int? routeId;
  final String? routeName;
  final String? contact;
  final String? taxPin;
  final String? location;
  final int status;
  final int? clientType;
  final int? outletAccount;
  final int countryId;
  final int? addedBy;
  final SalesRep? addedByUser;
  final DateTime? createdAt;

  const Client({
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

  Client copyWith({
    int? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    double? balance,
    String? email,
    int? regionId,
    String? region,
    int? routeId,
    String? routeName,
    String? contact,
    String? taxPin,
    String? location,
    int? status,
    int? clientType,
    int? outletAccount,
    int? countryId,
    int? addedBy,
    SalesRep? addedByUser,
    DateTime? createdAt,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      balance: balance ?? this.balance,
      email: email ?? this.email,
      regionId: regionId ?? this.regionId,
      region: region ?? this.region,
      routeId: routeId ?? this.routeId,
      routeName: routeName ?? this.routeName,
      contact: contact ?? this.contact,
      taxPin: taxPin ?? this.taxPin,
      location: location ?? this.location,
      status: status ?? this.status,
      clientType: clientType ?? this.clientType,
      outletAccount: outletAccount ?? this.outletAccount,
      countryId: countryId ?? this.countryId,
      addedBy: addedBy ?? this.addedBy,
      addedByUser: addedByUser ?? this.addedByUser,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Client && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Client(id: $id, name: $name, contact: $contact, status: $status)';
  }
}
