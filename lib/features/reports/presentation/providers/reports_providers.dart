import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../data/services/reports_service.dart';
import '../../data/models/feedback_report_model.dart';
import '../../data/models/product_availability_report_model.dart';
import '../../data/models/visibility_report_model.dart';
import '../../data/models/show_of_shelf_report_model.dart';
import '../../data/models/product_expiry_report_model.dart';

// Reports Service Provider
final reportsServiceProvider = Provider<ReportsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReportsService(apiClient.dio);
});

// Reports State
class ReportsState {
  final List<String> completedReports;
  final bool isLoading;
  final String? error;

  ReportsState({
    this.completedReports = const [],
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    List<String>? completedReports,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      completedReports: completedReports ?? this.completedReports,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Reports Notifier
class ReportsNotifier extends StateNotifier<ReportsState> {
  final ReportsService _reportsService;

  ReportsNotifier(this._reportsService) : super(ReportsState());

  Future<bool> submitFeedbackReport(FeedbackReportModel report) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _reportsService.submitFeedbackReport(report);

      if (result['success'] == true) {
        state = state.copyWith(
          isLoading: false,
          completedReports: [...state.completedReports, 'FEEDBACK'],
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['error'] ?? 'Failed to submit feedback report',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> submitProductAvailabilityReport(
      ProductAvailabilityReportModel report) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result =
          await _reportsService.submitProductAvailabilityReport(report);

      if (result['success'] == true) {
        state = state.copyWith(
          isLoading: false,
          completedReports: [...state.completedReports, 'PRODUCT_AVAILABILITY'],
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error:
              result['error'] ?? 'Failed to submit product availability report',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> submitVisibilityReport(VisibilityReportModel report) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _reportsService.submitVisibilityReport(report);

      if (result['success'] == true) {
        state = state.copyWith(
          isLoading: false,
          completedReports: [...state.completedReports, 'VISIBILITY_ACTIVITY'],
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['error'] ?? 'Failed to submit visibility report',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> submitShowOfShelfReport(ShowOfShelfReportModel report) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _reportsService.submitShowOfShelfReport(report);

      if (result['success'] == true) {
        state = state.copyWith(
          isLoading: false,
          completedReports: [...state.completedReports, 'SHOW_OF_SHELF'],
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['error'] ?? 'Failed to submit show of shelf report',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> submitProductExpiryReport(ProductExpiryReportModel report) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _reportsService.submitProductExpiryReport(report);

      if (result['success'] == true) {
        state = state.copyWith(
          isLoading: false,
          completedReports: [...state.completedReports, 'PRODUCT_EXPIRY'],
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['error'] ?? 'Failed to submit product expiry report',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  bool isReportCompleted(String reportType) {
    return state.completedReports.contains(reportType);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void resetState() {
    state = ReportsState();
  }
}

// Reports Notifier Provider
final reportsNotifierProvider =
    StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  final reportsService = ref.watch(reportsServiceProvider);
  return ReportsNotifier(reportsService);
});



