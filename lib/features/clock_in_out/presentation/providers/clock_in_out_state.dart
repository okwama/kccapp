import '../../domain/entities/clock_session.dart';
import '../../domain/entities/clock_status.dart';

class ClockInOutState {
  final ClockStatus status;
  final List<ClockSession> todaySessions;
  final List<ClockSession> clockHistory;
  final bool isLoading;
  final bool isClockingIn;
  final bool isClockingOut;
  final String? error;

  const ClockInOutState({
    required this.status,
    this.todaySessions = const [],
    this.clockHistory = const [],
    this.isLoading = false,
    this.isClockingIn = false,
    this.isClockingOut = false,
    this.error,
  });

  factory ClockInOutState.initial() {
    return ClockInOutState(
      status: ClockStatus.notClockedIn(),
    );
  }

  ClockInOutState copyWith({
    ClockStatus? status,
    List<ClockSession>? todaySessions,
    List<ClockSession>? clockHistory,
    bool? isLoading,
    bool? isClockingIn,
    bool? isClockingOut,
    String? error,
  }) {
    return ClockInOutState(
      status: status ?? this.status,
      todaySessions: todaySessions ?? this.todaySessions,
      clockHistory: clockHistory ?? this.clockHistory,
      isLoading: isLoading ?? this.isLoading,
      isClockingIn: isClockingIn ?? this.isClockingIn,
      isClockingOut: isClockingOut ?? this.isClockingOut,
      error: error ?? this.error,
    );
  }

  ClockInOutState clearError() {
    return copyWith(error: null);
  }

  @override
  String toString() {
    return 'ClockInOutState(status: $status, todaySessions: ${todaySessions.length}, isLoading: $isLoading, error: $error)';
  }
}
