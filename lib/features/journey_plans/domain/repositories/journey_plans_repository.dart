import '../entities/journey_plan.dart';
import '../entities/journey_plan_status.dart';

// Simple Result pattern
abstract class Result<T> {
  const Result();
  
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T? get data => isSuccess ? (this as Success<T>).data : null;
  String? get error => isFailure ? (this as Failure<T>).message : null;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}

abstract class JourneyPlansRepository {
  Future<Result<List<JourneyPlan>>> getJourneyPlans({
    int page = 1,
    int limit = 20,
    JourneyPlanStatus? status,
    DateTime? date,
  });
  
  Future<Result<List<JourneyPlan>>> getJourneyPlansByDateRange({
    int page = 1,
    int limit = 20,
    JourneyPlanStatus? status,
    required DateTime startDate,
    required DateTime endDate,
  });
  
  Future<Result<JourneyPlan>> createJourneyPlan({
    required int clientId,
    required DateTime date,
    required String time,
    String? notes,
    int? routeId,
  });
  
  Future<Result<JourneyPlan>> updateJourneyPlan(int id, Map<String, dynamic> data);
  Future<Result<void>> deleteJourneyPlan(int id);
  
  Future<Result<JourneyPlan>> checkIn(int id, {
    double? latitude,
    double? longitude,
    String? imageUrl,
  });
  
  Future<Result<JourneyPlan>> checkOut(int id, {
    double? latitude,
    double? longitude,
  });
}
