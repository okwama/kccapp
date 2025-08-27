import 'package:dio/dio.dart';
import '../models/clock_session_model.dart';
import '../models/clock_status_model.dart';
import '../../domain/entities/clock_session.dart';

abstract class ClockInOutRemoteDataSource {
  Future<Map<String, dynamic>> clockIn(int userId, String clientTime);
  Future<Map<String, dynamic>> clockOut(int userId, String clientTime);
  Future<ClockStatusModel> getCurrentStatus(int userId);
  Future<List<ClockSessionModel>> getTodaySessions(int userId);
  Future<List<ClockSessionModel>> getClockHistory(
    int userId, {
    String? startDate,
    String? endDate,
  });
}

class ClockInOutRemoteDataSourceImpl implements ClockInOutRemoteDataSource {
  final Dio dio;

  ClockInOutRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> clockIn(int userId, String clientTime) async {
    try {
      print('🟢 ClockIn API Call - UserId: $userId, ClientTime: $clientTime');

      final response = await dio.post(
        '/clock-in-out/clock-in',
        data: {
          'userId': userId,
          'clientTime': clientTime,
        },
      );

      print('✅ ClockIn Response: ${response.data}');
      return response.data;
    } catch (e) {
      print('❌ ClockIn Error: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> clockOut(int userId, String clientTime) async {
    try {
      print('🔴 ClockOut API Call - UserId: $userId, ClientTime: $clientTime');

      final response = await dio.post(
        '/clock-in-out/clock-out',
        data: {
          'userId': userId,
          'clientTime': clientTime,
        },
      );

      print('✅ ClockOut Response: ${response.data}');
      return response.data;
    } catch (e) {
      print('❌ ClockOut Error: $e');
      rethrow;
    }
  }

  @override
  Future<ClockStatusModel> getCurrentStatus(int userId) async {
    try {
      print('🔍 GetStatus API Call - UserId: $userId');

      final response = await dio.get('/clock-in-out/status/$userId');

      print('✅ GetStatus Response: ${response.data}');

      // Handle the API response structure
      final data = response.data;
      print('🔍 Parsing status data: $data');
      print('🔍 isClockedIn value: ${data['isClockedIn']}');
      print('🔍 isClockedIn type: ${data['isClockedIn'].runtimeType}');

      // Check if user is clocked in
      if (data['isClockedIn'] == true) {
        print('✅ User is clocked in, creating session...');
        print('🔍 Session data from API:');
        print('  - sessionId: ${data['sessionId']}');
        print('  - sessionStart: ${data['sessionStart']}');
        print('  - duration: ${data['duration']}');
        print('  - All data keys: ${data.keys.toList()}');

        // Create session from the response data
        final session = ClockSession(
          id: data['sessionId'] ?? 0,
          userId: userId,
          status: 1, // Active
          sessionStart: data['sessionStart'] ?? '',
          duration: data['duration'] ?? 0,
        );

        print('🔍 Created ClockSession: $session');
        print('🔍 Session startDateTime: ${session.startDateTime}');
        print('🔍 Session isActive: ${session.isActive}');
        print('🔍 Session formattedDuration: ${session.formattedDuration}');

        final statusModel = ClockStatusModel(
          isClockedIn: true,
          currentSession: session,
          message: 'Clocked in',
        );
        print('✅ Created ClockStatusModel: $statusModel');
        return statusModel;
      }

      print('❌ User is not clocked in');
      return const ClockStatusModel(
        isClockedIn: false,
        currentSession: null,
        message: 'Not clocked in',
      );
    } catch (e) {
      print('❌ GetStatus Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<ClockSessionModel>> getTodaySessions(int userId) async {
    try {
      print('📅 GetTodaySessions API Call - UserId: $userId');

      final response = await dio.get('/clock-in-out/today/$userId');

      print('✅ GetTodaySessions Response: ${response.data}');

      final List<dynamic> sessionsData = response.data['sessions'] ?? [];
      return sessionsData
          .map((json) => ClockSessionModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ GetTodaySessions Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<ClockSessionModel>> getClockHistory(
    int userId, {
    String? startDate,
    String? endDate,
  }) async {
    try {
      print(
          '📚 GetClockHistory API Call - UserId: $userId, StartDate: $startDate, EndDate: $endDate');

      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await dio.get(
        '/clock-in-out/history/$userId',
        queryParameters: queryParams,
      );

      print('✅ GetClockHistory Response: ${response.data}');

      final List<dynamic> sessionsData = response.data['sessions'] ?? [];
      return sessionsData
          .map((json) => ClockSessionModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ GetClockHistory Error: $e');
      rethrow;
    }
  }
}
