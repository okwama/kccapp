import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/datasources/notices_remote_data_source.dart';
import '../../data/repositories/notices_repository_impl.dart';
import '../../data/models/notice.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Data source provider
final noticesDataSourceProvider = Provider<NoticesRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return NoticesRemoteDataSourceImpl(dio);
});

// Repository provider
final noticesRepositoryProvider = Provider<NoticesRepositoryImpl>((ref) {
  final dataSource = ref.watch(noticesDataSourceProvider);
  return NoticesRepositoryImpl(dataSource);
});

// Notices state
class NoticesState {
  final List<Notice> notices;
  final bool isLoading;
  final String? error;
  final Notice? selectedNotice;

  NoticesState({
    this.notices = const [],
    this.isLoading = false,
    this.error,
    this.selectedNotice,
  });

  NoticesState copyWith({
    List<Notice>? notices,
    bool? isLoading,
    String? error,
    Notice? selectedNotice,
  }) {
    return NoticesState(
      notices: notices ?? this.notices,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedNotice: selectedNotice ?? this.selectedNotice,
    );
  }
}

// Notices notifier
class NoticesNotifier extends StateNotifier<NoticesState> {
  final NoticesRepositoryImpl _repository;

  NoticesNotifier(this._repository) : super(NoticesState());

  Future<void> loadNotices({int? countryId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final notices = await _repository.getNotices(countryId: countryId);
      state = state.copyWith(notices: notices, isLoading: false);
    } catch (e) {
      print('⚠️ Error loading notices: $e');

      // If API fails, show empty state instead of error
      // This prevents the app from crashing when API is not available
      state = state.copyWith(
        notices: [],
        isLoading: false,
        error: null, // Don't show error to user
      );
    }
  }

  Future<void> loadNoticeById(int id) async {
    try {
      final notice = await _repository.getNoticeById(id);
      state = state.copyWith(selectedNotice: notice, error: null);
    } catch (e) {
      print('⚠️ Error loading notice by ID: $e');
      state = state.copyWith(
        selectedNotice: null,
        error: 'Failed to load notice details',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSelectedNotice() {
    state = state.copyWith(selectedNotice: null);
  }
}

// Notices provider
final noticesNotifierProvider =
    StateNotifierProvider<NoticesNotifier, NoticesState>((ref) {
  final repository = ref.watch(noticesRepositoryProvider);
  return NoticesNotifier(repository);
});
