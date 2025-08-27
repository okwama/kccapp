import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/clock_in.dart';
import '../../domain/usecases/clock_out.dart';
import '../../domain/usecases/get_clock_status.dart';
import '../../domain/usecases/get_clock_history.dart';
import 'clock_in_out_state.dart';

class ClockInOutNotifier extends StateNotifier<ClockInOutState> {
  final ClockIn _clockIn;
  final ClockOut _clockOut;
  final GetClockStatus _getClockStatus;
  ClockInOutNotifier({
    required ClockIn clockIn,
    required ClockOut clockOut,
    required GetClockStatus getClockStatus,
    required GetClockHistory getClockHistory,
  })  : _clockIn = clockIn,
        _clockOut = clockOut,
        _getClockStatus = getClockStatus,
        super(ClockInOutState.initial());

  Future<void> loadClockStatus(int userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _getClockStatus.call(userId);

      if (result.isSuccess) {
        print('🔍 ClockInOutProvider: Result data: ${result.data}');
        print(
            '🔍 ClockInOutProvider: Result data type: ${result.data.runtimeType}');
        print(
            '🔍 ClockInOutProvider: isClockedIn: ${result.data!.isClockedIn}');

        state = state.copyWith(
          status: result.data!,
          isLoading: false,
        );
        print(
            '🔍 ClockInOutProvider: Status loaded - ${result.data!.isClockedIn ? "Clocked In" : "Not Clocked In"}');
      } else {
        state = state.copyWith(
          error: result.error,
          isLoading: false,
        );
        print('❌ ClockInOutProvider: Error loading status - ${result.error}');
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      print('❌ ClockInOutProvider: Exception loading status - $e');
    }
  }

  Future<bool> clockIn(int userId) async {
    state = state.copyWith(isClockingIn: true, error: null);

    try {
      final clientTime = DateTime.now().toIso8601String();
      print(
          '🟢 ClockInOutProvider: Attempting clock in for user $userId at $clientTime');

      final result = await _clockIn.call(userId, clientTime);

      if (result.isSuccess) {
        print(
            '✅ ClockInOutProvider: Clock in successful - ${result.data!['message']}');

        // Reload status after successful clock in
        await loadClockStatus(userId);

        state = state.copyWith(isClockingIn: false);
        return true;
      } else {
        state = state.copyWith(
          error: result.error,
          isClockingIn: false,
        );
        print('❌ ClockInOutProvider: Clock in failed - ${result.error}');
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isClockingIn: false,
      );
      print('❌ ClockInOutProvider: Clock in exception - $e');
      return false;
    }
  }

  Future<bool> clockOut(int userId) async {
    state = state.copyWith(isClockingOut: true, error: null);

    try {
      final clientTime = DateTime.now().toIso8601String();
      print(
          '🔴 ClockInOutProvider: Attempting clock out for user $userId at $clientTime');

      final result = await _clockOut.call(userId, clientTime);

      if (result.isSuccess) {
        print(
            '✅ ClockInOutProvider: Clock out successful - ${result.data!['message']}');

        // Reload status after successful clock out
        await loadClockStatus(userId);

        state = state.copyWith(isClockingOut: false);
        return true;
      } else {
        state = state.copyWith(
          error: result.error,
          isClockingOut: false,
        );
        print('❌ ClockInOutProvider: Clock out failed - ${result.error}');
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isClockingOut: false,
      );
      print('❌ ClockInOutProvider: Clock out exception - $e');
      return false;
    }
  }

  Future<void> loadTodaySessions(int userId) async {
    try {
      // This would use getTodaySessions use case when needed
      // For now, we'll just reload the status
      await loadClockStatus(userId);
    } catch (e) {
      print('❌ ClockInOutProvider: Error loading today sessions - $e');
    }
  }

  void clearError() {
    state = state.clearError();
  }
}
