import '../repositories/journey_plans_repository.dart';
import '../entities/journey_plan.dart';

class CheckInParams {
  final int id;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;

  const CheckInParams({
    required this.id,
    this.latitude,
    this.longitude,
    this.imageUrl,
  });
}

class CheckInJourneyPlan {
  final JourneyPlansRepository _repository;
  
  CheckInJourneyPlan(this._repository);
  
  Future<Result<JourneyPlan>> call(CheckInParams params) {
    return _repository.checkIn(
      params.id,
      latitude: params.latitude,
      longitude: params.longitude,
      imageUrl: params.imageUrl,
    );
  }
}
