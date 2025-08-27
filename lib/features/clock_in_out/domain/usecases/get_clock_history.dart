import '../utils/result.dart';
import '../entities/clock_session.dart';
import '../repositories/clock_in_out_repository.dart';

class GetClockHistory {
  final ClockInOutRepository repository;

  GetClockHistory(this.repository);

  Future<Result<List<ClockSession>>> call(
    int userId, {
    String? startDate,
    String? endDate,
  }) {
    return repository.getClockHistory(
      userId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
