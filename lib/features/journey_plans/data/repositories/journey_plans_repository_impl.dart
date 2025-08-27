import '../../domain/repositories/journey_plans_repository.dart';
import '../../domain/entities/journey_plan.dart';
import '../../domain/entities/journey_plan_status.dart';
import '../datasources/journey_plans_remote_data_source.dart';
import '../models/create_journey_plan_request.dart';

class JourneyPlansRepositoryImpl implements JourneyPlansRepository {
  final JourneyPlansRemoteDataSource _remoteDataSource;
  
  JourneyPlansRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<Result<List<JourneyPlan>>> getJourneyPlans({
    int page = 1,
    int limit = 20,
    JourneyPlanStatus? status,
    DateTime? date,
  }) async {
    try {
      final response = await _remoteDataSource.getJourneyPlans(
        page: page,
        limit: limit,
        status: status?.apiValue,
        date: date?.toIso8601String().split('T')[0],
      );
      
      final journeyPlans = response.data.map((model) => model.toEntity()).toList();
      return Success(journeyPlans);
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }
  
  @override
  Future<Result<List<JourneyPlan>>> getJourneyPlansByDateRange({
    int page = 1,
    int limit = 20,
    JourneyPlanStatus? status,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _remoteDataSource.getJourneyPlansByDateRange(
        page: page,
        limit: limit,
        status: status?.apiValue,
        startDate: startDate.toIso8601String().split('T')[0],
        endDate: endDate.toIso8601String().split('T')[0],
      );
      
      final journeyPlans = response.data.map((model) => model.toEntity()).toList();
      return Success(journeyPlans);
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }
  
  @override
  Future<Result<JourneyPlan>> createJourneyPlan({
    required int clientId,
    required DateTime date,
    required String time,
    String? notes,
    int? routeId,
  }) async {
    try {
      final request = CreateJourneyPlanRequest(
        clientId: clientId,
        date: date.toIso8601String().split('T')[0],
        time: time,
        notes: notes,
        routeId: routeId,
      );
      
      final model = await _remoteDataSource.createJourneyPlan(request);
      return Success(model.toEntity());
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }
  
  @override
  Future<Result<JourneyPlan>> updateJourneyPlan(int id, Map<String, dynamic> data) async {
    try {
      final model = await _remoteDataSource.updateJourneyPlan(id, data);
      return Success(model.toEntity());
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }
  
  @override
  Future<Result<void>> deleteJourneyPlan(int id) async {
    try {
      await _remoteDataSource.deleteJourneyPlan(id);
      return const Success(null);
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }
  
  @override
  Future<Result<JourneyPlan>> checkIn(int id, {
    double? latitude,
    double? longitude,
    String? imageUrl,
  }) async {
    try {
      final model = await _remoteDataSource.checkIn(
        id,
        latitude: latitude,
        longitude: longitude,
        imageUrl: imageUrl,
      );
      return Success(model.toEntity());
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }
  
  @override
  Future<Result<JourneyPlan>> checkOut(int id, {
    double? latitude,
    double? longitude,
  }) async {
    try {
      final model = await _remoteDataSource.checkOut(
        id,
        latitude: latitude,
        longitude: longitude,
      );
      return Success(model.toEntity());
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }
}
