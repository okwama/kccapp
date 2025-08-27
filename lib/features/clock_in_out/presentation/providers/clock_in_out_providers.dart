import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../data/datasources/clock_in_out_remote_data_source.dart';
import '../../data/repositories/clock_in_out_repository_impl.dart';
import '../../domain/usecases/clock_in.dart';
import '../../domain/usecases/clock_out.dart';
import '../../domain/usecases/get_clock_status.dart';
import '../../domain/usecases/get_clock_history.dart';
import 'clock_in_out_provider.dart';
import 'clock_in_out_state.dart';

// Data Sources
final clockInOutRemoteDataSourceProvider =
    Provider<ClockInOutRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ClockInOutRemoteDataSourceImpl(apiClient.dio);
});

// Repository
final clockInOutRepositoryProvider = Provider<ClockInOutRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(clockInOutRemoteDataSourceProvider);
  return ClockInOutRepositoryImpl(remoteDataSource);
});

// Use Cases
final clockInProvider = Provider<ClockIn>((ref) {
  final repository = ref.watch(clockInOutRepositoryProvider);
  return ClockIn(repository);
});

final clockOutProvider = Provider<ClockOut>((ref) {
  final repository = ref.watch(clockInOutRepositoryProvider);
  return ClockOut(repository);
});

final getClockStatusProvider = Provider<GetClockStatus>((ref) {
  final repository = ref.watch(clockInOutRepositoryProvider);
  return GetClockStatus(repository);
});

final getClockHistoryProvider = Provider<GetClockHistory>((ref) {
  final repository = ref.watch(clockInOutRepositoryProvider);
  return GetClockHistory(repository);
});

// State Notifier
final clockInOutNotifierProvider =
    StateNotifierProvider<ClockInOutNotifier, ClockInOutState>((ref) {
  final clockIn = ref.watch(clockInProvider);
  final clockOut = ref.watch(clockOutProvider);
  final getClockStatus = ref.watch(getClockStatusProvider);
  final getClockHistory = ref.watch(getClockHistoryProvider);

  return ClockInOutNotifier(
    clockIn: clockIn,
    clockOut: clockOut,
    getClockStatus: getClockStatus,
    getClockHistory: getClockHistory,
  );
});
