import '../repositories/journey_plans_repository.dart';
import '../entities/journey_plan.dart';

class CreateJourneyPlanParams {
  final int clientId;
  final DateTime date;
  final String time;
  final String? notes;
  final int? routeId;

  const CreateJourneyPlanParams({
    required this.clientId,
    required this.date,
    required this.time,
    this.notes,
    this.routeId,
  });
}

class CreateJourneyPlan {
  final JourneyPlansRepository _repository;
  
  CreateJourneyPlan(this._repository);
  
  Future<Result<JourneyPlan>> call(CreateJourneyPlanParams params) {
    return _repository.createJourneyPlan(
      clientId: params.clientId,
      date: params.date,
      time: params.time,
      notes: params.notes,
      routeId: params.routeId,
    );
  }
}
