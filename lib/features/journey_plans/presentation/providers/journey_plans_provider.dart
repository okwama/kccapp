import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/journey_plan.dart';
import '../../domain/entities/journey_plan_status.dart';
import '../../domain/usecases/get_journey_plans.dart';
import '../../domain/usecases/create_journey_plan.dart';
import '../../domain/usecases/check_in_journey_plan.dart';
import '../../domain/usecases/check_out_journey_plan.dart';
import '../../domain/usecases/delete_journey_plan.dart';
import 'journey_plans_state.dart';

class JourneyPlansNotifier extends StateNotifier<JourneyPlansState> {
  final GetJourneyPlans _getJourneyPlans;
  final CreateJourneyPlan _createJourneyPlan;
  final CheckInJourneyPlan _checkInJourneyPlan;
  final CheckOutJourneyPlan _checkOutJourneyPlan;
  final DeleteJourneyPlan _deleteJourneyPlan;

  JourneyPlansNotifier({
    required GetJourneyPlans getJourneyPlans,
    required CreateJourneyPlan createJourneyPlan,
    required CheckInJourneyPlan checkInJourneyPlan,
    required CheckOutJourneyPlan checkOutJourneyPlan,
    required DeleteJourneyPlan deleteJourneyPlan,
  })  : _getJourneyPlans = getJourneyPlans,
        _createJourneyPlan = createJourneyPlan,
        _checkInJourneyPlan = checkInJourneyPlan,
        _checkOutJourneyPlan = checkOutJourneyPlan,
        _deleteJourneyPlan = deleteJourneyPlan,
        super(const JourneyPlansState());

  Future<void> loadJourneyPlans({
    int page = 1,
    JourneyPlanStatus? status,
    DateTime? date,
  }) async {
    if (page == 1) {
      state = state.copyWith(isLoading: true, error: null);
    }

    final result = await _getJourneyPlans.call(
      GetJourneyPlansParams(
        page: page,
        status: status,
        date: date,
      ),
    );

    if (result.isSuccess) {
      final journeyPlans = result.data!;
      print(
          '🔍 JourneyPlansProvider: Loaded ${journeyPlans.length} journey plans');
      print(
          '🔍 JourneyPlansProvider: Plans: ${journeyPlans.map((p) => '${p.id}: ${p.client?.name ?? 'Unknown'}').join(', ')}');

      final updatedPlans =
          page == 1 ? journeyPlans : [...state.journeyPlans, ...journeyPlans];

      state = state.copyWith(
        journeyPlans: updatedPlans,
        currentPage: page,
        hasMore: journeyPlans.length >= 20,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        error: result.error,
        isLoading: false,
      );
    }
  }

  Future<void> createJourneyPlan({
    required int clientId,
    required DateTime date,
    required String time,
    String? notes,
  }) async {
    final result = await _createJourneyPlan.call(
      CreateJourneyPlanParams(
        clientId: clientId,
        date: date,
        time: time,
        notes: notes,
      ),
    );

    if (result.isSuccess) {
      print(
          '✅ JourneyPlansProvider: Journey plan created successfully, refreshing list...');
      // Refresh the list
      loadJourneyPlans();
    } else {
      print(
          '❌ JourneyPlansProvider: Failed to create journey plan: ${result.error}');
      state = state.copyWith(error: result.error);
    }
  }

  Future<void> checkIn(
    int journeyPlanId, {
    double? latitude,
    double? longitude,
    String? imageUrl,
  }) async {
    final result = await _checkInJourneyPlan.call(
      CheckInParams(
        id: journeyPlanId,
        latitude: latitude,
        longitude: longitude,
        imageUrl: imageUrl,
      ),
    );

    if (result.isSuccess) {
      final journeyPlan = result.data!;
      // Update the specific journey plan in the list
      final updatedList = state.journeyPlans.map((plan) {
        return plan.id == journeyPlanId ? journeyPlan : plan;
      }).toList();

      state = state.copyWith(
        journeyPlans: updatedList,
      );
    } else {
      state = state.copyWith(error: result.error);
    }
  }

  Future<void> checkOut(
    int journeyPlanId, {
    double? latitude,
    double? longitude,
  }) async {
    final result = await _checkOutJourneyPlan.call(
      CheckOutParams(
        id: journeyPlanId,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    if (result.isSuccess) {
      final journeyPlan = result.data!;
      // Update the specific journey plan in the list
      final updatedList = state.journeyPlans.map((plan) {
        return plan.id == journeyPlanId ? journeyPlan : plan;
      }).toList();

      state = state.copyWith(
        journeyPlans: updatedList,
      );
    } else {
      state = state.copyWith(error: result.error);
    }
  }

  Future<void> deleteJourneyPlan(int journeyPlanId) async {
    final result = await _deleteJourneyPlan.call(
      DeleteJourneyPlanParams(id: journeyPlanId),
    );

    if (result.isSuccess) {
      // Remove the journey plan from the list
      final updatedList =
          state.journeyPlans.where((plan) => plan.id != journeyPlanId).toList();

      state = state.copyWith(
        journeyPlans: updatedList,
      );
    } else {
      state = state.copyWith(error: result.error);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
