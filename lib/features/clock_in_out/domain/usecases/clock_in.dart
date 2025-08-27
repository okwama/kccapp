import '../utils/result.dart';
import '../repositories/clock_in_out_repository.dart';

class ClockIn {
  final ClockInOutRepository repository;

  ClockIn(this.repository);

  Future<Result<Map<String, dynamic>>> call(int userId, String clientTime) {
    return repository.clockIn(userId, clientTime);
  }
}
