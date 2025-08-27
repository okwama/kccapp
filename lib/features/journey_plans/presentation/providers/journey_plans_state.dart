import '../../domain/entities/journey_plan.dart';

class JourneyPlansState {
  final List<JourneyPlan> journeyPlans;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final String? error;
  
  const JourneyPlansState({
    this.journeyPlans = const [],
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoading = false,
    this.error,
  });
  
  JourneyPlansState copyWith({
    List<JourneyPlan>? journeyPlans,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    String? error,
  }) {
    return JourneyPlansState(
      journeyPlans: journeyPlans ?? this.journeyPlans,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
