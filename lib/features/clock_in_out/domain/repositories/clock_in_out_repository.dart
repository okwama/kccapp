import '../utils/result.dart';
import '../entities/clock_session.dart';
import '../entities/clock_status.dart';

abstract class ClockInOutRepository {
  Future<Result<Map<String, dynamic>>> clockIn(int userId, String clientTime);
  Future<Result<Map<String, dynamic>>> clockOut(int userId, String clientTime);
  Future<Result<ClockStatus>> getCurrentStatus(int userId);
  Future<Result<List<ClockSession>>> getTodaySessions(int userId);
  Future<Result<List<ClockSession>>> getClockHistory(
    int userId, {
    String? startDate,
    String? endDate,
  });
}
