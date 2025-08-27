import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/journey_plan.dart';
import '../../../../core/models/auth_models.dart';
import '../../../clients/data/models/client_model.dart';
import '../../../clients/domain/entities/client.dart';

part 'journey_plan_model.g.dart';

// Helper functions for bool/int conversion
bool _boolFromInt(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value == '1' || value.toLowerCase() == 'true';
  return false;
}

int _boolToInt(bool value) => value ? 1 : 0;

// Simplified models for journey plan context
@JsonSerializable()
class SimpleClient {
  final int id;
  final String name;

  const SimpleClient({
    required this.id,
    required this.name,
  });

  factory SimpleClient.fromJson(Map<String, dynamic> json) =>
      _$SimpleClientFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleClientToJson(this);
}

@JsonSerializable()
class SimpleSalesRep {
  final int id;
  final String name;

  const SimpleSalesRep({
    required this.id,
    required this.name,
  });

  factory SimpleSalesRep.fromJson(Map<String, dynamic> json) =>
      _$SimpleSalesRepFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleSalesRepToJson(this);
}

// Helper function to safely parse journey plan data
JourneyPlanModel _safeParseJourneyPlan(Map<String, dynamic> json) {
  try {
    return JourneyPlanModel.fromJson(json);
  } catch (e) {
    print('⚠️ JourneyPlan parsing error: $e');
    print('⚠️ Problematic JSON: $json');

    // If parsing fails, try to create with default values for required fields
    return JourneyPlanModel(
      id: json['id'] ?? 0,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      time: json['time']?.toString() ?? '00:00',
      userId: json['userId'] ?? 0,
      clientId: json['clientId'] ?? 0,
      status: json['status'] ?? 0,
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime'].toString())
          : null,
      latitude:
          json['latitude'] is num ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] is num
          ? (json['longitude'] as num).toDouble()
          : null,
      imageUrl: json['imageUrl']?.toString(),
      notes: json['notes']?.toString(),
      checkoutTime: json['checkoutTime'] != null
          ? DateTime.tryParse(json['checkoutTime'].toString())
          : null,
      checkoutLatitude: json['checkoutLatitude'] is num
          ? (json['checkoutLatitude'] as num).toDouble()
          : null,
      checkoutLongitude: json['checkoutLongitude'] is num
          ? (json['checkoutLongitude'] as num).toDouble()
          : null,
      showUpdateLocation: json['showUpdateLocation'] == null
          ? true
          : _boolFromInt(json['showUpdateLocation']),
      routeId: json['routeId'],
      client: json['client'] is Map<String, dynamic>
          ? SimpleClient.fromJson(json['client'] as Map<String, dynamic>)
          : null,
      user: json['user'] is Map<String, dynamic>
          ? SimpleSalesRep.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

@JsonSerializable()
class JourneyPlanModel {
  final int id;
  @JsonKey(name: 'date')
  final DateTime date;
  final String time;
  @JsonKey(name: 'userId')
  final int userId;
  @JsonKey(name: 'clientId')
  final int clientId;
  final int status;
  @JsonKey(name: 'checkInTime')
  final DateTime? checkInTime;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  final String? notes;
  @JsonKey(name: 'checkoutTime')
  final DateTime? checkoutTime;
  final double? checkoutLatitude;
  final double? checkoutLongitude;
  @JsonKey(
      name: 'showUpdateLocation', fromJson: _boolFromInt, toJson: _boolToInt)
  final bool showUpdateLocation;
  @JsonKey(name: 'routeId')
  final int? routeId;
  final SimpleClient? client;
  final SimpleSalesRep? user;

  const JourneyPlanModel({
    required this.id,
    required this.date,
    required this.time,
    required this.userId,
    required this.clientId,
    required this.status,
    this.checkInTime,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.notes,
    this.checkoutTime,
    this.checkoutLatitude,
    this.checkoutLongitude,
    this.showUpdateLocation = true,
    this.routeId,
    this.client,
    this.user,
  });

  factory JourneyPlanModel.fromJson(Map<String, dynamic> json) =>
      _$JourneyPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$JourneyPlanModelToJson(this);

  JourneyPlan toEntity() {
    return JourneyPlan(
      id: id,
      date: date,
      time: time,
      userId: userId,
      clientId: clientId,
      status: status,
      checkInTime: checkInTime,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      notes: notes,
      checkoutTime: checkoutTime,
      checkoutLatitude: checkoutLatitude,
      checkoutLongitude: checkoutLongitude,
      showUpdateLocation: showUpdateLocation,
      routeId: routeId,
      client: client != null
          ? Client(
              id: client!.id,
              name: client!.name,
              address: null,
              latitude: null,
              longitude: null,
              balance: null,
              email: null,
              regionId: 0,
              region: '',
              routeId: null,
              routeName: null,
              contact: null,
              taxPin: null,
              location: null,
              status: 0,
              clientType: null,
              outletAccount: null,
              countryId: 0,
              addedBy: null,
              addedByUser: null,
              createdAt: null,
            )
          : null,
      user: user != null
          ? SalesRep(
              id: user!.id,
              name: user!.name,
              email: '',
              phoneNumber: '',
              role: '',
              countryId: 0,
              regionId: 0,
              routeId: 0,
              status: 0,
              photoUrl: null,
            )
          : null,
    );
  }

  factory JourneyPlanModel.fromEntity(JourneyPlan entity) {
    return JourneyPlanModel(
      id: entity.id,
      date: entity.date,
      time: entity.time,
      userId: entity.userId,
      clientId: entity.clientId,
      status: entity.status,
      checkInTime: entity.checkInTime,
      latitude: entity.latitude,
      longitude: entity.longitude,
      imageUrl: entity.imageUrl,
      notes: entity.notes,
      checkoutTime: entity.checkoutTime,
      checkoutLatitude: entity.checkoutLatitude,
      checkoutLongitude: entity.checkoutLongitude,
      showUpdateLocation: entity.showUpdateLocation,
      routeId: entity.routeId,
      client: entity.client != null
          ? SimpleClient(
              id: entity.client!.id,
              name: entity.client!.name,
            )
          : null,
      user: entity.user != null
          ? SimpleSalesRep(
              id: entity.user!.id,
              name: entity.user!.name,
            )
          : null,
    );
  }
}
