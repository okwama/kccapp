import '../repositories/journey_plans_repository.dart';
import '../entities/journey_plan.dart';
import '../entities/journey_plan_status.dart';

class GetJourneyPlansParams {
  final int page;
  final int limit;
  final JourneyPlanStatus? status;
  final DateTime? date;

  const GetJourneyPlansParams({
    this.page = 1,
    this.limit = 20,
    this.status,
    this.date,
  });
}

class GetJourneyPlans {
  final JourneyPlansRepository _repository;
  
  GetJourneyPlans(this._repository);
  
  Future<Result<List<JourneyPlan>>> call(GetJourneyPlansParams params) {
    return _repository.getJourneyPlans(
      page: params.page,
      limit: params.limit,
      status: params.status,
      date: params.date,
    );
  }
}
