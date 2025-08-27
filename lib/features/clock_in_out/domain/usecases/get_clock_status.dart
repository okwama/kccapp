import '../utils/result.dart';
import '../entities/clock_status.dart';
import '../repositories/clock_in_out_repository.dart';

class GetClockStatus {
  final ClockInOutRepository repository;

  GetClockStatus(this.repository);

  Future<Result<ClockStatus>> call(int userId) {
    return repository.getCurrentStatus(userId);
  }
}
