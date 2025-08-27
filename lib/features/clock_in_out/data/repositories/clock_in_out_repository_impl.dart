import '../../domain/utils/result.dart';
import '../../domain/entities/clock_session.dart';
import '../../domain/entities/clock_status.dart';
import '../../domain/repositories/clock_in_out_repository.dart';
import '../datasources/clock_in_out_remote_data_source.dart';

class ClockInOutRepositoryImpl implements ClockInOutRepository {
  final ClockInOutRemoteDataSource remoteDataSource;

  ClockInOutRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<Map<String, dynamic>>> clockIn(
      int userId, String clientTime) async {
    try {
      final result = await remoteDataSource.clockIn(userId, clientTime);
      return Success(result);
    } catch (e) {
      print('❌ ClockInRepository Error: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> clockOut(
      int userId, String clientTime) async {
    try {
      final result = await remoteDataSource.clockOut(userId, clientTime);
      return Success(result);
    } catch (e) {
      print('❌ ClockOutRepository Error: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<ClockStatus>> getCurrentStatus(int userId) async {
    try {
      final statusModel = await remoteDataSource.getCurrentStatus(userId);
      final status = statusModel.toEntity();
      return Success(status);
    } catch (e) {
      print('❌ GetStatusRepository Error: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<List<ClockSession>>> getTodaySessions(int userId) async {
    try {
      final sessionModels = await remoteDataSource.getTodaySessions(userId);
      final sessions = sessionModels.map((model) => model.toEntity()).toList();
      return Success(sessions);
    } catch (e) {
      print('❌ GetTodaySessionsRepository Error: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<List<ClockSession>>> getClockHistory(
    int userId, {
    String? startDate,
    String? endDate,
  }) async {
    try {
      final sessionModels = await remoteDataSource.getClockHistory(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      final sessions = sessionModels.map((model) => model.toEntity()).toList();
      return Success(sessions);
    } catch (e) {
      print('❌ GetClockHistoryRepository Error: $e');
      return Failure(e.toString());
    }
  }
}
