import '../repositories/journey_plans_repository.dart';
import '../entities/journey_plan.dart';

class CheckOutParams {
  final int id;
  final double? latitude;
  final double? longitude;

  const CheckOutParams({
    required this.id,
    this.latitude,
    this.longitude,
  });
}

class CheckOutJourneyPlan {
  final JourneyPlansRepository _repository;

  CheckOutJourneyPlan(this._repository);

  Future<Result<JourneyPlan>> call(CheckOutParams params) {
    return _repository.checkOut(
      params.id,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
