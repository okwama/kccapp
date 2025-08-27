import '../../../../core/models/auth_models.dart';
import '../../../clients/domain/entities/client.dart';

class JourneyPlan {
  final int id;
  final DateTime date;
  final String time;
  final int userId;
  final int clientId;
  final int status;
  final DateTime? checkInTime;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final String? notes;
  final DateTime? checkoutTime;
  final double? checkoutLatitude;
  final double? checkoutLongitude;
  final bool showUpdateLocation;
  final int? routeId;
  final Client? client;
  final SalesRep? user;

  const JourneyPlan({
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

  JourneyPlan copyWith({
    int? id,
    DateTime? date,
    String? time,
    int? userId,
    int? clientId,
    int? status,
    DateTime? checkInTime,
    double? latitude,
    double? longitude,
    String? imageUrl,
    String? notes,
    DateTime? checkoutTime,
    double? checkoutLatitude,
    double? checkoutLongitude,
    bool? showUpdateLocation,
    int? routeId,
    Client? client,
    SalesRep? user,
  }) {
    return JourneyPlan(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      checkoutTime: checkoutTime ?? this.checkoutTime,
      checkoutLatitude: checkoutLatitude ?? this.checkoutLatitude,
      checkoutLongitude: checkoutLongitude ?? this.checkoutLongitude,
      showUpdateLocation: showUpdateLocation ?? this.showUpdateLocation,
      routeId: routeId ?? this.routeId,
      client: client ?? this.client,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JourneyPlan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'JourneyPlan(id: $id, date: $date, time: $time, clientId: $clientId, status: $status)';
  }
}
