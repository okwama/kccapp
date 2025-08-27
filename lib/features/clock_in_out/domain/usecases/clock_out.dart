import '../utils/result.dart';
import '../repositories/clock_in_out_repository.dart';

class ClockOut {
  final ClockInOutRepository repository;

  ClockOut(this.repository);

  Future<Result<Map<String, dynamic>>> call(int userId, String clientTime) {
    return repository.clockOut(userId, clientTime);
  }
}
