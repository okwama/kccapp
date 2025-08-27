import '../repositories/journey_plans_repository.dart';

class DeleteJourneyPlanParams {
  final int id;

  const DeleteJourneyPlanParams({
    required this.id,
  });
}

class DeleteJourneyPlan {
  final JourneyPlansRepository _repository;

  DeleteJourneyPlan(this._repository);

  Future<Result<void>> call(DeleteJourneyPlanParams params) {
    return _repository.deleteJourneyPlan(params.id);
  }
}
