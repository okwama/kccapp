import 'package:dio/dio.dart';
import '../models/journey_plan_model.dart';
import '../models/journey_plan_response.dart';
import '../models/create_journey_plan_request.dart';

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
          : (json['showUpdateLocation'] == 1 ||
              json['showUpdateLocation'] == true),
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

abstract class JourneyPlansRemoteDataSource {
  Future<JourneyPlanResponse> getJourneyPlans({
    int page = 1,
    int limit = 20,
    String? status,
    String? date,
    String timezone = 'Africa/Nairobi',
  });

  Future<JourneyPlanResponse> getJourneyPlansByDateRange({
    int page = 1,
    int limit = 20,
    String? status,
    required String startDate,
    required String endDate,
    String timezone = 'Africa/Nairobi',
  });

  Future<JourneyPlanModel> createJourneyPlan(CreateJourneyPlanRequest request);
  Future<JourneyPlanModel> updateJourneyPlan(int id, Map<String, dynamic> data);
  Future<void> deleteJourneyPlan(int id);
  Future<JourneyPlanModel> checkIn(
    int id, {
    double? latitude,
    double? longitude,
    String? imageUrl,
  });
  Future<JourneyPlanModel> checkOut(
    int id, {
    double? latitude,
    double? longitude,
  });
}

class JourneyPlansRemoteDataSourceImpl implements JourneyPlansRemoteDataSource {
  final Dio _dio;

  JourneyPlansRemoteDataSourceImpl(this._dio);

  @override
  Future<JourneyPlanResponse> getJourneyPlans({
    int page = 1,
    int limit = 20,
    String? status,
    String? date,
    String timezone = 'Africa/Nairobi',
  }) async {
    // Use current date if no specific date is provided
    final currentDate = date ?? DateTime.now().toIso8601String().split('T')[0];

    final response = await _dio.get('/journey-plans', queryParameters: {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      'date': currentDate,
      'timezone': timezone,
    });

    return JourneyPlanResponse.fromJson(response.data);
  }

  @override
  Future<JourneyPlanResponse> getJourneyPlansByDateRange({
    int page = 1,
    int limit = 20,
    String? status,
    required String startDate,
    required String endDate,
    String timezone = 'Africa/Nairobi',
  }) async {
    final response = await _dio.get('/journey-plans/by-date', queryParameters: {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      'startDate': startDate,
      'endDate': endDate,
      'timezone': timezone,
    });

    return JourneyPlanResponse.fromJson(response.data);
  }

  @override
  Future<JourneyPlanModel> createJourneyPlan(
      CreateJourneyPlanRequest request) async {
    final response = await _dio.post('/journey-plans', data: request.toJson());

    print(
        '🔍 JourneyPlansRemoteDataSource: Response type: ${response.data.runtimeType}');
    print('🔍 JourneyPlansRemoteDataSource: Response data: ${response.data}');

    // Handle different response formats
    if (response.data is Map<String, dynamic>) {
      print('🔍 JourneyPlansRemoteDataSource: Parsing as Map');
      return _safeParseJourneyPlan(response.data);
    } else if (response.data is List) {
      print('🔍 JourneyPlansRemoteDataSource: Parsing as List');
      // If API returns a list, take the first item
      final data = response.data as List;
      if (data.isNotEmpty && data.first is Map<String, dynamic>) {
        return _safeParseJourneyPlan(data.first);
      }
    }

    // Fallback: try to parse as is
    print('🔍 JourneyPlansRemoteDataSource: Using fallback parsing');
    return _safeParseJourneyPlan(response.data);
  }

  @override
  Future<JourneyPlanModel> updateJourneyPlan(
      int id, Map<String, dynamic> data) async {
    final response = await _dio.put('/journey-plans/$id', data: data);
    return _safeParseJourneyPlan(response.data);
  }

  @override
  Future<void> deleteJourneyPlan(int id) async {
    await _dio.delete('/journey-plans/$id');
  }

  @override
  Future<JourneyPlanModel> checkIn(
    int id, {
    double? latitude,
    double? longitude,
    String? imageUrl,
  }) async {
    final data = <String, dynamic>{
      'status': 'checked_in',
      'checkInTime': DateTime.now().toIso8601String(),
    };

    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (imageUrl != null) data['imageUrl'] = imageUrl;

    final response = await _dio.put('/journey-plans/$id', data: data);
    return _safeParseJourneyPlan(response.data);
  }

  @override
  Future<JourneyPlanModel> checkOut(
    int id, {
    double? latitude,
    double? longitude,
  }) async {
    final data = <String, dynamic>{
      'status': 'completed',
      'checkoutTime': DateTime.now().toIso8601String(),
    };

    if (latitude != null) data['checkoutLatitude'] = latitude;
    if (longitude != null) data['checkoutLongitude'] = longitude;

    final response = await _dio.put('/journey-plans/$id', data: data);
    return _safeParseJourneyPlan(response.data);
  }
}
