import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/providers/providers.dart';
import '../../data/datasources/journey_plans_remote_data_source.dart';
import '../../data/repositories/journey_plans_repository_impl.dart';
import '../../domain/repositories/journey_plans_repository.dart';
import '../../domain/usecases/get_journey_plans.dart';
import '../../domain/usecases/create_journey_plan.dart';
import '../../domain/usecases/check_in_journey_plan.dart';
import '../../domain/usecases/check_out_journey_plan.dart';
import '../../domain/usecases/delete_journey_plan.dart';
import 'journey_plans_provider.dart';
import 'journey_plans_state.dart';

// Data Sources
final journeyPlansRemoteDataSourceProvider =
    Provider<JourneyPlansRemoteDataSource>((ref) {
  final dio = ref.read(apiClientProvider).dio;
  return JourneyPlansRemoteDataSourceImpl(dio);
});

// Repository
final journeyPlansRepositoryProvider = Provider<JourneyPlansRepository>((ref) {
  final remoteDataSource = ref.read(journeyPlansRemoteDataSourceProvider);
  return JourneyPlansRepositoryImpl(remoteDataSource);
});

// Use Cases
final getJourneyPlansProvider = Provider<GetJourneyPlans>((ref) {
  final repository = ref.read(journeyPlansRepositoryProvider);
  return GetJourneyPlans(repository);
});

final createJourneyPlanProvider = Provider<CreateJourneyPlan>((ref) {
  final repository = ref.read(journeyPlansRepositoryProvider);
  return CreateJourneyPlan(repository);
});

final checkInJourneyPlanProvider = Provider<CheckInJourneyPlan>((ref) {
  final repository = ref.read(journeyPlansRepositoryProvider);
  return CheckInJourneyPlan(repository);
});

final checkOutJourneyPlanProvider = Provider<CheckOutJourneyPlan>((ref) {
  final repository = ref.read(journeyPlansRepositoryProvider);
  return CheckOutJourneyPlan(repository);
});

final deleteJourneyPlanProvider = Provider<DeleteJourneyPlan>((ref) {
  final repository = ref.read(journeyPlansRepositoryProvider);
  return DeleteJourneyPlan(repository);
});

// State Notifier
final journeyPlansNotifierProvider =
    StateNotifierProvider<JourneyPlansNotifier, JourneyPlansState>((ref) {
  final getJourneyPlans = ref.read(getJourneyPlansProvider);
  final createJourneyPlan = ref.read(createJourneyPlanProvider);
  final checkInJourneyPlan = ref.read(checkInJourneyPlanProvider);
  final checkOutJourneyPlan = ref.read(checkOutJourneyPlanProvider);
  final deleteJourneyPlan = ref.read(deleteJourneyPlanProvider);

  return JourneyPlansNotifier(
    getJourneyPlans: getJourneyPlans,
    createJourneyPlan: createJourneyPlan,
    checkInJourneyPlan: checkInJourneyPlan,
    checkOutJourneyPlan: checkOutJourneyPlan,
    deleteJourneyPlan: deleteJourneyPlan,
  );
});
